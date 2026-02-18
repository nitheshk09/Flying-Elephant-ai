const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '.env') });

const express = require('express');
const cors = require('cors');
const axios = require('axios');

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;
const SARVAM_KEY = process.env.SARVAM_API_KEY;
const SARVAM_URL = "https://api.sarvam.ai/v1/chat/completions";

console.log(`[Config] SARVAM_API_KEY: ${SARVAM_KEY ? 'Loaded ✅' : 'MISSING ❌'}`);

// ------------------------------------------------------------------
// Helper: Call Sarvam AI
// ------------------------------------------------------------------
async function callSarvam(messages, temperature = 0.2, maxTokens = 2000) {
    const response = await axios.post(SARVAM_URL, {
        model: "sarvam-m",
        messages,
        temperature,
        max_tokens: maxTokens
    }, {
        headers: {
            'Content-Type': 'application/json',
            'api-subscription-key': SARVAM_KEY
        },
        timeout: 60000
    });
    return response.data?.choices?.[0]?.message?.content ?? "";
}

// ------------------------------------------------------------------
// Helper: Parse JSON from AI response
// ------------------------------------------------------------------
function parseJSON(raw, fallback) {
    try {
        const clean = String(raw || "")
            .replace(/```json/g, '').replace(/```/g, '').trim();
        const start = clean.indexOf('[') !== -1 &&
            (clean.indexOf('[') < clean.indexOf('{') || clean.indexOf('{') === -1)
            ? clean.indexOf('[')
            : clean.indexOf('{');
        const end = clean.lastIndexOf(']') !== -1 && clean.lastIndexOf(']') > clean.lastIndexOf('}')
            ? clean.lastIndexOf(']')
            : clean.lastIndexOf('}');
        if (start !== -1 && end !== -1) {
            return JSON.parse(clean.substring(start, end + 1));
        }
        return JSON.parse(clean);
    } catch (e) {
        console.error("[Parse] Failed:", e.message);
        return fallback;
    }
}

app.get('/', (req, res) => {
    res.json({ message: "Flying Elephant Ai Orchestrator is running." });
});

// ------------------------------------------------------------------
// MAIN API ENDPOINT
// ------------------------------------------------------------------
app.post('/api/intent', async (req, res) => {
    const userText = req.body?.query ?? "";
    console.log(`\n[Intent] Processing: "${userText}"`);

    try {
        // ========== STEP 1: Intent + Slot Extraction ==========
        const intentPrompt = `You are a premium AI Concierge brain for Hyderabad.
Extract intent & entities from user queries. Return ONLY valid JSON.

Schema:
{
  "intent": "product"|"treatment"|"course"|"service"|"vehicle"|"other",
  "query": "search term",
  "location": "Hyderabad",
  "needs": ["price", "buy_links", "phone_numbers", "places"],
  "vehicle": null
}

Rules:
- Default location to "Hyderabad".
- Follow schema strictly.`;

        const messages = [
            { role: "system", content: intentPrompt },
            { role: "user", content: userText }
        ];

        const intentRaw = await callSarvam(messages);
        console.log(`[Sarvam] Intent raw: ${intentRaw}`);

        const intent = parseJSON(intentRaw, {
            intent: "other", query: userText, location: "Hyderabad",
            needs: ["places"], vehicle: null
        });

        intent.query_cleaned = intent.query || userText;
        intent.price_check_needed = intent.needs?.includes('price') || false;
        intent.needs_phone_number = intent.needs?.includes('phone_numbers') || false;
        intent.needs_buy_link = intent.needs?.includes('buy_links') || false;

        console.log(`[Orchestrator] Intent: ${intent.intent}, Location: ${intent.location}, Query: ${intent.query}`);

        // Only ask follow-ups if vehicle category is truly unknown
        if (intent.intent === "vehicle" &&
            (!intent.vehicle || !intent.vehicle.category) &&
            Array.isArray(intent.followup_questions) &&
            intent.followup_questions.length > 0) {
            return res.json({ ...intent, results: [] });
        }

        // ========== STEP 2: Fetch Details ==========
        let results = [];

        if (intent.intent !== 'other') {
            const detailsPrompt = getDetailsPrompt(intent);
            const userQuery = buildDetailsUserQuery(intent);

            const maxTok = intent.intent === 'vehicle' ? 8000 : 4500;
            const detailsRaw = await callSarvam([
                { role: "system", content: detailsPrompt },
                { role: "user", content: userQuery }
            ], 0.3, maxTok);

            console.log(`[Sarvam] Details raw: ${String(detailsRaw).substring(0, 300)}...`);

            results = parseJSON(detailsRaw, []);
            if (!Array.isArray(results)) results = [results];

            if (intent.intent === "vehicle") {
                results = results.map(v => {
                    // Construct real car image URL from imagin.studio
                    if (v.brand && v.model) {
                        const make = encodeURIComponent(v.brand.toLowerCase());
                        const model = encodeURIComponent(v.model.toLowerCase().replace(v.brand?.toLowerCase() + ' ', ''));
                        v.image_url = `https://cdn.imagin.studio/getimage?customer=hrjavascript-mastery&make=${make}&modelFamily=${model}&paintId=imagin-grey&angle=1`;
                    }
                    // Brand logo from clearbit
                    if (v.official_url) {
                        try {
                            const domain = new URL(v.official_url).hostname.replace('www.', '');
                            v.logo_url = `https://logo.clearbit.com/${domain}`;
                        } catch (_) { }
                    }
                    return v;
                });
            } else {
                results = enrichWithLogos(results);
            }

            console.log(`[Results] Got ${results.length} items`);
        }

        res.json({ ...intent, results });

    } catch (error) {
        console.error("[ERROR]", error.response?.data || error.message);
        res.status(500).json({
            error: "Failed to process",
            details: error.response?.data || error.message
        });
    }
});

// ------------------------------------------------------------------
// Build user query for details step
// ------------------------------------------------------------------
function buildDetailsUserQuery(intent) {
    if (intent.intent === "vehicle") {
        const v = intent.vehicle || {};
        return `Recommend vehicles available in the USA for a buyer in ${intent.location}.
Preferences: ${JSON.stringify(v)}
Return best options matching these constraints.`;
    }
    return `Find: ${intent.query_cleaned} in ${intent.location}`;
}

// ------------------------------------------------------------------
// DETAIL PROMPTS PER INTENT TYPE
// ------------------------------------------------------------------
function getDetailsPrompt(intent) {
    const base = `Return ONLY a valid JSON array of 5 objects. BE EXTREMELY CONCISE.
Fields: name, formatted_address, formatted_phone_number, rating, description, latitude, longitude, price_range.`;

    switch (intent.intent) {
        case 'vehicle':
            return `Return ONLY a valid JSON array of 3 objects for vehicles in Hyderabad.
Fields: brand, model, year, approx_price, description, image_url, dealers: [{name, address, phone, latitude, longitude}].
Be very concise to avoid truncation.`;

        case 'treatment':
            return `${base} Focus on clinics/hospitals in Hyderabad.`;

        case 'course':
            return `${base} Focus on institutes/coaching in Hyderabad.`;

        case 'product':
            return `${base} Focus on retailers/stores in Hyderabad.`;

        case 'service':
            return `${base} Focus on service providers in Hyderabad.`;

        default:
            return base;
    }
}
// ------------------------------------------------------------------
// Add logo URL from website domain
// ------------------------------------------------------------------
function enrichWithLogos(results) {
    return results.map(item => {
        if (item.website && !item.logo_url) {
            try {
                const domain = new URL(item.website).hostname.replace('www.', '');
                item.logo_url = `https://logo.clearbit.com/${domain}`;
            } catch (e) {
                item.logo_url = null;
            }
        }
        return item;
    });
}

// Health check
app.get('/', (req, res) => {
    res.send('AI Concierge Server Running!');
});

app.listen(PORT, '0.0.0.0', () => {
});

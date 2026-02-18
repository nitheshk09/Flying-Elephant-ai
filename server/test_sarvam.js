require('dotenv').config();
const axios = require('axios');

const SARVAM_KEY = process.env.SARVAM_API_KEY;
const SARVAM_URL = "https://api.sarvam.ai/v1/chat/completions";

console.log("Key:", SARVAM_KEY ? SARVAM_KEY.substring(0, 10) + "..." : "MISSING");

(async () => {
    try {
        const response = await axios.post(SARVAM_URL, {
            model: "sarvam-m",
            messages: [
                { role: "user", content: "Hello" }
            ],
            temperature: 0.2
        }, {
            headers: {
                'Content-Type': 'application/json',
                'api-subscription-key': SARVAM_KEY
            },
            timeout: 30000
        });

        console.log("Status:", response.status);
        console.log("Response:", JSON.stringify(response.data, null, 2));
    } catch (e) {
        console.error("Error:", e.response?.status, e.response?.data || e.message);
    }
})();

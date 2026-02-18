# Project: Flying Elephant Ai (Premium NYC Concierge)

## 1. Executive Summary
This project aims to build a **world-class** mobile application for New York residents. The app serves as an intelligent, conversational interface to find real-time prices, contact details, and actionable links for:
*   **Treatments** (Medical, Cosmetic, Dental)
*   **Courses** (Education, Coaching, Skill Training)
*   **Products** (Electronics, Home Appliances)
*   **Local Services** (Repairs, Event Planning)
*   **Vehicles** (Cars, SUVs, Trucks, Bikes)

The core value proposition is **determinism**: unlike standard LLM chats that hallucinate prices, this app uses AI only to *understand* intent, while a robust backend fetches *real* data.

## 2. Design Philosophy & Aesthetics
**Target Metric**: The app must feel like a premium boutique digital experience, surpassing mainstream AI assistants.
*   **Visual Style**: Material 3 (You) architecture. Large, rounded corners (24px+), mesh radial gradients, and subtle ambient glows.
*   **Typography**: *Inter* or *Outfit* (Google Fonts). Clean, geometric, highly readable.
*   **Motion Design**:
    *   **Mesh Gradients**: Fluid, slow-moving abstract shapes in the background.
    - **Premium Loading**: Global brand animations and intelligence-simulating taglines.
    *   **Text Generation**: Fade-in character animations with vertical slides.

## 3. Architecture & Tech Stack

### 3.1 Mobile App (Flutter)
*   **Framework**: Flutter (Latest Stable).
*   **State Management**: Riverpod.
*   **Navigation**: GoRouter.
*   **Design System**: Glassmorphism, Custom mesh gradients, and premium dark theme.

### 3.2 Backend (Middleware)
*   **Runtime**: Node.js (Express).
*   **Role**:
    1.  Receives raw user query.
    2.  Calls **Sarvam AI** to extract structured *Intent*.
    3.  Fetches US-market data including MSRP, dealership info, and real-time prices.
    4.  Aggregates and sanitizes data.
*   **Security**: API Keys stored in environment variables.

### 3.3 AI & Data Layer
*   **Intent Engine**: Sarvam AI (`sarvam-m` model).
*   **Data Focus**: New York and broader USA market.

## 4. Functional Requirements

### 4.1 Home Screen ("The Canvas")
*   **Search Interface**: A floating glassmorphism search bar with an Apple-style submission button.
*   **Suggestions**: AI-driven chips (e.g., "Tesla Model 3 Price", "Best NYU prep courses").
*   **Visuals**: Deep charcoal mesh gradient with ambient accent glows.

### 4.2 Search & Intent Processing
*   **Input**: Text or Voice.
*   **Processing State**: A high-end loading view with brand showcase and intelligent status updates.
*   **Result Categories**:
    1.  **Vehicle**: Highly detailed cards with 4x grid specs, AI-why-it-matches, and NYC dealership integration.
    2.  **Product/Service**: Modern "Place Cards" with call, web, and map interactions.

## 5. Implementation Stages
1.  **Backend Setup**: Secure Sarvam key, set up Express server, targeted to US market.
2.  **Flutter Foundation**: Redesigned home screen with mesh gradients and floating glass bar.
3.  **Vehicle Finder**: Conversational multi-step chat flow to find the perfect car in NYC.
4.  **Polish**: High-density spec grids and glassmorphism elements.

## 6. Constraints & Assumptions
*   **Geography**: Results strictly filtered for **New York** and US market.
*   **Currency**: All pricing in **USD ($)**.
*   **Data Accuracy**: Dealership data and prices are intended to be realistic but should be verified by the user.

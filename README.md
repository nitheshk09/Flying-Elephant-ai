# Hyderabad AI Concierge

A premium, localized AI assistant for Hyderabad that finds real prices, treatments, and courses.

## Architecture
- **Frontend**: Flutter (Mobile App)
- **Backend**: Node.js + Express (Middleware for API key security & orchestration)
- **AI**: Sarvam AI (Intent Classification)
- **Data**: Google Places & Search APIs (Real-time data fetching)

## Prerequisites
- Node.js & npm
- Flutter SDK
- Android Studio / Xcode

## Setup & Run

### 1. Start the Backend Server
This handles the AI communication.
```bash
cd server
npm install
node index.js
```
Server runs on `http://localhost:3000`.

### 2. Run the Mobile App
Open a new terminal.
```bash
flutter pub get
flutter run
```

## Features Implemented
- **Premium UI**: Custom Material 3 theme with Google Sans/Outfit typography.
- **Intent Engine**: Connects to Sarvam AI to understand if you are looking for a Product, Treatment, or Course.
- **State Management**: Uses Riverpod for robust state handling.

## Next Steps
- Add Google Places API Key to `server/.env`.
- Add Google Custom Search API Key to `server/.env`.
- Implement the "Fetch Real Data" step in the backend.

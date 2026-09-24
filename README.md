# Kaza

*Kaza* — Swahili for "tighten, strengthen." An evidence-based fitness and wellness tracking application built with Flutter and Dart, featuring AI-powered photo analysis and personalized coaching via Claude AI.

Part of the [wisdombusara.com](https://wisdombusara.com) family — live at **kaza.wisdombusara.com**.

## Features

### Core Tracking
- **Weight Management**: Track daily weight with trend analysis
- **Workout Logging**: Log resistance, cardio, calisthenics, and combat training
- **Nutrition**: Track meals, macros, and calories
- **Goal Setting**: Create and monitor fitness goals
- **Progress Photos**: Take and analyze body composition photos with AI feedback

### AI & Analytics
- **Claude AI Integration**: Get evidence-based workout recommendations and nutrition advice
- **Progress Photo Analysis**: AI-powered vision feedback on body composition changes
- **Smart Insights**: Data-driven recommendations based on your progress

### Multiple Fitness Domains
- Strength training & resistance
- Cardio & aerobic exercise
- Calisthenics
- Combat sports & conditioning
- Mobility & flexibility
- Yoga, Pilates, Dance
- Recovery & stress management

## Tech Stack

- **Frontend**: Flutter 3.x, Dart 3.x
- **Backend**: Self-hosted API server ([Dart Frog](https://dartfrog.vgv.dev/)) on your own VPS — see [`backend/`](backend/)
- **Database**: PostgreSQL
- **Object storage**: MinIO (S3-compatible), self-hosted
- **AI**: Claude API, proxied server-side so the key never ships in the app
- **State Management**: Provider
- **Auth**: JWT (access + rotating refresh tokens), bcrypt password hashing — fully self-hosted, no third-party auth provider

## Architecture

```
Flutter app  ──HTTPS──>  Dart Frog API  ──>  Postgres (all app data)
(kaza.wisdombusara.com)  (api.wisdombusara.com)  ──>  MinIO (progress photos)
                                              ──>  Claude API (server-side only)
```

The Flutter client never talks to Postgres, MinIO, or Anthropic directly — everything goes through the API in `backend/`. See [`backend/README.md`](backend/README.md) for setting that up on your VPS first; the app has nothing to run against until it's live.

## Getting Started

### Prerequisites
- Flutter SDK 3.0+
- Dart SDK 3.0+
- A running instance of the [backend](backend/) (Postgres + MinIO + the API server)

### Installation

1. **Clone the repository**
   ```bash
   git clone git@github.com:WisdomBusara/unfat.git
   cd unfat
   ```

2. **Set up the backend first** — see [`backend/README.md`](backend/README.md). You'll end up with an API running at something like `https://api.wisdombusara.com`.

3. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

4. **Point the app at your API**
   ```bash
   flutter run --dart-define=API_BASE_URL=https://api.wisdombusara.com
   ```
   Omit `--dart-define` during local development to use the default `http://localhost:8080` (matching `dart_frog dev`).

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── config/
│   └── api_config.dart          # API base URL (overridable via --dart-define)
├── models/                      # Data models (plain JSON, matches API responses)
│   ├── user.dart
│   ├── weight_entry.dart
│   ├── workout.dart
│   ├── nutrition.dart
│   ├── goal.dart
│   └── progress_photo.dart
├── services/                    # Business logic
│   ├── api_client.dart          # Dio client: attaches JWT, auto-refreshes on 401
│   ├── api_service.dart         # All backend calls
│   ├── token_storage.dart       # Secure storage for access/refresh tokens
│   └── camera_service.dart
├── providers/                   # State management
│   ├── auth_provider.dart
│   ├── user_provider.dart
│   ├── weight_provider.dart
│   ├── workout_provider.dart
│   ├── nutrition_provider.dart
│   ├── goal_provider.dart
│   └── photo_provider.dart
├── screens/                     # UI Screens
│   ├── auth/
│   ├── onboarding/
│   ├── home/
│   ├── workouts/
│   ├── nutrition/
│   ├── photos/
│   └── profile/
├── theme/                       # App theming
└── widgets/                     # Reusable widgets

backend/                         # Self-hosted API — see backend/README.md
```

## Features in Progress

### MVP (Phase 1)
- ✅ Self-hosted auth (JWT + bcrypt)
- ✅ Weight tracking
- ✅ Basic workout logging
- ✅ Goal management
- ✅ Progress photo capture + server-side AI vision analysis
- 🔄 Dashboard & analytics UI
- 🔄 Workout/nutrition logging screens

### Phase 2
- Combat sports tracking
- Advanced nutrition planning
- Meal recipes database
- Fasting protocols
- Supplement tracking

### Phase 3
- Lymphatic health module
- Traditional practices library
- Research database integration
- Wearable integration (Apple Health, Fitbit, Garmin)
- Advanced AI coaching

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Evidence-based fitness research and protocols
- Claude AI for personalized coaching
- Flutter, Dart, and Dart Frog communities

## Contact & Support

For issues, questions, or suggestions, please open an issue on GitHub.

---

**Note**: This app is designed to provide evidence-based fitness guidance. Always consult with healthcare professionals before starting new exercise or nutrition programs, especially if you have pre-existing health conditions.

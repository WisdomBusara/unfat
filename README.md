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
- **Progress Photo Analysis**: AI-powered feedback on body composition changes
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
- **Backend**: Firebase (Auth, Firestore, Storage)
- **AI**: Claude API for personalized coaching
- **State Management**: Provider
- **Storage**: Firebase Cloud Storage for progress photos

## Getting Started

### Prerequisites
- Flutter SDK 3.0+
- Dart SDK 3.0+
- Firebase project
- Claude API key

### Installation

1. **Clone the repository**
   ```bash
   git clone git@github.com:WisdomBusara/unfat.git
   cd unfat
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Update `lib/firebase_options.dart` with your Firebase credentials
   - Download your `google-services.json` and `GoogleService-Info.plist` files

4. **Set up environment variables**
   - Create `.env` file with your Claude API key:
     ```
     CLAUDE_API_KEY=your_api_key_here
     ```

5. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/                      # Data models
│   ├── user.dart
│   ├── weight_entry.dart
│   ├── workout.dart
│   ├── nutrition.dart
│   ├── goal.dart
│   └── progress_photo.dart
├── services/                    # Business logic
│   ├── firebase_service.dart
│   ├── claude_api_service.dart
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
```

## Features in Progress

### MVP (Phase 1)
- ✅ User authentication
- ✅ Weight tracking
- ✅ Basic workout logging
- ✅ Goal management
- ✅ Progress photo capture
- 🔄 Photo analysis with Claude API
- 🔄 Dashboard & analytics

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

## Configuration

### Firebase Setup
1. Create a Firebase project at [firebase.google.com](https://firebase.google.com)
2. Enable Authentication (Email/Password)
3. Create Firestore database
4. Enable Storage
5. Update credentials in `firebase_options.dart`

### Claude API
- Get your API key from [console.anthropic.com](https://console.anthropic.com)
- Store in `.env` file or environment variables

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
- Flutter and Dart communities
- Firebase for backend infrastructure

## Contact & Support

For issues, questions, or suggestions, please open an issue on GitHub.

---

**Note**: This app is designed to provide evidence-based fitness guidance. Always consult with healthcare professionals before starting new exercise or nutrition programs, especially if you have pre-existing health conditions.

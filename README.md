# 🏃‍♂️ FitFusion — Premium Flutter Fitness Tracking & Workout Planner Application

🎬 **Watch the Demo Video — FitFusion:** [https://github.com/AnasQ2003/Fitness-App/blob/main/videos/Video_Fitness.mp4](https://github.com/AnasQ2003/Fitness-App/blob/main/videos/Video_Fitness.mp4)

[![Flutter](https://img.shields.io/badge/Flutter-v3.8+-02569B.svg?style=flat-square&logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-v3.8-0175C2.svg?style=flat-square&logo=dart)](https://dart.dev/)
[![Animate](https://img.shields.io/badge/Flutter_Animate-v4.1-blueviolet.svg?style=flat-square&logo=flutter)](https://pub.dev/packages/flutter_animate)
[![Video Player](https://img.shields.io/badge/Video_Player-v2.8-blue.svg?style=flat-square&logo=flutter)](https://pub.dev/packages/video_player)

FitFusion is a premium, feature-rich Flutter fitness application designed to manage workouts, track exercise progress, and execute personalized fitness plans. The platform features an elegant modern interface, interactive progress trackers, video demonstrations, and animated achievements.

---

## ✨ Features

- **📊 Comprehensive Workout Categories** — Browse popular exercises across structured disciplines including Cardio, Strength, Yoga, HIIT, Pilates, and Stretching.
- **⏱️ Active Workout Timer** — Real-time progress timing for exercises with step counts, circular animation progression rings, and play/pause controls.
- **🎥 Video Demonstrations** — Integrated video player (`video_player`) to watch high-definition video walkthroughs of exercises directly on the workout detail screen.
- **📈 Structured Workout Plans** — Ready-to-use beginner (4-week) and intermediate (6-week) multi-day fitness calendars.
- **➕ Custom Plan Creator** — Create and title custom workout plans and add personalized descriptions to adapt to your training goals.
- **👤 Profile Analytics & Badges** — Track overall achievements and core statistics (Workouts logged, active Hours, total Calories burned) alongside gamified badge indicators.
- **❤️ Favorites Drawer** — Quickly bookmark workouts using an animated favorite like button to display them in a dedicated favorites tab.
- **🔍 Fast Search** — Find specific workouts instantly using the built-in search view.
- **🌙 Premium UI Toggles** — Custom settings panels to easily configure notification triggers and toggle sound effects or dark/light modes.
- **⚡ Framer-like Animations** — Powered by `flutter_animate` to trigger elegant fade-ins, scales, and item-entrance visual adjustments.

---

## 🛠️ Tech Stack & Dependencies

### Core Frameworks
- **Flutter SDK (>=3.8.1)** — Cross-platform UI development kit.
- **Dart Language** — High-performance modern app codebase.

### Third-Party Libraries
- **`flutter_animate` (v4.1.1)** — Triggers premium entry effects, shakes, and visual cues.
- **`video_player` (v2.8.0)** — Handles high-performance native mp4 file streaming and playback.
- **`animated_text_kit` (v4.2.2)** — Animates title headers and typing effects in app bars.
- **`like_button` (v2.1.0)** — Renders interactive favorite toggles with bubble animation bursts.
- **`cupertino_icons` (v1.0.5)** — iOS style system vector resources.

---

## 📁 Project Structure

```
fitness_app/
│
├── assets/                         # Application resources
│   ├── images/
│   │   ├── workouts/               # Cardio, Strength, Yoga illustrations
│   │   ├── exercises/              # Jumping jacks, push-ups, squats thumbnails
│   │   └── misc/                   # Profile and general icons
│   └── *.mp4                       # HD exercise demonstration videos
│
├── lib/
│   └── main.dart                   # Single-entry app architecture (UI & routes)
│
├── screenshot/                     # Walkthrough screenshots of the application
├── videos/                         # Demo and tutorial recording videos
│   └── Video_Fitness.mp4           # App walkthrough video demonstration
│
├── test/                           # Widget and unit testing suite
├── pubspec.yaml                    # Dependency configuration manifest
├── analysis_options.yaml           # Lint formatting definitions
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK** (v3.8.0 or higher)
- **Dart SDK** (v3.8.0 or higher)
- An **Android Emulator / iOS Simulator** or a physical test device

---

### Setup Instructions

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/AnasQ2003/Fitness-App.git
   cd Fitness-App
   ```

2. **Install Flutter Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify Connected Devices:**
   ```bash
   flutter devices
   ```

4. **Run the Application:**
   ```bash
   flutter run
   ```

---

## 📷 Screenshots Gallery

A complete visual walkthrough of the FitFusion interface showcasing its onboarding flow, workouts dashboard, category details, active workout timer, planner, nutrition logs, analytics, and dark mode configuration.

<table align="center">
  <tr>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053303.png" width="250"/><br/><sub>1. Splash & Welcome</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053310.png" width="250"/><br/><sub>2. Login Screen</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053327.png" width="250"/><br/><sub>3. Sign Up Screen</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053358.png" width="250"/><br/><sub>4. Onboarding Welcome</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053408.png" width="250"/><br/><sub>5. Gender Selection</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053418.png" width="250"/><br/><sub>6. Age Selection</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053432.png" width="250"/><br/><sub>7. Height & Weight Setup</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053558.png" width="250"/><br/><sub>8. Home Dashboard</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053609.png" width="250"/><br/><sub>9. App Drawer Menu</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053620.png" width="250"/><br/><sub>10. Search Workouts</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053640.png" width="250"/><br/><sub>11. Filter Categories</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053648.png" width="250"/><br/><sub>12. Categories Grid</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053702.png" width="250"/><br/><sub>13. Cardio Category Details</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053716.png" width="250"/><br/><sub>14. Strength Category Details</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053725.png" width="250"/><br/><sub>15. Yoga Category Details</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053737.png" width="250"/><br/><sub>16. HIIT Category Details</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053806.png" width="250"/><br/><sub>17. Workout Detail View</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053818.png" width="250"/><br/><sub>18. Video Demonstrations</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053834.png" width="250"/><br/><sub>19. Exercise Step Items</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053843.png" width="250"/><br/><sub>20. Detailed Descriptions</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053850.png" width="250"/><br/><sub>21. Start Workout Actions</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053903.png" width="250"/><br/><sub>22. Workout Timer Setup</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053911.png" width="250"/><br/><sub>23. Active Timer Running</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053934.png" width="250"/><br/><sub>24. Timer Paused View</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053941.png" width="250"/><br/><sub>25. Workout Completed</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20053951.png" width="250"/><br/><sub>26. Workout Plans List</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20054003.png" width="250"/><br/><sub>27. Create Custom Plan</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20054020.png" width="250"/><br/><sub>28. Plan Details & Weeks</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20054029.png" width="250"/><br/><sub>29. Plan Workouts Calendar</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20054046.png" width="250"/><br/><sub>30. Favorites Drawer (Empty)</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20054104.png" width="250"/><br/><sub>31. Favorites Bookmarked</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20054113.png" width="250"/><br/><sub>32. Profile Stats & Badges</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20054122.png" width="250"/><br/><sub>33. Performance History</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20054132.png" width="250"/><br/><sub>34. Nutrition Daily Log</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20054138.png" width="250"/><br/><sub>35. Nutrition Details Log</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20054149.png" width="250"/><br/><sub>36. Settings & Config Menu</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20054158.png" width="250"/><br/><sub>37. Dark Mode Configuration</sub></td>
    <td align="center"><img src="screenshot/Screenshot%202026-07-13%20054254.png" width="250"/><br/><sub>38. Help & Contact Center</sub></td>
    <td></td>
  </tr>
</table>

---

## 📄 License

```
MIT License

Copyright (c) Fitness=App---2026 AnasQ2003

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
```

---


## 👨‍💻 Author

**Anas Ahmed Qureshi.** — [@AnasQ2003](https://github.com/AnasQ2003)

---

<div align="center">
  <p>Built with ❤️ by <strong>Anas</strong></p>
  
 <div align="center">

Made with 🔥 and a lot of ☕

**⭐ If you found this useful, please star the repository!**

</div>

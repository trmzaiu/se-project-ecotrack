# 🌱 EcoTrack - Waste Sorting App

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.13-blue)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-9.22-orange)](https://firebase.google.com)

**Transform waste management with AI-powered classification and gamified sustainability!**

## 📱 Key Features
- 🖼️ **Waste Classification with AI**: a key feature designed to help users easily identify the type of waste
- 🌳 **Virtual Tree and Donation Mechanism**: encourages users to use their points for an environmental contribution.
- 📸 **Upload Evidence Module**: verify whether users have correctly classified waste according to the app's classification guidelines.  

## 🛠️ Core Technologies
**Frontend Framework**  
📱 Flutter - For cross-platform UI development and performance optimization

**Backend Services**  
🔥 Firebase:
- **Authentication** - Secure user login and session management  
- **Firestore** - Real-time database for user profiles, evidence, and challenges  
- **Cloud Messaging** - Push notification delivery  

**Media & AI**  
☁️ Cloudinary - Secure image upload and storage  
🧠 CLIP AI Model - Waste classification (Recyclable/Organic/Hazardous/General)

## 📥 Installation
### Option 1: Download APK
[![QR Code](https://res.cloudinary.com/dosqd0oni/image/upload/c_fill,w_200,h_200/v1746273015/qr-code_nw3qwr.png)](https://res.cloudinary.com/dosqd0oni/image/upload/c_fill,w_200,h_200/v1746273015/qr-code_nw3qwr.png)

1. Scan the QR code or visit [[Latest Release]](https://github.com/trmzaiu/se-project-waste-sort-app/releases/download/EcoTrack/app-release.apk)
2. Download `app-release.apk`
3. Enable "Unknown Sources" in Android Settings
4. Install and launch!

### Option 2: Build from Source
```bash
flutter pub get
flutter run

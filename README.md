# 🌱 Smart Farm IoT & Weed Detection System

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)

_A comprehensive IoT-powered smart farming solution with AI-driven weed detection and real-time monitoring capabilities._

</div>

## 🚀 Overview

Smart Farm IoT is a cutting-edge mobile application that revolutionizes modern agriculture by combining Internet of Things (IoT) sensors, machine learning-powered weed detection, and intuitive farm management tools. Built with Flutter for cross-platform compatibility, this app empowers farmers to monitor their crops in real-time, detect weeds automatically, and make data-driven decisions to optimize their farming operations.

## ✨ Key Features

### 🔐 **Authentication & Security**

- **Firebase Authentication** with email/password and Google Sign-In
- Secure user registration and login system
- Password reset functionality
- Session management and auto-login

### 📊 **Real-Time IoT Monitoring**

- **Live sensor data** from multiple farm locations
- Temperature, humidity, soil moisture, and light intensity tracking
- **Interactive charts** with historical data visualization
- Real-time alerts and notifications for critical conditions
- CORS-compliant API integration with fallback mock data

### 🤖 **AI-Powered Weed Detection**

- **Machine learning integration** for automated weed identification
- Camera-based weed detection with image upload
- Real-time analysis and classification results
- Detection history and analytics

### 🚜 **Farm Management**

- **Multi-farm support** with detailed farm profiles
- Comprehensive dashboard with key metrics
- Equipment control and monitoring
- Crop management and planning tools

### 📱 **Modern Mobile Experience**

- **Cross-platform** support (Android & iOS)
- Intuitive navigation with bottom tab bar
- **Dark/Light theme** support
- Responsive design for all screen sizes
- Offline capability with data synchronization

### 👤 **User Profile & Settings**

- **Editable user profiles** with image upload
- Farm information management
- Statistics and performance metrics
- Notification preferences
- Data export functionality

## 🛠️ Technology Stack

### **Frontend**

- **Flutter 3.x** - Cross-platform mobile framework
- **Dart** - Programming language
- **Google Fonts** - Typography
- **FL Chart** - Interactive data visualization
- **Image Picker** - Camera and gallery integration

### **Backend & Services**

- **Firebase Authentication** - User management
- **Firebase Cloud Firestore** - Real-time database
- **REST API** - IoT sensor data integration
- **Google Services** - OAuth and cloud integration

### **Architecture**

- **Feature-based architecture** for scalability
- **Provider/Bloc pattern** for state management
- **Repository pattern** for data abstraction
- **Clean architecture principles**

## 📁 Project Structure

```
lib/
├── features/
│   ├── auth/
│   │   ├── screens/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   └── services/
│   ├── home/
│   │   └── screens/
│   │       ├── home_screen.dart
│   │       ├── farm_details_screen.dart
│   │       └── profile_screen.dart
│   ├── weed_detection/
│   │   └── screens/
│   │       └── weed_detection_screen.dart
│   ├── control/
│   │   └── screens/
│   │       └── control_car_screen.dart
│   ├── notifications/
│   │   └── screens/
│   │       └── notifications_screen.dart
│   └── camera/
│       └── screens/
│           └── camera_screen.dart
├── services/
│   ├── auth_service.dart
│   └── api_service.dart
├── models/
│   └── sensor_data.dart
├── firebase_options.dart
└── main.dart
```

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** (3.0 or higher)
- **Dart SDK** (3.0 or higher)
- **Android Studio** or **VS Code** with Flutter extensions
- **Firebase project** with Authentication and Firestore enabled
- **Android/iOS device** or emulator

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/weed_detection_iot_ml.git
   cd weed_detection_iot_ml
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Firebase Setup**

   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication (Email/Password and Google Sign-In)
   - Enable Cloud Firestore
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place the files in their respective platform directories

4. **Configure Firebase**

   ```bash
   flutter packages pub run build_runner build
   ```

5. **Run the application**
   ```bash
   flutter run
   ```

## 📱 Screenshots & Demo

### Authentication Flow

- Clean, modern login and registration screens
- Google Sign-In integration
- Form validation and error handling

### Dashboard & Monitoring

- Real-time sensor data visualization
- Interactive charts with multiple data points
- Farm overview with key metrics

### Weed Detection

- Camera integration for image capture
- AI-powered weed classification
- Detection results and recommendations

### Profile Management

- Editable user profiles
- Farm information management
- Statistics and analytics

## 🔧 Configuration

### API Configuration

Update the API endpoints in `lib/services/api_service.dart`:

```dart
static const String baseUrl = 'YOUR_IOT_API_ENDPOINT';
```

### Firebase Configuration

Ensure your `firebase_options.dart` is properly configured with your project credentials.

## 🧪 Testing

Run the test suite:

```bash
flutter test
```

For integration tests:

```bash
flutter drive --target=test_driver/app.dart
```

## 📦 Build & Deployment

### Android

```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Flutter/Dart style guidelines
- Write comprehensive tests for new features
- Update documentation for API changes
- Ensure cross-platform compatibility

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team** for the amazing framework
- **Firebase** for backend services
- **Material Design** for UI components
- **IoT sensor manufacturers** for hardware integration
- **Open source community** for various packages and tools

## 📞 Support & Contact

- **Issues**: [GitHub Issues](https://github.com/yourusername/weed_detection_iot_ml/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/weed_detection_iot_ml/discussions)
- **Email**: your.email@example.com

---

<div align="center">

**Made with ❤️ for sustainable agriculture**

_Empowering farmers with technology for a greener future_

</div>

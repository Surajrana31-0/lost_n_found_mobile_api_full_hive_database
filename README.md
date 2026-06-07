# Lost & Found Mobile App

A Flutter mobile application for Softwarica College's lost and found system.

> **Note:** This project is solely for college teaching purposes only.

## Backend API

This app uses the following backend API:

- **Repository:** https://github.com/kiranrana8973/lost_n_found_api

## Getting Started

This project is a starting point for a Flutter application.

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio / VS Code

### Installation

1. Clone the repository

```bash
git clone https://github.com/kiranrana8973/lost_n_found_mobile.git
```

2. Install dependencies

```bash
flutter pub get
```

3. Run the app

```bash
flutter run
```

## Features

- User authentication (Login/Signup)
- Report lost items
- Report found items
- Browse lost and found items
- Item details and claiming


# For baseUrl to host a application in localhost
// Base URL - change this for production
  // static const String baseUrl = 'http://10.0.2.2:3000/api/v1';//emmulator
  // static const String baseUrl = 'http://[2400:1a00:3b67:621e:921d:5bb7:5c96:c695]:3000/api/v1';//Mero ghar ko wify
  // static const String baseUrl = 'http://192.168.1.xxx:3000/api/v1'; 
  // static const String baseUrl = 'http://192.168.x.x:3000/api/v1';

  //static const String baseUrl = 'http://localhost:3000/api/v1';
  // For Android Emulator use: 'http://10.0.2.2:3000/api/v1'
  // For iOS Simulator use: 'http://localhost:3000/api/v1'
  // For Physical Device use your computer's IP: 'http://192.168.x.x:3000/api/v1'


# To run in every exixting divices use
```bash
flutter run -d all  
```
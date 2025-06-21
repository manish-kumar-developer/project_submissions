# 📦 Project Submission – Laravel & Flutter App

A complete Laravel 12 backend API and Flutter mobile client, demonstrating authentication, data management, and a live deployment for easy testing.

---

## 🚀 Live Version & APK Download

I’ve deployed the backend to Plesk and built a Flutter release APK so you can jump right in:

- 🔗 **Live API Base URL:**  
  https://submission.sarmie.in/

- 📱 **Download Android APK:**  
  https://github.com/manish-kumar-developer/project_submissions/blob/main/app-release.apk


| Role   | Email                          | Password  |
|--------|--------------------------------|-----------|
| Admin  | admin@example.com              | password  |
| User   | herzog.euna@example.com        | password  |

---

## 📂 Repository Structure



![Demo](demo.gif)

This project consists of:

- 🔙 **Laravel 12 Backend (API only)**  
- 📲 **Flutter Frontend App**

A complete full-stack solution where the Laravel backend provides secure RESTful APIs, and the Flutter app consumes them to deliver a seamless mobile experience.

---

## 🛠️ Getting Started

### 📦 Requirements

#### For Laravel Backend
- PHP >= 8.1
- Composer
- MySQL 
- Laravel 12
- Postman or API testing tool (optional)

#### For Flutter App
- Flutter SDK (latest stable)
- Android Studio or VS Code
- Dart >= 3.x
- Android/iOS Emulator or Device

---

## 🚀 Backend: Laravel 12 API Setup

```bash
cd laravel-backend-folder
composer install
cp .env.example .env
php artisan key:generate

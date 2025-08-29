# 🛒 Shop-Ease Admin Panel

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)](https://flutter.dev)  
[![State Management](https://img.shields.io/badge/State%20Management-Bloc%20%2B%20Cubit-purple)](https://bloclibrary.dev/#/)  
[![Auth](https://img.shields.io/badge/Auth-Supabase-green?logo=supabase)](https://supabase.com)  
[![Backend](https://img.shields.io/badge/Backend-Node.js%20%2B%20Express-lightgreen?logo=node.js)](https://expressjs.com)  
[![Database](https://img.shields.io/badge/Database-PostgreSQL-blue?logo=postgresql)](https://www.postgresql.org/)  
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)  
[![Contributions Welcome](https://img.shields.io/badge/Contributions-Welcome-orange)](../../issues)  

> **Admin Dashboard** for managing products, banners, and users in the **Shop-Ease** e-commerce ecosystem.  
Built with **Flutter**, powered by **Bloc state management**, **Supabase authentication**, and a **REST API backend**.  

---

## ✨ Features

- 🔐 **Authentication** with Supabase (login, logout, session persistence)  
- 📦 **Product Management** (CRUD, image upload, rating, price, description)  
- 🖼️ **Banner Management** (CRUD, title validation, image upload)  
- 🧭 **Sidebar Navigation** with Cubit state management  
- 🖼️ **Image Picker Cubit** for local byte handling before upload  
- ⚡ Optimized with **Bloc + Equatable** (minimal rebuilds, predictable states)  
- 🌐 Configurable **API URL system** (`api_url_remote.dart`) for local/production switching  
- 📱 **Responsive Flutter UI** suitable for web and desktop  

---

## 🏗️ Project Structure

```
lib/
├── core/                     # API base URLs and constants
│   ├── app_theme.dart
│   ├── api_url_remote.dart
│   └── api_url.dart
│____ config/
├── data/
│   └── repositories/         # Data layer (Auth, Products, Banners)
│
├── features/
│   └── views/
│       ├── auth/             # AuthBloc, Login UI, states, events
│       ├── products/         # ProductBloc, models, CRUD
│       └── banners/          # BannerBloc, models, CRUD
│       |___ dashboard/       # DashboardBloc, UI    
├── services/                 # NetworkService for multipart/form-data   
|__ widgets/
|__ app.dart                  
└── main.dart                 # Entry point

```
## 🧩 State Management

- **Bloc (flutter_bloc)** for major features:
  - `AuthBloc` → handles login/logout/session
  - `ProductBloc` → handles product CRUD & validation
  - `BannerBloc` → handles banner CRUD & validation  

- **Cubit** for lightweight UI state:
  - `SidebarNavigationCubit` → tracks active menu/route
  - `ImagePickerCubit` → manages selected image bytes
  - `PasswordVisibilityCubit` → toggles login password field  

---

## 🔐 Authentication

- **Backend:** Supabase (`supabase_flutter`)  
- **Repository:** `auth_repository.dart`  
  - `signIn(email, password)`  
  - `getCurrentUser()`  
  - `signOut()`  

- **Bloc flow:**  
  - Events → `AuthSignInRequested`, `AuthSignOutRequested`, `AuthCheckRequested`  
  - States → `AuthInitial`, `AuthLoading`, `AuthAuthenticated(User)`, `AuthUnauthenticated`, `AuthFailure(String)`  

---

## 🌐 API Endpoints

> Base URL defined in `core/api_remote_base_url.dart`.  
Switch between **local (`http://localhost:4000/api`)** and **production** by editing this file.  

### 🔹 Products
- `POST    /products/add`  
- `GET     /products`  
- `GET     /products/:id`  
- `PUT     /products/update/:id`  
- `DELETE  /products/delete/:id`  

### 🔹 Banners
- `POST    /banners/add`  
- `GET     /banners`  
- `GET     /banners/:id`  
- `PUT     /banners/update/:id`  
- `DELETE  /banners/delete/:id`  

---

## 🗂️ CRUD via Repositories

- **Products:** `product_repository.dart`  
  - `addProduct(ProductModel, Uint8List image)` → multipart upload  
  - `fetchProducts()` / `fetchProductById(id)`  
  - `updateProduct(product, [image])`  
  - `deleteProduct(id)`  
  - `doesProductTitleExist(name)`  

- **Banners:** `banner_repository.dart`  
  - `addBanner(BannerModelLocal)` → multipart upload  
  - `fetchBanners()` / `fetchBannerById(id)`  
  - `updateBanner(id, ...)`  
  - `deleteBanner(id)`  
  - `doesBannerTitleExist(title)`  

- **Network Service:** `services/network_service_banner.dart`  
  - Singleton class with `postMultipart` / `putMultipart`  
  - Uses `http.MultipartRequest` for image + text fields  

---

## 📊 Data Models

- **ProductModel** → `id`, `name`, `price`, `rating`, `description`, `imageUrl`  
- **BannerModel** → `id`, `title`, `imageUrl`  
- **BannerModelLocal** → form helper (title + imageBytes)  

---

## ⚡ Optimizations

- `Equatable` for efficient Bloc state comparison (less widget rebuilds)  
- Centralized `ApiRemoteBaseUrl` for environment switching  
- Multipart uploads instead of base64 (lighter & faster)  
- `doesTitleExist` methods to validate uniqueness client-side  
- Repositories decouple UI from data/network logic  

---

## 🚀 Getting Started

### 1️⃣ Prerequisites
- Flutter SDK (>=3.0)  
- Supabase project (with email/password auth enabled)  
- API backend (Shop-Ease API running on Node.js/Express)
- 
# ** Update core/api_remote_base_url.dart with your API URL **
# ** Add Supabase credentials in main.dart initialization **
### 2️⃣ Installation

```bash
# Clone the repo
git clone https://github.com/your-org/shop-ease-admin.git
cd shop-ease-admin

# Install dependencies
flutter pub get

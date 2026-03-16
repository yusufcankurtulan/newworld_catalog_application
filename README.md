# 🛍️ New World Catalog App

A modern and user-friendly **e-commerce catalog application** developed with Flutter.

The application allows users to browse products, view detailed product information, and add items to a shopping cart with an automatically applied discount system.

---

## 📱 About the Project

New World Catalog App is designed to demonstrate a clean mobile architecture and modern UI patterns using Flutter. Products are fetched dynamically from an API and displayed in a smooth, card-based interface. Users can explore product details and manage a smart shopping cart that automatically calculates discounts and savings.

The application also includes a simple authentication flow. Users are required to create an account and log in before accessing the app. For demonstration purposes, user credentials are stored locally on the device rather than using a remote authentication service.

---

## ✨ Features

### 📦 Product Catalog
- Dynamically fetches products from an API
- Displays products in a modern card-based layout

### 🔍 Product Details
- Shows complete product information
- Includes price, description, and category

### 💸 20% Discount System
- Automatically applies a **20% discount** to products added to the cart

### 🛒 Smart Cart
- Add products to the cart
- Remove products from the cart
- Delete items completely
- Automatic discount and savings calculation

### 📊 Savings Display
- Unit discount amount
- Total savings percentage
- Comparison between original and discounted prices

### 🎨 Modern UI
- Gradient AppBar
- Card-based product design
- Smooth UI animations
- Clean and minimal layout

---

## 🧰 Technology Stack

- **Flutter 3.41.2** – Cross-platform UI framework used to build the application  
- **Dart** – Programming language used for Flutter development  
- **Provider (ChangeNotifier)** – State management for handling cart and product states  
- **REST API** – Dynamic product data fetched from Fake Store API  
- **Fake Store API** – https://fakestoreapi.com/products

---

## 🚀 Installation

Clone the repository and install dependencies:

```bash
git clone https://github.com/yusufcankurtulan/newworld_catalog_application.git
cd newworld_catalog_application
flutter pub get

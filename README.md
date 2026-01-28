# 🍽 Smart Recipe Manager (iOS)

Smart Recipe Manager is a modern iOS application built with **SwiftUI** that allows users to create, manage, and explore recipes seamlessly.  
The app supports **local recipe management**, **API-based recipe inspiration**, **shopping list generation**, **favorites**, **cooked status tracking**, **profile analytics**, and **secure authentication**.

---

## ✨ Key Features

### 🔐 Authentication
- Login & Sign-Up flow using `@AppStorage`
- Persistent login state
- Secure logout from Profile section
- Personalized greeting using stored username

---

### 🏠 Home (My Recipes)
- View all saved recipes in a **grid layout**
- Filter recipes by category:
  - All
  - Vegetarian
  - Vegan
  - Dessert
- Add new recipes with image support
- Favorite / Unfavorite recipes
- Navigate to detailed recipe view
- Persistent storage using **Core Data**

---

### ➕ Add / Edit Recipe
- Add and edit recipes using a **SwiftUI Form**
- Fields:
  - Recipe name
  - Category
  - Cooking time (Stepper)
  - Difficulty (Slider)
  - Ingredients (multi-line input)
  - Cooking steps
  - Recipe image (Photo Library)
- Images are:
  - Selected via `PhotosPicker`
  - Saved securely to disk
  - Re-loaded using `AsyncImage`
- Supports both **create** and **edit** modes

---

### 📖 Recipe Detail View
- Hero image display
- Ingredients list
- Step-by-step cooking instructions
- Mark recipe as **Cooked / Done**
- Generate shopping list
- Favorite & share recipe
- Edit / Delete recipes (with Undo support)
- API recipes can be saved to Home

---

### 🌐 API Recipes (Inspiration)
- Fetch up to 5 random recipes from a public API
- Display recipes in elegant cards
- Open full recipe details
- Save API recipes to **My Recipes**
- API recipes become fully editable once saved

---

### 🛒 Shopping List
- Generate shopping list from selected recipes
- Ingredient checklist
- Persistent state across app relaunch

---

### 👤 Profile
- User profile section with avatar
- Stats dashboard:
  - Total Recipes
  - Favorite Recipes
  - Cooked Recipes
- Settings:
  - Dark Mode toggle (persistent)
  - Logout button

---

### 🌗 Dark Mode
- Fully adaptive UI
- Persistent user preference
- Works across all screens

---

### 💾 Data Persistence
- **Core Data** for local recipe storage
- Proper relationships for ingredients
- Disk-based image persistence (no image loss)
- Undo support for recipe deletion

---

## 🛠 Technologies Used

- **SwiftUI** – UI and navigation
- **Core Data** – Local persistence
- **Combine** – State updates via `@Published`
- **PhotosPicker** – Image selection
- **AsyncImage** – Image loading
- **Widget-ready architecture**
- **MVVM architecture**

---

## 📂 Project Structure

```plaintext
SmartRecipeManager
│
├── App
│   └── SmartRecipeManagerApp.swift
│
├── Authentication
│   ├── LoginView.swift
│   └── SignUpView.swift
│
├── Models
│   ├── Recipe.swift
│   ├── Ingredient.swift
│   └── APIRecipe.swift
│
├── ViewModels
│   └── RecipeViewModel.swift
│
├── Views
│   ├── Home
│   │   ├── HomeView.swift
│   │   ├── RecipeCard.swift
│   │   └── CategoryPicker.swift
│   │
│   ├── Recipe
│   │   ├── AddEditRecipeView.swift
│   │   └── RecipeDetailView.swift
│   │
│   ├── API
│   │   └── APIRecipesView.swift
│   │
│   ├── Shopping
│   │   └── ShoppingListView.swift
│   │
│   └── Profile
│       └── ProfileView.swift
│
├── CoreData
│   ├── PersistenceController.swift
│   ├── CoreDataMapper.swift
│   └── SmartRecipeManager.xcdatamodeld
│
├── Components
│   ├── ShareSheet.swift
│   └── ReusableViews.swift
│
└── Resources
    └── Assets.xcassets

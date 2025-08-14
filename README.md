# 🍳 Recipe Buddy

Recipe Buddy is a SwiftUI iOS app that helps users browse, search, and save recipes, plan meals, and generate a shopping list — all with an offline-first experience.  

## 🚀 How to Run

1. **Clone the repository**:
   ```bash
   git clone https://github.com/rivaldofez/RecipeBuddy.git
   cd RecipeBuddy
   ```

2. **Open in Xcode**:
   - Open `RecipeBuddy.xcodeproj` in Xcode 15 or newer.

3. **Run the app**:
   - Select an iOS Simulator or a connected device.
   - Press `Cmd + R` to build and run.

No additional configuration is needed — the app ships with a bundled `recipes.json` for offline use.

---

## 🏗 Architecture and Trade-offs

**Architecture**:  
- **MVVM** pattern with `Repository` abstraction for data access.
- **Repository Protocol** allows switching between local bundled data and remote JSON.
- **Async/Await** for async operations.
- State is managed with `@StateObject` and `@Published` properties.
- Image loader and caching using KingFisher library.

**Trade-offs**:
- **Persistence**: Chose `CoreData` for favorites, offline first, and meal plan
- **Offline-first**: Bundled JSON guarantees offline availability with cached in Core Data; remote fetch is first if available and falls back gracefully.
- **Ingredient quantities**: Basic string parsing for shopping list merge. More robust unit conversion could be added.

---

## ✅ Completed Features

### **Level 1 — Core (60 pts)**
- **Home list**: Load recipes from bundled `recipes.json`, display thumbnail, title, tags, and estimated time.
- **Detail screen**: Show image, ingredients, step-by-step method; check off obtained ingredients (UI state only).
- **Search & Empty States**:
  - Search by title or ingredient (debounced).
  - Friendly empty/error states.
- **Favorites (Persisted)**: Toggle from list/detail; persisted with CoreData.
- **Architecture & State**: MVVM + Repository, async/await, no IO in Views.

### **Level 2 — Plus (25 pts)**
- **Sort & Filter**: Sort by time (asc/desc); filter by tags with multi-select chips.
- **Offline-first**:
  - Default to remote JSON.
  - Switch to local JSON and CoreData for fallback.
- **Tests & Caching**:
  - Unit tests for repository or domain layer.
  - Image loader and caching via `KingFisher`.

### **Level 3 — Pro (10 pts)**
- **Meal Plan + Shopping List**:
  - Add recipes to “This Week’s Plan”.
  - Consolidated shopping list merges duplicate ingredients/quantities.
- **Share Sheet**:
  - Share shopping list via iOS system share sheet.

---
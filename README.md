# 🎬 Movie Explorer

An iOS app built using **Swift**, **UIKit**, and **MVVM** architecture to browse and search movies using **TMDB API**. It supports features like movie detail view, search with debounce, pagination, favorite management with **Realm**, and **AVPlayer** for watching trailers.

---

## 📱 Features

### 🏠 Home Screen
- Displays **Now Playing** or **Popular** movies.
- Shows **poster**, **title**, **release date**, and **rating**.
- Supports **pagination** after every 10 items.

### 🔍 Search
- Search movies by title.
- Debounced search with 500ms delay.
- Search bar appears above the movie list.

### 🎬 Movie Detail
- Shows **title**, **poster**, **overview**, **release date**, **genres**, and **rating**.
- Button to **add/remove favorites** (persisted via Realm).
- Button to **Watch Trailer**, playing in **landscape** using `AVPlayer`.

### ❤️ Favorites
- Favorites are persisted using **Realm**.
- **Local notifications** alert users when a movie is added to favorites.

---

## 🧠 Architecture

Built with **MVVM**:
- `ViewController`: Handles view lifecycle and UI binding.
- `ViewModel`: Contains business logic and data formatting.
- `ServiceManager`: Handles all TMDB API networking.
- `VideoPlayerManager`: Modular AVPlayer logic to play trailers in landscape mode.

---

## 🧩 Dependencies

- [Alamofire](https://github.com/Alamofire/Alamofire) – Networking
- [RealmSwift](https://realm.io/) – Local data persistence
- `AVKit` – Video playback
- `UIKit` – Interface and navigation

Install via CocoaPods:

```bash
pod 'Alamofire'
pod 'RealmSwift'

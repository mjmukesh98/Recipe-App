## 📘 README

---

## 🏗️ Architecture Explanation

This project follows **Clean Architecture** with a feature-based structure to keep the code scalable and maintainable.

The codebase is divided into three main layers:

* **Presentation Layer** → UI and BLoC
* **Domain Layer** → UseCases and business logic
* **Data Layer** → API calls and local storage (Hive)

Each feature (auth, recipes, etc.) is self-contained, which makes the app easy to extend and test.

---

## ⚙️ State Management Approach

The app uses **BLoC (Business Logic Component)** for state management.

### Why BLoC?

* Separates UI from business logic
* Predictable state flow
* Easy to test and scale

### Flow:

```
UI → Event → Bloc → UseCase → Repository → State → UI
```

Each feature has its own Bloc:

* AuthBloc → login & register flow
* RecipeBloc → fetch + cache recipes
* NetworkBloc → internet status
* ThemeBloc → light/dark theme

---

## 🔐 Token Refresh Strategy

The app uses **JWT authentication with automatic token refresh using Dio interceptors**.

### Flow:

1. User logs in and receives:

    * Access Token (short-lived)
    * Refresh Token (long-lived)

2. Access token is attached to every API request.

3. If the server returns **401 Unauthorized**:

    * Refresh API is called automatically
    * Refresh token is sent to server
    * New access token is received
    * Original request is retried automatically

4. If refresh fails:

    * Stored tokens are cleared
    * User is logged out
    * Session is terminated

This ensures users stay logged in without manual re-authentication.

---

## 💾 Offline Caching Strategy

The app supports **offline-first functionality using Hive local storage**.

### Flow:

* When online:

    * Data is fetched from API
    * Response is stored in Hive cache

* When offline:

    * App reads data directly from Hive
    * UI continues working without internet

### Benefits:

* Smooth offline experience
* Reduced API calls
* Faster data loading
* Reliable fallback when network is unavailable

---

## ✅ Summary

* Clean Architecture ensures separation of concerns
* BLoC manages predictable state flow
* Dio interceptor handles secure token refresh automatically
* Hive provides offline-first data support

---

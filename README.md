# Bhoomi Sakti 🪴 – Soil-Tech Platform

> Agriculture-focused Flutter application that digitises soil testing, crop advisory and agri-service delivery for **Farmers, Agents & Admins**.
> Built end-to-end by **[Your Name] – Solo Flutter Engineer**.

---

## 🚀 Why this project matters

1. **Real-world complexity:** multi-role app with secure login, e-commerce–style shop/cart/checkout, orders & payments, plus agronomy workflows.
2. **Enterprise-grade architecture:** Clean Architecture, feature-first modules, SOLID principles, CI-ready.
3. **Production readiness:** flavour-based builds, error handling, token refresh, offline cache, analytics hooks, theming & localisation scaffolds.

---

## 📹 Demo Video

Once you clone the repository you can watch a short walkthrough of the main user flows:

```html
<!-- GitHub renders the HTML <video> tag, providing in-page playback -->
<video src="assets/demo1.mp4" controls style="max-width: 100%; height: auto;">
  Your browser does not support the <code>video</code> tag.
</video>
```

```html
<!-- GitHub renders the HTML <video> tag, providing in-page playback -->
<video src="assets/demo2.mp4" controls style="max-width: 100%; height: auto;">
  Your browser does not support the <code>video</code> tag.
</video>
```

## 🧰 Tech Stack & Key Decisions

| Layer | Technology | Why |
|-------|------------|-----|
| UI & Routing | Flutter 3.22, **go_router** | Declarative navigation, deep links, guards |
| State | **flutter_bloc** (complex flows), **Riverpod** (DI/light state) | Clear separation of concerns, testability |
| Networking | **dio** + interceptors (Token, Refresh) | Fine-grained HTTP control, retry, logging |
| Local Storage | **isar** | High-performance NoSQL, offline cache |
| Secure Storage | **flutter_secure_storage** | Persist JWT & refresh tokens |
| Functional utils | **fpdart** | `Either<Failure, T>` for errors |
| CI ready | GitHub Actions (template included) | Automated format → analyse → test → build |

> All packages pinned in `pubspec.yaml` for reproducible builds.

---

## 🏛️ Architecture

Clean Architecture with feature slicing:

```
lib/
  app/                ← App-level config (router, themes, injections)
  core/               ← Cross-cutting concerns (exceptions, failure, utils)
  features/
    auth/
      data/ • domain/ • presentation/
    products/
    cart/
    checkout/
    orders/           ← scaffolded (API pending)
  common/             ← Reusable widgets, extensions, providers
```

### Data-Flow Diagram

```
UI (Bloc / Riverpod Consumer)
  │  events / state
  ▼
UseCase   ←–– functional wrapper (Either<Failure,T>)
  │
  ▼
Repository (abstract in domain → impl in data)
  │
  ├── RemoteDataSource (Dio)   ↔  API / JSON
  └── LocalDataSource  (Isar)  ↔  Device DB
```

### Navigation Graph (excerpt)

```
/splash → /login → /home (ShellRoute)
                ├─ /dashboard
                ├─ /shop
                │     └─ /shop/product/:productId
                ├─ /cart
                └─ /profile
```

Auth guard redirects unauthenticated users to `/login` and prevents back-navigation to splash.

---

## 🧑‍💻 Running the app

```bash
# Get packages
flutter pub get

# Run Dev flavour
flutter run --flavor dev -t lib/main_dev.dart

# Run Prod flavour (release)
flutter run --flavor prod -t lib/main_prod.dart --release
```

> VS Code users: `.vscode/launch.json` already contains launch configs *Bhoomi Sakti (Dev/Prod/Profile)*.

### Environment variables

```
# .env.dev
API_BASE_URL=https://dev.api.example.com
# ...
```
Loaded at start-up via `flutter_dotenv` (hooked in `main_*.dart`).

---

## 📝 Testing & Quality Gates

* **Unit tests** for use-cases, repositories, blocs (100% deterministic via mocks).
* **Widget tests** for critical flows (login, add-to-cart, checkout).  
* **very_good_analysis** + **dart format** enforced in CI.
* **GitHub Actions**: on PR – `flutter pub get`, `flutter test --coverage`, `dart analyze`, `flutter build apk --debug`.

Badge templates included – add your own secrets to enable.

---

## 🌟 Highlights & Problem-Solving Stories

1. **Token refresh race-condition:** implemented `RefreshInterceptor` that queues failed 401 requests until a new token arrives, eliminating double refresh calls.
2. **Offline cart:** Cart items cached in Isar; queued mutations sync when connectivity restores (Connectivity + Stream listen).
3. **UseCase abstraction:** `UseCase` vs `FutureUseCase` split surfaced a bug (async mis-match) – fixed in `RefreshTokenUsecase`, improving compile-time safety.
4. **Composable routing:** Nested `StatefulShellRoute` allows independent nav stacks per bottom-tab while preserving global auth redirects.
5. **Scalable DI:** Riverpod providers (e.g., `cartBlocProvider`) make BLoCs mockable in tests and hot-swappable (e.g., switching to StateNotifier for trivial flows).

---

## 📈 What I’d improve next

* Finish **Orders** module (design skeleton already present) once backend endpoints are finalised.
* Integrate **Firebase Crashlytics** & **Sentry** for release monitoring.
* Add **Melos** workspace + code-gen for freezed models to streamline data layer.
* Implement **e2e tests** with `flutter_driver` / `integration_test`.

---

## 👋 Author

**Satendra Pal**

[LinkedIn](https://www.linkedin.com/in/satendra-pal-943540209/) • [Email](mailto:palsatyendra9984@gmail.com)

Feel free to fork, open issues, or reach out if you have questions!
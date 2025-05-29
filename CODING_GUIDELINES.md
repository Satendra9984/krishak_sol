# Bhoomi Shakti - Coding Guidelines and Clean Architecture Tutorial

Welcome to the Bhoomi Shakti project! This document provides a comprehensive guide to our coding standards, architectural patterns, and development workflow. Adhering to these guidelines will help us build a robust, maintainable, and scalable application.

## 1. Introduction to Clean Architecture

Clean Architecture is a software design philosophy that separates an application into distinct layers with specific responsibilities. The primary goal is to create a system that is:

-   **Independent of Frameworks:** The core business logic should not depend on specific frameworks (e.g., Flutter).
-   **Testable:** Each layer can be tested independently.
-   **Independent of UI:** The UI can change without affecting the underlying business rules.
-   **Independent of Database:** The choice of database or data storage can be changed without impacting business logic.
-   **Independent of External Agencies:** Business rules don't know anything about the outside world.

The key principle is the **Dependency Rule**: *Source code dependencies can only point inwards*. Nothing in an inner circle can know anything at all about something in an outer circle.

## 2. Project Structure (Clean Architecture in Flutter)

Our project follows a structure based on Clean Architecture principles, typically divided into three main layers:

```
lib/
├── app/
│   ├── config/                 # Flavor configurations, themes, etc.
│   ├── core/                   # Core utilities, constants, error handling, extensions
│   └── navigation/             # Routing setup (go_router)
├── features/
│   └── [feature_name]/         # Each feature module (e.g., soil_testing, user_auth)
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── local/      # Local data sources (e.g., Isar)
│       │   │   └── remote/     # Remote data sources (API calls using Dio)
│       │   ├── models/         # Data Transfer Objects (DTOs), API response models
│       │   └── repositories/   # Implementation of domain repositories
│       ├── domain/
│       │   ├── entities/       # Core business objects, independent of data layer
│       │   ├── repositories/   # Abstract contracts for data access
│       │   └── usecases/       # Application-specific business rules, orchestrate data flow
│       └── presentation/
│           ├── bloc/           # BLoCs/Cubits for state management
│           ├── pages/          # Screens/Pages
│           └── widgets/        # Reusable UI components specific to the feature
├── main_dev.dart
├── main_prod.dart
└── main.dart
```

### Layers Explained:

1.  **Domain Layer (`features/[feature_name]/domain/`)**
    *   **Purpose:** Contains the enterprise-wide business logic. This layer is the core of the application and should be independent of any other layer.
    *   **Components:**
        *   `entities/`: Plain Dart objects representing the core business data structures. They have no dependencies on Flutter or any specific packages.
        *   `repositories/`: Abstract classes (interfaces) defining the contract for data operations. These are implemented by the Data layer.
        *   `usecases/`: Implement specific business rules or actions. They orchestrate calls to repositories and perform logic. Each use case should have a single responsibility.
    *   **Dependencies:** Depends only on itself and Dart core libraries. *No Flutter dependencies here!* Uses `fpdart` for functional programming constructs like `Either` for error handling.

2.  **Data Layer (`features/[feature_name]/data/`)**
    *   **Purpose:** Implements the repository contracts defined in the Domain layer. It handles all data operations, whether from a remote API, local database, or device sensors.
    *   **Components:**
        *   `models/`: Data Transfer Objects (DTOs) that often extend or map to/from Domain Entities. These models are specific to the data source (e.g., JSON parsing annotations for API responses).
        *   `datasources/`: Concrete implementations for fetching and storing data. This is where `dio` (for network) and `isar` (for local storage) are used.
        *   `repositories/`: Concrete implementations of the `repositories` defined in the Domain layer. They adapt data from datasources to the format expected by the Domain layer.
    *   **Dependencies:** Depends on the Domain layer (to implement its interfaces and use entities) and external packages like `dio`, `isar`, `connectivity_plus`.

3.  **Presentation Layer (`features/[feature_name]/presentation/`)**
    *   **Purpose:** Handles all UI and user interaction. It displays data to the user and captures user input.
    *   **Components:**
        *   `pages/` or `screens/`: The actual UI screens built with Flutter widgets.
        *   `widgets/`: Reusable UI components specific to a feature or shared across features.
        *   `bloc/` or `cubit/` or `provider/`: State management logic using `flutter_bloc` and `flutter_riverpod`. These connect the UI to the use cases in the Domain layer.
    *   **Dependencies:** Depends on the Domain layer (to call use cases and display entities) and Flutter SDK, `flutter_bloc`, `flutter_riverpod`, `go_router`.

### `app/` Directory:

*   `config/`: Contains application-wide configurations like themes, flavor settings (`FlavorConfig`).
*   `core/`: Shared utilities, constants, base classes for error handling (`Failure` objects), extensions, network info (`connectivity_plus`).
*   `navigation/`: Configuration for `go_router`, defining routes and navigation logic.

## 3. Guiding Principles

*   **Dependency Rule:** Always ensure dependencies flow inwards (Presentation -> Domain <- Data). The Domain layer should not know about the Presentation or Data layers.
*   **Separation of Concerns:** Each component and layer has a clear, distinct responsibility.
*   **Single Responsibility Principle (SRP):** Each class or function should do one thing and do it well.
*   **Testability:** Design components to be easily testable. Use dependency injection to mock dependencies.
*   **Immutability:** Prefer immutable data structures, especially for entities and state objects.

## 4. How to Add a New Feature (Step-by-Step)

Let's say you need to add a new feature, for example, "Crop Recommendation".

**Step 1: Define in the Domain Layer (`features/crop_recommendation/domain/`)**

1.  **Entities:** Create Dart classes for core concepts like `Crop`, `RecommendationParams`.
    ```dart
    // features/crop_recommendation/domain/entities/crop.dart
    class Crop {
      final String id;
      final String name;
      final String description;

      Crop({required this.id, required this.name, required this.description});
    }
    ```
2.  **Repository Interface:** Define what data operations are needed. For example, `CropRepository`.
    ```dart
    // features/crop_recommendation/domain/repositories/crop_repository.dart
    import 'package:fpdart/fpdart.dart';
    import 'package:bhoomi_sakti/app/core/error/failure.dart';
    import '../entities/crop.dart';
    import '../entities/recommendation_params.dart';

    abstract class CropRepository {
      Future<Either<Failure, List<Crop>>> getRecommendedCrops(RecommendationParams params);
      Future<Either<Failure, Crop>> getCropDetails(String cropId);
    }
    ```
3.  **Use Cases:** Create classes for each specific user action or business rule.
    ```dart
    // features/crop_recommendation/domain/usecases/get_recommended_crops.dart
    import 'package:fpdart/fpdart.dart';
    import 'package:bhoomi_sakti/app/core/error/failure.dart';
    import 'package:bhoomi_sakti/app/core/usecases/usecase.dart'; // Generic usecase interface
    import '../entities/crop.dart';
    import '../entities/recommendation_params.dart';
    import '../repositories/crop_repository.dart';

    class GetRecommendedCrops implements UseCase<List<Crop>, RecommendationParams> {
      final CropRepository repository;

      GetRecommendedCrops(this.repository);

      @override
      Future<Either<Failure, List<Crop>>> call(RecommendationParams params) async {
        return await repository.getRecommendedCrops(params);
      }
    }
    ```
    *(You might need a generic `UseCase` interface in `app/core/usecases/`)*

**Step 2: Implement in the Data Layer (`features/crop_recommendation/data/`)**

1.  **Models:** Create data models that match the API response or database structure. These might extend or map to/from domain entities.
    ```dart
    // features/crop_recommendation/data/models/crop_model.dart
    import '../../domain/entities/crop.dart';

    class CropModel extends Crop {
      CropModel({
        required String id,
        required String name,
        required String description,
        // Add any API-specific fields here
      }) : super(id: id, name: name, description: description);

      factory CropModel.fromJson(Map<String, dynamic> json) {
        return CropModel(
          id: json['id'],
          name: json['name'],
          description: json['description'],
        );
      }

      Map<String, dynamic> toJson() {
        return {
          'id': id,
          'name': name,
          'description': description,
        };
      }
    }
    ```
2.  **Data Sources:** Implement how to fetch/store data.
    *   `RemoteDataSource`: Uses `dio` for API calls.
        ```dart
        // features/crop_recommendation/data/datasources/remote/crop_remote_data_source.dart
        import 'package:dio/dio.dart';
        import 'package:bhoomi_sakti/app/core/error/exceptions.dart';
        import '../../models/crop_model.dart';
        import '../../../domain/entities/recommendation_params.dart'; // Assuming this is simple enough not to need a model

        abstract class CropRemoteDataSource {
          Future<List<CropModel>> getRecommendedCrops(RecommendationParams params);
          Future<CropModel> getCropDetails(String cropId);
        }

        class CropRemoteDataSourceImpl implements CropRemoteDataSource {
          final Dio dioClient;

          CropRemoteDataSourceImpl({required this.dioClient});

          @override
          Future<List<CropModel>> getRecommendedCrops(RecommendationParams params) async {
            // Example API call
            // final response = await dioClient.post('/recommend_crops', data: params.toJson());
            // if (response.statusCode == 200) {
            //   return (response.data as List).map((crop) => CropModel.fromJson(crop)).toList();
            // } else {
            //   throw ServerException();
            // }
            // Placeholder:
            await Future.delayed(Duration(seconds: 1));
            return [CropModel(id: '1', name: 'Wheat', description: 'A good crop')];
          }

          @override
          Future<CropModel> getCropDetails(String cropId) async {
            // API call for crop details
            await Future.delayed(Duration(seconds: 1));
            return CropModel(id: cropId, name: 'Wheat Detail', description: 'Detailed description');
          }
        }
        ```
    *   `LocalDataSource`: Uses `isar` for caching (optional).
3.  **Repository Implementation:** Implement the `CropRepository` from the Domain layer.
    ```dart
    // features/crop_recommendation/data/repositories/crop_repository_impl.dart
    import 'package:fpdart/fpdart.dart';
    import 'package:bhoomi_sakti/app/core/error/failure.dart';
    import 'package:bhoomi_sakti/app/core/error/exceptions.dart';
    import 'package:bhoomi_sakti/app/core/network/network_info.dart'; // For checking connectivity
    import '../../domain/entities/crop.dart';
    import '../../domain/entities/recommendation_params.dart';
    import '../../domain/repositories/crop_repository.dart';
    import '../datasources/remote/crop_remote_data_source.dart';
    // import '../datasources/local/crop_local_data_source.dart'; // If caching

    class CropRepositoryImpl implements CropRepository {
      final CropRemoteDataSource remoteDataSource;
      // final CropLocalDataSource localDataSource; // If caching
      final NetworkInfo networkInfo;

      CropRepositoryImpl({
        required this.remoteDataSource,
        // required this.localDataSource,
        required this.networkInfo,
      });

      @override
      Future<Either<Failure, List<Crop>>> getRecommendedCrops(RecommendationParams params) async {
        if (await networkInfo.isConnected) {
          try {
            final remoteCrops = await remoteDataSource.getRecommendedCrops(params);
            // localDataSource.cacheRecommendedCrops(remoteCrops); // Optional: cache
            return Right(remoteCrops); // Models are subtypes of Entities, so this works
          } on ServerException {
            return Left(ServerFailure());
          } on DioException {
             return Left(ServerFailure(message: "Network error occurred."));
          }
        } else {
          // try {
          //   final localCrops = await localDataSource.getLastRecommendedCrops();
          //   return Right(localCrops);
          // } on CacheException {
          //   return Left(CacheFailure());
          // }
          return Left(NetworkFailure());
        }
      }

      @override
      Future<Either<Failure, Crop>> getCropDetails(String cropId) async {
        // Similar implementation for fetching crop details
        if (await networkInfo.isConnected) {
          try {
            final cropDetail = await remoteDataSource.getCropDetails(cropId);
            return Right(cropDetail);
          } on ServerException {
            return Left(ServerFailure());
          } on DioException {
             return Left(ServerFailure(message: "Network error occurred."));
          }
        } else {
          return Left(NetworkFailure());
        }
      }
    }
    ```

**Step 3: Implement in the Presentation Layer (`features/crop_recommendation/presentation/`)**

1.  **State Management (BLoC/Cubit):** Create a BLoC or Cubit to manage the state of the crop recommendation feature.
    ```dart
    // features/crop_recommendation/presentation/bloc/crop_recommendation_state.dart
    part of 'crop_recommendation_bloc.dart';

    abstract class CropRecommendationState extends Equatable {
      const CropRecommendationState();
      @override
      List<Object> get props => [];
    }

    class CropRecommendationInitial extends CropRecommendationState {}
    class CropRecommendationLoading extends CropRecommendationState {}
    class CropRecommendationLoaded extends CropRecommendationState {
      final List<Crop> crops;
      const CropRecommendationLoaded(this.crops);
      @override
      List<Object> get props => [crops];
    }
    class CropRecommendationError extends CropRecommendationState {
      final String message;
      const CropRecommendationError(this.message);
      @override
      List<Object> get props => [message];
    }

    // features/crop_recommendation/presentation/bloc/crop_recommendation_event.dart
    part of 'crop_recommendation_bloc.dart';

    abstract class CropRecommendationEvent extends Equatable {
      const CropRecommendationEvent();
      @override
      List<Object> get props => [];
    }

    class FetchRecommendedCrops extends CropRecommendationEvent {
      final RecommendationParams params;
      const FetchRecommendedCrops(this.params);
      @override
      List<Object> get props => [params];
    }

    // features/crop_recommendation/presentation/bloc/crop_recommendation_bloc.dart
    import 'package:bloc/bloc.dart';
    import 'package:equatable/equatable.dart';
    import 'package:bhoomi_sakti/app/core/error/failure_utils.dart';
    import '../../domain/entities/crop.dart';
    import '../../domain/entities/recommendation_params.dart';
    import '../../domain/usecases/get_recommended_crops.dart';

    part 'crop_recommendation_event.dart';
    part 'crop_recommendation_state.dart';

    class CropRecommendationBloc extends Bloc<CropRecommendationEvent, CropRecommendationState> {
      final GetRecommendedCrops getRecommendedCrops;

      CropRecommendationBloc({required this.getRecommendedCrops}) : super(CropRecommendationInitial()) {
        on<FetchRecommendedCrops>((event, emit) async {
          emit(CropRecommendationLoading());
          final failureOrCrops = await getRecommendedCrops(event.params);
          failureOrCrops.fold(
            (failure) => emit(CropRecommendationError(mapFailureToMessage(failure))),
            (crops) => emit(CropRecommendationLoaded(crops)),
          );
        });
      }
    }
    ```
    *(You'll need a `mapFailureToMessage` utility in `app/core/error/failure_utils.dart`)*
2.  **Pages/Screens:** Create Flutter widgets to display the UI.
    ```dart
    // features/crop_recommendation/presentation/pages/crop_recommendation_page.dart
    import 'package:flutter/material.dart';
    import 'package:flutter_bloc/flutter_bloc.dart';
    import 'package:bhoomi_sakti/app/core/dependency_injection/service_locator.dart'; // Your DI setup
    import '../../domain/entities/recommendation_params.dart';
    import '../bloc/crop_recommendation_bloc.dart';

    class CropRecommendationPage extends StatelessWidget {
      const CropRecommendationPage({super.key});

      @override
      Widget build(BuildContext context) {
        return BlocProvider(
          create: (context) => sl<CropRecommendationBloc>(), // Use service locator (Riverpod/GetIt)
          child: Scaffold(
            appBar: AppBar(title: const Text('Crop Recommendations')),
            body: CropRecommendationView(),
          ),
        );
      }
    }

    class CropRecommendationView extends StatefulWidget {
      @override
      _CropRecommendationViewState createState() => _CropRecommendationViewState();
    }

    class _CropRecommendationViewState extends State<CropRecommendationView> {
      @override
      void initState() {
        super.initState();
        // Example: Trigger fetch with default or previously saved params
        final params = RecommendationParams(soilPh: 7.0, rainfall: 1000); // Example params
        context.read<CropRecommendationBloc>().add(FetchRecommendedCrops(params));
      }

      @override
      Widget build(BuildContext context) {
        return BlocBuilder<CropRecommendationBloc, CropRecommendationState>(
          builder: (context, state) {
            if (state is CropRecommendationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CropRecommendationLoaded) {
              if (state.crops.isEmpty) {
                return const Center(child: Text('No recommendations found.'));
              }
              return ListView.builder(
                itemCount: state.crops.length,
                itemBuilder: (context, index) {
                  final crop = state.crops[index];
                  return ListTile(
                    title: Text(crop.name),
                    subtitle: Text(crop.description),
                  );
                },
              );
            } else if (state is CropRecommendationError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('Enter parameters to get recommendations.'));
            }
          },
        );
      }
    }
    ```
3.  **Widgets:** Create any reusable widgets specific to this feature.

**Step 4: Dependency Injection (using `flutter_riverpod` or `get_it`)**

Set up your dependency injection. For Riverpod, you'd define providers. For GetIt (as shown in `service_locator.dart` example above), you'd register your BLoCs, UseCases, Repositories, and DataSources.

Example using GetIt (`app/core/dependency_injection/service_locator.dart`):
```dart
// app/core/dependency_injection/service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:bhoomi_sakti/app/core/network/network_info.dart';

// Feature specific imports
import 'package:bhoomi_sakti/features/crop_recommendation/data/datasources/remote/crop_remote_data_source.dart';
import 'package:bhoomi_sakti/features/crop_recommendation/data/repositories/crop_repository_impl.dart';
import 'package:bhoomi_sakti/features/crop_recommendation/domain/repositories/crop_repository.dart';
import 'package:bhoomi_sakti/features/crop_recommendation/domain/usecases/get_recommended_crops.dart';
import 'package:bhoomi_sakti/features/crop_recommendation/presentation/bloc/crop_recommendation_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Features - Crop Recommendation
  // Bloc
  sl.registerFactory(
    () => CropRecommendationBloc(getRecommendedCrops: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetRecommendedCrops(sl()));

  // Repository
  sl.registerLazySingleton<CropRepository>(
    () => CropRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
      // localDataSource: sl(), // if you have one
    ),
  );

  // Data sources
  sl.registerLazySingleton<CropRemoteDataSource>(
    () => CropRemoteDataSourceImpl(dioClient: sl()),
  );
  // sl.registerLazySingleton<CropLocalDataSource>(() => CropLocalDataSourceImpl(isarInstance: sl())); // if you have one and Isar is registered
}
```
Call `await init()` in your `main.dart` before `runApp()`.

If using Riverpod, you would define providers:
```dart
// Example Riverpod providers (can be in a dedicated file or feature-specific files)
final dioProvider = Provider<Dio>((ref) => Dio());
final networkInfoProvider = Provider<NetworkInfo>((ref) => NetworkInfoImpl(Connectivity()));

// Crop Recommendation Feature Providers
final cropRemoteDataSourceProvider = Provider<CropRemoteDataSource>(
  (ref) => CropRemoteDataSourceImpl(dioClient: ref.watch(dioProvider)),
);

final cropRepositoryProvider = Provider<CropRepository>(
  (ref) => CropRepositoryImpl(
    remoteDataSource: ref.watch(cropRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  ),
);

final getRecommendedCropsUseCaseProvider = Provider<GetRecommendedCrops>(
  (ref) => GetRecommendedCrops(ref.watch(cropRepositoryProvider)),
);

final cropRecommendationBlocProvider = StateNotifierProvider.autoDispose<CropRecommendationBloc, CropRecommendationState>(
  (ref) => CropRecommendationBloc(getRecommendedCrops: ref.watch(getRecommendedCropsUseCaseProvider)),
);

// In your widget:
// To read the BLoC: context.read(cropRecommendationBlocProvider.notifier)
// To watch the BLoC state: final state = useProvider(cropRecommendationBlocProvider);
```

**Step 5: Routing (using `go_router`)**

Add a route for your new page in your `go_router` configuration (`app/navigation/app_router.dart` or similar).

```dart
// app/navigation/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:bhoomi_sakti/features/crop_recommendation/presentation/pages/crop_recommendation_page.dart';
// ... other page imports

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(), // Your home page
    ),
    GoRoute(
      path: '/crop-recommendation',
      builder: (context, state) => CropRecommendationPage(),
    ),
    // ... other routes
  ],
);
```

**Step 6: Write Tests!**

*   **Domain Layer:** Unit test use cases and entities.
*   **Data Layer:** Unit test repositories (mocking data sources) and data sources (mocking Dio/Isar).
*   **Presentation Layer:** Widget test pages and widgets. BLoC/Cubit tests.

## 5. Coding Standards and Best Practices

*   **Naming Conventions:**
    *   Classes, Enums, Typedefs: `UpperCamelCase` (e.g., `MyClass`).
    *   Methods, Functions, Variables: `lowerCamelCase` (e.g., `myVariable`).
    *   Constants: `kLowerCamelCase` or `ALL_CAPS_WITH_UNDERSCORES` (e.g., `kDefaultPadding` or `DEFAULT_TIMEOUT`).
    *   Files: `snake_case.dart` (e.g., `my_file.dart`).
*   **Formatting:** Use `dart format` to ensure consistent code style.
*   **Linting:** Adhere to lint rules defined in `analysis_options.yaml`. We use `flutter_lints` or a stricter set.
*   **Error Handling:**
    *   Use `Either<Failure, SuccessType>` from `fpdart` in Domain and Data layers to handle operations that can fail.
    *   Define custom `Failure` classes (e.g., `ServerFailure`, `CacheFailure`, `NetworkFailure`) in `app/core/error/failure.dart`.
    *   Define custom `Exception` classes (e.g., `ServerException`, `CacheException`) in `app/core/error/exceptions.dart` for the Data layer.
    *   The Presentation layer (BLoC) will convert `Failure` objects into user-friendly messages.
*   **State Management (`flutter_bloc`):**
    *   Clearly define `Events`, `States`, and the `Bloc` logic.
    *   Keep states immutable.
    *   Use `Equatable` for states and events to prevent unnecessary rebuilds.
*   **Dependency Injection (`flutter_riverpod` / `get_it`):**
    *   Centralize DI setup.
    *   Inject dependencies through constructors.
*   **Network Calls (`dio`):**
    *   Centralize Dio instance creation and configuration (interceptors for logging, auth tokens, error handling).
    *   Handle different HTTP status codes appropriately.
*   **Local Storage (`isar`):**
    *   Define Isar schemas clearly.
    *   Handle migrations carefully.
*   **Functional Programming (`fpdart`):**
    *   Use `Either` for error handling, `Option` for nullable values, `TaskEither` for async operations that can fail.
*   **Comments:** Write clear and concise comments for complex logic or public APIs. Use `///` for documentation comments.
*   **Avoid `dynamic`:** Use specific types whenever possible.
*   **Constants:** Define constants in a shared file or feature-specific constant files.

## 6. Managing Multiple App Environments (Flavors)

This project utilizes Flutter's flavor mechanism (often referred to as environments or build configurations) to manage distinct settings for different stages of development and deployment, such as development, staging (optional), and production.

### What are Flavors/Environments?

Flavors allow you to build and run different versions of your app from the same codebase. Each flavor can have its own:

*   **Application Name and ID:** e.g., "Bhoomi Sakti Dev" (com.example.bhoomisakti.dev) vs. "Bhoomi Sakti" (com.example.bhoomisakti).
*   **API Endpoints:** Connecting to a development, staging, or production backend server.
*   **Third-Party Service Keys:** Using sandbox or production keys for services like analytics, crash reporting, or payment gateways.
*   **Feature Flags:** Enabling or disabling certain features based on the environment.
*   **Logging Levels:** More verbose logging in development, less in production.
*   **Icon and Splash Screen:** Potentially different branding for non-production builds.

### Why Use Multiple Environments?

Using multiple environments is a standard practice that offers several benefits:

- **Isolation:** Development and testing can occur without affecting the production environment or live user data.
- **Safety:** Allows for thorough testing of new features and bug fixes on a staging environment that closely mirrors production before releasing to actual users.
- **Configuration Management:** Keeps sensitive production credentials and configurations separate from development settings.
- **Parallel Development:** Different teams or developers can work against different backend environments simultaneously.
- **Clearer Testing:** Testers can easily identify which version of the app they are testing.

### How Flavors are Implemented in Bhoomi Shakti

1. **Entry Points:**
    - `lib/main_dev.dart`: The entry point for the **development** environment.
    - `lib/main_prod.dart`: The entry point for the **production** environment.
    - (A `lib/main_staging.dart` could be added if a dedicated staging environment is required).

2. **Flavor Configuration (`FlavorConfig`):**
    - The `FlavorConfig` class located in `lib/app/config/flavors/flavor_config.dart` is responsible for holding and providing flavor-specific values (like API base URLs, app names, etc.).
    - This class is initialized with the appropriate `Flavor` enum (`dev` or `prod`) in the respective `main_` files.

3. **Native Configuration (Advanced):**
    - For platform-specific settings like app icons, bundle IDs, or native service configurations, you would typically configure build schemes (iOS) and productFlavors (Android) in the native `ios` and `android` directories. This setup is more advanced and can be implemented as needed.

### How to Run the App with Different Flavors

#### 1. Using the Command Line

- **Development Flavor:**

  ```bash
  flutter run -t lib/main_dev.dart
  ```

- **Production Flavor (for testing a release build):**

  ```bash
  flutter run -t lib/main_prod.dart --release
  ```

- **Production Flavor (for profiling):**

  ```bash
  flutter run -t lib/main_prod.dart --profile
  ```

#### 2. Using VS Code Launch Configurations

We have pre-configured launch settings in `.vscode/launch.json` for convenience:

- Open the "Run and Debug" view in VS Code (usually `Ctrl+Shift+D` or the play icon with a bug).
- From the dropdown menu at the top, select one of the following configurations:
  - `Bhoomi Sakti (Dev)`: Runs the app using `lib/main_dev.dart` in debug mode.
  - `Bhoomi Sakti (Prod)`: Runs the app using `lib/main_prod.dart` in release mode. This is how you'd test a production-like build.
  - `Bhoomi Sakti (Profile)`: Runs the app using `lib/main_prod.dart` in profile mode, which is useful for analyzing app performance.
- Press `F5` or click the green play button to start the selected configuration.

### Standard Practices for Using Multiple Environments

- **Configuration Secrecy:** Never commit sensitive production API keys, credentials, or secrets directly into the codebase. Use environment variables, build arguments, or secure secret management tools, especially for CI/CD. `FlavorConfig` can load these at runtime.
- **Backend Alignment:** Ensure your backend team also maintains corresponding dev, staging, and production environments for their services.
- **Data Isolation:** Development and staging environments should use separate databases from production. Avoid testing with live production data.
- **Thorough Staging Tests:** Before deploying to production, always deploy to and thoroughly test on a staging environment that mimics production as closely as possible.
- **CI/CD Integration:** Your Continuous Integration/Continuous Deployment (CI/CD) pipeline should be configured to build and deploy specific flavors to their respective environments (e.g., `dev` branch deploys to a development server, `main` branch deploys to production).
- **Clear Identification:** Consider visually distinguishing non-production builds (e.g., a "DEV" banner, different app icon color overlay) to avoid confusion during testing.

## 7. Version Control (Git)

* **Branching Strategy:** Use a feature branching strategy (e.g., Gitflow or GitHub Flow).
  * `main` or `master`: Production-ready code.
  * `develop`: Integration branch for features.
  * `feature/[feature-name]`: For developing new features.
  * `bugfix/[issue-id]`: For fixing bugs.
  * `hotfix/[issue-id]`: For critical production fixes.
*   **Commit Messages:** Write clear and descriptive commit messages (e.g., `feat: Add crop recommendation feature` or `fix: Correct login validation`). Consider using Conventional Commits.
*   **Pull Requests (PRs):**
    *   All code changes should go through PRs.
    *   Ensure PRs are reviewed by at least one other team member.
    *   Ensure tests pass before merging.

## 8. Testing

Writing tests is crucial for maintaining code quality and stability.

* **Unit Tests:**
  * Test individual functions, methods, or classes.
  * Focus on Domain layer (use cases, entities) and Data layer (repositories, data sources - with mocks).
  * Use the `test` package.
* **Widget Tests:**
  * Test individual Flutter widgets in isolation.
  * Verify UI rendering and interaction.
  * Use the `flutter_test` package.
* **BLoC/Cubit Tests:**
  * Test state transitions and logic within BLoCs/Cubits.
  * Use the `bloc_test` package.
* **Integration Tests:**
  * Test complete features or user flows, involving multiple layers.
  * Use the `integration_test` package.

Place tests in a `test/` directory mirroring the `lib/` structure.

---

This guide provides a foundation for working on the Bhoomi Shakti project. As the project evolves, this document may be updated. Collaboration and communication are key to our success! If you have questions or suggestions, please discuss them with the team.

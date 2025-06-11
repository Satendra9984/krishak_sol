# Bhoomi Shakti - Authentication Module Architecture

## 1. Overview

This document outlines the architecture of the authentication module for the Bhoomi Shakti Flutter application. The primary goal of this module is to provide a secure and user-friendly OTP (One-Time Password) based authentication system for both new user sign-ups and existing user logins.

## 2. Tech Stack

The authentication module leverages the following core technologies and packages:

- **Flutter SDK**: For building the cross-platform mobile application.
- **Dart**: Programming language.
- **State Management**:
  - `flutter_bloc`: For managing business logic and state changes in a predictable manner (e.g., `LoginBloc`, `SignupBloc`, `VerifyOtpBloc`).
  - `flutter_riverpod`: For dependency injection and providing BLoC instances to the UI.
- **Navigation**: `go_router`: For declarative routing and deep linking.
- **Networking**: `dio`: For making HTTP requests to the backend API.
- **OTP Input**: `pinput`: For a user-friendly OTP input experience.
- **Functional Programming**: `fpdart`: For handling success/failure states (Either type) from use cases.
- **Code Style & Linting**: Standard Flutter linting rules.

## 3. Directory Structure

The authentication module resides within `lib/features/auth/` and follows the principles of Clean Architecture, separating concerns into distinct layers:

```text
lib/
└── features/
    └── auth/
        ├── AUTH_ARCHITECTURE.md  (This document)
        ├── auth_providers.dart   (Riverpod providers for auth BLoCs and use cases)
        ├── data/
        │   ├── datasources/
        │   │   ├── auth_remote_data_source.dart         (Interface for remote data operations)
        │   │   └── auth_remote_data_source_impl.dart    (Dio-based implementation)
        │   ├── models/
        │   │   ├── auth_success_model.dart (User and Tokens after successful OTP verification)
        │   │   ├── otp_request_model.dart  (Request body for OTP generation)
        │   │   ├── otp_verification_model.dart (Request body for OTP verification)
        │   │   ├── tokens_model.dart       (Access and Refresh tokens)
        │   │   └── user_model.dart         (User data)
        │   └── repositories/
        │       └── auth_repository_impl.dart (Implementation of AuthRepository)
        ├── domain/
        │   ├── entities/                 (Core business objects - not extensively used yet, models act as DTOs and entities)
        │   ├── repositories/
        │   │   └── auth_repository.dart    (Interface defining auth operations)
        │   └── usecases/
        │       ├── get_current_user_usecase.dart
        │       ├── login_usecase.dart      (Handles login OTP request logic)
        │       ├── signup_usecase.dart     (Handles signup OTP request logic)
        │       └── verify_otp_usecase.dart (Handles OTP verification logic)
        └── presentation/
            ├── blocs/
            │   ├── login_bloc.dart, login_event.dart, login_state.dart
            │   ├── signup_bloc.dart, signup_event.dart, signup_state.dart
            │   └── verify_otp_bloc.dart, verify_otp_event.dart, verify_otp_state.dart
            ├── pages/
            │   ├── login_page.dart
            │   ├── otp_verification_page.dart
            │   └── signup_page.dart
            └── widgets/                  (Reusable UI components for auth screens - if any)
```

## 4. Core Concepts

### 4.1. OTP Flow (Login & Signup)

- **Signup**:
    1. User enters name and mobile number on `SignupPage`.
    2. `SignupBloc` dispatches `SignupButtonPressed` event.
    3. `SignupUsecase` is called, which interacts with `AuthRepository` to request an OTP from the backend via `AuthRemoteDataSource.requestSignupOtp`.
    4. On success, navigates to `OtpVerificationPage` with `OtpFlowType.signup` and mobile number.
- **Login**:
    1. User enters mobile number on `LoginPage`.
    2. `LoginBloc` dispatches `LoginButtonPressed` event.
    3. `LoginUsecase` is called, interacting with `AuthRepository` to request OTP via `AuthRemoteDataSource.requestLoginOtp`.
    4. On success, navigates to `OtpVerificationPage` with `OtpFlowType.login` and mobile number.
- **OTP Verification** (`OtpVerificationPage`):
    1. User enters the received OTP using the `Pinput` widget.
    2. `VerifyOtpBloc` dispatches `VerifyOtpButtonPressed` event.
    3. `VerifyOtpUsecase` is called, which interacts with `AuthRepository` to verify the OTP via `AuthRemoteDataSource.verifyOtp`.
    4. On successful verification, the backend returns user data and tokens (`AuthSuccessModel`).
    5. The application's `AuthNotifier` (or a similar global state manager) updates the authentication state, and `GoRouter` redirects the user to the home screen.

### 4.2. Resend OTP

- Implemented in `OtpVerificationPage`.
- A "Resend OTP" button is available, enabled after a 30-second cooldown period managed by a `Timer`.
- Pressing "Resend OTP" dispatches either `ResendLoginOtp` (to `LoginBloc`) or `ResendSignupOtp` (to `SignupBloc`) based on the current `OtpFlowType`.
- The respective BLoCs call their corresponding use cases (`LoginUsecase` or `SignupUsecase`) to request a new OTP.
- For signup resend, the `name` parameter is currently sent as an empty string; backend needs to support this or UI needs adjustment.
- User feedback for resend success/failure is provided via Snackbars.

### 4.3. State Management

- **BLoCs**: Each primary authentication action (login, signup, OTP verification) has its own BLoC.
  - `LoginBloc`: Handles `LoginButtonPressed`, `ResendLoginOtp` events. Emits `LoginInitial`, `LoginOtpRequestLoading`, `LoginOtpSentSuccess`, `LoginFailure` states.
  - `SignupBloc`: Handles `SignupButtonPressed`, `ResendSignupOtp` events. Emits `SignupInitial`, `SignupOtpRequestLoading`, `SignupOtpSentSuccess`, `SignupFailure` states.
  - `VerifyOtpBloc`: Handles `VerifyOtpButtonPressed` event. Emits `VerifyOtpInitial`, `VerifyOtpLoading`, `VerifyOtpSuccess`, `VerifyOtpFailure` states.
- **Riverpod Providers** (`auth_providers.dart`):
  - Used to provide instances of BLoCs and Use Cases to the widget tree.
  - Example: `loginBlocProvider`, `signupUsecaseProvider`.
- **MultiBlocListener**: Used in `OtpVerificationPage` to listen to state changes from `VerifyOtpBloc`, `LoginBloc`, and `SignupBloc` simultaneously for displaying Snackbars and handling UI updates related to OTP verification and resend actions.

### 4.4. Navigation

- **GoRouter**: Manages app navigation.
- **`OtpFlowType` Enum**: (`login`, `signup`) is passed from `LoginPage`/`SignupPage` to `OtpVerificationPage` to differentiate the flow and determine which BLoC to use for resend OTP actions.
- Navigation to `OtpVerificationPage` includes `mobileNumber` and `flowType` as route parameters (passed via `extra` in `GoRouter`).

### 4.5. Error Handling

- **`AppException`**: Custom exceptions (e.g., `ServerException`, `NetworkException`) are defined in `lib/app/core/error/app_exceptions.dart`.
- **`Failure`**: Abstract class (`lib/app/core/error/app_failures.dart`) with concrete implementations (e.g., `ServerFailure`) representing business logic errors.
- Use cases return `Either<Failure, SuccessType>`.
- BLoCs catch `Failure` objects and emit appropriate failure states, which UI can use to display error messages (e.g., via Snackbars).

### 4.6. Token Management

- Upon successful OTP verification, `AuthSuccessModel` is received, containing `UserModel` and `TokensModel` (access and refresh tokens).
- **(Future Work)**: A `TokenStorageService` (e.g., using `flutter_secure_storage`) will be responsible for securely storing and retrieving these tokens.
- Dio interceptors (`TokenInterceptor`, `RefreshInterceptor`) will be implemented to automatically attach access tokens to requests and handle token refresh logic.

## 5. Data Flow Example: OTP Verification

1. **UI (`OtpVerificationPage`)**: User enters OTP and taps "Verify OTP".
    - `_onVerifyOtpPressed()` is called.
    - `VerifyOtpButtonPressed` event (with mobile number and OTP) is added to `VerifyOtpBloc`.

2. **BLoC (`VerifyOtpBloc`)**:
    - Receives `VerifyOtpButtonPressed` event.
    - Emits `VerifyOtpLoading` state.
    - Calls `VerifyOtpUsecase` with `VerifyOtpParams` (mobile number, OTP).
    - Awaits `Either<Failure, AuthSuccessModel>` from the use case.
    - If `Right(AuthSuccessModel)`, emits `VerifyOtpSuccess` (triggers navigation via `AuthNotifier`).
    - If `Left(Failure)`, emits `VerifyOtpFailure` (UI shows error).

3. **Use Case (`VerifyOtpUsecase`)**:
    - Implements `call(VerifyOtpParams params)`.
    - Calls `authRepository.verifyOtp(otp: params.otp, mobileNumber: params.mobileNumber)`.
    - Returns the result from the repository.

4. **Repository (`AuthRepositoryImpl`)**:
    - Implements `Future<Either<Failure, AuthSuccessModel>> verifyOtp(...)`.
    - Calls `authRemoteDataSource.verifyOtp(OtpVerificationModel(...))`.
    - Handles potential `AppException` from data source and maps it to a `Failure` type.

5. **Data Source (`AuthRemoteDataSourceImpl`)**:
    - Implements `Future<AuthSuccessModel> verifyOtp(OtpVerificationModel otpVerification)`.
    - Makes a POST request to the backend API (`$_baseUrl/auth/verify-otp`) using `Dio`.
    - Parses the JSON response into `AuthSuccessModel`.
    - Throws `ServerException` or other `AppException` on API errors or non-200 status codes.

6. **API (Backend)**:
    - Receives OTP verification request.
    - Validates OTP.
    - Returns user details and tokens on success, or an error response.

## 6. Key Components/Files

- **`auth_providers.dart`**: Centralizes Riverpod providers for easy access to BLoCs and use cases throughout the auth feature.
- **`otp_verification_page.dart`**: The core screen for OTP entry and resend logic. Features include:
  - `Pinput` for styled OTP input.
  - Resend OTP button with a 30-second cooldown timer.
  - `MultiBlocListener` to react to states from `VerifyOtpBloc` (for verification status) and `LoginBloc`/`SignupBloc` (for resend status).
  - Dispatches events to appropriate BLoCs based on `OtpFlowType`.
- **BLoCs** (`LoginBloc`, `SignupBloc`, `VerifyOtpBloc`):
  - Encapsulate business logic for their respective operations.
  - Manage UI state transitions (loading, success, failure).
  - Interact with use cases.
- **Use Cases** (`LoginUsecase`, `SignupUsecase`, `VerifyOtpUsecase`):
  - Contain specific business rules for each action.
  - Orchestrate calls to the `AuthRepository`.
  - Decouple BLoCs from the data layer.
- **Repository** (`AuthRepository`, `AuthRepositoryImpl`):
  - Abstract the data layer from the domain layer.
  - `AuthRepositoryImpl` coordinates data from `AuthRemoteDataSource` and handles error mapping.
- **Data Source** (`AuthRemoteDataSource`, `AuthRemoteDataSourceImpl`):
  - `AuthRemoteDataSourceImpl` is responsible for all network communication with the backend API using `Dio`.
  - Handles JSON serialization/deserialization and API-specific error handling.
- **Models** (`OtpRequestModel`, `OtpVerificationModel`, `AuthSuccessModel`):
  - Define the structure of data for API requests and responses.
  - Include `toJson()` and `fromJson()` methods.
- **`OtpFlowType` enum**: Crucial for `OtpVerificationPage` to adapt its behavior (especially for resend OTP) based on whether the user is in a login or signup flow.

## 7. Backend Dependencies

- The application relies on a backend API for all authentication operations.
- Current `AuthRemoteDataSourceImpl` uses **placeholder URLs**. These must be updated with actual production/development API endpoints:
  - Base URL: `YOUR_BASE_URL_HERE`
  - Request Signup OTP: `$_baseUrl/auth/request-signup-otp`
  - Request Login OTP: `$_baseUrl/auth/request-login-otp`
  - Verify OTP: `$_baseUrl/auth/verify-otp`
- **Expected API Payloads**:
  - **Request OTP (Signup/Login)**:
    - Request: `{"mobileNumber": "1234567890", "name": "John Doe"}` (name is optional for login/resend)
    - Response: HTTP 200/201/204 on success (no body or simple success message).
  - **Verify OTP**:
    - Request: `{"mobileNumber": "1234567890", "otp": "123456"}`
    - Response (Success): HTTP 200 with `{"user": {"id": "...", "name": "...", ...}, "tokens": {"accessToken": "...", "refreshToken": "..."}}` (matching `AuthSuccessModel`).
    - Response (Failure): HTTP 4xx/5xx with error details.

## 8. Security Considerations

- **Resend OTP Cooldown**: A 30-second timer prevents abuse of the resend OTP functionality.
- **HTTPS**: All API communication should be over HTTPS in production.
- **(Future Work) Secure Token Storage**: Access and refresh tokens must be stored securely using `flutter_secure_storage` or an equivalent.
- **Input Validation**: Basic input validation is performed on the client-side (e.g., OTP length), but comprehensive validation must occur on the backend.

## 9. Future Enhancements & TODOs

- **Complete Backend Integration**: Update all placeholder URLs in `AuthRemoteDataSourceImpl` with actual API endpoints.
- **Implement Logout Functionality**: Clear stored tokens and reset authentication state.
- **Token Management**: Fully implement `TokenStorageService` and Dio interceptors for automatic token handling and refresh.
- **Testing**:
  - Write unit tests for BLoCs, Use Cases, and Repositories.
  - Write widget tests for `LoginPage`, `SignupPage`, and `OtpVerificationPage`.
  - Write integration tests for the complete authentication flow.
- **UI/UX Improvements**:
  - More refined loading indicators.
  - Consistent error message display.
  - Accessibility improvements.
- **Cleanup**: Remove any legacy password-based authentication code if it exists.
- **Configuration Management**: Move base URL and API endpoints to a configuration file or environment variables instead of hardcoding.

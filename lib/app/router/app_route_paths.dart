/// Contains all the route paths used in the application.
class AppRoutePaths {
  // Auth routes
  static const String onboarding = '/onboarding'; // Added onboarding path
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String resetPassword = '/reset-password';

  // Main app routes
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Farmer module routes
  static const String farmerHome = '/farmer/home';
  static const String soilTestRequest = '/farmer/soil-test-request';
  static const String cropAdvisory = '/farmer/crop-advisory';
  static const String requestHistory = '/farmer/request-history';

  // Agent module routes
  static const String agentHome = '/agent/home';
  static const String assignedRequests = '/agent/assigned-requests';
  static const String submitReport = '/agent/submit-report';

  // Admin module routes
  static const String adminDashboard = '/admin/dashboard';
  static const String userManagement = '/admin/user-management';
  static const String reports = '/admin/reports';

  // Utility routes
  static const String notFound = '/not-found';
  static const String maintenance = '/maintenance';
  static const String error = '/error';

  // Helper method to check if a path is a sub-route of a parent path
  static bool isSubRoute(String parentPath, String path) {
    return path.startsWith(parentPath) && path != parentPath;
  }
}

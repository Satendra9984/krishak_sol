class ApiEndpoints {
  // Base URLs
  static const String baseUrl = 'https://api.bhoomisakti.com/v1';
  static const String baseUrlV2 = 'https://api.bhoomisakti.com/v2';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh-token';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyOtp = '/auth/verify-otp';

  // User endpoints
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/update-profile';
  static const String changePassword = '/user/change-password';
  static const String deleteAccount = '/user/delete-account';

  // Farmer endpoints
  static const String farmerProfile = '/farmer/profile';
  static const String farmerFarms = '/farmer/farms';
  static const String farmerCrops = '/farmer/crops';
  static const String farmerSoilTests = '/farmer/soil-tests';
  static const String farmerAdvisories = '/farmer/advisories';

  // Agent endpoints
  static const String agentProfile = '/agent/profile';
  static const String agentFarmers = '/agent/farmers';
  static const String agentSoilTests = '/agent/soil-tests';
  static const String agentAdvisories = '/agent/advisories';
  static const String agentSchedules = '/agent/schedules';

  // Admin endpoints
  static const String adminUsers = '/admin/users';
  static const String adminFarmers = '/admin/farmers';
  static const String adminAgents = '/admin/agents';
  static const String adminSoilTests = '/admin/soil-tests';
  static const String adminAdvisories = '/admin/advisories';
  static const String adminReports = '/admin/reports';

  // Utility endpoints
  static const String uploadFile = '/utils/upload';
  static const String getAppSettings = '/utils/settings';
  static const String getAppVersion = '/utils/version';

  // Helper method to build full URL
  static String buildUrl(String endpoint, {String base = baseUrl}) {
    return '$base$endpoint';
  }
}

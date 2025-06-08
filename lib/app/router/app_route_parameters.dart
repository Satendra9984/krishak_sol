/// Contains parameter names and helper methods for route parameters.
class AppRouteParameters {
  // Common parameters
  static const String id = 'id';
  static const String type = 'type';
  static const String title = 'title';
  
  // Auth parameters
  static const String email = 'email';
  static const String phone = 'phone';
  static const String token = 'token';
  static const String redirectTo = 'redirectTo';
  
  // OTP verification
  static const String otpType = 'otpType'; // 'signup', 'reset-password', etc.
  static const String verificationId = 'verificationId';
  
  // Soil test parameters
  static const String requestId = 'requestId';
  static const String status = 'status';
  
  // Crop advisory parameters
  static const String cropId = 'cropId';
  static const String season = 'season';
  
  // Report parameters
  static const String reportType = 'reportType';
  static const String dateRange = 'dateRange';
  
  // Helper methods for parameter extraction
  static String? getParameterValue(
    Map<String, String> params, 
    String paramName, {
    String? defaultValue,
  }) {
    return params[paramName] ?? defaultValue;
  }
  
  static int? getIntParameter(
    Map<String, String> params, 
    String paramName, {
    int? defaultValue,
  }) {
    final value = params[paramName];
    if (value == null) return defaultValue;
    return int.tryParse(value) ?? defaultValue;
  }
  
  static bool getBoolParameter(
    Map<String, String> params, 
    String paramName, {
    bool defaultValue = false,
  }) {
    final value = params[paramName];
    if (value == null) return defaultValue;
    return value.toLowerCase() == 'true';
  }
  
  // Helper method to create query parameters string
  static String createQueryString(Map<String, dynamic> params) {
    final queryParams = <String>[];
    
    params.forEach((key, value) {
      if (value != null) {
        queryParams.add('$key=${Uri.encodeComponent(value.toString())}');
      }
    });
    
    return queryParams.isEmpty ? '' : '?${queryParams.join('&')}';
  }
}

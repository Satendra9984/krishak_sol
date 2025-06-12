import 'package:shared_preferences/shared_preferences.dart';

abstract class SplashLocalDataSource {
  Future<bool> isFirstLaunch();
  Future<void> setFirstLaunchComplete();
}

class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  static const String _firstLaunchKey = 'first_launch';
  final SharedPreferences sharedPreferences;

  SplashLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> isFirstLaunch() async {
    return sharedPreferences.getBool(_firstLaunchKey) ?? true;
  }

  @override
  Future<void> setFirstLaunchComplete() async {
    await sharedPreferences.setBool(_firstLaunchKey, false);
  }
}

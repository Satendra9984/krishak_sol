import 'splash_local_data_source.dart';

class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  @override
  Future<bool> isFirstLaunch() async {
    // TODO: Implement actual logic
    return true;
  }

  @override
  Future<void> setFirstLaunchComplete() async {
    // TODO: Implement actual logic
  }
}

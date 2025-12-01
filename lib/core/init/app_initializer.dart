import 'package:flutter/widgets.dart';
import '../di/service_locator.dart';
import 'hive_intialization.dart';
// import '../services/socket_service.dart';
// import 'hive_intialization.dart';
import 'package:get_storage/get_storage.dart';


class AppInitializer {
  static Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    await HiveInitialization.initHive();

    setupServiceLocator();
    await GetStorage.init();

    // (Rest of your initializations remain)
    await Future.delayed(const Duration(milliseconds: 500));

    // SocketService.initializeSocket(sl());
  }
}

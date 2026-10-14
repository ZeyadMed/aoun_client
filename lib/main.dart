import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aoun_client/core/local_storage/local_storage.dart';
import 'package:aoun_client/core/notification/messaging_config.dart';
import 'package:aoun_client/core/service_locator/service_locator.dart';
import 'package:aoun_client/core/theme/theme_mode_controller.dart';
import 'package:aoun_client/feature/my_app.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MessagingConfig.initFirebaseMessaging();
  await ThemeModeController.loadSavedTheme();
  await EasyLocalization.ensureInitialized();
  await HiveServiceImpl.init();
  await DI.execute();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      saveLocale: true,
      useOnlyLangCode: true,
      child: const TaqseetProApp(),
    ),
  );
}

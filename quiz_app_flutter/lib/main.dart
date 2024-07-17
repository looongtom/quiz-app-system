import 'dart:developer';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:quiz_app_flutter/common/constants/other_constants.dart';
import 'package:quiz_app_flutter/common/utils/dialog/loading_widget.dart';
import 'package:quiz_app_flutter/di/di_setup.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'common/config/screen_utils_config.dart';
import 'routes/app_pages.dart';

String envConfig(String flavor) {
  switch (flavor) {
    case 'dev':
      return 'assets/env/.env_dev';
    case 'staging':
      return 'assets/env/.env_staging';
    case 'production':
      return 'assets/env/.env_production';
    default:
      return 'assets/env/.env_dev';
  }
}
// await Firebase.initializeApp();
// await getIt<PushNotificationHelper>().initialize();
// await getIt<LocalNotificationHelper>().init();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const flavor = String.fromEnvironment('flavor', defaultValue: 'dev');
  log("flavor: $flavor");
  await dotenv.load(
    fileName: envConfig(flavor),
  );
  await EasyLocalization.ensureInitialized();
  configureDependencies();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        LocalizationConstants.enUSLocale,
        LocalizationConstants.viLocale
      ],
      path: LocalizationConstants.path,
      startLocale: LocalizationConstants.viLocale,
      fallbackLocale: LocalizationConstants.viLocale,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _appRoute = getIt<AppPages>();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
        ScreenUtilsConfig.designWidth,
        ScreenUtilsConfig.designHeight,
      ),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          builder: FlutterSmartDialog.init(
              loadingBuilder: (msg) => const LoadingWidget(),
              builder: (context, child) => MediaQuery(
                ///Setting font does not change with system font size
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1),
                ),
                child: child ?? const SizedBox(),
              ),
          ),
          routeInformationParser: _appRoute.defaultRouteParser(),
          routerDelegate: _appRoute.delegate(),
        );
      },
    );
  }
}

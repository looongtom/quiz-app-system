import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:quiz_app_flutter/base/network/dio/dio_builder.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AppModule {
  @singleton
  Dio get dio => DioBuilder().getDio();

  @Named('authDio')
  @singleton
  Dio get authDio => AuthDioBuilder().getDio();

  @singleton
  EventBus get eventBus => EventBus();

  @singleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  @singleton
  Logger get loggerHelper => Logger(
    printer: PrettyPrinter(),
  );
}

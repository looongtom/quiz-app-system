import 'package:flutter/material.dart';
import 'package:flutter_alice/alice.dart';
import 'package:injectable/injectable.dart';

@singleton
class AliceHelper {
  late Alice alice;

  AliceHelper() {
    _initAlice();
  }

  // GlobalKey<NavigatorState>? get getNavigatorKey => alice.getNavigatorKey();
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  void _initAlice() {
    alice = Alice(
      showInspectorOnShake:
          true, // const String.fromEnvironment("flavor") == "dev",
      darkTheme: true,
      navigatorKey: navigatorKey,
    );
  }
}

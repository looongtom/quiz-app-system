import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:quiz_app_flutter/features/domain/entity/quiz_entity.dart';
import 'package:quiz_app_flutter/features/presentation/core/pages/core_page.dart';
import 'package:quiz_app_flutter/features/presentation/do_quiz/page/do_quiz_page.dart';
import 'package:quiz_app_flutter/features/presentation/enter_quiz/presentation/page/participate_quiz_with_id_page.dart';
import 'package:quiz_app_flutter/features/presentation/enter_quiz/presentation/page/qr_scanner_page.dart';
import 'package:quiz_app_flutter/features/presentation/login/page/login_page.dart';
import 'package:quiz_app_flutter/features/presentation/register/page/register_page.dart';
import 'package:quiz_app_flutter/features/presentation/score/page/do_quiz_history_page.dart';
import 'package:quiz_app_flutter/features/presentation/score/page/score_page.dart';
import 'package:quiz_app_flutter/features/presentation/splash/page/splash_page.dart';
import 'package:quiz_app_flutter/routes/app_routes.dart';

part 'app_pages.gr.dart';

@singleton
@AutoRouterConfig()
class AppPages extends _$AppPages {
  @override
  RouteType get defaultRouteType => const RouteType.material();
  @override
  List<AutoRoute> routes = [
    AutoRoute(path: AppRoutes.initial, page: SplashRoute.page),
    AutoRoute(path: AppRoutes.login, page: LoginRoute.page),
    AutoRoute(path: AppRoutes.register, page: RegisterRoute.page),
    AutoRoute(
      path: AppRoutes.core,
      page: CoreRoute.page,
    ),
    AutoRoute(
      path: AppRoutes.qrScanner,
      page: QRScannerRoute.page,
    ),
    AutoRoute(
      path: AppRoutes.participateWithID,
      page: ParticipateQuizWithIDRoute.page,
    ),
    AutoRoute(
      path: AppRoutes.doQuiz,
      page: DoQuizRoute.page,
    ),
    AutoRoute(
      path: AppRoutes.score,
      page: ScoreRoute.page,
    ),
    AutoRoute(
      path: AppRoutes.doQuizHistory,
      page: DoQuizHistoryRoute.page,
    ),
  ];
}

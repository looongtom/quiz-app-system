import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app_flutter/base/base_widget.dart';
import 'package:quiz_app_flutter/common/index.dart';
import 'package:quiz_app_flutter/features/presentation/splash/bloc/splash_bloc.dart';
import 'package:quiz_app_flutter/gen/assets.gen.dart';
import 'package:quiz_app_flutter/routes/app_pages.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState
    extends BaseState<SplashPage, SplashEvent, SplashState, SplashBloc> {
  @override
  void initState() {
    super.initState();
    bloc.add(const SplashEvent.init());
  }

  @override
  void listener(BuildContext context, SplashState state) {
    super.listener(context, state);
    switch (state.actionState) {
      case SplashActionState.goToLogin:
        context.router.replaceAll([
          const LoginRoute(),
        ]);
        break;
      case SplashActionState.goToMain:
        context.router.replaceAll([
          const CoreRoute(),
        ]);
        break;
      default:
        break;
    }
  }

  @override
  Widget renderUI(BuildContext context) {
    return BaseScaffold(
      body: Container(
        color: AppColors.base200,
        child: Center(
          child: Assets.images.logo.image(
            width: 200.w,
          ),
        ),
      ),
    );
  }
}

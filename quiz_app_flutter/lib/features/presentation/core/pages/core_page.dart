import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app_flutter/base/base_widget.dart';
import 'package:quiz_app_flutter/base/bloc/bloc_status.dart';
import 'package:quiz_app_flutter/common/index.dart';
import 'package:quiz_app_flutter/common/widgets/buttons/app_button.dart';
import 'package:quiz_app_flutter/di/di_setup.dart';
import 'package:quiz_app_flutter/features/domain/events/event_bus_event.dart';
import 'package:quiz_app_flutter/features/presentation/core/bloc/core_bloc.dart';
import 'package:quiz_app_flutter/gen/assets.gen.dart';
import 'package:quiz_app_flutter/routes/app_pages.dart';

@RoutePage()
class CorePage extends StatefulWidget {
  const CorePage({Key? key}) : super(key: key);

  @override
  State<CorePage> createState() => _CorePageState();
}

class _CorePageState
    extends BaseState<CorePage, CoreEvent, CoreState, CoreBloc> {
  late StreamSubscription _eventBusSubscription;

  @override
  void initState() {
    super.initState();
    bloc.add(const CoreEvent.init());
    _eventBusSubscription = getIt<EventBus>().on<OpenLoginPageEvent>().listen((event) {
      context.router.replaceAll([
        const LoginRoute(),
      ]);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _eventBusSubscription.cancel();
  }

  @override
  void listener(BuildContext context, CoreState state) {
    super.listener(context, state);
    switch (state.status) {
      case BaseStateStatus.success:
        context.router.replaceAll([
          const LoginRoute(),
        ]);
        break;
      case BaseStateStatus.failed:
        DialogService.showInformationDialog(
          context,
          title: 'error'.tr(),
          description: state.message ?? 'error_system'.tr(),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget renderUI(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: 'home'.tr(),
        hasBack: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 24.h),
            Row(
              children: [
                Text(
                  'username'.tr(),
                  style: AppTextStyles.s16w400,
                ),
                SizedBox(width: 16.w),
                blocBuilder(
                  buildWhen: (previous, current) =>
                      previous.username != current.username,
                  (context, state) => Text(
                    state.username,
                    style: AppTextStyles.s16w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  'email'.tr(),
                  style: AppTextStyles.s16w400,
                ),
                SizedBox(width: 16.w),
                blocBuilder(
                  buildWhen: (previous, current) =>
                      previous.email != current.email,
                  (context, state) => Text(
                    state.email,
                    style: AppTextStyles.s16w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            AppButton(
              title: 'scan_qr_code_to_quizz'.tr(),
              height: 56.h,
              borderRadius: 28.r,
              trailingIcon: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Assets.images.icQrCode.image(
                  height: 40.h,
                ),
              ),
              textColor: AppColors.primary700,
              onPressed: () {
                context.router.push(const QRScannerRoute());
              },
            ),
            SizedBox(height: 24.h),
            AppButton(
              title: 'participate_with_quiz_id'.tr(),
              height: 56.h,
              borderRadius: 28.r,
              leadingIcon: Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Assets.svg.icInfo.svg(
                  height: 40.h,
                  colorFilter: const ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              backgroundColor: AppColors.primary700,
              onPressed: () {
                context.router.push(const ParticipateQuizWithIDRoute());
              },
            ),
            SizedBox(height: 24.h),
            AppButton(
              title: 'do_quiz_history'.tr(),
              backgroundColor: AppColors.green,
              height: 56.h,
              borderRadius: 28.r,
              onPressed: () {
                context.router.push(const DoQuizHistoryRoute());
              },
            ),
            SizedBox(height: 24.h),
            AppButton(
              title: 'logout'.tr(),
              backgroundColor: AppColors.red,
              height: 56.h,
              borderRadius: 28.r,
              onPressed: () {
                bloc.add(const CoreEvent.logout());
              },
            ),
          ],
        ),
      ),
    );
  }
}

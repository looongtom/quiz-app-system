import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:quiz_app_flutter/base/base_widget.dart';
import 'package:quiz_app_flutter/common/index.dart';
import 'package:quiz_app_flutter/common/widgets/buttons/app_button.dart';
import 'package:quiz_app_flutter/features/presentation/enter_quiz/presentation/bloc/enter_quiz_bloc.dart';
import 'package:quiz_app_flutter/routes/app_pages.dart';
import 'package:quiz_app_flutter/base/bloc/bloc_status.dart';

@RoutePage()
class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends BaseState<QRScannerPage, EnterQuizEvent,
    EnterQuizState, EnterQuizBloc> {
  @override
  void listener(BuildContext context, EnterQuizState state) {
    super.listener(context, state);
    if (state.quiz != null && state.status == BaseStateStatus.success) {
      context.router.push(
        DoQuizRoute(
          quizId: int.parse(state.quizId ?? '0'),
          quiz: state.quiz!,
        ),
      );
    }
    if (state.status == BaseStateStatus.failed) {
      DialogService.showInformationDialog(
        context,
        title: 'error'.tr(),
        description: state.message ?? 'error_system'.tr(),
      );
    }
  }

  @override
  Widget renderUI(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: 'qr_scanner'.tr(),
      ),
      body: Column(
        children: [
          SizedBox(
            width: 1.sw,
            height: 500.h,
            child: MobileScanner(
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  debugPrint('Barcode found! ${barcode.rawValue}');
                  if (barcode.rawValue != null &&
                      barcode.rawValue!.isNotEmpty) {
                    bloc.add(
                      EnterQuizEvent.inputQuizId(quizId: barcode.rawValue!),
                    );
                  }
                }
              },
              overlay: Container(
                width: 200.w,
                height: 200.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                    width: 2.w,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          blocBuilder(
            buildWhen: (previous, current) =>
                previous.quizId != current.quizId,
            (context, state) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Visibility(
                visible: state.quizId != null && state.quizId!.isNotEmpty,
                child: Column(
                  children: [
                    AppButton(
                      title: 'take_quiz'.tr(),
                      height: 56.h,
                      backgroundColor: AppColors.primary700,
                      borderRadius: 28.r,
                      onPressed: () {
                        bloc.add(const EnterQuizEvent.onEnterQuiz());
                      },
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'link_quiz'.tr(),
                          style: AppTextStyles.s16w400,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          state.quizId ?? '',
                          style: AppTextStyles.s16w400,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

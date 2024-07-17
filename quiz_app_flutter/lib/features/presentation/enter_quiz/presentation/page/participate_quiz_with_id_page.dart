import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app_flutter/base/base_widget.dart';
import 'package:quiz_app_flutter/base/bloc/bloc_status.dart';
import 'package:quiz_app_flutter/common/index.dart';
import 'package:quiz_app_flutter/common/widgets/buttons/app_button.dart';
import 'package:quiz_app_flutter/common/widgets/textfields/app_text_form_field.dart';
import 'package:quiz_app_flutter/features/presentation/enter_quiz/presentation/bloc/enter_quiz_bloc.dart';
import 'package:quiz_app_flutter/routes/app_pages.dart';

@RoutePage()
class ParticipateQuizWithIDPage extends StatefulWidget {
  const ParticipateQuizWithIDPage({super.key});

  @override
  State<ParticipateQuizWithIDPage> createState() =>
      _ParticipateQuizWithIDPageState();
}

class _ParticipateQuizWithIDPageState extends BaseState<
    ParticipateQuizWithIDPage, EnterQuizEvent, EnterQuizState, EnterQuizBloc> {
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
        title: 'take_quiz'.tr(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),
            Text(
              'quiz_id'.tr(),
              style: AppTextStyles.s16w600,
            ),
            SizedBox(height: 8.h),
            AppTextFormField(
              hintText: 'please_enter'.tr(),
              prefixIcon: SizedBox(width: 16.w),
              fillColor: AppColors.primary050,
              contentPadding: EdgeInsets.only(
                top: 16.h,
                bottom: 16.h,
                right: 16.w,
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                bloc.add(
                  EnterQuizEvent.inputQuizId(
                    quizId: value,
                  ),
                );
              },
            ),
            SizedBox(height: 16.h),
            blocBuilder(
              buildWhen: (previous, current) =>
                  previous.quizId != current.quizId,
              (context, state) => AppButton(
                title: 'take_quiz'.tr(),
                height: 56.h,
                backgroundColor: state.quizId != null
                    ? AppColors.primary500
                    : AppColors.primary300,
                textColor: state.quizId != null
                    ? AppColors.white
                    : AppColors.white.withOpacity(0.6),
                borderRadius: 28.r,
                onPressed: state.quizId != null
                    ? () {
                        bloc.add(const EnterQuizEvent.onEnterQuiz());
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

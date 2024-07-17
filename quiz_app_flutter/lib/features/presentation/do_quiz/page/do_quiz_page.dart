import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app_flutter/base/base_widget.dart';
import 'package:quiz_app_flutter/base/bloc/bloc_status.dart';
import 'package:quiz_app_flutter/common/index.dart';
import 'package:quiz_app_flutter/common/widgets/buttons/app_button.dart';
import 'package:quiz_app_flutter/features/domain/entity/quiz_entity.dart';
import 'package:quiz_app_flutter/features/domain/enum/question_type.dart';
import 'package:quiz_app_flutter/features/presentation/do_quiz/bloc/do_quiz_bloc.dart';
import 'package:quiz_app_flutter/features/presentation/do_quiz/widget/multiple_choice_item.dart';
import 'package:quiz_app_flutter/features/presentation/do_quiz/widget/single_choice_item.dart';
import 'package:quiz_app_flutter/routes/app_pages.dart';

@RoutePage()
class DoQuizPage extends StatefulWidget {
  final int quizId;
  final QuizEntity quiz;

  const DoQuizPage({
    super.key,
    required this.quizId,
    required this.quiz,
  });

  @override
  State<DoQuizPage> createState() => _DoQuizPageState();
}

class _DoQuizPageState
    extends BaseState<DoQuizPage, DoQuizEvent, DoQuizState, DoQuizBloc> {
  @override
  void initState() {
    super.initState();
    bloc.add(DoQuizEvent.init(quiz: widget.quiz));
  }

  @override
  void listener(BuildContext context, DoQuizState state) {
    super.listener(context, state);
    switch (state.status) {
      case BaseStateStatus.success:
        context.router.pushAndPopUntil(
          ScoreRoute(
            score: state.numberOfRightAnswers /
                (state.quiz?.questions.length ?? 0.1) *
                100,
            quizId: widget.quizId,
          ),
          predicate: (route) => route.settings.name == CoreRoute.name,
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
        title: 'take_quiz'.tr(),
        onLeadingTap: () {
          DialogService.showActionDialog(
            context,
            barrierDismissible: false,
            description: 'do_you_want_to_exit'.tr(),
            leftButtonText: 'no'.tr(),
            rightButtonText: 'yes'.tr(),
            onPressedRightButton: () {
              Navigator.of(context).pop();
              context.maybePop();
            },
          );
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),
            blocBuilder(
              buildWhen: (previous, current) =>
                  previous.currentQuestionIndex != current.currentQuestionIndex,
              (context, state) => Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      color: AppColors.primary300,
                      borderRadius: BorderRadius.circular(8),
                      minHeight: 16.h,
                      value: state.currentQuestionIndex /
                          (state.quiz?.questions.length ?? 10),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  SizedBox(
                    width: 50.w,
                    child: Text(
                      '${(state.currentQuestionIndex / (state.quiz?.questions.length ?? 10) * 100).toStringAsFixed(0)} %',
                      style: AppTextStyles.s16w600.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Text(
                  'number_of_questions'.tr(),
                  style: AppTextStyles.s16w600.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 8.w),
                blocBuilder(
                  buildWhen: (previous, current) =>
                      previous.quiz?.questions.length !=
                      current.quiz?.questions.length,
                  (context, state) => Text(
                    '${state.quiz?.questions.length ?? 0}',
                    style: AppTextStyles.s16w600.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  'number_of_right_answers'.tr(),
                  style: AppTextStyles.s16w600.copyWith(
                    color: AppColors.green,
                  ),
                ),
                SizedBox(width: 8.w),
                blocBuilder(
                  buildWhen: (previous, current) =>
                      previous.numberOfRightAnswers !=
                      current.numberOfRightAnswers,
                  (context, state) => Text(
                    '${state.numberOfRightAnswers}',
                    style: AppTextStyles.s16w600.copyWith(
                      color: AppColors.green,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  'number_of_wrong_answers'.tr(),
                  style: AppTextStyles.s16w600.copyWith(
                    color: AppColors.red,
                  ),
                ),
                SizedBox(width: 8.w),
                blocBuilder(
                  buildWhen: (previous, current) =>
                      previous.numberOfWrongAnswers !=
                      current.numberOfWrongAnswers,
                  (context, state) => Text(
                    '${state.numberOfWrongAnswers}',
                    style: AppTextStyles.s16w600.copyWith(
                      color: AppColors.red,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: blocBuilder(
                    buildWhen: (previous, current) =>
                        previous.time != current.time,
                    (context, state) => LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(8.r),
                      minHeight: 16.h,
                      value: state.time /
                          (state.quiz?.questions[state.currentQuestionIndex - 1]
                                  .time ??
                              30),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                SizedBox(
                  width: 50.w,
                  child: blocBuilder(
                    buildWhen: (previous, current) =>
                        previous.time != current.time,
                    (context, state) => Text(
                      '${state.time.toStringAsFixed(0)} s',
                      style: AppTextStyles.s16w600.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            blocBuilder(
              buildWhen: (previous, current) =>
                  previous.currentQuestionIndex != current.currentQuestionIndex,
              (context, state) => Row(
                children: [
                  Text(
                    '${'question'.tr()} ${state.currentQuestionIndex}:',
                    style: AppTextStyles.s16w600.copyWith(
                      color: AppColors.primary700,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    state.quiz?.questions[state.currentQuestionIndex - 1]
                            .question ??
                        '',
                    style: AppTextStyles.s16w600.copyWith(
                      color: AppColors.primary700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            /// Answers
            blocBuilder(
              buildWhen: (previous, current) =>
                  previous.isShowAnswers != current.isShowAnswers ||
                  previous.currentQuestionIndex != current.currentQuestionIndex,
              (context, state) => Column(
                children: state
                        .quiz?.questions[state.currentQuestionIndex - 1].answers
                        .map(
                          (answer) => state
                                      .quiz
                                      ?.questions[
                                          state.currentQuestionIndex - 1]
                                      .type ==
                                  QuestionType.singleChoice
                              ? Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: SingleChoiceItem(
                                    answer: answer,
                                    isShowAnswers: state.isShowAnswers,
                                    onTap: (value) {
                                      bloc.add(DoQuizEvent.onSelectAnswer(
                                          isRightAnswer: value));
                                    },
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: MultipleChoiceItem(
                                    answer: answer,
                                    isShowAnswers: state.isShowAnswers,
                                    onChange: (value) {
                                      bloc.add(
                                        DoQuizEvent
                                            .onSelectMultipleChoiceQuestionAnswer(
                                          answer: answer,
                                          isSelected: value,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        )
                        .toList() ??
                    [],
              ),
            ),

            SizedBox(height: 24.h),
            blocBuilder(
              (context, state) => Visibility(
                visible: state
                        .quiz?.questions[state.currentQuestionIndex - 1].type ==
                    QuestionType.multipleChoice,
                child: AppButton(
                  title: 'submit_answer'.tr(),
                  height: 56.h,
                  backgroundColor: AppColors.primary700,
                  borderRadius: 28.r,
                  onPressed: () {
                    bloc.add(const DoQuizEvent
                        .onSubmitMultipleChoiceQuestionAnswer());
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

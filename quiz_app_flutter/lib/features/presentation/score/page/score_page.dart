import 'package:auto_route/annotations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app_flutter/base/base_widget.dart';
import 'package:quiz_app_flutter/common/index.dart';
import 'package:quiz_app_flutter/features/presentation/score/bloc/score_bloc.dart';
import 'package:quiz_app_flutter/features/presentation/score/widget/leaderboard_item_widget.dart';

@RoutePage()
class ScorePage extends StatefulWidget {
  final double score;
  final int quizId;

  const ScorePage({
    super.key,
    required this.score,
    required this.quizId,
  });

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState
    extends BaseState<ScorePage, ScoreEvent, ScoreState, ScoreBloc> {
  @override
  void initState() {
    super.initState();
    bloc.add(ScoreEvent.init(
      score: widget.score,
      quizId: widget.quizId,
      isDoQuizHistory: false,
    ));
  }

  @override
  Widget renderUI(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: 'score'.tr(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Text(
              'score'.tr(),
              style: AppTextStyles.s16w600.copyWith(
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              widget.score.toStringAsFixed(0),
              style: AppTextStyles.s24w800.copyWith(
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Text(
                  'history'.tr(),
                  style: AppTextStyles.s16w600.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: blocBuilder(
                buildWhen: (previous, current) =>
                    previous.leaderboard != current.leaderboard,
                (context, state) => ListView.separated(
                  shrinkWrap: true,
                  itemCount: state.leaderboard.length,
                  separatorBuilder: (context, index) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    final score = state.leaderboard[index];
                    return LeaderboardItemWidget(
                      score: score.score.toStringAsFixed(0),
                      name: score.username,
                      date: score.timeStamp,
                      index: index + 1,
                    );
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

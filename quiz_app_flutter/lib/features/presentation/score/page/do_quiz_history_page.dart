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
class DoQuizHistoryPage extends StatefulWidget {
  const DoQuizHistoryPage({super.key});

  @override
  State<DoQuizHistoryPage> createState() => _DoQuizHistoryPageState();
}

class _DoQuizHistoryPageState
    extends BaseState<DoQuizHistoryPage, ScoreEvent, ScoreState, ScoreBloc> {
  @override
  void initState() {
    super.initState();
    bloc.add(const ScoreEvent.getDoQuizHistory());
  }

  @override
  Widget renderUI(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: 'do_quiz_history'.tr(),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 16.w, left: 16.w, right: 16.w),
        child: Expanded(
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app_flutter/common/app_theme/app_colors.dart';
import 'package:quiz_app_flutter/common/app_theme/app_text_styles.dart';
import 'package:quiz_app_flutter/common/utils/date_time/date_time_utils.dart';

class LeaderboardItemWidget extends StatelessWidget {
  final int index;
  final String name;
  final String score;
  final DateTime date;

  const LeaderboardItemWidget({
    super.key,
    required this.index,
    required this.name,
    required this.score,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppColors.primary050,
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Text(
              index.toString(),
              style: AppTextStyles.s20w600,
            ),
            SizedBox(width: 24.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.s16w600,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    DateTimeUtils.getStringDate(date, Pattern.ddMMyyyy),
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              score,
              style: AppTextStyles.s20w600,
            ),
          ],
        ),
      ),
    );
  }
}

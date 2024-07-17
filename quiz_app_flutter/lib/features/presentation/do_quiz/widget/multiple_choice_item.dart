import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app_flutter/common/app_theme/app_colors.dart';
import 'package:quiz_app_flutter/common/app_theme/app_text_styles.dart';
import 'package:quiz_app_flutter/common/constants/other_constants.dart';
import 'package:quiz_app_flutter/features/domain/entity/answer_entity.dart';
import 'package:quiz_app_flutter/gen/assets.gen.dart';

class MultipleChoiceItem extends StatefulWidget {
  final AnswerEntity answer;
  final Function(bool) onChange;
  final bool isShowAnswers;

  const MultipleChoiceItem({
    super.key,
    this.isShowAnswers = false,
    required this.answer,
    required this.onChange,
  });

  @override
  State<MultipleChoiceItem> createState() => _MultipleChoiceItemState();
}

class _MultipleChoiceItemState extends State<MultipleChoiceItem> {
  bool _isChecked = false;

  @override
  void didUpdateWidget(covariant MultipleChoiceItem oldWidget) {
    if(oldWidget.answer != widget.answer) {
      _isChecked = false;
    }
    super.didUpdateWidget(oldWidget);
  }

  Color get itemColor {
    if (widget.isShowAnswers) {
      if (_isChecked) {
        if (widget.answer.isCorrect) {
          return AppColors.alertSuccess;
        } else {
          return AppColors.red;
        }
      } else {
        if (widget.answer.isCorrect) {
          return AppColors.green;
        } else {
          return AppColors.primary050;
        }
      }
    } else {
      return AppColors.primary050;
    }
  }

  Color get itemTextColor {
    if (widget.isShowAnswers) {
      if(_isChecked) {
        return AppColors.white;
      } else {
        return AppColors.primary700;
      }
    } else {
      return AppColors.primary700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
        });
        widget.onChange(_isChecked);
      },
      child: Container(
        height: 74.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: itemColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.primary700,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedCrossFade(
              firstChild: Assets.svg.icon28CheckBlank.svg(
                width: 28.w,
              ),
              secondChild: Assets.svg.icon28CheckIdeal.svg(
                width: 28.w,
              ),
              crossFadeState: _isChecked
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: AnimationConstants.crossFadeDuration,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Center(
                child: Text(
                  widget.answer.name,
                  style: AppTextStyles.s14w400.copyWith(
                    color: itemTextColor,
                  ),
                  maxLines: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

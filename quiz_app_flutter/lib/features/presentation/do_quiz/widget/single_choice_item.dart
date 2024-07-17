import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app_flutter/common/app_theme/app_colors.dart';
import 'package:quiz_app_flutter/common/app_theme/app_text_styles.dart';
import 'package:quiz_app_flutter/features/domain/entity/answer_entity.dart';

class SingleChoiceItem extends StatefulWidget {
  final AnswerEntity answer;
  final Function(bool)? onTap;
  final bool isShowAnswers;

  const SingleChoiceItem({
    super.key,
    required this.answer,
    this.onTap,
    this.isShowAnswers = false,
  });

  @override
  State<SingleChoiceItem> createState() => _SingleChoiceItemState();
}

class _SingleChoiceItemState extends State<SingleChoiceItem> {
  bool _isChosen = false;

  @override
  void didUpdateWidget(covariant SingleChoiceItem oldWidget) {
    if(oldWidget.answer != widget.answer) {
      _isChosen = false;
    }
    super.didUpdateWidget(oldWidget);
  }


  Color? get itemColor {
    if (widget.isShowAnswers) {
      if (_isChosen) {
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
      if(_isChosen) {
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
        widget.onTap?.call(widget.answer.isCorrect);
        setState(() {
          _isChosen = true;
        });
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
    );
  }
}

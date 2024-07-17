import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app_flutter/common/app_theme/app_colors.dart';
import 'package:quiz_app_flutter/common/app_theme/app_text_styles.dart';
import 'package:quiz_app_flutter/gen/assets.gen.dart';

class BaseAppBar extends StatelessWidget {
  final String? title;
  final String? icon;
  final bool? hasBack;
  final Widget? leading;
  final VoidCallback? onLeadingTap;
  final double? elevation;
  final double? leadingWidth;
  final Widget? appBarWidget;
  final PreferredSize? bottom;
  final List<Widget>? actions;
  final double? titleSpacing;
  final Function()? onPressedLeading;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Color? leadingColor;
  final SystemUiOverlayStyle? systemUiOverlayStyle;
  final bool? backwardsCompatibility;
  final Color? textColor;
  final dynamic result;
  final Widget? leadingIcon;
  final Color? shadowColor;

  const BaseAppBar({
    Key? key,
    this.backgroundColor,
    this.titleSpacing,
    this.title,
    this.icon,
    this.leading,
    this.onLeadingTap,
    this.leadingWidth,
    this.hasBack,
    this.bottom,
    this.leadingColor,
    this.appBarWidget,
    this.textStyle,
    this.textColor,
    this.elevation,
    this.backwardsCompatibility,
    this.actions,
    this.onPressedLeading,
    this.result,
    this.systemUiOverlayStyle,
    this.leadingIcon,
    this.shadowColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: elevation ?? 0.7,
      shadowColor: shadowColor,
      leadingWidth: leadingWidth ?? 100.w,
      titleSpacing: 0,
      systemOverlayStyle: systemUiOverlayStyle ?? SystemUiOverlayStyle.dark,
      leading: leading ??
          Visibility(
            visible: hasBack ?? true,
            child: InkWell(
              onTap: onLeadingTap ??
                      () {
                    context.maybePop();
                  },
              child: Row(
                children: [
                  SizedBox(width: 8.w),
                  Assets.svg.icon16ArrowLeft.svg(
                    width: 16.w,
                    colorFilter: const ColorFilter.mode(
                      AppColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Flexible(
                    child: Text(
                      'return'.tr(),
                      style: AppTextStyles.s14w400.copyWith(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
      title: appBarWidget ??
          Text(
            title ?? '',
            maxLines: 1,
            style: textStyle ??
                AppTextStyles.s16w600.copyWith(color: AppColors.white),
          ),
      actions: actions ?? [SizedBox(width: 5.w)],
      bottom: bottom,
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.images.appBarBg.path),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
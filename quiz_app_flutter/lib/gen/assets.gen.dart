/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsEnvGen {
  const $AssetsEnvGen();

  /// File path: assets/env/.env_dev
  String get envDev => 'assets/env/.env_dev';

  /// File path: assets/env/.env_production
  String get envProduction => 'assets/env/.env_production';

  /// File path: assets/env/.env_staging
  String get envStaging => 'assets/env/.env_staging';

  /// List of all assets
  List<String> get values => [envDev, envProduction, envStaging];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/app_bar_bg.png
  AssetGenImage get appBarBg =>
      const AssetGenImage('assets/images/app_bar_bg.png');

  /// File path: assets/images/ic_qr_code.jpg
  AssetGenImage get icQrCode =>
      const AssetGenImage('assets/images/ic_qr_code.jpg');

  /// File path: assets/images/loading.png
  AssetGenImage get loading => const AssetGenImage('assets/images/loading.png');

  /// File path: assets/images/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/images/logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [appBarBg, icQrCode, loading, logo];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/ic_arrow_left.svg
  SvgGenImage get icArrowLeft =>
      const SvgGenImage('assets/svg/ic_arrow_left.svg');

  /// File path: assets/svg/ic_arrow_right.svg
  SvgGenImage get icArrowRight =>
      const SvgGenImage('assets/svg/ic_arrow_right.svg');

  /// File path: assets/svg/ic_check_box_active.svg
  SvgGenImage get icCheckBoxActive =>
      const SvgGenImage('assets/svg/ic_check_box_active.svg');

  /// File path: assets/svg/ic_check_box_inactive.svg
  SvgGenImage get icCheckBoxInactive =>
      const SvgGenImage('assets/svg/ic_check_box_inactive.svg');

  /// File path: assets/svg/ic_close.svg
  SvgGenImage get icClose => const SvgGenImage('assets/svg/ic_close.svg');

  /// File path: assets/svg/ic_eye.svg
  SvgGenImage get icEye => const SvgGenImage('assets/svg/ic_eye.svg');

  /// File path: assets/svg/ic_eye_off.svg
  SvgGenImage get icEyeOff => const SvgGenImage('assets/svg/ic_eye_off.svg');

  /// File path: assets/svg/ic_google.svg
  SvgGenImage get icGoogle => const SvgGenImage('assets/svg/ic_google.svg');

  /// File path: assets/svg/ic_info.svg
  SvgGenImage get icInfo => const SvgGenImage('assets/svg/ic_info.svg');

  /// File path: assets/svg/ic_profile.svg
  SvgGenImage get icProfile => const SvgGenImage('assets/svg/ic_profile.svg');

  /// File path: assets/svg/icon-16-arrowLeft.svg
  SvgGenImage get icon16ArrowLeft =>
      const SvgGenImage('assets/svg/icon-16-arrowLeft.svg');

  /// File path: assets/svg/icon-16-arrowRight.svg
  SvgGenImage get icon16ArrowRight =>
      const SvgGenImage('assets/svg/icon-16-arrowRight.svg');

  /// File path: assets/svg/icon-16-checkOff.svg
  SvgGenImage get icon16CheckOff =>
      const SvgGenImage('assets/svg/icon-16-checkOff.svg');

  /// File path: assets/svg/icon-16-checkOn.svg
  SvgGenImage get icon16CheckOn =>
      const SvgGenImage('assets/svg/icon-16-checkOn.svg');

  /// File path: assets/svg/icon-20-close.svg
  SvgGenImage get icon20Close =>
      const SvgGenImage('assets/svg/icon-20-close.svg');

  /// File path: assets/svg/icon-28-checkBlank.svg
  SvgGenImage get icon28CheckBlank =>
      const SvgGenImage('assets/svg/icon-28-checkBlank.svg');

  /// File path: assets/svg/icon-28-checkIdeal.svg
  SvgGenImage get icon28CheckIdeal =>
      const SvgGenImage('assets/svg/icon-28-checkIdeal.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        icArrowLeft,
        icArrowRight,
        icCheckBoxActive,
        icCheckBoxInactive,
        icClose,
        icEye,
        icEyeOff,
        icGoogle,
        icInfo,
        icProfile,
        icon16ArrowLeft,
        icon16ArrowRight,
        icon16CheckOff,
        icon16CheckOn,
        icon20Close,
        icon28CheckBlank,
        icon28CheckIdeal
      ];
}

class $AssetsTranslationsGen {
  const $AssetsTranslationsGen();

  /// File path: assets/translations/en-US.json
  String get enUS => 'assets/translations/en-US.json';

  /// File path: assets/translations/vi-VN.json
  String get viVN => 'assets/translations/vi-VN.json';

  /// List of all assets
  List<String> get values => [enUS, viVN];
}

class Assets {
  Assets._();

  static const $AssetsEnvGen env = $AssetsEnvGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
  static const $AssetsTranslationsGen translations = $AssetsTranslationsGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme theme = const SvgTheme(),
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      theme: theme,
      colorFilter: colorFilter,
      color: color,
      colorBlendMode: colorBlendMode,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

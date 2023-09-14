import 'package:we_pro/modules/core/utils/core_import.dart';

/// Used by [AppFont] of app and web
class AppFont {
  static const regular = TextStyle(fontFamily: 'MontserratRegular');
  static const bold = TextStyle(fontFamily: 'MontserratBold');
  static const semiBold = TextStyle(fontFamily: 'MontserratSemiBold');
  static const mediumBold =
      TextStyle(fontFamily: 'MontserratMedium', fontWeight: FontWeight.w500);

  ///-------regular-----------
  static final regular1DB712 = regular.copyWith(color: AppColors.color1DB712);

  ///colorHint-------
  static final regularColorWhite =
      regular.copyWith(color: AppColors.colorWhite);

  static final regularColorSecondary =
      regular.copyWith(color: AppColors.colorSecondary);

  static final regularColorBlack =
      regular.copyWith(color: AppColors.colorBlack);

  static final regularColorRed = regular.copyWith(color: AppColors.colorC31B1B);

  static final regularColor7E7E7E =
      regular.copyWith(color: AppColors.color7E7E7E);

  static final regularcolorC31B1B =
      regular.copyWith(color: AppColors.colorC31B1B);
  static final regularColorPrimary =
      regular.copyWith(color: AppColors.colorPrimary);

  static final regularColorF0A04B =
      regular.copyWith(color: AppColors.colorF0A04B);

  static final regularColorEAEAEA =
      regular.copyWith(color: AppColors.colorEAEAEA);

  static final regularColor183A1D =
      regular.copyWith(color: AppColors.color183A1D);

  static final regularColor777777 =
      regular.copyWith(color: AppColors.color777777);

  static final regularColor707070 =
      regular.copyWith(color: AppColors.color707070);
  static final regularColorD9D9D9 =
      regular.copyWith(color: AppColors.colorD9D9D9);
  static final regularColor007AFF =
      regular.copyWith(color: AppColors.color007AFF);

  ///-------bold-------------

  static final colorWhiteBold = bold.copyWith(color: AppColors.colorWhite);
  static final colorPrimaryBoldUnderline = bold.copyWith(
      color: AppColors.colorPrimary,
      decoration: TextDecoration.underline,
      height: 2);
  static final colorSecondaryBold =
      bold.copyWith(color: AppColors.colorSecondary);
  static final colorF0A04BBold = bold.copyWith(color: AppColors.colorF0A04B);

  ///-------mediumBold-------------

  static final mediumColorWhite =
      mediumBold.copyWith(color: AppColors.colorWhite);

  static final mediumColorPrimary =
      mediumBold.copyWith(color: AppColors.colorPrimary);

  static final mediumColorF0A04B =
      mediumBold.copyWith(color: AppColors.colorF0A04B);

  static final mediumColor818181 =
      mediumBold.copyWith(color: AppColors.color818181);

  // static final mediumColorwhite =
  //     mediumBold.copyWith(color: AppColors.colorWhite);

  ///-------semiBold-------------
  static final semiBoldColorPrimary =
      semiBold.copyWith(color: AppColors.colorPrimary);

  static final colorSecondarySemiBold =
      semiBold.copyWith(color: AppColors.colorSecondary);

  static final colorPrimarySemiBold =
      semiBold.copyWith(color: AppColors.colorPrimary);
  static final colorWhiteSemiBold =
      semiBold.copyWith(color: AppColors.colorWhite);
  static final colorBlackSemiBold =
      semiBold.copyWith(color: AppColors.colorBlack);
  static final colorBlackMediumBold =
      mediumBold.copyWith(color: AppColors.colorBlack);
  static final colorAA4444SemiBold =
      semiBold.copyWith(color: AppColors.colorAA4444);
  static final color1DB712SemiBold =
      semiBold.copyWith(color: AppColors.color1DB712);

  static final color727272Regular =
      regular.copyWith(color: AppColors.color727272);
}

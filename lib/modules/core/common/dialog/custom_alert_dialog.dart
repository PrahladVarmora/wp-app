import 'package:flutter/cupertino.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';

/// [CustomAlertDialog] class is used Custom Alert Dialog
class CustomAlertDialog {
  static final CustomAlertDialog _instance = CustomAlertDialog.internal();

  CustomAlertDialog.internal();

  factory CustomAlertDialog() => _instance;

  static void showCustomDialog(BuildContext context,
      {String? title,
      TextAlign? titleAlign,
      required String content,
      required String okBtnText,
      String? cancelBtnText,
      required VoidCallback okBtnFunction,
      VoidCallback? cancelBtnFunction,
      bool barrierDismissible = true}) {
    showCupertinoDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) {
          Widget text(String text, TextAlign textAlign, TextStyle style) {
            return Text(
              text,
              textAlign: textAlign,
              style: style,
            );
          }

          return WillPopScope(
            onWillPop: () async {
              return barrierDismissible;
            },
            child: AlertDialog(
              contentPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimens.margin10))),
              content: Container(
                // width:  MediaQuery.of(context).size.width,
                // height: Dimens.margin190,
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.margin20, vertical: Dimens.margin20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(Dimens.margin10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null) ...[
                      text(
                        title,
                        titleAlign ?? TextAlign.left,
                        getTextStyleFontWeight(
                            Theme.of(context).primaryTextTheme.displaySmall!,
                            Dimens.textSize26,
                            FontWeight.w600),
                      ),
                      const SizedBox(height: Dimens.margin17),
                    ],
                    text(
                      content,
                      TextAlign.center,
                      getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.labelSmall!,
                          Dimens.textSize16,
                          FontWeight.w600),
                    ),
                    const SizedBox(height: Dimens.margin17),
                    CustomButton(
                      buttonText: okBtnText,
                      height: Dimens.margin40,
                      width: double.infinity,
                      backgroundColor: Theme.of(context).primaryColor,
                      borderColor: Theme.of(context).primaryColor,
                      borderRadius: Dimens.margin8,
                      onPress: () {
                        okBtnFunction();
                      },
                      style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.displayMedium!,
                          Dimens.textSize16,
                          FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static void showOnfidoDialog(
    BuildContext context, {
    String? title,
    String? content,
  }) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          Widget text(String text, TextAlign textAlign, TextStyle style) {
            return Text(
              text,
              textAlign: textAlign,
              style: style,
            );
          }

          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(Dimens.margin10))),
            content: Container(
              width: Responsive.isDesktop(context)
                  ? Dimens.margin432
                  : MediaQuery.of(context).size.width,
              height: Dimens.margin190,
              padding: const EdgeInsets.symmetric(horizontal: Dimens.margin20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(Dimens.margin10),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: Dimens.margin20,
                  ),
                  text(
                    title!,
                    TextAlign.left,
                    getTextStyleFontWeight(
                        Theme.of(context).primaryTextTheme.displaySmall!,
                        Dimens.textSize26,
                        FontWeight.w600),
                  ),
                  const SizedBox(
                    height: Dimens.margin17,
                  ),
                  text(
                    content!,
                    TextAlign.left,
                    getTextStyleFontWeight(
                        Theme.of(context).primaryTextTheme.displaySmall!,
                        Dimens.textSize16,
                        FontWeight.w600),
                  ),
                  const SizedBox(height: Dimens.margin17),
                ],
              ),
            ),
          );
        });
  }

  static void showCustomPermissionDialog(BuildContext context,
      {String? title,
      TextAlign? titleAlign,
      required String content,
      required String okBtnText,
      String? cancelBtnText,
      required VoidCallback okBtnFunction,
      VoidCallback? cancelBtnFunction,
      bool barrierDismissible = true}) {
    showCupertinoDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) {
          Widget text(String text, TextAlign textAlign, TextStyle style) {
            return Text(
              text,
              textAlign: textAlign,
              style: style,
            );
          }

          return WillPopScope(
            onWillPop: () async {
              return barrierDismissible;
            },
            child: AlertDialog(
              contentPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimens.margin10))),
              content: Container(
                // width:  MediaQuery.of(context).size.width,
                // height: Dimens.margin190,
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.margin20, vertical: Dimens.margin20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(Dimens.margin10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null) ...[
                      text(
                        title,
                        titleAlign ?? TextAlign.left,
                        getTextStyleFontWeight(
                            Theme.of(context).primaryTextTheme.displaySmall!,
                            Dimens.textSize26,
                            FontWeight.w600),
                      ),
                      const SizedBox(height: Dimens.margin17),
                    ],
                    text(
                      content,
                      TextAlign.center,
                      getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.labelSmall!,
                          Dimens.textSize16,
                          FontWeight.w600),
                    ),
                    const SizedBox(height: Dimens.margin17),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomButton(
                          buttonText: cancelBtnText,
                          height: Dimens.margin40,
                          width: Dimens.margin100,
                          backgroundColor: Theme.of(context).primaryColor,
                          borderColor: Theme.of(context).primaryColor,
                          borderRadius: Dimens.margin8,
                          onPress: () {
                            cancelBtnFunction!();
                          },
                          style: getTextStyleFontWeight(
                              Theme.of(context).primaryTextTheme.displayMedium!,
                              Dimens.textSize16,
                              FontWeight.w600),
                        ),
                        CustomButton(
                          buttonText: okBtnText,
                          height: Dimens.margin40,
                          width: Dimens.margin100,
                          backgroundColor: Theme.of(context).primaryColor,
                          borderColor: Theme.of(context).primaryColor,
                          borderRadius: Dimens.margin8,
                          onPress: () {
                            okBtnFunction();
                          },
                          style: getTextStyleFontWeight(
                              Theme.of(context).primaryTextTheme.displayMedium!,
                              Dimens.textSize16,
                              FontWeight.w600),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

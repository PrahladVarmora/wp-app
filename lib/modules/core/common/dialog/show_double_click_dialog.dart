import 'package:we_pro/modules/core/utils/core_import.dart';

/// [DialogDoubleClick] class is used Custom Alert Dialog Double Click
class DialogDoubleClick {
  static final DialogDoubleClick _instance = DialogDoubleClick.internal();

  DialogDoubleClick.internal();

  factory DialogDoubleClick() => _instance;

  static void showCustomDialogYesNo(BuildContext context,
      {String? title,
      @required String? content,
      @required String? yesText,
      @required String? noText,
      @required VoidCallback? okBtnFunction,
      VoidCallback? cancelBtnFunction}) {
    Widget text(String text, TextAlign textAlign, {TextStyle? style}) {
      return Text(
        text,
        textAlign: textAlign,
        style: style,
      );
    }

    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(Dimens.margin10))),
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: Dimens.margin180,
              padding: const EdgeInsets.symmetric(horizontal: Dimens.margin20),
              decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor,
                  borderRadius: BorderRadius.circular(Dimens.margin10),
                  border: Border.all(color: Theme.of(context).primaryColor)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: Dimens.margin20,
                  ),
                  text(
                    title!,
                    TextAlign.left,
                    style: getTextStyleFontWeight(
                        Theme.of(context).textTheme.labelSmall!,
                        Dimens.textSize16,
                        FontWeight.bold),
                  ),
                  const SizedBox(
                    height: Dimens.margin17,
                  ),
                  text(
                    content!,
                    TextAlign.left,
                    style: getTextStyleFontWeight(
                        Theme.of(context).textTheme.labelSmall!,
                        Dimens.textSize14,
                        FontWeight.normal),
                  ),
                  const SizedBox(
                    height: Dimens.margin17,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        buttonText: noText!,
                        height: Dimens.margin40,
                        style: getTextStyleFontWeight(
                            Theme.of(context).textTheme.labelSmall!,
                            Dimens.textSize12,
                            FontWeight.normal),
                        width: (MediaQuery.of(context).size.width / 2) -
                            Dimens.margin75,
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        borderColor: Theme.of(context).primaryColor,
                        borderRadius: Dimens.margin8,
                        onPress: () {
                          if (cancelBtnFunction != null) {
                            cancelBtnFunction();
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                      const SizedBox(
                        width: Dimens.margin20,
                      ),
                      CustomButton(
                        buttonText: yesText!,
                        height: Dimens.margin40,
                        width: (MediaQuery.of(context).size.width / 2) -
                            Dimens.margin75,
                        backgroundColor: Theme.of(context).primaryColor,
                        borderColor: Theme.of(context).primaryColor,
                        borderRadius: Dimens.margin8,
                        onPress: () {
                          okBtnFunction!();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: Dimens.margin24,
                  ),
                ],
              ),
            ),
          );
        });
  }
}

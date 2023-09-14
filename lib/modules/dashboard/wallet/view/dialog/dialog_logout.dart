import 'package:we_pro/modules/core/utils/core_import.dart';

///[DialogLogout] this class is used as Dialog Add Money
class DialogLogout extends StatefulWidget {
  const DialogLogout(
      {Key? key,
      required this.buttonOnTap,
      required this.title,
      required this.desc})
      : super(key: key);

  ///this variable is used for Description og dialog box
  final Function buttonOnTap;
  final String title;
  final String desc;

  @override
  State<DialogLogout> createState() => _DialogLogoutState();
}

class _DialogLogoutState extends State<DialogLogout> {
  TextEditingController amountController = TextEditingController();
  ValueNotifier<String> amountError = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    /// A function that returns a widget.
    Widget logout() {
      return CustomButton(
        height: Dimens.margin50,
        backgroundColor: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
        borderRadius: Dimens.margin15,
        onPress: () {
          widget.buttonOnTap.call();
        },
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displayMedium!,
            Dimens.textSize15,
            FontWeight.w500),
        buttonText: APPStrings.textYesIAmSure.translate(),
      );
    }

    /// A function that returns a widget.
    Widget cancel() {
      return CustomButton(
        height: Dimens.margin50,
        backgroundColor: Theme.of(context).colorScheme.background,
        borderColor: Theme.of(context).primaryColor,
        borderRadius: Dimens.margin15,
        onPress: () {
          Navigator.pop(context);
        },
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.textSize15,
            FontWeight.w500),
        buttonText: APPStrings.textCancel.translate(),
      );
    }

    return Dialog(
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: Dimens.margin16),
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.margin30),
      ),
      child: MultiValueListenableBuilder(
          valueListenables: [amountError],
          builder: (context, values, Widget? child) {
            return Padding(
              padding: const EdgeInsets.only(
                  top: Dimens.margin16,
                  bottom: Dimens.margin20,
                  left: Dimens.margin20,
                  right: Dimens.margin20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: Dimens.margin15),
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          widget.title.translate(),
                          style: getTextStyleFontWeight(
                              Theme.of(context).primaryTextTheme.labelSmall!,
                              Dimens.textSize18,
                              FontWeight.w600),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          child: SvgPicture.asset(APPImages.icClose),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: Dimens.margin32),
                  Text(
                    widget.desc.translate(),
                    textAlign: TextAlign.center,
                    style: getTextStyleFontWeight(
                        Theme.of(context).primaryTextTheme.labelSmall!,
                        Dimens.textSize15,
                        FontWeight.w400),
                  ),
                  const SizedBox(height: Dimens.margin20),
                  Row(
                    children: [
                      Expanded(child: cancel()),
                      const SizedBox(
                        width: Dimens.margin10,
                      ),
                      Expanded(child: logout()),
                    ],
                  ),
                  const SizedBox(height: Dimens.margin5),
                ],
              ),
            );
          }),
    );
  }
}

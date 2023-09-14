import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/wallet/model/model_transactions_history.dart';

///[DialogAcceptReject] this class is used as Dialog Add Money
class DialogAcceptReject extends StatefulWidget {
  const DialogAcceptReject(
      {Key? key, required this.buttonOnTap, required this.mTransaction})
      : super(key: key);

  ///this variable is used for Description og dialog box
  final Function(bool) buttonOnTap;
  final Transaction mTransaction;

  @override
  State<DialogAcceptReject> createState() => _DialogAcceptRejectState();
}

class _DialogAcceptRejectState extends State<DialogAcceptReject> {
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
          widget.buttonOnTap.call(true);
        },
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displayMedium!,
            Dimens.textSize15,
            FontWeight.w500),
        buttonText: APPStrings.textAccept.translate(),
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
          widget.buttonOnTap.call(false);
        },
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.textSize15,
            FontWeight.w500),
        buttonText: APPStrings.textReject.translate(),
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
                          widget.mTransaction.pMode ?? '',
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
                  const SizedBox(height: Dimens.margin20),
                  Text(
                    APPStrings.textRequestingForMoneyInterpolate
                        .translate()
                        .interpolate([
                      '${widget.mTransaction.firstname ?? ''}${widget.mTransaction.firstname != null ? ' ' : ''}${widget.mTransaction.lastname ?? ''}',
                      ((widget.mTransaction.pAmount ?? '').replaceAll('-', ''))
                    ]),
                    textAlign: TextAlign.center,
                    style: getTextStyleFontWeight(
                        Theme.of(context).primaryTextTheme.labelSmall!,
                        Dimens.textSize15,
                        FontWeight.w400),
                  ),
                  const SizedBox(height: Dimens.margin20),
                  if ((widget.mTransaction.description ?? '').isNotEmpty) ...[
                    Text(
                      widget.mTransaction.description ?? '',
                      textAlign: TextAlign.center,
                      style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.labelSmall!,
                          Dimens.textSize15,
                          FontWeight.w400),
                    ),
                    const SizedBox(height: Dimens.margin20),
                  ],
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

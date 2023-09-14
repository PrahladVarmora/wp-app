import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/wallet/bloc/add_money/add_money_bloc.dart';

///[DialogAddMoney] this class is used as Dialog Add Money
class DialogAddMoney extends StatefulWidget {
  const DialogAddMoney({Key? key}) : super(key: key);

  @override
  State<DialogAddMoney> createState() => _DialogAddMoneyState();
}

class _DialogAddMoneyState extends State<DialogAddMoney> {
  TextEditingController amountController = TextEditingController();
  ValueNotifier<String> amountError = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    ///[textAmount] is used for text input of Amount input in screen
    Widget textAmount() {
      return BaseTextFormFieldSuffix(
          controller: amountController,
          isRequired: true,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          // Only numbe// rs can be entered
          fillColor: Theme.of(context).highlightColor,
          keyboardType: TextInputType.number,
          maxLength: 8,
          textInputAction: TextInputAction.next,
          titleText: APPStrings.textAmount.translate(),
          titleStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.labelSmall!,
              Dimens.margin12,
              FontWeight.w400),
          onChange: () {
            if (amountError.value.isNotEmpty) {
              amountError.value = '';
            }
          },
          suffixIcon: Container(
            margin: const EdgeInsets.only(right: Dimens.margin20),
            child: SvgPicture.asset(APPImages.icDollar),
          ),
          errorText: amountError.value,
          hintText: APPStrings.textEnterAmount.translate(),
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w400)
          // hintText: 'Enter First Name',
          );
    }

    /// A function that returns a widget.
    Widget addMoney() {
      return CustomButton(
        height: Dimens.margin50,
        backgroundColor: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
        borderRadius: Dimens.margin15,
        onPress: () {
          validation(context);
        },
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displayMedium!,
            Dimens.textSize15,
            FontWeight.w500),
        buttonText: APPStrings.textAddMoney.translate(),
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
                          APPStrings.textAddMoney.translate(),
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
                  textAmount(),
                  const SizedBox(height: Dimens.margin50),
                  addMoney(),
                  const SizedBox(height: Dimens.margin10),
                ],
              ),
            );
          }),
    );
  }

  void validation(BuildContext context) {
    if (amountController.text.isEmpty) {
      amountError.value = APPStrings.textEnterAmount.translate();
    } else if (double.parse(amountController.text) <= 0) {
      amountError.value = APPStrings.textEnterAmount.translate();
    } else {
      //TODO
      addMoneyEvent(context);
      // Navigator.pop(context);
    }
  }

  void addMoneyEvent(BuildContext context) {
    Map<String, String> mBody = {ApiParams.paramPAmount: amountController.text};
    BlocProvider.of<AddMoneyBloc>(context)
        .add(AddMoney(url: AppUrls.apiAddMoney, body: mBody));
    Navigator.pop(context);
  }
}

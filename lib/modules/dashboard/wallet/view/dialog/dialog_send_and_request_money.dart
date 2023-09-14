import 'package:country_code_picker/country_code_picker.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/wallet/bloc/request_money/request_money_bloc.dart';

///[DialogSendAndRequestMoney] this class is used as Dialog Send And RequestMoney
class DialogSendAndRequestMoney extends StatefulWidget {
  final bool isSend;

  const DialogSendAndRequestMoney({Key? key, required this.isSend})
      : super(key: key);

  @override
  State<DialogSendAndRequestMoney> createState() =>
      _DialogSendAndRequestMoneyState();
}

class _DialogSendAndRequestMoneyState extends State<DialogSendAndRequestMoney> {
  TextEditingController amountController = TextEditingController();

  ValueNotifier<CountryCode> mSelectedCountry =
      ValueNotifier(CountryCode.fromCountryCode('US'));
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  FocusNode amountNumberFocus = FocusNode();
  FocusNode contactNumberFocus = FocusNode();
  FocusNode descriptionNumberFocus = FocusNode();

  ValueNotifier<String> isContactNumberError = ValueNotifier('');
  ValueNotifier<String> amountError = ValueNotifier('');
  ValueNotifier<String> descError = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    ///[textCountry] is used for text input of country name input in screen
    Widget textAmount() {
      return BaseTextFormFieldSuffix(
          controller: amountController,
          focusNode: amountNumberFocus,
          nextFocusNode: contactNumberFocus,
          isRequired: true,
          maxLength: 10,
          fillColor: Theme.of(context).highlightColor,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          keyboardType: const TextInputType.numberWithOptions(
              decimal: false, signed: false),
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
    Widget sendMoney() {
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
        buttonText: widget.isSend
            ? APPStrings.textSendMoney.translate()
            : APPStrings.textSendRequestForMoney.translate(),
      );
    }

    ///[textFieldContactNumber] is used for text input of contact number on this screen
    Widget textFieldContactNumber() {
      return BaseTextFormFieldPrefix(
          controller: contactNumberController,
          focusNode: contactNumberFocus,
          fillColor: Theme.of(context).highlightColor,
          nextFocusNode: descriptionNumberFocus,
          keyboardType: TextInputType.number,
          maxLength: 11,
          textInputAction: TextInputAction.next,
          isRequired: true,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          titleText: APPStrings.textReceiverContactNumber.translate(),
          titleStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.labelSmall!,
              Dimens.margin12,
              FontWeight.w400),
          prefixIcon: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Dimens.margin100),
            child: CountryCodePicker(
              onChanged: (country) {
                _onCountryChange(country);
              },
              dialogSize: const Size.fromHeight(Dimens.margin300),
              searchStyle: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.labelSmall!,
                  Dimens.margin15,
                  FontWeight.w400),
              dialogTextStyle: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.labelSmall!,
                  Dimens.margin15,
                  FontWeight.w400),
              textStyle: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.labelSmall!,
                  Dimens.margin15,
                  FontWeight.w400),
              initialSelection: mSelectedCountry.value.name ?? 'United States',
              favorite: const ['United States'],
              countryFilter: const ['US', 'AU'],
              showCountryOnly: true,
              //  showOnlyCountryWhenClosed: false,
              alignLeft: false,
            ),
          ),
          onChange: () {
            if (isContactNumberError.value.isNotEmpty) {
              isContactNumberError.value = '';
            }
          },
          errorText: isContactNumberError.value,
          hintText: APPStrings.hintEnterContactNumber.translate(),
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w400)
          // hintText: 'Enter First Name',
          );
    }

    ///[textFieldContactNumber] is used for text input of contact number on this screen
    Widget textDescription() {
      return BaseTextFormField(
          controller: descriptionController,
          focusNode: descriptionNumberFocus,
          maxLength: 300,
          maxLine: 10,
          height: 100,
          fillColor: Theme.of(context).highlightColor,
          isRequired: true,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
          titleText: APPStrings.textDescription.translate(),
          titleStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.labelSmall!,
              Dimens.margin12,
              FontWeight.w400),
          onChange: () {
            if (descError.value.isNotEmpty) {
              descError.value = '';
            }
          },
          errorText: descError.value,
          hintText: APPStrings.hintWriteHere.translate(),
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w400)
          // hintText: 'Enter First Name',
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
          valueListenables: [
            amountError,
            mSelectedCountry,
            descError,
            isContactNumberError
          ],
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
                          widget.isSend
                              ? APPStrings.textSendMoney.translate()
                              : APPStrings.textRequestForMoney.translate(),
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
                  const SizedBox(height: Dimens.margin32),
                  textFieldContactNumber(),
                  const SizedBox(height: Dimens.margin32),
                  textDescription(),
                  const SizedBox(height: Dimens.margin20),
                  sendMoney(),
                  const SizedBox(height: Dimens.margin10),
                ],
              ),
            );
          }),
    );
  }

  ///[_onCountryChange] this method is used to display country selector dialog
  void _onCountryChange(CountryCode countryCode) {
    mSelectedCountry.value = countryCode;
    isContactNumberError.value = '';
  }

  void validation(BuildContext context) {
    if (amountController.text.isEmpty) {
      amountError.value = APPStrings.textEnterAmount.translate();
    } else if (mSelectedCountry.value.code == null) {
      isContactNumberError.value =
          APPStrings.warningPleaseChooseCountryCode.translate();
      return;
    } else if (contactNumberController.text.isEmpty) {
      isContactNumberError.value =
          APPStrings.hintEnterContactNumber.translate();
    } else if (contactNumberController.text.trim().length < 9) {
      isContactNumberError.value =
          APPStrings.hintEnterValidContactNumber.translate();
    } else if (descriptionController.text.isEmpty) {
      descError.value =
          '${APPStrings.textDescription.translate()} ${APPStrings.hintWriteHere.translate()}';
    } else {
      sendRequestEvent(context);
    }
  }

  void sendRequestEvent(BuildContext context) {
    Map<String, String> mBody = {
      ApiParams.paramPhoneNo: (mSelectedCountry.value.dialCode ?? '') +
          contactNumberController.text.trim(),
      ApiParams.paramPAmount: amountController.text,
      ApiParams.paramDescription: descriptionController.text,
    };
    Navigator.pop(context);
    BlocProvider.of<SendAndRequestMoneyBloc>(context).add(SendAndRequestMoney(
        url: widget.isSend ? AppUrls.apiSendMoney : AppUrls.apiRequestMoney,
        body: mBody));
  }
}

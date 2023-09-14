import 'package:country_code_picker/country_code_picker.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/bloc/collect_invoice/collect_invoice_bloc.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';

class ScreenAddPartialPayment extends StatefulWidget {
  final JobData mJobData;

  const ScreenAddPartialPayment({Key? key, required this.mJobData})
      : super(key: key);

  @override
  State<ScreenAddPartialPayment> createState() =>
      _ScreenAddPartialPaymentState();
}

class _ScreenAddPartialPaymentState extends State<ScreenAddPartialPayment> {
  TextEditingController amountController = TextEditingController();

  // ValueNotifier<CountryCode> mSelectedCountry = ValueNotifier(CountryCode());
  // TextEditingController contactNumberController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  ValueNotifier<String> amountError = ValueNotifier('');

  // ValueNotifier<String> isContactNumberError = ValueNotifier('');
  // ValueNotifier<String> emailError = ValueNotifier('');
  ValueNotifier<String> isNoteError = ValueNotifier('');

  FocusNode amountFocus = FocusNode();
  ValueNotifier<CountryCode> mSelectedCountry = ValueNotifier(CountryCode());
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  FocusNode contactNumberFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

  ValueNotifier<String> isContactNumberError = ValueNotifier('');
  ValueNotifier<String> emailError = ValueNotifier('');

  // FocusNode contactNumberFocus = FocusNode();
  // FocusNode emailFocus = FocusNode();
  FocusNode noteFocus = FocusNode();
  ValueNotifier<List<ModelCommonSelect>> paymentMethod = ValueNotifier([]);

  ValueNotifier<ModelCommonSelect> selectedPaymentMethod =
      ValueNotifier(ModelCommonSelect());

  ValueNotifier<CountryCode> mSelectedCountryCode =
      ValueNotifier(CountryCode());

  @override
  void initState() {
    paymentMethod.value.addAll(paymentMethodList());

    // emailController.text = widget.mJobData.email ?? '';
    if (widget.mJobData.phoneNumberFormat?.countryCode == '+1' ||
        widget.mJobData.phoneNumberFormat?.countryCode == '1') {
      mSelectedCountryCode.value = CountryCode.fromCountryCode('US');
    } else {
      mSelectedCountryCode.value = CountryCode.fromDialCode(
          widget.mJobData.phoneNumberFormat?.countryCode ?? '');
    }
    contactNumberController.text =
        widget.mJobData.phoneNumberFormat?.number ?? '';
    emailController.text = widget.mJobData.email ?? '';

    /*contactNumberController.text =
        widget.mJobData.phoneNumberFormat?.number ?? '';*/

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// A widget that is used to create a text field for the job name.
    Widget textFieldAmount() {
      return BaseTextFormFieldSuffix(
        controller: amountController,
        focusNode: amountFocus,
        nextFocusNode: amountFocus,
        titleStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.margin12,
            FontWeight.w400),
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textAmount.translate(),
        onChange: () {
          if (amountError.value.isNotEmpty) {
            amountError.value = '';
          }
        },
        keyboardType: TextInputType.number,
        maxLength: 8,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        suffixIcon: Container(
          margin: const EdgeInsets.only(right: Dimens.margin20),
          child: SvgPicture.asset(APPImages.icDollar),
        ),
        fillColor: Theme.of(context).highlightColor,
        errorText: amountError.value,
        hintText: APPStrings.hintEnterAmount.translate(),
        hintStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.margin15,
            FontWeight.w400),
        isRequired: true,
      );
    }

    /* ///[textEmail] is used for text input of Email input in screen
    Widget textEmail() {
      return BaseTextFormFieldSuffix(
          controller: emailController,
          focusNode: emailFocus,
          isRequired: true,
          fillColor: Theme.of(context).highlightColor,
          // Only numbers can be entered
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          titleText: APPStrings.textEmailID.translate(),
          titleStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.labelSmall!,
              Dimens.margin12,
              FontWeight.w400),
          onChange: () {
            if (emailError.value.isNotEmpty) {
              emailError.value = '';
            }
          },
          suffixIcon: Container(
            padding: const EdgeInsets.all(Dimens.margin14),
            child: SvgPicture.asset(
              APPImages.icMail,
            ),
          ),
          errorText: emailError.value,
          hintText: APPStrings.textEmailID.translate(),
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w400)
          // hintText: 'Enter First Name',
          );
    }

    ///[textFieldContactNumber] is used for text input of contact number on this screen
    Widget textFieldContactNumber() {
      return BaseTextFormFieldPrefix(
          controller: contactNumberController,
          focusNode: contactNumberFocus,
          isRequired: true,
          fillColor: Theme.of(context).highlightColor,
          nextFocusNode: emailFocus,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
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
              initialSelection: mSelectedCountryCode.value.code,
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
    }*/

    /// [selectPaymentMethod] This is widget is use for show dropDown Payment Method
    Widget selectPaymentMethod() {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                  text: APPStrings.textPaymentMethod.translate(),
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.labelSmall!,
                      Dimens.textSize12,
                      FontWeight.w400),
                  children: [
                    const TextSpan(text: '  '),
                    TextSpan(
                        text: APPStrings.textAsterisk.translate(),
                        style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.headlineMedium!,
                          Dimens.textSize12,
                          FontWeight.w400,
                        )),
                  ]),
            ),
            const SizedBox(height: Dimens.margin8),
            Container(
              height: Dimens.margin50,
              padding: const EdgeInsets.all(Dimens.margin16),
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.all(Radius.circular(Dimens.margin16)),
                color: Theme.of(context).highlightColor,
              ),
              clipBehavior: Clip.hardEdge,
              child: DropdownButton2<ModelCommonSelect>(
                isExpanded: true,
                isDense: true,
                underline: Container(),
                hint: Text(
                  APPStrings.hingSelectPaymentMethod.translate(),
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.displaySmall!,
                      Dimens.margin16,
                      FontWeight.w400),
                ),
                items: paymentMethod.value.map((value) {
                  return DropdownMenuItem<ModelCommonSelect>(
                    value: value,
                    child: Text(
                      value.title.toString(),
                      style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.labelSmall!,
                          Dimens.margin16,
                          FontWeight.w400),
                    ),
                  );
                }).toList(),
                value: selectedPaymentMethod.value.value != null
                    ? selectedPaymentMethod.value
                    : null,
                onChanged: (newValue) {
                  selectedPaymentMethod.value = newValue!;
                },
              ),
            ),
          ],
        ),
      );
    }

    ///[textFieldContactNumber] is used for text input of contact number on this screen
    Widget textFieldContactNumber() {
      return BaseTextFormFieldPrefix(
          controller: contactNumberController,
          focusNode: contactNumberFocus,
          fillColor: Theme.of(context).highlightColor,
          nextFocusNode: emailFocus,
          keyboardType: TextInputType.number,
          maxLength: 11,
          textInputAction: TextInputAction.next,
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
              initialSelection: 'United States',
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

    ///[textEmail] is used for text input of Email input in screen
    Widget textEmail() {
      return BaseTextFormFieldPrefix(
          controller: emailController,
          focusNode: emailFocus,
          isRequired: false,
          fillColor: Theme.of(context).highlightColor,
          // Only numbers can be entered
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          titleText: APPStrings.textEmailID.translate(),
          titleStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.labelSmall!,
              Dimens.margin12,
              FontWeight.w400),
          onChange: () {
            if (emailError.value.isNotEmpty) {
              emailError.value = '';
            }
          },
          prefixIcon: Container(
            padding: const EdgeInsets.all(Dimens.margin14),
            child: SvgPicture.asset(
              APPImages.icMail,
            ),
          ),
          errorText: emailError.value,
          hintText: APPStrings.textEmailID.translate(),
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w400)
          // hintText: 'Enter First Name',
          );
    }

    /// Creating a text field with the name textFieldNote.
    Widget textFieldNote() {
      return BaseMultiLineTextFormField(
        controller: noteController,
        focusNode: noteFocus,
        hintText: APPStrings.hintWriteHere.translate(),
        maxLines: 5,
        textCapitalization: TextCapitalization.sentences,
        titleStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.margin12,
            FontWeight.w400),
        titleText: APPStrings.textNote.translate(),
        errorText: isNoteError.value,
        onChange: () {
          if (isNoteError.value.isNotEmpty) {
            isNoteError.value = '';
          }
        },
      );
    }

    /// Creating a new class called mBody.
    Widget mBody() {
      return SingleChildScrollView(
        child: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.margin15),
            child: Column(
              children: [
                const SizedBox(height: Dimens.margin20),
                textFieldAmount(),
                const SizedBox(height: Dimens.margin30),
                selectPaymentMethod(),
                const SizedBox(height: Dimens.margin30),
                textFieldContactNumber(),
                const SizedBox(height: Dimens.margin30),
                textEmail(),
                // if (selectedPaymentMethod.value.value == payRequestSMS)
                //   const SizedBox(height: Dimens.margin30),
                // if (selectedPaymentMethod.value.value == payRequestSMS)
                //   textFieldContactNumber(),
                // if (selectedPaymentMethod.value.value == payRequestEmail)
                //   const SizedBox(height: Dimens.margin30),
                // if (selectedPaymentMethod.value.value == payRequestEmail)
                //   textEmail(),
                const SizedBox(height: Dimens.margin30),
                textFieldNote(),
                const SizedBox(height: Dimens.margin40),
              ],
            ),
          ),
        ),
      );
    }

    ///[getAppbar] is used to get Appbar for different views i.e. Mobile
    BaseAppBar getAppbar() {
      return BaseAppBar(
        appBar: AppBar(),
        title: APPStrings.textPayment.translate(),
        mLeftImage: APPImages.icArrowBack,
        textStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.titleLarge!,
            Dimens.textSize15,
            FontWeight.w500),
        backgroundColor: Theme.of(context).colorScheme.primary,
        mLeftAction: () {
          NavigatorKey.navigatorKey.currentState!.pop();
        },
      );
    }

    /// A button to apply Button.
    Widget button() {
      return CustomButton(
        height: Dimens.margin50,
        backgroundColor: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
        borderRadius: Dimens.margin30,
        onPress: () {
          validation();
        },
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displayMedium!,
            Dimens.textSize15,
            FontWeight.w500),
        buttonText: APPStrings.textCollectPayment.translate(),
      );
    }

    return MultiValueListenableBuilder(
        valueListenables: [
          amountError,
          selectedPaymentMethod,
          isNoteError,
        ],
        builder: (context, values, child) {
          return BlocBuilder<CollectInvoiceBloc, CollectInvoiceState>(
            builder: (context, state) {
              return ModalProgressHUD(
                inAsyncCall: state is CollectInvoiceLoading,
                child: Scaffold(
                  appBar: getAppbar(),
                  body: mBody(),
                  bottomNavigationBar: Container(
                    margin: const EdgeInsets.only(
                        bottom: Dimens.margin30,
                        left: Dimens.margin15,
                        right: Dimens.margin15),
                    child: button(),
                  ),
                ),
              );
            },
          );
        });
  }

  /*///[_onCountryChange] this method is used to display country selector dialog
  void _onCountryChange(CountryCode countryCode) {
    mSelectedCountry.value = countryCode;
  }*/

  /// Checking if the input is a number.
  void validation() {
    if (amountController.text.isEmpty) {
      amountError.value = APPStrings.hintEnterAmount.translate();
    } else if (!validateAmount()) {
      ToastController.showToast(
          ValidationString.validationPartialInvoicePayment
              .translate()
              .interpolate([
            double.parse(
                    (double.parse(widget.mJobData.invoice!.first.totalAmount!) -
                            getTotalAmount())
                        .toString())
                .toString()
          ]),
          context,
          false);
    } else if (selectedPaymentMethod.value.value == null) {
      ToastController.showToast(
          APPStrings.hingSelectPaymentMethod.translate(), context, false);
    }
    /* else if (selectedPaymentMethod.value.value == payRequestSMS &&
        contactNumberController.text.isEmpty) {
      isContactNumberError.value =
          APPStrings.hintEnterContactNumber.translate();
    } else if (selectedPaymentMethod.value.value == payRequestSMS &&
        contactNumberController.text
                .toString()
                .trim()
                .replaceAll(' ', '')
                .replaceAll('-', '')
                .replaceAll('(', '')
                .replaceAll(')', '')
                .length <
            9) {
      isContactNumberError.value =
          APPStrings.hintEnterValidContactNumber.translate();
    } else if (selectedPaymentMethod.value.value == payRequestEmail &&
        emailController.text.toString().trim().isEmpty) {
      emailError.value = APPStrings.warningEnterEmailId.translate();
    } else if (selectedPaymentMethod.value.value == payRequestEmail &&
        !EmailValidation.validate(emailController.text.toString().trim())) {
      emailError.value = APPStrings.errorEmail.translate();
    }*/
    else {
      //TODO: Close job
      collectInvoiceEvent();

      // Navigator.pushNamed(context, AppRoutes.routesInvoiceList);
    }
  }

  bool validateAmount() {
    if ((double.parse(amountController.text) + getTotalAmount()) <=
        double.parse(widget.mJobData.invoice!.first.totalAmount ?? '0')) {
      return true;
    } else {
      return false;
    }
  }

  double getTotalAmount() {
    if ((widget.mJobData.invoice ?? []).isNotEmpty &&
        (widget.mJobData.invoice!.first.partials ?? []).isNotEmpty) {
      return widget.mJobData.invoice!.first.partials
              ?.toSet()
              .map((e) => double.tryParse(e.totalAmount ?? '0') ?? 0)
              .toList()
              .reduce((value, element) => value + element) ??
          0;
    } else {
      return 0.0;
    }
  }

  ///[_onCountryChange] this method is used to display country selector dialog
  void _onCountryChange(CountryCode countryCode) {
    mSelectedCountry.value = countryCode;
  }

  void collectInvoiceEvent() {
    Map<String, String> mBody = {
      ApiParams.paramJobId: widget.mJobData.jobId.toString(),
      ApiParams.paramPType: 'Partial',
      ApiParams.paramChargeMethod: selectedPaymentMethod.value.value ?? '',
      ApiParams.paramDescription: noteController.text,
      ApiParams.paramPartialAmount: amountController.text,
      ApiParams.paramEmail: emailController.text,
      ApiParams.paramPhoneNo: (mSelectedCountry.value.dialCode ?? '') +
          contactNumberController.text,
    };
    BlocProvider.of<CollectInvoiceBloc>(context).add(CollectInvoice(
        url: AppUrls.apiCollectInvoicePayment,
        body: mBody,
        mJobData: widget.mJobData,
        isPartial: true));
  }
}

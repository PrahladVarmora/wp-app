import 'package:country_code_picker/country_code_picker.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/bloc/collect_invoice/collect_invoice_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/job_detail_bloc.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';
import 'package:we_pro/modules/job_detail/view/widget/row_partial_payment_added_list.dart';

/// This class is a stateful widget that collect payment a screen
class ScreenCollectPayment extends StatefulWidget {
  final JobData mJobData;

  const ScreenCollectPayment({Key? key, required this.mJobData})
      : super(key: key);

  @override
  State<ScreenCollectPayment> createState() => _ScreenCollectPaymentState();
}

class _ScreenCollectPaymentState extends State<ScreenCollectPayment> {
  ValueNotifier<bool> mLoading = ValueNotifier(false);
  ValueNotifier<JobData> mInvoice = ValueNotifier(JobData());
  ValueNotifier<bool> isPartialSelected = ValueNotifier(false);

  ValueNotifier<String> amountError = ValueNotifier('');

  // ValueNotifier<String> taxError = ValueNotifier('');
  ValueNotifier<String> isNoteError = ValueNotifier('');

  /// Creating a controller for the password text field.
  TextEditingController amountController = TextEditingController();

  // TextEditingController taxController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  ValueNotifier<CountryCode> mSelectedCountry = ValueNotifier(CountryCode());
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  FocusNode contactNumberFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

  ValueNotifier<String> isContactNumberError = ValueNotifier('');
  ValueNotifier<String> emailError = ValueNotifier('');

  /// FocusNode is a class that manages the focus of nodes.
  FocusNode amountFocus = FocusNode();

  // FocusNode taxCostFocus = FocusNode();
  FocusNode noteFocus = FocusNode();

  ValueNotifier<List<ModelCommonSelect>> paymentMethod = ValueNotifier([]);

  ValueNotifier<ModelCommonSelect> selectedPaymentMethod =
      ValueNotifier(ModelCommonSelect());

  ValueNotifier<CountryCode> mSelectedCountryCode =
      ValueNotifier(CountryCode());

  @override
  void initState() {
    mInvoice.value = widget.mJobData;
    paymentMethod.value.addAll(paymentMethodList());
    initData();
    super.initState();
  }

  void initData() {
    if (mInvoice.value.invoice != null &&
        (mInvoice.value.invoice ?? []).isNotEmpty &&
        (mInvoice.value.invoice?.first.partials ?? []).isNotEmpty) {
      isPartialSelected.value = true;
    }
    if (mInvoice.value.phoneNumberFormat?.countryCode == '+1' ||
        widget.mJobData.phoneNumberFormat?.countryCode == '1') {
      mSelectedCountryCode.value = CountryCode.fromCountryCode('US');
    } else {
      mSelectedCountryCode.value = CountryCode.fromDialCode(
          mInvoice.value.phoneNumberFormat?.countryCode ?? '');
    }
    contactNumberController.text =
        mInvoice.value.phoneNumberFormat?.number ?? '';
    emailController.text = mInvoice.value.email ?? '';
    if ((mInvoice.value.invoice ?? []).isNotEmpty) {
      amountController.text = mInvoice.value.invoice?.first.totalAmount ?? '';
    }
    try {
      selectedPaymentMethod.value = paymentMethod.value.firstWhere(
          (element) => element.value == mInvoice.value.invoice?.first.pMethod);
    } catch (e) {
      selectedPaymentMethod.value = ModelCommonSelect();
    }
    // jobDetailEvent();
    /*Future.delayed(const Duration(seconds: 2)).whenComplete(() {

    });*/
  }

  @override
  Widget build(BuildContext context) {
    ///[getAppbar] is used to get Appbar for different views i.e. Mobile
    BaseAppBar getAppbar() {
      return BaseAppBar(
        appBar: AppBar(),
        title: APPStrings.textCollectPayment.translate(),
        mLeftImage: APPImages.icArrowBack,
        backgroundColor: Theme.of(context).colorScheme.primary,
        mLeftAction: () {
          NavigatorKey.navigatorKey.currentState!.pop(mInvoice.value);
        },
      );
    }

/*    ///[textEmail] is used for text input of Email input in screen
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
                  isContactNumberError.value = '';
                  emailError.value = '';
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
          textInputAction: TextInputAction.done,
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
    /*/// [selectStatus] This is widget is use for show dropDown select Status
    Widget selectStatus() {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                  text: APPStrings.textStatus.translate(),
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
              child: DropdownButton2<String>(
                isExpanded: true,
                isDense: true,
                underline: Container(),
                icon: SvgPicture.asset(
                  APPImages.icDropDownArrow,
                  width: Dimens.margin13,
                  height: Dimens.margin11,
                ),
                items: statusType.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: value == APPStrings.hintSelectStatus.translate()
                          ? getTextStyleFontWeight(
                              Theme.of(context).primaryTextTheme.displaySmall!,
                              Dimens.margin16,
                              FontWeight.w400)
                          : getTextStyleFontWeight(
                              Theme.of(context).primaryTextTheme.labelSmall!,
                              Dimens.margin16,
                              FontWeight.w400),
                    ),
                  );
                }).toList(),
                value: selectedStatusType.value,
                onChanged: (newValue) {
                  selectedStatusType.value = newValue!;
                },
              ),
            ),
          ],
        ),
      );
    }*/

    /// A widget that is used to create a text field for the job name.
    Widget textFieldAmount() {
      return BaseTextFormFieldSuffix(
        enabled: (mInvoice.value.invoice ?? []).isEmpty,
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

    /*/// Creating a text field with the name textFieldTax.
    Widget textFieldTax() {
      return BaseTextFormFieldSuffix(
        controller: taxController,
        focusNode: taxCostFocus,
        nextFocusNode: noteFocus,
        titleStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.margin12,
            FontWeight.w400),
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textTax.translate(),
        suffixIcon: Container(
          margin: const EdgeInsets.only(right: Dimens.margin20),
          child: SvgPicture.asset(APPImages.icDollarBold),
        ),
        fillColor: Theme.of(context).colorScheme.onSurfaceVariant,
        onChange: () {
          if (taxError.value.isNotEmpty) {
            taxError.value = '';
          }
        },
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        errorText: taxError.value,
        enabled: false,
        hintText: setCurrency('100'),
        hintStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.margin15,
            FontWeight.w400),
        isRequired: false,
      );
    }*/

    /// Creating a text field with the name textFieldNote.
    Widget textFieldNote() {
      return BaseMultiLineTextFormField(
        controller: noteController,
        focusNode: noteFocus,
        hintText: APPStrings.hintWriteHere.translate(),
        maxLines: 5,
        textInputAction: TextInputAction.done,
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

    /// A button to apply Button.
    Widget button() {
      return Opacity(
        opacity: checkPayment() ? 1 : 0.6,
        child: CustomButton(
          height: Dimens.margin50,
          backgroundColor: Theme.of(context).primaryColor,
          borderColor: Theme.of(context).primaryColor,
          borderRadius: Dimens.margin30,
          onPress: checkPayment()
              ? () {
                  /*Navigator.pushNamed(context, AppRoutes.routesPartialPaymentStatus,
                arguments: mInvoice.value);*/
                  validation();
                }
              : null,
          style: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displayMedium!,
              Dimens.textSize15,
              FontWeight.w500),
          buttonText: APPStrings.textPaymentReceive.translate(),
        ),
      );
    }

    /// Creating a new class called mBody.
    Widget mBody() {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.margin15),
          child: Column(
            children: [
              const SizedBox(height: Dimens.margin20),
              textFieldAmount(),
              if ((mInvoice.value.invoice ?? []).isNotEmpty)
                const SizedBox(height: Dimens.margin30),
              if ((mInvoice.value.invoice ?? []).isNotEmpty)
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        height: Dimens.margin50,
                        backgroundColor: !isPartialSelected.value
                            ? Theme.of(context).colorScheme.surfaceTint
                            : Theme.of(context).highlightColor,
                        buttonText: APPStrings.textFullPayment.translate(),
                        style: getTextStyleFontWeight(
                            !isPartialSelected.value
                                ? Theme.of(context).primaryTextTheme.labelSmall!
                                : Theme.of(context)
                                    .primaryTextTheme
                                    .displaySmall!,
                            Dimens.margin15,
                            FontWeight.w400),
                        borderRadius: Dimens.margin15_5,
                        onPress: () {
                          isPartialSelected.value = false;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: Dimens.margin10,
                    ),
                    Expanded(
                      child: CustomButton(
                        height: Dimens.margin50,
                        backgroundColor: isPartialSelected.value
                            ? Theme.of(context).colorScheme.surfaceTint
                            : Theme.of(context).highlightColor,
                        buttonText: APPStrings.textPartialPayment.translate(),
                        style: getTextStyleFontWeight(
                            isPartialSelected.value
                                ? Theme.of(context).primaryTextTheme.labelSmall!
                                : Theme.of(context)
                                    .primaryTextTheme
                                    .displaySmall!,
                            Dimens.margin15,
                            FontWeight.w400),
                        borderRadius: Dimens.margin15_5,
                        onPress: () {
                          isPartialSelected.value = true;
                        },
                      ),
                    )
                  ],
                ),
              // const SizedBox(height: Dimens.margin30),
              // textFieldTax(),

              const SizedBox(height: Dimens.margin30),
              if (!isPartialSelected.value) ...[
                selectPaymentMethod(),
                const SizedBox(height: Dimens.margin30),
                textFieldContactNumber(),
                const SizedBox(height: Dimens.margin30),
                textEmail(),
                const SizedBox(height: Dimens.margin30),
                textFieldNote(),
                const SizedBox(height: Dimens.margin40),
              ] else ...[
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                            context, AppRoutes.routesAddPartialPayment,
                            arguments: mInvoice.value)
                        .then((value) {
                      jobDetailEvent();
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        APPStrings.textMakePayment.translate(),
                        style: getTextStyleFontWeight(
                            Theme.of(context).textTheme.bodyLarge!,
                            Dimens.textSize14,
                            FontWeight.w400),
                      ),
                      SvgPicture.asset(
                        APPImages.icArrowRight,
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.onTertiary,
                            BlendMode.srcIn),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: Dimens.margin30),
                ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: (mInvoice.value.invoice ?? []).isNotEmpty
                      ? (mInvoice.value.invoice?.first.partials ?? []).length
                      : 0,
                  itemBuilder: (context, index) {
                    return RowPartialPaymentAddedList(
                      invoiceList:
                          (mInvoice.value.invoice?.first.partials ?? [])[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: Dimens.margin20);
                  },
                ),
              ]
            ],
          ),
        ),
      );
    }

    return MultiValueListenableBuilder(
      valueListenables: [
        mLoading,
        mInvoice,
        amountError,
        isPartialSelected,
        mSelectedCountry,
        isContactNumberError,
        emailError,
        isNoteError,
        selectedPaymentMethod,
        paymentMethod,
      ],
      builder: (BuildContext context, List<dynamic> values, Widget? child) {
        return MultiBlocListener(
          listeners: [
            BlocListener<CollectInvoiceBloc, CollectInvoiceState>(
              listener: (context, state) {
                mLoading.value = state is CollectInvoiceLoading;
              },
            ),
            BlocListener<JobDetailBloc, JobDetailState>(
              listener: (context, state) {
                mLoading.value = state is JobDetailLoading;
                if (state is JobDetailResponse) {
                  if ((state.mModelJobDetail.jobData ?? []).isNotEmpty) {
                    if (mInvoice.value !=
                        state.mModelJobDetail.jobData!.first) {
                      mInvoice.value = state.mModelJobDetail.jobData!.first;
                      initData();
                    }
                  }
                }
              },
            ),
          ],
          child: ModalProgressHUD(
            inAsyncCall: mLoading.value,
            child: RefreshIndicator(
              onRefresh: () async {
                jobDetailEvent();
              },
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanDown: (_) {
                  FocusScope.of(context).unfocus();
                },
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Scaffold(
                  appBar: getAppbar(),
                  backgroundColor: Theme.of(context).colorScheme.background,
                  body: mBody(),
                  bottomNavigationBar: Container(
                    margin: const EdgeInsets.only(
                        bottom: Dimens.margin30,
                        left: Dimens.margin15,
                        right: Dimens.margin15),
                    child: button(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool checkPayment() {
    if (!isPartialSelected.value) {
      return !isPartialSelected.value;
    } else {
      try {
        return (((mInvoice.value.invoice?.first.partials
                    ?.every((element) => element.status == 'Paid') ??
                false) &&
            (mInvoice.value.invoice?.first.partials
                    ?.toSet()
                    .map((e) => double.parse(e.totalAmount ?? '0.0'))
                    .reduce((value, element) => value + element)) ==
                double.parse(
                    mInvoice.value.invoice?.first.totalAmount ?? '0')));
      } catch (e) {
        return false;
      }
    }
  }

  /// Checking if the input is a number.
  void validation() {
    // if (amountController.text.isEmpty) {
    //   amountError.value = APPStrings.hintEnterAmount.translate();
    // }
    // printWrapped('isAvailabilitySelected.value---${isPartialSelected.value}');

    if (!isPartialSelected.value) {
      if (amountController.text.isEmpty) {
        amountError.value = APPStrings.hintEnterAmount.translate();
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
        collectInvoiceEvent();
        // Navigator.pushNamed(context, AppRoutes.routesPaymentSuccessfully);

        // Navigator.pushNamed(context, AppRoutes.routesInvoiceList);
      }
    } else {
      if (amountController.text.isEmpty) {
        amountError.value = APPStrings.hintEnterAmount.translate();
      } else {
        // collectInvoiceEvent();
        Navigator.pushNamed(context, AppRoutes.routesPaymentSuccessfully,
            arguments: mInvoice.value);
      }
    }
  }

  void collectInvoiceEvent() {
    Map<String, String> mBody = {
      ApiParams.paramJobId: mInvoice.value.jobId.toString(),
      ApiParams.paramPType: isPartialSelected.value ? 'Partial' : 'Full',
      ApiParams.paramChargeMethod: selectedPaymentMethod.value.value ?? '',
      ApiParams.paramDescription: noteController.text,
      ApiParams.paramTotalAmount: amountController.text,
      ApiParams.paramEmail: emailController.text,
      ApiParams.paramPhoneNo: (mSelectedCountry.value.dialCode ?? '') +
          contactNumberController.text,
    };
    BlocProvider.of<CollectInvoiceBloc>(context).add(CollectInvoice(
        url: AppUrls.apiCollectInvoicePayment,
        body: mBody,
        mJobData: mInvoice.value));
  }

  /*///[_onCountryChange] this method is used to display country selector dialog
  void _onCountryChange(CountryCode countryCode) {
    mSelectedCountry.value = countryCode;
  }
*/

  ///[_onCountryChange] this method is used to display country selector dialog
  void _onCountryChange(CountryCode countryCode) {
    mSelectedCountry.value = countryCode;
    printWrapped("New Country selected: $countryCode");
  }

  ///[jobDetailEvent] this method is used to connect to job detail
  void jobDetailEvent() async {
    Map<String, dynamic> mBody = {
      ApiParams.paramJobId: mInvoice.value.jobId,
      ApiParams.paramLatitude:
          MyAppState.mCurrentPosition.value.latitude.toString(),
      ApiParams.paramLongitude:
          MyAppState.mCurrentPosition.value.longitude.toString()
    };
    BlocProvider.of<JobDetailBloc>(context).add(JobDetail(
      body: mBody,
      url: AppUrls.apiJobs,
    ));
  }

  @override
  void dispose() {
    amountController.text = "";
    super.dispose();
  }
}

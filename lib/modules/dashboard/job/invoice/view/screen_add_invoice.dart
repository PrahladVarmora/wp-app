import 'package:we_pro/modules/dashboard/bloc/add_invoice/add_invoice_bloc.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';

import '../../../../core/utils/core_import.dart';

/// A screen that allows the user to add an invoice.
class ScreenAddInvoice extends StatefulWidget {
  final JobData mJobData;
  final bool isEdit;

  const ScreenAddInvoice(
      {Key? key, required this.mJobData, this.isEdit = false})
      : super(key: key);

  @override
  State<ScreenAddInvoice> createState() => _ScreenAddInvoiceState();
}

class _ScreenAddInvoiceState extends State<ScreenAddInvoice> {
  ValueNotifier<bool> mLoading = ValueNotifier(false);

  ValueNotifier<String> amountError = ValueNotifier('');
  ValueNotifier<String> paymentMethodError = ValueNotifier('');
  ValueNotifier<String> sendInvoiceTypeError = ValueNotifier('');

  ValueNotifier<String> descriptionError = ValueNotifier('');

  /// Creating a controller for the password text field.
  TextEditingController amountController = TextEditingController();
  TextEditingController technicalCostController = TextEditingController();
  TextEditingController companyCostController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  /// FocusNode is a class that manages the focus of nodes.
  FocusNode amountFocus = FocusNode();
  FocusNode technicalCostFocus = FocusNode();
  FocusNode companyCostFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  /*List<ModelCommonSelect> paymentMethod = [
    ModelCommonSelect(title: 'Cash', value: 'Cash'),
    ModelCommonSelect(title: 'Cheque', value: 'Cheque'),
    ModelCommonSelect(title: 'Charge Now', value: 'Charge_Now'),
    ModelCommonSelect(title: 'SMS', value: 'Request_SMS'),
    ModelCommonSelect(title: 'Email', value: 'Request_Email')
  ];*/
  List<ModelCommonSelect> paymentMethod = [];
  List<ModelCommonSelect> sendInvoiceType = [];

  /*List<ModelCommonSelect> sendInvoiceType = [
    ModelCommonSelect(title: 'Email', value: 'Email'),
    ModelCommonSelect(title: 'Phone', value: 'Phone'),
    ModelCommonSelect(title: 'Email and Phone', value: 'Both')
  ];*/

  ValueNotifier<ModelCommonSelect> selectedPaymentMethod =
      ValueNotifier(ModelCommonSelect());
  ValueNotifier<ModelCommonSelect> selectedSendInvoice =
      ValueNotifier(ModelCommonSelect());
  TextEditingController dueDateController = TextEditingController();
  ValueNotifier<String> isStartTimeError = ValueNotifier('');

  DateTime? dueDate;

  @override
  void initState() {
    paymentMethod.addAll(paymentMethodListForInvoice());
    sendInvoiceType.addAll(sendInvoiceTypeList());
    selectedSendInvoice.value = sendInvoiceType.first;
    if (widget.isEdit) {
      setEditData();
    }
    super.initState();
  }

  void setEditData() {
    amountController.text =
        double.parse(widget.mJobData.invoice?.first.totalAmount ?? '0')
            .toStringAsFixed(0);
    try {
      selectedPaymentMethod.value = paymentMethod.firstWhere(
          (element) => element.value == widget.mJobData.invoice?.first.pMethod);
    } catch (e) {
      selectedPaymentMethod.value = ModelCommonSelect();
    }
    selectedSendInvoice.value = sendInvoiceType.firstWhere(
        (element) => element.value == widget.mJobData.invoice?.first.sendType);
    if (widget.mJobData.invoice?.first.dueDate != null) {
      dueDate = convertStringToDateFormat(
          widget.mJobData.invoice?.first.dueDate ?? '',
          AppConfig.dateFormatYYYYMMDD);
      dueDateController.text = formatOnlyDate(
          formatDate(dueDate, AppConfig.dateFormatDDMMYYYYHHMMSS));
    }
    descriptionController.text =
        widget.mJobData.invoice?.first.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    ///[getAppbar] is used to get Appbar for different views i.e. Mobile
    BaseAppBar getAppbar() {
      return BaseAppBar(
        appBar: AppBar(),
        title: (widget.isEdit
                ? APPStrings.textEditInvoice
                : APPStrings.textAddInvoice)
            .translate(),
        mLeftImage: APPImages.icArrowBack,
        mLeftAction: () {
          Navigator.pop(context);
        },
      );
    }

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
                items: paymentMethod.map((value) {
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
                  if (newValue != null) {
                    paymentMethodError.value = '';
                    selectedPaymentMethod.value = newValue;
                  }
                },
              ),
            ),
            if (paymentMethodError.value.isNotEmpty) ...[
              const SizedBox(height: Dimens.margin8),
              BaseTextFieldErrorIndicator(errorText: paymentMethodError.value)
            ]
          ],
        ),
      );
    }

    Widget selectSendInvoiceType() {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                  text: APPStrings.textSendInvoice.translate(),
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
                hint: Text(APPStrings.hintSelectSendInvoiceType.translate(),
                    style: getTextStyleFontWeight(
                        Theme.of(context).primaryTextTheme.displaySmall!,
                        Dimens.margin16,
                        FontWeight.w400)),
                items: sendInvoiceType.map((value) {
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
                value: selectedSendInvoice.value.value != null
                    ? selectedSendInvoice.value
                    : null,
                onChanged: (newValue) {
                  if (newValue != null) {
                    sendInvoiceTypeError.value = '';
                    selectedSendInvoice.value = newValue;
                  }
                },
              ),
            ),
            if (sendInvoiceTypeError.value.isNotEmpty) ...[
              const SizedBox(height: Dimens.margin8),
              BaseTextFieldErrorIndicator(errorText: sendInvoiceTypeError.value)
            ]
          ],
        ),
      );
    }

    Widget selectDueDate() {
      return InkWell(
        onTap: () {
          _pickDate();
        },
        child: BaseTextFormFieldSuffix(
            controller: dueDateController,
            enabled: false,
            textInputAction: TextInputAction.next,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: Dimens.margin16),
              child: SvgPicture.asset(
                APPImages.icCalendar,
              ),
            ),
            fillColor: Theme.of(context).highlightColor,
            titleText: APPStrings.textDueDate.translate(),
            titleStyle: getTextStyleFontWeight(
                Theme.of(context).primaryTextTheme.labelSmall!,
                Dimens.margin12,
                FontWeight.w400),
            errorText: isStartTimeError.value,
            hintText: APPStrings.textSelectDate.translate(),
            hintStyle: getTextStyleFontWeight(
                Theme.of(context).primaryTextTheme.displaySmall!,
                Dimens.margin14,
                FontWeight.w400)),
      );
    }

    /// This function likely returns a widget for a text field description in a Dart
    /// application.
    Widget textFieldDescription() {
      return BaseMultiLineTextFormField(
        controller: descriptionController,
        focusNode: descriptionFocus,
        errorText: descriptionError.value,
        onChange: () {
          descriptionError.value = '';
        },
        titleText: APPStrings.textDescription.translate(),
        hintText: APPStrings.hintWriteHere.translate(),
        maxLines: 5,
      );
    }

    /// A widget that is used to create a text field for the job name.
    Widget textFieldAmount() {
      return BaseTextFormFieldSuffix(
        // enabled: !widget.isEdit,
        controller: amountController,
        focusNode: amountFocus,
        nextFocusNode: technicalCostFocus,
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

    /// A button to apply Button.
    Widget button() {
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
        buttonText: APPStrings.textAdd.translate(),
      );
    }

    /// Creating a new class called mBody.
    Widget mBody() {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.margin15),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (_) {
              FocusScope.of(context).unfocus();
            },
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                const SizedBox(height: Dimens.margin20),
                textFieldAmount(),
                const SizedBox(height: Dimens.margin30),
                selectPaymentMethod(),
                const SizedBox(height: Dimens.margin30),
                selectSendInvoiceType(),
                const SizedBox(height: Dimens.margin30),
                selectDueDate(),
                const SizedBox(height: Dimens.margin30),
                textFieldDescription(),
                const SizedBox(height: Dimens.margin30),

                //TODO: Hidden
                /*...[
                  selectStatus(),
                  const SizedBox(height: Dimens.margin30),
                  textFieldTechnicalCost(),
                  const SizedBox(height: Dimens.margin30),
                  textFieldCompanyCost(),
                  const SizedBox(height: Dimens.margin30),
                ]*/
              ],
            ),
          ),
        ),
      );
    }

    return MultiValueListenableBuilder(
      valueListenables: [
        mLoading,
        amountError,
        paymentMethodError,
        sendInvoiceTypeError,
        descriptionError,
        selectedPaymentMethod,
        selectedSendInvoice,
        selectedPaymentMethod,
      ],
      builder: (BuildContext context, List<dynamic> values, Widget? child) {
        return BlocBuilder<AddInvoiceBloc, AddInvoiceState>(
          builder: (context, state) {
            return ModalProgressHUD(
              inAsyncCall: state is AddInvoiceLoading,
              progressIndicator: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
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
            );
          },
        );
      },
    );
  }

  /// Checking if the input is a number.
  void validation(BuildContext context) {
    if (amountController.text.isEmpty) {
      amountError.value = APPStrings.hintEnterAmount.translate();
    }
    if (selectedPaymentMethod.value.value == null) {
      paymentMethodError.value = APPStrings.hingSelectPaymentMethod.translate();
    }
    if (selectedSendInvoice.value.value == null) {
      sendInvoiceTypeError.value =
          APPStrings.hintSelectSendInvoiceType.translate();
    }
    if (amountController.text.isNotEmpty &&
        selectedPaymentMethod.value.value != null &&
        selectedSendInvoice.value.value != null) {
      // Navigator.pop(context);
      addInvoiceEvent(context);
    }
  }

  void addInvoiceEvent(BuildContext context) {
    Map<String, String> mBody = {
      ApiParams.paramJobId: widget.mJobData.jobId ?? '',
      ApiParams.paramTotalAmount: amountController.text,
      ApiParams.paramPMethod: selectedPaymentMethod.value.value ?? '',
      ApiParams.paramJobUpdateStatus: 'Unpaid',
      ApiParams.paramSendType: selectedSendInvoice.value.value ?? '',
      ApiParams.paramDescription: descriptionController.text,
    };

    if (dueDate != null) {
      mBody[ApiParams.paramDueDate] =
          formatDate(dueDate, AppConfig.dateFormatYYYYMMDD);
    }

    if (widget.isEdit) {
      mBody[ApiParams.paramInvId] = widget.mJobData.invoice?.first.id ?? '';
      BlocProvider.of<AddInvoiceBloc>(context)
          .add(UpdateInvoice(url: AppUrls.apiAddInvoiceApi, body: mBody));
    } else {
      BlocProvider.of<AddInvoiceBloc>(context)
          .add(AddInvoice(url: AppUrls.apiAddInvoiceApi, body: mBody));
    }
  }

  ///[_pickDate] this method use to Android, iOS and web date picker
  void _pickDate() async {
    FocusScope.of(context).requestFocus(FocusNode());

    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      initialDate: dueDate ?? DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: MyAppState.themeChangeValue
                ? AppColors.colorPrimary
                : AppColors.colorWhite,
            colorScheme: ColorScheme.light(
              primary: AppColors.colorPrimary,
              onPrimary: AppColors.colorWhite,
              onSurface: MyAppState.themeChangeValue
                  ? AppColors.colorWhite
                  : AppColors.colorPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: MyAppState.themeChangeValue
                    ? AppColors.colorWhite
                    : AppColors.colorPrimary, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setDate(date);
    }
  }

  ///[setDate] this method use to set date is per the picker status
  void setDate(DateTime setDate) {
    dueDate = setDate;
    dueDateController.text =
        formatOnlyDate(formatDate(setDate, AppConfig.dateFormatDDMMYYYYHHMMSS));
  }
}

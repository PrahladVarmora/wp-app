import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/wallet/model/model_transactions_filter.dart';

/// This class is a stateful widget that creates a bottom sheet that allows the user to filter the
/// wallets displayed in the wallet list
class BottomSheetWalletFilter extends StatefulWidget {
  final ModelTransactionsFilter mModelTransactionsFilter;
  final Function(ModelTransactionsFilter) onApply;
  final Function onReset;

  const BottomSheetWalletFilter(
      {Key? key,
      required this.mModelTransactionsFilter,
      required this.onApply,
      required this.onReset})
      : super(key: key);

  @override
  State<BottomSheetWalletFilter> createState() =>
      _BottomSheetWalletFilterState();
}

class _BottomSheetWalletFilterState extends State<BottomSheetWalletFilter> {
  ValueNotifier<String> isStartTimeError = ValueNotifier('');
  ValueNotifier<String> isEndTimeError = ValueNotifier('');
  ValueNotifier<int> mPaymentType = ValueNotifier(0);

  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  FocusNode startTimeFocus = FocusNode();
  FocusNode endTimeFocus = FocusNode();

  DateTime? startDate;
  DateTime? endDate;

  ValueNotifier<String> selectedPaymentTypeNotifier = ValueNotifier('');

  // ValueNotifier<String> isSelectSourceError = ValueNotifier('');

  // ValueNotifier<ModelTransactionsFilter> mFilterData =
  //     ValueNotifier(ModelTransactionsFilter());

  List<String> paymentType = [
    'Credited',
    'Debited',
  ];

  @override
  void initState() {
    if ((widget.mModelTransactionsFilter.paymentType ?? '').isNotEmpty) {
      selectedPaymentTypeNotifier.value =
          widget.mModelTransactionsFilter.paymentType ?? '';
    }
    if ((widget.mModelTransactionsFilter.fromDate ?? '').isNotEmpty) {
      startDate = convertStringToDateFormat(
          widget.mModelTransactionsFilter.fromDate ?? '',
          AppConfig.dateFormatYYYYMMDD);
      startTimeController.text = formatOnlyDate(
          formatDate(startDate, AppConfig.dateFormatDDMMYYYYHHMMSS));
    }
    if ((widget.mModelTransactionsFilter.toDate ?? '').isNotEmpty) {
      endDate = convertStringToDateFormat(
          widget.mModelTransactionsFilter.toDate ?? '',
          AppConfig.dateFormatYYYYMMDD);
      endTimeController.text = formatOnlyDate(
          formatDate(endDate, AppConfig.dateFormatDDMMYYYYHHMMSS));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///[startTime] is used for text input of date of start Time input in screen
    Widget startTime() {
      return InkWell(
        onTap: () {
          _pickDate(true);
        },
        child: BaseTextFormFieldSuffix(
            controller: startTimeController,
            focusNode: startTimeFocus,
            nextFocusNode: endTimeFocus,
            enabled: false,
            isRequired: true,
            textInputAction: TextInputAction.next,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: Dimens.margin16),
              child: SvgPicture.asset(
                APPImages.icCalendar,
              ),
            ),
            fillColor: Theme.of(context).highlightColor,
            titleText: APPStrings.textFromDate.translate(),
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

    ///[endTime] is used for text input of date of start Time input in screen
    Widget endTime() {
      return InkWell(
        onTap: () {
          _pickDate(false);
        },
        child: BaseTextFormFieldSuffix(
            controller: endTimeController,
            focusNode: endTimeFocus,
            nextFocusNode: endTimeFocus,
            enabled: false,
            fillColor: Theme.of(context).highlightColor,
            isRequired: true,
            textInputAction: TextInputAction.next,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: Dimens.margin16),
              child: SvgPicture.asset(
                APPImages.icCalendar,
              ),
            ),
            titleStyle: getTextStyleFontWeight(
                Theme.of(context).primaryTextTheme.labelSmall!,
                Dimens.margin12,
                FontWeight.w400),
            titleText: APPStrings.textToDate.translate(),
            errorText: isEndTimeError.value,
            hintText: APPStrings.textSelectDate.translate(),
            hintStyle: getTextStyleFontWeight(
                Theme.of(context).primaryTextTheme.displaySmall!,
                Dimens.margin14,
                FontWeight.w400)),
      );
    }

    /// A button to apply Button.
    Widget applyButton() {
      return Expanded(
        child: CustomButton(
          style: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displayLarge!,
              Dimens.textSize15,
              FontWeight.w500),
          height: Dimens.margin40,
          borderRadius: Dimens.margin30,
          backgroundColor: Theme.of(context).primaryColor,
          borderColor: Theme.of(context).primaryColor,
          onPress: () {
            var isValid = true;
            if (startTimeController.text.isEmpty) {
              isStartTimeError.value = "Please select Start Time";
              isValid = false;
            } else if (endTimeController.text.isEmpty) {
              isEndTimeError.value = "Please select End Time";
              isValid = false;
            } else if (selectedPaymentTypeNotifier.value.isEmpty) {
              ToastController.showToast(
                  "Please select Payment type.", context, false);
              isValid = false;
            }
            if (isValid) {
              onApply();
            }
          },
          buttonText: APPStrings.textApply.translate(),
        ),
      );
    }

    /// It returns a widget that is a button that resets the filter.
    Widget resetFilterButton() {
      return Expanded(
        child: CustomButton(
          borderRadius: Dimens.margin30,
          height: Dimens.margin40,
          borderColor: Theme.of(context).colorScheme.inverseSurface,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          style: getTextStyleFontWeight(Theme.of(context).textTheme.titleLarge!,
              Dimens.textSize15, FontWeight.w500),
          onPress: () {
            widget.onReset();
          },
          buttonText: APPStrings.textRestFilter.translate(),
        ),
      );
    }

    return MultiValueListenableBuilder(
        valueListenables: [
          isEndTimeError,
          mPaymentType,
          isStartTimeError,
          selectedPaymentTypeNotifier,
        ],
        builder: (context, values, Widget? child) {
          return Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimens.margin30),
                    topRight: Radius.circular(Dimens.margin30))),
            padding: const EdgeInsets.symmetric(horizontal: Dimens.margin15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: Dimens.margin33,
                ),
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        APPStrings.textFilter.translate(),
                        style: getTextStyleFontWeight(
                            Theme.of(context).primaryTextTheme.labelSmall!,
                            Dimens.textSize18,
                            FontWeight.w600),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: Dimens.margin20),
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
                const SizedBox(
                  height: Dimens.margin32,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: startTime()),
                    const SizedBox(
                      width: Dimens.margin10,
                    ),
                    Expanded(child: endTime()),
                  ],
                ),
                const SizedBox(height: Dimens.margin32),
                /*   Container(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                      text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: APPStrings.textPaymentType.translate(),
                        style: getTextStyleFontWeight(
                            Theme.of(context).primaryTextTheme.labelSmall!,
                            Dimens.margin12,
                            FontWeight.w400),
                      ),
                      const TextSpan(text: '  '),
                      TextSpan(
                        text: '*',
                        style: getTextStyleFontWeight(
                            Theme.of(context).primaryTextTheme.headlineMedium!,
                            Dimens.margin15,
                            FontWeight.normal),
                      )
                    ],
                  )),
                ),
                const SizedBox(
                  height: Dimens.margin11,
                ),*/
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                            text: APPStrings.textPaymentType.translate(),
                            style: getTextStyleFontWeight(
                                Theme.of(context).primaryTextTheme.labelSmall!,
                                Dimens.margin12,
                                FontWeight.w400),
                            children: [
                              const TextSpan(text: '  '),
                              TextSpan(
                                  text: APPStrings.textAsterisk.translate(),
                                  style: getTextStyleFontWeight(
                                      Theme.of(context)
                                          .primaryTextTheme
                                          .headlineMedium!,
                                      Dimens.margin15,
                                      FontWeight.normal)),
                            ]),
                      ),
                      const SizedBox(height: Dimens.margin8),
                      Container(
                        height: Dimens.margin50,
                        padding: const EdgeInsets.all(Dimens.margin16),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                              Radius.circular(Dimens.margin16)),
                          color: Theme.of(context).highlightColor,
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          isDense: true,
                          underline: Container(),
                          hint: Text(
                            APPStrings.textSelectPaymentType.translate(),
                            style: getTextStyleFontWeight(
                                Theme.of(context)
                                    .primaryTextTheme
                                    .displaySmall!,
                                Dimens.margin16,
                                FontWeight.w400),
                          ),
                          items: paymentType.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: getTextStyleFontWeight(
                                    Theme.of(context)
                                        .primaryTextTheme
                                        .labelSmall!,
                                    Dimens.margin16,
                                    FontWeight.w400),
                              ),
                            );
                          }).toList(),
                          value: selectedPaymentTypeNotifier.value.isNotEmpty
                              ? selectedPaymentTypeNotifier.value
                              : null,
                          onChanged: (newValue) {
                            selectedPaymentTypeNotifier.value = newValue!;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: Dimens.margin32,
                ),
                Row(
                  children: [
                    resetFilterButton(),
                    const SizedBox(width: Dimens.margin16),
                    applyButton(),
                  ],
                ),
                const SizedBox(
                  height: Dimens.margin32,
                ),
              ],
            ),
          );
        });
  }

  ///[_pickDate] this method use to Android, iOS and web date picker
  void _pickDate(bool isStart) async {
    FocusScope.of(context).requestFocus(FocusNode());

    DateTime? date = await showDatePicker(
      context: context,
      firstDate: isStart
          ? DateTime.now().subtract(const Duration(days: 180))
          : (startDate ?? DateTime.now()),
      lastDate: DateTime.now(),
      initialDate: (isStart ? startDate : endDate) ?? DateTime.now(),
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
    setDate(date!, isStart);
  }

  ///[setDate] this method use to set date is per the picker status
  void setDate(DateTime setDate, bool isStart) {
    if (isStart) {
      startDate = setDate;
      // endDate = DateTime.now();
      endTimeController.text = '';
      // startTimeController.text =
      //     formatDate(setDate, AppConfig.dateFormatYYYYMMDD);
      startTimeController.text = formatOnlyDate(
          formatDate(setDate, AppConfig.dateFormatDDMMYYYYHHMMSS));
      isStartTimeError.value = "";
    } else {
      endDate = setDate;
      // endTimeController.text =
      //     formatDate(setDate, AppConfig.dateFormatYYYYMMDD);
      endTimeController.text = formatOnlyDate(
          formatDate(setDate, AppConfig.dateFormatDDMMYYYYHHMMSS));
      isEndTimeError.value = "";
    }
    setState(() {});
  }

  void onApply() {
    ModelTransactionsFilter mFilterData = ModelTransactionsFilter();
    mFilterData.paymentType = selectedPaymentTypeNotifier.value;
    if (startDate != null) {
      mFilterData.fromDate =
          formatDate(startDate, AppConfig.dateFormatYYYYMMDD);
    }
    if (endDate != null) {
      mFilterData.toDate = formatDate(endDate, AppConfig.dateFormatYYYYMMDD);
    }
    widget.onApply(mFilterData);
  }
}

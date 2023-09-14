import 'package:flutter/cupertino.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/bloc/sub_status_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/update_dispatcher/update_dispatcher_bloc.dart';
import 'package:we_pro/modules/dashboard/job/model/model_sub_status.dart';
import 'package:we_pro/modules/masters/model/model_get_status.dart';

/// This class is a stateful widget that displays a list of jobs that the user has
/// applied to.
class ScreenSendJobUpdates extends StatefulWidget {
  final String jobId;

  const ScreenSendJobUpdates({Key? key, required this.jobId}) : super(key: key);

  @override
  State<ScreenSendJobUpdates> createState() => _ScreenSendJobUpdatesState();
}

class _ScreenSendJobUpdatesState extends State<ScreenSendJobUpdates> {
  ValueNotifier<bool> mLoading = ValueNotifier(false);

  ValueNotifier<List<JobStatus>> mReasonList = ValueNotifier([]);
  ValueNotifier<JobStatus> selectedReason = ValueNotifier(JobStatus());
  ValueNotifier<List<SubStatusData>> mStatusList = ValueNotifier([]);
  ValueNotifier<SubStatusData> selectedStatus =
      ValueNotifier<SubStatusData>(SubStatusData());
  TextEditingController requestDateController = TextEditingController();
  TextEditingController requestTimeController = TextEditingController();

  TextEditingController noteController = TextEditingController();
  ValueNotifier<String> isNoteError = ValueNotifier('');
  ValueNotifier<String> isReasonError = ValueNotifier('');
  ValueNotifier<String> isSubStatusError = ValueNotifier('');
  ValueNotifier<String> requestDateError = ValueNotifier('');
  ValueNotifier<String> requestTimeError = ValueNotifier('');

  final tooltipSkillController = JustTheController();
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    ///mReasonList.value.addAll(listModelReason);
    /// [getReasonListEvent()] this method is called for Reason list
    initData();
    super.initState();
  }

  void initData() {
    mReasonList.value = getUpdateDispatchStatusList();
  }

  @override
  Widget build(BuildContext context) {
    /// [selectStatus] This is widget is use for show dropDown select Status
    Widget selectReason() {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                  text: APPStrings.textJobStatus.translate(),
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
              child: DropdownButton2<JobStatus>(
                isExpanded: true,
                isDense: true,
                underline: Container(),
                hint: Text(
                  APPStrings.hintSelectReason.translate(),
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.displaySmall!,
                      Dimens.margin16,
                      FontWeight.w400),
                ),
                items: mReasonList.value.map((value) {
                  return DropdownMenuItem<JobStatus>(
                    value: value,
                    child: Text(
                      value.status.toString(),
                      style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.labelSmall!,
                          Dimens.margin16,
                          FontWeight.w400),
                    ),
                  );
                }).toList(),
                value: selectedReason.value.jsId != null
                    ? selectedReason.value
                    : null,
                onChanged: (newValue) {
                  if (newValue != null) {
                    isReasonError.value = '';
                    selectedReason.value = newValue;
                    mStatusList.value = [];
                    selectedStatus.value = SubStatusData();
                    if ((selectedReason.value.isSubStatus ?? '')
                            .toLowerCase() ==
                        'yes') {
                      getReasonListEvent();
                    }
                  }
                },
              ),
            ),
          ],
        ),
      );
    }

    /// It returns a widget.
    Widget selectReasonMain() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          selectReason(),
          if (isReasonError.value.isNotEmpty) ...[
            const SizedBox(height: Dimens.margin10),
            BaseTextFieldErrorIndicator(errorText: isReasonError.value),
          ],
        ],
      );
    }

    /// [selectStatus] This is widget is use for show dropDown select Status
    Widget selectStatus() {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: APPStrings.textSubStatus.translate(),
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize12,
                    FontWeight.w400),
                /*  children: [
                    // const TextSpan(text: '  '),
                    // TextSpan(
                    //     text: APPStrings.textAsterisk.translate(),
                    //     style: getTextStyleFontWeight(
                    //       Theme.of(context).primaryTextTheme.headlineMedium!,
                    //       Dimens.textSize12,
                    //       FontWeight.w400,
                    //     )),
                  ]*/
              ),
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
              child: DropdownButton2<SubStatusData>(
                isExpanded: true,
                isDense: true,
                underline: Container(),
                hint: Text(
                  APPStrings.hintSelectReason.translate(),
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.displaySmall!,
                      Dimens.margin16,
                      FontWeight.w400),
                ),
                items: mStatusList.value.map((value) {
                  return DropdownMenuItem<SubStatusData>(
                    value: value,
                    child: Text(
                      value.reasonName.toString(),
                      style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.labelSmall!,
                          Dimens.margin16,
                          FontWeight.w400),
                    ),
                  );
                }).toList(),
                value: selectedStatus.value.jsId != null
                    ? selectedStatus.value
                    : null,
                onChanged: (newValue) {
                  if (newValue != null) {
                    isSubStatusError.value = '';
                    selectedStatus.value = newValue;
                  }
                },
              ),
            ),
          ],
        ),
      );
    }

    /// It returns a widget.
    Widget selectStatusMain() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          selectStatus(),
          if (isSubStatusError.value.isNotEmpty) ...[
            const SizedBox(height: Dimens.margin10),
            BaseTextFieldErrorIndicator(errorText: isSubStatusError.value),
          ],
        ],
      );
    }

    ///[requestDate] is used for text input of date of request Date input in screen
    Widget requestDate() {
      return InkWell(
        onTap: () {
          _pickDate(true);
        },
        child: BaseTextFormFieldSuffix(
          controller: requestDateController,
          enabled: false,
          fillColor: Theme.of(context).highlightColor,
          textInputAction: TextInputAction.done,
          titleText: APPStrings.textRequestDate.translate(),
          titleStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.labelSmall!,
              Dimens.margin12,
              FontWeight.w400),
          suffixIcon: Container(
            padding: const EdgeInsets.all(Dimens.margin14),
            child: SvgPicture.asset(
              APPImages.icCalender,
            ),
          ),
          errorText: requestDateError.value,
          hintText: APPStrings.hintSelectRequestDate.translate(),
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w400),
          isRequired: true,
        ),
      );
    }

    ///[requestTime] is used for text input of date of request time input in screen
    Widget requestTime() {
      return InkWell(
        onTap: () {
          _pickDate(false);
          // _pickTime();
        },
        child: BaseTextFormFieldSuffix(
          controller: requestTimeController,
          enabled: false,
          fillColor: Theme.of(context).highlightColor,
          textInputAction: TextInputAction.done,
          titleText: APPStrings.textRequestTime.translate(),
          titleStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.labelSmall!,
              Dimens.margin12,
              FontWeight.w400),
          suffixIcon: Container(
            padding: const EdgeInsets.all(Dimens.margin14),
            child: SvgPicture.asset(
              APPImages.icCalender,
            ),
          ),
          errorText: requestTimeError.value,
          hintText: APPStrings.hintSelectRequestTime.translate(),
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w400),
          isRequired: true,
        ),
      );
    }

    return MultiValueListenableBuilder(
        valueListenables: [
          isNoteError,
          isReasonError,
          isSubStatusError,
          mLoading,
          mStatusList,
          selectedStatus,
          requestDateError,
        ],
        builder: (context, value, Widget? child) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: MultiBlocListener(
              listeners: [
                BlocListener<SubStatusBloc, SubStatusState>(
                  listener: (context, state) {
                    mLoading.value = state is SubStatusLoading;

                    if (state is SubStatusResponse) {
                      mStatusList.value = state.mModelSubStatus.subStatusList!;
                      selectedStatus.value = SubStatusData();
                    }
                  },
                ),
                BlocListener<UpdateDispatcherBloc, UpdateDispatcherState>(
                  listener: (context, state) {
                    mLoading.value = state is UpdateDispatcherLoading;
                    if (selectedReason.value.removeMyJob == 'Yes' &&
                        state is UpdateDispatcherResponse) {
                      ToastController.showToast(
                          state.mModelUpdateDispatcher.message!,
                          getNavigatorKeyContext(),
                          false);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
              child: ModalProgressHUD(
                inAsyncCall: mLoading.value,
                progressIndicator: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor),
                child: Scaffold(
                  appBar: BaseAppBar(
                    mLeftImage: APPImages.icArrowBack,
                    title: APPStrings.textUpdateDispatcher.translate(),
                    appBar: AppBar(),
                  ),
                  body: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimens.margin15, vertical: Dimens.margin20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        selectReasonMain(),
                        if (mStatusList.value.isNotEmpty) ...[
                          const SizedBox(height: Dimens.margin20),
                          selectStatusMain(),
                        ],
                        if (selectedReason.value.status ==
                            statusAppointments) ...[
                          const SizedBox(height: Dimens.margin30),
                          requestDate(),
                          const SizedBox(height: Dimens.margin30),
                          requestTime(),
                        ],
                        const SizedBox(height: Dimens.margin30),
                        BaseMultiLineTextFormField(
                          controller: noteController,
                          hintText: APPStrings.hintWriteHere.translate(),
                          maxLines: 5,
                          textCapitalization: TextCapitalization.sentences,
                          errorText: isNoteError.value,
                        ),
                        const SizedBox(height: Dimens.margin30),
                        const Spacer(),
                        CustomButton(
                          onPress: () {
                            validateSendDispatcher(context);
                          },
                          backgroundColor: Theme.of(context).primaryColor,
                          borderRadius: Dimens.margin15,
                          style: getTextStyleFontWeight(
                              Theme.of(context).primaryTextTheme.displayMedium!,
                              Dimens.textSize15,
                              FontWeight.w500),
                          buttonText: APPStrings.textSend.translate(),
                        ),
                        const SizedBox(height: Dimens.margin30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  ///[_pickDate] this method use to Android, iOS and web date picker
  void _pickDate(bool isStart) async {
    FocusScope.of(context).requestFocus(FocusNode());
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: startDate ?? DateTime.now(),
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
      if ((isStart && startDate == null) || (!isStart && endDate == null)) {
        date = date.copyWith(
            hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);
      } else if (isStart) {
        date = date.copyWith(hour: startDate!.hour, minute: startDate!.minute);
      } else if (!isStart) {
        date = date.copyWith(hour: endDate!.hour, minute: endDate!.minute);
      }

      _pickTime(date, isStart);
      // setDate(date!, isStart);
    }
  }

  ///[_pickTime] this method use to Android, iOS and web date picker
  void _pickTime(DateTime setDate, bool isStart) async {
    DateTime mNewTime = setDate;
    DateTime initialDateTime = DateTime.now()
        .copyWith(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);
    TimeOfDay initialTime = TimeOfDay.fromDateTime(setDate);

    initialDateTime = initialDateTime.copyWith(
        hour: initialTime.hour, minute: initialTime.minute);

    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      child: const Text('Done'),
                      onPressed: () {
                        Navigator.pop(context);
                        setTime(
                            TimeOfDay.fromDateTime(mNewTime), isStart, setDate);
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    // use24hFormat: true,
                    initialDateTime: initialDateTime,
                    onDateTimeChanged: (startTime) {
                      mNewTime = startTime;
                    },
                  ),
                ),
              ],
            ),
          );
        });
    /*showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(setDate),
        initialEntryMode: TimePickerEntryMode.dial,
        builder: (context, widget) {
          return Theme(
              data: Theme.of(context).copyWith(
                dialogBackgroundColor: AppColors.colorWhite,
                colorScheme: ColorScheme.light(
                  primary: Theme.of(context).primaryColor,
                  // header background color
                  onPrimary: AppColors.colorWhite,
                  // header text color
                  onSurface: Theme.of(context).primaryColor, // body text color
                ),
              ),
              child: MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: widget!));
        }).then((value) {
      if (value != null) {
        setTime(value, isStart, setDate);
      }
    });*/
  }

  ///[setTime] this method use to set date is per the picker status
  void setTime(TimeOfDay setTime, bool isStart, DateTime setDate) {
    DateTime mTime =
        setDate.copyWith(hour: setTime.hour, minute: setTime.minute);

    if (isStart) {
      if (endDate != null && (mTime.compareTo(endDate!) >= 0)) {
        ToastController.showToast(
            ValidationString.errorClosingTimeMustBeGreaterThanOpeningTime
                .translate(),
            context,
            false);
        return;
      } else {
        startDate = mTime;
        requestDateController.text = formatDateWithSuffix(
            formatDate(mTime, AppConfig.dateFormatDDMMYYYYHHMMSS));
        // requestDateController.text += ' ${formatTime24H(setTime)}';
      }
    } else {
      if (startDate != null && (startDate!.compareTo(mTime) >= 0)) {
        ToastController.showToast(
            ValidationString.errorClosingTimeMustBeGreaterThanOpeningTime
                .translate(),
            context,
            false);
        return;
      } else {
        endDate = mTime;
        requestTimeController.text = formatDateWithSuffix(
            formatDate(mTime, AppConfig.dateFormatDDMMYYYYHHMMSS));
        /* requestTimeController.text =
            formatDate(mTime, AppConfig.dateFormatYYYYMMDD);
        requestTimeController.text += ' ${formatTime24H(setTime)}';*/
      }
    }
  }

  void validateSendDispatcher(BuildContext context) {
    printWrapped('mStatusList.value---${mStatusList.value.length}');
    if (selectedReason.value.jsId == null) {
      isReasonError.value = APPStrings.hintSelectReason.translate();
      // ToastController.showToast(
      //     APPStrings.hintSelectReason.translate(), context, false);
    }
    // if (mStatusList.value.isNotEmpty && selectedStatus.value.jsId == null) {
    //   isSubStatusError.value = APPStrings.hintSelectStatus.translate();
    // }
    if (selectedReason.value.status == statusAppointments &&
        startDate == null) {
      requestDateError.value = APPStrings.textSelectDate.translate();
    }
    if (selectedReason.value.status == statusAppointments && endDate == null) {
      requestTimeError.value = APPStrings.textSelectDate.translate();
    }
    if ((selectedReason.value.jsId != null) &&
        (mStatusList.value.isEmpty ||
            (mStatusList.value
                .isNotEmpty /*&&
                selectedStatus.value.jsId != null*/
            )) &&
        (selectedReason.value.status != statusAppointments ||
            (selectedReason.value.status == statusAppointments &&
                startDate != null &&
                endDate != null))) {
      updateDispatcherEvent();
    } else {
      return;
    }
  }

  ///[getReasonListEvent] this method is used to connect to Reject of Reason List
  void getReasonListEvent() async {
    Map<String, dynamic> mBody = {
      ApiParams.paramJsId: selectedReason.value.jsId,
    };
    BlocProvider.of<SubStatusBloc>(context).add(SubStatusList(
      body: mBody,
      url: AppUrls.apiSubStatus,
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    selectedReason.value = JobStatus();
  }

  ///[updateDispatcherEvent] this method is used to connect to update dispatcher list
  void updateDispatcherEvent() async {
    Map<String, dynamic> mBody = {
      ApiParams.paramJobId: widget.jobId,
      ApiParams.paramJobUpdateStatus: selectedReason.value.status ?? '',
      ApiParams.paramSubStatus: selectedStatus.value.jsId ?? '',
      ApiParams.paramNotes: noteController.text,
    };

    if (selectedReason.value.status == statusAppointments) {
      mBody.addAll(
        {
          ApiParams.paramSchedule: startDate != null
              ? formatDate(startDate, AppConfig.dateFormatYYYYMMDDHHMM)
              : '',
          ApiParams.paramScheduleEnd: endDate != null
              ? formatDate(endDate, AppConfig.dateFormatYYYYMMDDHHMM)
              : '',
        },
      );
    }
    BlocProvider.of<UpdateDispatcherBloc>(context).add(UpdateDispatcher(
      body: mBody,
      url: AppUrls.apiUpdateJob,
    ));
  }
}

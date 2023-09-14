import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/model/model_filter_job_history.dart';
import 'package:we_pro/modules/masters/model/model_get_status.dart';

import '../../dashboard/model/model_job_types_history_filter.dart';

/// This class is a stateful widget that creates a bottom sheet that allows the user to filter the
/// wallets displayed in the wallet list
class BottomSheetRecentJobFilter extends StatefulWidget {
  final ModelFilterJobHistory modelFilterJobHistory;

  const BottomSheetRecentJobFilter(
      {Key? key, required this.modelFilterJobHistory})
      : super(key: key);

  @override
  State<BottomSheetRecentJobFilter> createState() =>
      _BottomSheetRecentJobFilterState();
}

class _BottomSheetRecentJobFilterState
    extends State<BottomSheetRecentJobFilter> {
  ValueNotifier<String> isStartTimeError = ValueNotifier('');
  ValueNotifier<String> isEndTimeError = ValueNotifier('');
  ValueNotifier<int> mDurationFilter = ValueNotifier(0);

  /// Source Provider
  ValueNotifier<JobTypeFilter> selectedSourceProviderNotifier =
      ValueNotifier(JobTypeFilter());
  ValueNotifier<List<JobTypeFilter>> sourceProvider = ValueNotifier([]);

  ValueNotifier<JobStatus> selectedJobStatusNotifier =
      ValueNotifier(JobStatus());
  ValueNotifier<List<JobStatus>> jobStatusFinal = ValueNotifier([]);
  ValueNotifier<List<JobStatus>> jobStatusList = ValueNotifier([]);

  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  FocusNode startTimeFocus = FocusNode();
  FocusNode endTimeFocus = FocusNode();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  @override
  void initState() {
    //   jobStatusList.value = getStatusList();
    jobStatusFinal.value = getStatusList();
    for (var element in jobStatusFinal.value) {
      if (element.status == "Done" ||
          element.status == "Completed" ||
          element.status == "Rejected" ||
          element.status == "Canceled" ||
          element.status == "Confirmed") {
        jobStatusList.value.add(element);
      }
    }
    sourceProvider.value = getJobTypesHistoryFilterList();
    if (widget.modelFilterJobHistory.duration != null) {
      if (widget.modelFilterJobHistory.duration ==
          APPStrings.textDateDuration.translate()) {
        mDurationFilter.value = 1;
        startDate = convertStringToDateFormat(
            widget.modelFilterJobHistory.startDate ?? "",
            AppConfig.dateFormatYYYYMMDD);
        endDate = convertStringToDateFormat(
            widget.modelFilterJobHistory.endDate ?? "",
            AppConfig.dateFormatYYYYMMDD);

        setDate(startDate, true);
        setDate(endDate, false);

        //   formatDate(endDate, AppConfig.dateFormatDDMMYYYYHHMMSS);
      } else if (widget.modelFilterJobHistory.duration ==
          APPStrings.textLastWeek.translate()) {
        mDurationFilter.value = 2;
      } else if (widget.modelFilterJobHistory.duration ==
          APPStrings.textLastMonth.translate()) {
        mDurationFilter.value = 3;
      }
    }
    if (widget.modelFilterJobHistory.jobStatus != null) {
      for (var element in jobStatusList.value) {
        if (element.status == widget.modelFilterJobHistory.jobStatus) {
          selectedJobStatusNotifier.value = element;
        }
      }
    }
    if (widget.modelFilterJobHistory.jobType != null) {
      for (var element in sourceProvider.value) {
        if (element.jId == widget.modelFilterJobHistory.jobType) {
          selectedSourceProviderNotifier.value = element;
        }
      }
    }

    printWrapped("jobStatusList==${jobStatusList.value.length}");
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
              FontWeight.w400),
          onChange: () {
            if (isStartTimeError.value.isNotEmpty) {
              isStartTimeError.value = '';
            }
          },
          onSubmit: () {
            if (isStartTimeError.value.isNotEmpty) {
              isStartTimeError.value = '';
            }
          },
        ),
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
                FontWeight.w400),
            onChange: () {
              if (isEndTimeError.value.isNotEmpty) {
                isEndTimeError.value = '';
              }
            }),
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
            if (mDurationFilter.value == 1 &&
                startTimeController.text.isEmpty) {
              isStartTimeError.value = "Please select Start Time";
              isValid = false;
            } else if (mDurationFilter.value == 1 &&
                endTimeController.text.isEmpty) {
              isEndTimeError.value = "Please select End Time";
              isValid = false;
            }

            if (isValid) {
              isStartTimeError.value = "";
              isEndTimeError.value = "";
              ModelFilterJobHistory mModelFilterJobHistory =
                  ModelFilterJobHistory(
                      duration: getDurationValue(),
                      endDate: mDurationFilter.value == 1
                          ? formatDate(endDate, AppConfig.dateFormatYYYYMMDD)
                          : null,
                      startDate: mDurationFilter.value == 1
                          ? formatDate(startDate, AppConfig.dateFormatYYYYMMDD)
                          : null,
                      jobStatus: selectedJobStatusNotifier.value.status,
                      jobType: selectedSourceProviderNotifier.value.jId);

              Navigator.pop(context, mModelFilterJobHistory);
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
            Navigator.pop(context, ModelFilterJobHistory());
          },
          buttonText: APPStrings.textRestFilter.translate(),
        ),
      );
    }

    ///[selectSourceProvider] This is widget is use for show dropDown source provider
    // Widget selectSourceProvider() {
    //   return SizedBox(
    //     width: MediaQuery.of(context).size.width,
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text(
    //           APPStrings.textSourceProvider.translate(),
    //           style: getTextStyleFontWeight(
    //               Theme.of(context).primaryTextTheme.labelSmall!,
    //               Dimens.textSize12,
    //               FontWeight.w400),
    //         ),
    //         const SizedBox(height: Dimens.margin8),
    //         Container(
    //           height: Dimens.margin50,
    //           padding: const EdgeInsets.all(Dimens.margin16),
    //           decoration: BoxDecoration(
    //             borderRadius:
    //                 const BorderRadius.all(Radius.circular(Dimens.margin16)),
    //             color: Theme.of(context).highlightColor,
    //           ),
    //           clipBehavior: Clip.hardEdge,
    //           child: DropdownButton2<JobTypeFilter>(
    //             isExpanded: true,
    //             isDense: true,
    //             underline: Container(),
    //             /*icon: SvgPicture.asset(
    //               APPImages.icDropDownArrow,
    //               width: Dimens.margin13,
    //               height: Dimens.margin11,
    //             ),*/
    //             hint: Text(
    //               APPStrings.warningSelectSourceProvider.translate(),
    //               style: getTextStyleFontWeight(
    //                   Theme.of(context).primaryTextTheme.displaySmall!,
    //                   Dimens.margin15,
    //                   FontWeight.w400),
    //             ),
    //             items: sourceProvider.value.map((value) {
    //               return DropdownMenuItem<JobTypeFilter>(
    //                 value: value,
    //                 child: Text(
    //                   value.name ?? "",
    //                   style: getTextStyleFontWeight(
    //                       Theme.of(context).primaryTextTheme.labelSmall!,
    //                       Dimens.margin16,
    //                       FontWeight.w400),
    //                 ),
    //               );
    //             }).toList(),
    //             value: selectedSourceProviderNotifier.value.jId != null
    //                 ? selectedSourceProviderNotifier.value
    //                 : null,
    //             onChanged: (newValue) {
    //               selectedSourceProviderNotifier.value = newValue!;
    //             },
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    /// [selectJobStatus] This is widget is use for Job Status
    Widget selectJobStatus() {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              APPStrings.textJobStatus.translate(),
              style: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.labelSmall!,
                  Dimens.textSize12,
                  FontWeight.w400),
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
                /*icon: SvgPicture.asset(
                  APPImages.icDropDownArrow,
                  width: Dimens.margin13,
                  height: Dimens.margin11,
                ),*/
                hint: Text(
                  APPStrings.textSelectJobStatus.translate(),
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.displaySmall!,
                      Dimens.margin15,
                      FontWeight.w400),
                ),
                items: jobStatusList.value.map((value) {
                  return DropdownMenuItem<JobStatus>(
                    value: value,
                    child: Text(
                      value.status ?? "",
                      style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.labelSmall!,
                          Dimens.margin16,
                          FontWeight.w400),
                    ),
                  );
                }).toList(),
                value: selectedJobStatusNotifier.value.jsId != null
                    ? selectedJobStatusNotifier.value
                    : null,
                onChanged: (newValue) {
                  selectedJobStatusNotifier.value = newValue!;
                },
              ),
            ),
          ],
        ),
      );
    }

    return MultiValueListenableBuilder(
        valueListenables: [
          isEndTimeError,
          mDurationFilter,
          isStartTimeError,
          selectedSourceProviderNotifier,
          selectedJobStatusNotifier,
          jobStatusList
        ],
        builder: (context, values, Widget? child) {
          return StatefulBuilder(builder: (context, setState) {
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
                  const SizedBox(height: Dimens.margin32),
                  Wrap(
                    spacing: Dimens.margin10,
                    runSpacing: Dimens.margin10,
                    children: [
                      CustomButton(
                        height: Dimens.margin50,
                        width: Dimens.margin150,
                        backgroundColor: mDurationFilter.value == 1
                            ? Theme.of(context).colorScheme.surfaceTint
                            : Theme.of(context).highlightColor,
                        borderColor: mDurationFilter.value == 1
                            ? Theme.of(context).colorScheme.surfaceTint
                            : Theme.of(context).highlightColor,
                        borderRadius: Dimens.margin15,
                        onPress: () {
                          if (mDurationFilter.value == 1) {
                            mDurationFilter.value = 0;
                          } else {
                            mDurationFilter.value = 1;
                          }
                        },
                        style: mDurationFilter.value == 1
                            ? getTextStyleFontWeight(
                                Theme.of(context).primaryTextTheme.labelSmall!,
                                Dimens.textSize15,
                                FontWeight.w400)
                            : getTextStyleFontWeight(
                                Theme.of(context)
                                    .primaryTextTheme
                                    .displaySmall!,
                                Dimens.textSize15,
                                FontWeight.w400),
                        buttonText: APPStrings.textDateDuration.translate(),
                      ),
                      // const SizedBox(width: Dimens.margin10),
                      CustomButton(
                        height: Dimens.margin50,
                        width: Dimens.margin150,
                        backgroundColor: mDurationFilter.value == 2
                            ? Theme.of(context).colorScheme.surfaceTint
                            : Theme.of(context).highlightColor,
                        borderColor: mDurationFilter.value == 2
                            ? Theme.of(context).colorScheme.surfaceTint
                            : Theme.of(context).highlightColor,
                        borderRadius: Dimens.margin15,
                        onPress: () {
                          if (mDurationFilter.value == 2) {
                            mDurationFilter.value = 0;
                          } else {
                            mDurationFilter.value = 2;
                          }
                        },
                        style: mDurationFilter.value == 2
                            ? getTextStyleFontWeight(
                                Theme.of(context).primaryTextTheme.labelSmall!,
                                Dimens.textSize15,
                                FontWeight.normal)
                            : getTextStyleFontWeight(
                                Theme.of(context)
                                    .primaryTextTheme
                                    .displaySmall!,
                                Dimens.textSize15,
                                FontWeight.normal),
                        buttonText: APPStrings.textLastWeek.translate(),
                      ),
                      CustomButton(
                        height: Dimens.margin50,
                        width: Dimens.margin150,
                        backgroundColor: mDurationFilter.value == 3
                            ? Theme.of(context).colorScheme.surfaceTint
                            : Theme.of(context).highlightColor,
                        borderColor: mDurationFilter.value == 3
                            ? Theme.of(context).colorScheme.surfaceTint
                            : Theme.of(context).highlightColor,
                        borderRadius: Dimens.margin15,
                        onPress: () {
                          if (mDurationFilter.value == 3) {
                            mDurationFilter.value = 0;
                          } else {
                            mDurationFilter.value = 3;
                          }
                        },
                        style: mDurationFilter.value == 3
                            ? getTextStyleFontWeight(
                                Theme.of(context).primaryTextTheme.labelSmall!,
                                Dimens.textSize15,
                                FontWeight.normal)
                            : getTextStyleFontWeight(
                                Theme.of(context)
                                    .primaryTextTheme
                                    .displaySmall!,
                                Dimens.textSize15,
                                FontWeight.normal),
                        buttonText: APPStrings.textLastMonth.translate(),
                      )
                    ],
                  ),
                  const SizedBox(height: Dimens.margin30),
                  (mDurationFilter.value == 1)
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                            const SizedBox(
                              height: Dimens.margin32,
                            ),
                          ],
                        )
                      : const SizedBox(),
                  // selectSourceProvider(),
                  // const SizedBox(
                  //   height: Dimens.margin30,
                  // ),
                  if (jobStatusList.value.isNotEmpty) selectJobStatus(),
                  const SizedBox(
                    height: Dimens.margin50,
                  ),
                  Row(
                    children: [
                      resetFilterButton(),
                      const SizedBox(width: Dimens.margin16),
                      applyButton(),
                    ],
                  ),
                  const SizedBox(
                    height: Dimens.margin40,
                  ),
                ],
              ),
            );
          });
        });
  }

  ///[_pickDate] this method use to Android, iOS and web date picker
  void _pickDate(bool isStart) async {
    FocusScope.of(context).requestFocus(FocusNode());

    DateTime? date = await showDatePicker(
      context: context,
      firstDate: isStart
          ? DateTime.now().subtract(const Duration(days: 180))
          : startDate,
      lastDate: DateTime.now(),
      initialDate: isStart ? startDate : endDate,
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
      endDate = DateTime.now();
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

  String? getDurationValue() {
    switch (mDurationFilter.value) {
      case 0:
        return null;
      case 1:
        return APPStrings.textDateDuration.translate();
      case 2:
        return APPStrings.textLastWeek.translate();
      case 3:
        return APPStrings.textLastMonth.translate();
    }
    return null;
  }
}

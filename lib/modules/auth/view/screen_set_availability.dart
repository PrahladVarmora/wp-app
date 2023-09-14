// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/cupertino.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/profile/bloc/update_availability/update_availability_bloc.dart';
import 'package:we_pro/modules/profile/model/model_get_profile.dart';

import '../../core/utils/api_import.dart';

/// The ScreenSetAvailability class is a stateful widget in Dart.
class ScreenSetAvailability extends StatefulWidget {
  final List<AvailabilityHours> mModelBusinessHours;

  const ScreenSetAvailability({Key? key, required this.mModelBusinessHours})
      : super(key: key);

  @override
  State<ScreenSetAvailability> createState() => _ScreenSetAvailabilityState();
}

class _ScreenSetAvailabilityState extends State<ScreenSetAvailability> {
  List<String> mDays = [
    APPStrings.textMonday,
    APPStrings.textTuesday,
    APPStrings.textWednesday,
    APPStrings.textThursday,
    APPStrings.textFriday,
    APPStrings.textSaturday,
    APPStrings.textSunday,
  ];
  ValueNotifier<List<AvailabilityHours>> mModelBusinessHours =
      ValueNotifier([]);
  ValueNotifier<bool> mLoading = ValueNotifier(false);

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() {
    if (widget.mModelBusinessHours.isNotEmpty) {
      mModelBusinessHours.value.addAll(widget.mModelBusinessHours);
      for (int i = 0; i < mModelBusinessHours.value.length; i++) {
        mModelBusinessHours.value[i].dayName = mDays[i];
      }
    } else {
      for (int i = 0; i < mDays.length; i++) {
        mModelBusinessHours.value.add(AvailabilityHours(
            dayName: mDays[i].translate(), day: (i + 1).toString()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    /// `mBody` is a function that returns a `Container` widget containing a
    /// `Column` widget with a single child, an `Expanded` widget containing a
    /// `ListView.separated` widget. The `ListView.separated` widget displays a list
    /// of business hours for each day of the week, with each item in the list
    /// containing a `Row` widget with a `CustomSwitch` widget, two `InkWell`
    /// widgets, and some `SizedBox` and `Visibility` widgets. The `CustomSwitch`
    /// widget is used to toggle the availability of the business on a particular
    /// day, while the `InkWell` widgets are used to select the opening and closing
    /// times for the business on that day. The `Visibility` widgets are used to
    /// show or hide the opening and closing time selection widgets based on whether
    /// the business is available on that day or not.
    Widget mBody() {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
            padding: const EdgeInsets.all(Dimens.margin16),
            child: Column(
              children: [
                ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: Dimens.margin8),
                  itemCount: mModelBusinessHours.value.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              (mModelBusinessHours.value[index].dayName ?? '')
                                  .translate(),
                              style: getTextStyleFontWeight(
                                  Theme.of(context).textTheme.displayMedium!,
                                  Dimens.textSize18,
                                  FontWeight.w500),
                            ),
                            CustomSwitch(
                              isSwitchOn:
                                  !mModelBusinessHours.value[index].isOff!,
                              onPress: () {
                                mModelBusinessHours.value[index].isOff =
                                    !mModelBusinessHours.value[index].isOff!;
                                if (mModelBusinessHours.value[index].isOff ==
                                    true) {
                                  mModelBusinessHours.value[index].open = null;
                                  mModelBusinessHours.value[index].close = null;
                                }
                                mModelBusinessHours.notifyListeners();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: Dimens.margin10),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  _pickTime(true, index);
                                },
                                child: Container(
                                  height: Dimens.margin50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimens.margin16),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).dividerColor,
                                    borderRadius:
                                        BorderRadius.circular(Dimens.margin12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          mModelBusinessHours
                                                      .value[index].open !=
                                                  null
                                              ? (formatTime12H(
                                                  convertStringToTimeOfDay(
                                                      mModelBusinessHours
                                                              .value[index]
                                                              .open ??
                                                          '')))
                                              : APPStrings.textStartTime
                                                  .translate(),
                                          style: getTextStyleFontWeight(
                                              /*  mModelBusinessHours
                                                          .value[index].open !=
                                                      null
                                                  ? Theme.of(context)
                                                      .primaryTextTheme
                                                      .displaySmall!
                                                  :*/
                                              Theme.of(context)
                                                  .primaryTextTheme
                                                  .labelSmall!,
                                              Dimens.textSize15,
                                              FontWeight.w400)),
                                      SvgPicture.asset(
                                        APPImages.icDropDownArrow,
                                        width: Dimens.margin10,
                                        height: Dimens.margin8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: Dimens.margin10),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  _pickTime(false, index);
                                },
                                child: Container(
                                  height: Dimens.margin50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimens.margin16),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).dividerColor,
                                    borderRadius:
                                        BorderRadius.circular(Dimens.margin12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          mModelBusinessHours
                                                      .value[index].close !=
                                                  null
                                              ? (formatTime12H(
                                                  convertStringToTimeOfDay(
                                                      mModelBusinessHours
                                                              .value[index]
                                                              .close ??
                                                          '')))
                                              : APPStrings.textEndTime
                                                  .translate(),
                                          style: getTextStyleFontWeight(
                                              /* mModelBusinessHours
                                                          .value[index].close !=
                                                      null
                                                  ? Theme.of(context)
                                                      .primaryTextTheme
                                                      .displaySmall!
                                                  :*/
                                              Theme.of(context)
                                                  .primaryTextTheme
                                                  .labelSmall!,
                                              Dimens.textSize15,
                                              FontWeight.w400)),
                                      SvgPicture.asset(
                                        APPImages.icDropDownArrow,
                                        width: Dimens.margin10,
                                        height: Dimens.margin8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: Dimens.margin20);
                  },
                ),
                const SizedBox(height: Dimens.margin20),
                CustomButton(
                  height: Dimens.margin50,
                  onPress: () {
                    validation(context);
                    // backPress(context);
                  },
                  backgroundColor: Theme.of(context).primaryColor,
                  borderRadius: Dimens.textSize15,
                  buttonText: APPStrings.textSave.translate(),
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.displayLarge!,
                      Dimens.textSize15,
                      FontWeight.w500),
                ),
                const SizedBox(height: Dimens.margin20),
              ],
            )),
      );
    }

    BaseAppBar getAppbar() {
      return BaseAppBar(
        appBar: AppBar(),
        title: APPStrings.textSetAvailability.translate(),
        mLeftImage: APPImages.icArrowBack,
        mLeftAction: () {
          backPress(context);
        },
        textStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.titleLarge!,
            Dimens.textSize18,
            FontWeight.w600),
        backgroundColor: Theme.of(context).colorScheme.primary,
      );
    }

    return MultiValueListenableBuilder(
        valueListenables: [
          mModelBusinessHours,
          mLoading,
        ],
        builder: (context, values, child) {
          return WillPopScope(
            onWillPop: () async {
              backPress(context);
              return false;
            },
            child:
                BlocListener<UpdateAvailabilityBloc, UpdateAvailabilityState>(
              listener: (context, state) {
                mLoading.value = state is UpdateAvailabilityLoading;
                if (state is UpdateAvailabilityResponse) {
                  backPress(context);
                }
              },
              child: ModalProgressHUD(
                inAsyncCall: mLoading.value,
                child: Scaffold(
                  appBar: getAppbar(),
                  body: mBody(),
                ),
              ),
            ),
          );
        });
  }

  /// This function handles the back button press in a Flutter app.
  ///
  /// Args:
  ///   context (BuildContext): The context parameter in Flutter is an object that
  /// contains information about the current state of the app. It is used to access
  /// resources such as themes, localization, and navigation. In this case, the
  /// context parameter is being used to navigate back to the previous screen when
  /// the back button is pressed.
  void backPress(BuildContext context) {
    Navigator.pop(context);
  }

  ///[_pickTime] this method use to Android, iOS and web date picker
  void _pickTime(bool isStart, int index) async {
    DateTime mNewTime = DateTime.now();
    DateTime initialDateTime = DateTime.now();
    TimeOfDay initialTime = (isStart
                ? mModelBusinessHours.value[index].open
                : mModelBusinessHours.value[index].close) ==
            null
        ? TimeOfDay.now()
        : convertStringToTimeOfDay((isStart
                ? mModelBusinessHours.value[index].open
                : mModelBusinessHours.value[index].close) ??
            '');

    initialDateTime = initialDateTime.copyWith(
        hour: initialTime.hour, minute: initialTime.minute);
    mNewTime = initialDateTime;

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
                        setDate(
                            TimeOfDay.fromDateTime(mNewTime), isStart, index);
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
    /*if (kIsWeb) {
      showTimePicker(
          context: context,
          helpText: '',
          initialTime: (isStart
                      ? mModelBusinessHours.value[index].open
                      : mModelBusinessHours.value[index].close) ==
                  null
              ? TimeOfDay.now()
              : convertStringToTimeOfDay((isStart
                      ? mModelBusinessHours.value[index].open
                      : mModelBusinessHours.value[index].close) ??
                  ''),
          initialEntryMode: TimePickerEntryMode.dial,
          builder: (context, widget) {
            return Theme(
                data: Theme.of(context).copyWith(
                  dialogBackgroundColor: AppColors.colorWhite,
                  colorScheme: ColorScheme.light(
                    primary: Theme.of(context).colorScheme.primary,
                    // header background color
                    onPrimary: AppColors.colorWhite,
                    // header text color
                    onSurface:
                        Theme.of(context).primaryColor, // body text color
                  ),
                ),
                child: MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(alwaysUse24HourFormat: true),
                    child: widget!));
          }).then((value) {
        if (value != null) {
          setDate(value, isStart, index);
        }
      });
    }*/
  }

  ///[setDate] this method use to set date is per the picker status
  void setDate(TimeOfDay setDate, bool isStart, int index) {
    if (isStart) {
      if (mModelBusinessHours.value[index].close != null) {
        if (convertStringToTimeOfDay(formatTime24H(setDate)).compareTo(
                convertStringToTimeOfDay(
                    mModelBusinessHours.value[index].close!)) >=
            0) {
          ToastController.showToast(
              ValidationString.errorClosingTimeMustBeGreaterThanOpeningTime
                  .translate(),
              context,
              false);
          return;
        }
      }
      mModelBusinessHours.value[index].open = formatTime24H(setDate);
    } else {
      if (mModelBusinessHours.value[index].open != null) {
        if ((convertStringToTimeOfDay(mModelBusinessHours.value[index].open!)
                .compareTo(convertStringToTimeOfDay(formatTime24H(setDate)))) >=
            0) {
          ToastController.showToast(
              ValidationString.errorClosingTimeMustBeGreaterThanOpeningTime
                  .translate(),
              context,
              false);
          return;
        }
      }
      mModelBusinessHours.value[index].close = formatTime24H(setDate);
    }

    mModelBusinessHours.notifyListeners();
  }

  void validation(BuildContext context) {
    if (mModelBusinessHours.value.every((element) {
      if (element.isOff == false) {
        return (element.isOff == false &&
            element.open != null &&
            element.close != null);
      } else {
        return true;
      }
    })) {
      updateEvent(context);
    } else {
      ToastController.showToast(
          ValidationString.validationAvailability.translate(), context, false);
    }
  }

  void updateEvent(BuildContext context) {
    Map<String, dynamic> mBody = {
      ApiParams.paramUserAvailable:
          mModelBusinessHours.value.every((element) => element.isOff == true)
              ? '24'
              : 'Custom',
      ApiParams.paramAvailabilityHours:
          mModelBusinessHours.value.map((v) => v.toJson()).toList(),
    };
    printWrapped('mBody-----${jsonEncode(mBody)}');
    BlocProvider.of<UpdateAvailabilityBloc>(context).add(UpdateAvailabilityUser(
        url: AppUrls.apiTechniciansUsersUpdateAvailability, body: mBody));
  }
}

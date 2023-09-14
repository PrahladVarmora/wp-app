import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:we_pro/modules/auth/view/model/model_slot_time.dart';
import 'package:we_pro/modules/auth/view/widget/multi_select_dropdown_list.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/masters/model/model_skill.dart';
import 'package:we_pro/modules/masters/skill/bloc/skill_bloc.dart';
import 'package:we_pro/modules/profile/widget/skill_multi_select_dropdown_list.dart';

import '../../core/utils/core_import.dart';

///[ScreenProfileCompletion] this class is used for Profile Completion screen
class ScreenProfileCompletion extends StatefulWidget {
  const ScreenProfileCompletion({Key? key}) : super(key: key);

  @override
  State<ScreenProfileCompletion> createState() =>
      _ScreenProfileCompletionState();
}

class _ScreenProfileCompletionState extends State<ScreenProfileCompletion> {
  ValueNotifier<bool> mLoading = ValueNotifier(false);
  ValueNotifier<bool> isAvailabilitySelected = ValueNotifier(true);
  ValueNotifier<String> isWeekDaysError = ValueNotifier('');
  ValueNotifier<String> isSkillDaysError = ValueNotifier('');

  /// listener for particular widget
  ValueNotifier<String> isStartTimeError = ValueNotifier('');
  ValueNotifier<String> isEndTimeError = ValueNotifier('');
  ValueNotifier<String> isAddressError = ValueNotifier('');
  ValueNotifier<String> isCountryError = ValueNotifier('');
  ValueNotifier<String> isStateError = ValueNotifier('');
  ValueNotifier<String> isCityError = ValueNotifier('');
  ValueNotifier<String> isZipcodeError = ValueNotifier('');
  ValueNotifier<String> isDateOfBirthError = ValueNotifier('');
  ValueNotifier<String> isAccountHolderError = ValueNotifier('');
  ValueNotifier<String> isBankNameError = ValueNotifier('');
  ValueNotifier<String> isBankAccountError = ValueNotifier('');
  ValueNotifier<String> isACHRoutingError = ValueNotifier('');
  ValueNotifier<String> isBankAddressError = ValueNotifier('');
  ValueNotifier<String> selectedSourceProviderNotifier = ValueNotifier('');
  ValueNotifier<String> isBankCountryError = ValueNotifier('');
  ValueNotifier<String> isBankStateError = ValueNotifier('');
  ValueNotifier<String> isBankCityError = ValueNotifier('');
  ValueNotifier<String> isBankZipcodeError = ValueNotifier('');

  /// controller for particular widget
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController accountHolderController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController bankAccountController = TextEditingController();
  TextEditingController achRoutingController = TextEditingController();
  TextEditingController bankAddressController = TextEditingController();
  TextEditingController bankCountryController = TextEditingController();
  TextEditingController bankStateController = TextEditingController();
  TextEditingController bankCityController = TextEditingController();
  TextEditingController bankZipcodeController = TextEditingController();

  /// focus for particular widget
  FocusNode startTimeFocus = FocusNode();
  FocusNode endTimeFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode countryFocus = FocusNode();
  FocusNode stateFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode zipcodeFocus = FocusNode();
  FocusNode dateOfBirthFocus = FocusNode();
  FocusNode accountHolderFocus = FocusNode();
  FocusNode bankNameFocus = FocusNode();
  FocusNode bankAccountFocus = FocusNode();
  FocusNode achRoutingFocus = FocusNode();
  FocusNode bankAddressFocus = FocusNode();
  FocusNode bankCountryFocus = FocusNode();
  FocusNode bankStateFocus = FocusNode();
  FocusNode bankCityFocus = FocusNode();
  FocusNode bankZipcodeFocus = FocusNode();

  /// tool-trip
  final tooltipController = JustTheController();
  final tooltipSkillController = JustTheController();

  ValueNotifier<List<WeekDayModel>> mListWeekDay =
      ValueNotifier<List<WeekDayModel>>([]);
  ValueNotifier<List<String>> mListSelectedWeek =
      ValueNotifier<List<String>>([]);

  ValueNotifier<List<Skills>> mSkillList = ValueNotifier([]);
  ValueNotifier<List<String>> mListSelectedSkill = ValueNotifier([]);

  /* List<SkillModel> listSkillModel = [
    SkillModel(skillName: 'Self-Discipline', isSelected: false),
    SkillModel(skillName: 'Good Communicator', isSelected: false),
    SkillModel(skillName: 'Problem-Solver', isSelected: false),
    SkillModel(skillName: 'Attention to Detail', isSelected: false)
  ];*/

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  File? selectFrontDrivingLicence;
  File? selectBackDrivingLicence;

  List<String> sourceProvider = ['One', 'Two', 'Three'];

  @override
  void initState() {
    super.initState();
    readJsonWeekSlot();

    ///mSkillList.value.addAll(listSkillModel);
    mSkillList.value
        .addAll(BlocProvider.of<SkillBloc>(getNavigatorKeyContext()).mSkills);
  }

  Future<void> readJsonWeekSlot() async {
    final response =
        await rootBundle.loadString('assets/weekslot/weekslot.json');
    List<WeekDayModel> tempSlotWeekModel = List<WeekDayModel>.from(
        json.decode(response).map((x) => WeekDayModel.fromJson(x)));
    mListWeekDay.value = tempSlotWeekModel;
  }

  @override
  Widget build(BuildContext context) {
    /// [textSkip]  is used to display skip text
    Widget textSkip() {
      return IconButton(
          padding: const EdgeInsets.only(right: Dimens.margin15),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.routesDashboard, (route) => false);
          },
          icon: Text(
            APPStrings.textSkip.translate(),
            style: getTextStyleFontWeight(
                Theme.of(context).primaryTextTheme.headlineSmall!,
                Dimens.textSize12,
                FontWeight.w600),
          ));
    }

    ///[submitButton] is used for submit profile
    Widget submitButton() {
      return CustomButton(
          height: Dimens.margin50,
          onPress: () {
            validateProfileSubmitData(context);
          },
          backgroundColor: Theme.of(context).primaryColor,
          buttonText: APPStrings.textSubmit.translate(),
          style: getTextStyleFontWeight(
              AppFont.mediumColorWhite, Dimens.margin15, FontWeight.w400),
          borderRadius: Dimens.margin15_5);
    }

    ///[startTime] is used for text input of date of start Time input in screen
    Widget startTime() {
      return InkWell(
        onTap: () {
          _pickTime(true, errorNotifier: isStartTimeError);
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
              APPImages.icDropDownArrow,
            ),
          ),
          errorText: isStartTimeError.value,
          hintText: APPStrings.textStartTime.translate(),
        ),
      );
    }

    ///[endTime] is used for text input of date of start Time input in screen
    Widget endTime() {
      return InkWell(
        onTap: () {
          _pickTime(false, errorNotifier: isEndTimeError);
        },
        child: BaseTextFormFieldSuffix(
          controller: endTimeController,
          focusNode: endTimeFocus,
          nextFocusNode: addressFocus,
          enabled: false,
          isRequired: true,
          textInputAction: TextInputAction.next,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: Dimens.margin16),
            child: SvgPicture.asset(
              APPImages.icDropDownArrow,
            ),
          ),
          errorText: isEndTimeError.value,
          hintText: APPStrings.textEndTime.translate(),
        ),
      );
    }

    /// [selectWeekDay] This is widget is use for multi selection dropDown
    Widget selectWeekDay() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          JustTheTooltip(
            controller: tooltipController,
            tailBaseWidth: 0,
            margin: const EdgeInsets.only(
                left: Dimens.margin15, right: Dimens.margin15),
            isModal: true,
            barrierDismissible: true,
            borderRadius:
                const BorderRadius.all(Radius.circular(Dimens.margin10)),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: Dimens.margin300,
              child: MultiSelectDropDown(
                mWeekDayModel: mListWeekDay.value,
                onPressed: (value) {
                  isWeekDaysError.value = '';
                  mListSelectedWeek.value.clear();
                  mListWeekDay.value = value;
                  for (int i = 0; i < mListWeekDay.value.length; i++) {
                    if (mListWeekDay.value[i].isSelected!) {
                      mListSelectedWeek.value
                          .add(mListWeekDay.value[i].weekName.toString());
                    }
                  }
                  tooltipController.hideTooltip();
                  setState(() {});
                },
              ),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: Dimens.margin50,
              padding: const EdgeInsets.only(
                  top: Dimens.margin3, bottom: Dimens.margin3),
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.all(Radius.circular(Dimens.margin16)),
                color: Theme.of(context).dividerColor,
              ),
              clipBehavior: Clip.hardEdge,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  mListSelectedWeek.value.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: mListWeekDay.value.length,
                              itemBuilder: (BuildContext context, int index) {
                                var item = mListWeekDay.value[index];
                                return mListWeekDay.value[index].isSelected!
                                    ? Container(
                                        margin: const EdgeInsets.all(
                                            Dimens.margin3),
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surfaceVariant,
                                          border: Border.all(
                                              width: Dimens.margin05,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surfaceVariant),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(Dimens.margin25)),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: Dimens.margin15),
                                              child: Text(
                                                  item.weekName.toString(),
                                                  style: getTextStyleFontWeight(
                                                      Theme.of(context)
                                                          .primaryTextTheme
                                                          .labelSmall!,
                                                      Dimens.margin12,
                                                      FontWeight.w400)),
                                            ),
                                            const SizedBox(
                                                width: Dimens.margin8),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: Dimens.margin10),
                                              child: InkWell(
                                                  onTap: () {
                                                    mListWeekDay.value[index]
                                                        .isSelected = false;
                                                    if (mListWeekDay
                                                            .value[index]
                                                            .isSelected! ==
                                                        true) {
                                                      mListSelectedWeek.value
                                                          .add(mListWeekDay
                                                              .value[index]
                                                              .weekName
                                                              .toString());
                                                    } else {
                                                      mListSelectedWeek.value
                                                          .remove(mListWeekDay
                                                              .value[index]
                                                              .weekName
                                                              .toString());
                                                    }
                                                    setState(() {});
                                                  },
                                                  child: const Icon(Icons.close,
                                                      color:
                                                          AppColors.color707070,
                                                      size: Dimens.margin18)),
                                            ),
                                            const SizedBox(
                                                width: Dimens.margin3),
                                          ],
                                        ))
                                    : const SizedBox();
                              }))
                      : Expanded(
                          child: Container(
                            margin:
                                const EdgeInsets.only(left: Dimens.margin15),
                            child: Text(
                              APPStrings.textSelectWeekDays.translate(),
                              style: getTextStyleFontWeight(
                                  Theme.of(context)
                                      .primaryTextTheme
                                      .displaySmall!,
                                  Dimens.margin15,
                                  FontWeight.w400),
                            ),
                          ),
                        ),
                  const SizedBox(
                    width: Dimens.margin10,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: Dimens.margin15),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          APPImages.icDropDownArrow,
                          width: Dimens.margin13,
                          height: Dimens.margin11,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          if (isWeekDaysError.value.isNotEmpty) ...[
            const SizedBox(height: Dimens.margin10),
            BaseTextFieldErrorIndicator(
              errorText: isWeekDaysError.value,
            ),
          ]
        ],
      );
    }

    /// [selectSkill]  is used to display multi selection skill
    Widget selectSkill() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
                text: APPStrings.textSkills.translate(),
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.bodySmall!,
                    Dimens.margin12,
                    FontWeight.normal),
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
          JustTheTooltip(
            controller: tooltipSkillController,
            tailBaseWidth: 0,
            margin: const EdgeInsets.only(
                left: Dimens.margin15, right: Dimens.margin15),
            isModal: true,
            barrierDismissible: true,
            borderRadius:
                const BorderRadius.all(Radius.circular(Dimens.margin10)),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: Dimens.margin300,
              child: SkillMultiSelectDropDown(
                mSkills: mSkillList.value,
                onPressed: (value) {
                  isSkillDaysError.value = '';
                  mListSelectedSkill.value.clear();
                  mSkillList.value = value;
                  for (int i = 0; i < mSkillList.value.length; i++) {
                    if (mSkillList.value[i].isSelected!) {
                      mListSelectedSkill.value
                          .add(mSkillList.value[i].name.toString());
                    }
                  }
                  tooltipSkillController.hideTooltip();
                  setState(() {});
                },
              ),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: Dimens.margin50,
              padding: const EdgeInsets.only(
                  top: Dimens.margin3, bottom: Dimens.margin3),
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.all(Radius.circular(Dimens.margin16)),
                color: Theme.of(context).dividerColor,
              ),
              clipBehavior: Clip.hardEdge,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: Dimens.margin15),
                      child: Text(
                        APPStrings.textSelectYourSkills.translate(),
                        style: getTextStyleFontWeight(
                            Theme.of(context).primaryTextTheme.displaySmall!,
                            Dimens.margin15,
                            FontWeight.w400),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: Dimens.margin10,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: Dimens.margin15),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          APPImages.icDropDownArrow,
                          width: Dimens.margin13,
                          height: Dimens.margin11,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          if (isSkillDaysError.value.isNotEmpty) ...[
            const SizedBox(height: Dimens.margin10),
            BaseTextFieldErrorIndicator(
              errorText: isSkillDaysError.value,
            ),
          ]
        ],
      );
    }

    /// [selectAvailability]  is used to display selection availability
    Widget selectAvailability() {
      return isAvailabilitySelected.value
          ? Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: startTime()),
                    const SizedBox(
                      width: Dimens.margin11,
                    ),
                    Expanded(child: endTime())
                  ],
                ),
                const SizedBox(
                  height: Dimens.margin20,
                ),
                selectWeekDay(),
                const SizedBox(height: Dimens.margin30),
              ],
            )
          : const SizedBox();
    }

    /// [availability]  is used to display availability text
    Widget availability() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
                text: APPStrings.textAvailability.translate(),
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.bodySmall!,
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
          const SizedBox(
            height: Dimens.margin11,
          ),
          Row(
            children: [
              CustomButton(
                height: Dimens.margin50,
                width: Dimens.margin113,
                backgroundColor: !isAvailabilitySelected.value
                    ? Theme.of(context).colorScheme.surfaceTint
                    : Theme.of(context).highlightColor,
                buttonText: APPStrings.text24hour.translate(),
                style: getTextStyleFontWeight(
                    !isAvailabilitySelected.value
                        ? Theme.of(context).primaryTextTheme.labelSmall!
                        : Theme.of(context).primaryTextTheme.displaySmall!,
                    Dimens.margin15,
                    FontWeight.w400),
                borderRadius: Dimens.margin15_5,
                onPress: () {
                  printWrapped('Click1');
                  isAvailabilitySelected.value = false;
                },
              ),
              const SizedBox(
                width: Dimens.margin10,
              ),
              CustomButton(
                height: Dimens.margin50,
                width: Dimens.margin113,
                backgroundColor: isAvailabilitySelected.value
                    ? Theme.of(context).colorScheme.surfaceTint
                    : Theme.of(context).highlightColor,
                buttonText: APPStrings.textCustom.translate(),
                style: getTextStyleFontWeight(
                    isAvailabilitySelected.value
                        ? Theme.of(context).primaryTextTheme.labelSmall!
                        : Theme.of(context).primaryTextTheme.displaySmall!,
                    Dimens.margin15,
                    FontWeight.w400),
                borderRadius: Dimens.margin15_5,
                onPress: () {
                  isAvailabilitySelected.value = true;
                },
              )
            ],
          ),
          const SizedBox(
            height: Dimens.margin20,
          ),
          selectAvailability()
        ],
      );
    }

    ///[textAddress] is used for text input of address name input in screen
    Widget textAddress() {
      return BaseTextFormFieldSuffix(
        controller: addressController,
        focusNode: addressFocus,
        nextFocusNode: addressFocus,
        isRequired: true,
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textAddress.translate(),
        suffixIcon: Container(
          padding: const EdgeInsets.all(Dimens.margin14),
          child: SvgPicture.asset(
            APPImages.icUser,
            colorFilter:
                const ColorFilter.mode(AppColors.color7E7E7E, BlendMode.srcIn),
          ),
        ),
        onChange: () {
          if (isAddressError.value.isNotEmpty) {
            isAddressError.value = '';
          }
        },
        errorText: isAddressError.value,
        hintText: APPStrings.textAddress1.translate(),

        // hintText: 'Enter First Name',
      );
    }

    ///[textCountry] is used for text input of country name input in screen
    Widget textCountry() {
      return BaseTextFormFieldSuffix(
        controller: countryController,
        focusNode: countryFocus,
        nextFocusNode: stateFocus,
        isRequired: true,
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textCountry.translate(),
        onChange: () {
          if (isCountryError.value.isNotEmpty) {
            isCountryError.value = '';
          }
        },
        errorText: isCountryError.value,
        hintText: APPStrings.textEnterCountry.translate(),

        // hintText: 'Enter First Name',
      );
    }

    ///[textState] is used for text input of state name input in screen
    Widget textState() {
      return BaseTextFormFieldSuffix(
        controller: stateController,
        focusNode: stateFocus,
        nextFocusNode: cityFocus,
        isRequired: true,
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textState.translate(),
        onChange: () {
          if (isStateError.value.isNotEmpty) {
            isStateError.value = '';
          }
        },
        errorText: isStateError.value,
        hintText: APPStrings.textEnterState.translate(),

        // hintText: 'Enter First Name',
      );
    }

    ///[textCity] is used for text input of city name input in screen
    Widget textCity() {
      return BaseTextFormFieldSuffix(
        controller: cityController,
        focusNode: cityFocus,
        nextFocusNode: zipcodeFocus,
        isRequired: true,
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textCity.translate(),
        onChange: () {
          if (isCityError.value.isNotEmpty) {
            isCityError.value = '';
          }
        },
        errorText: isCityError.value,
        hintText: APPStrings.textEnterCity.translate(),

        // hintText: 'Enter First Name',
      );
    }

    ///[textZipCode] is used for text input of zipcode name input in screen
    Widget textZipCode() {
      return BaseTextFormFieldSuffix(
        controller: zipcodeController,
        focusNode: zipcodeFocus,
        nextFocusNode: dateOfBirthFocus,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        isRequired: true,
        maxLength: 8,
        titleText: APPStrings.textZipcode.translate(),
        inputFormatters: <TextInputFormatter>[
          MaskTextInputFormatter(mask: AppConfig.maskingZipCodeInput),
        ],
        onChange: () {
          if (isZipcodeError.value.isNotEmpty) {
            isZipcodeError.value = '';
          }
        },
        errorText: isZipcodeError.value,
        hintText: APPStrings.textEnterZipcode.translate(),

        // hintText: 'Enter First Name',
      );
    }

    ///[dateOfBirth] is used for text input of date of birth input in screen
    Widget dateOfBirth() {
      return InkWell(
        onTap: () {
          _pickDate(false);
        },
        child: BaseTextFormFieldSuffix(
          controller: dateOfBirthController,
          focusNode: dateOfBirthFocus,
          nextFocusNode: dateOfBirthFocus,
          isRequired: true,
          enabled: false,
          textInputAction: TextInputAction.next,
          titleText: APPStrings.textDateOfBirth.translate(),
          suffixIcon: Container(
            padding: const EdgeInsets.all(Dimens.margin14),
            child: SvgPicture.asset(
              APPImages.icCalender,
            ),
          ),
          errorText: isDateOfBirthError.value,
          hintText: APPStrings.warningSelectYourDateOfBirth.translate(),
        ),
      );
    }

    ///[textAccountHolder] is used for text input of account holder name input in screen
    Widget textAccountHolder() {
      return BaseTextFormFieldSuffix(
        controller: accountHolderController,
        focusNode: accountHolderFocus,
        nextFocusNode: accountHolderFocus,
        isRequired: true,
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textAccountHolderName.translate(),
        suffixIcon: Container(
          padding: const EdgeInsets.all(Dimens.margin14),
          child: SvgPicture.asset(
            APPImages.icUser,
            colorFilter:
                const ColorFilter.mode(AppColors.color7E7E7E, BlendMode.srcIn),
          ),
        ),
        onChange: () {
          if (isAccountHolderError.value.isNotEmpty) {
            isAccountHolderError.value = '';
          }
        },
        errorText: isAccountHolderError.value,
        hintText: APPStrings.textEnterAccountHolderName.translate(),

        // hintText: 'Enter First Name',
      );
    }

    ///[textBankName] is used for text input of bank name input in screen
    Widget textBankName() {
      return BaseTextFormFieldSuffix(
        controller: bankNameController,
        focusNode: bankNameFocus,
        nextFocusNode: achRoutingFocus,
        isRequired: true,
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textBankName.translate(),
        suffixIcon: Container(
          padding: const EdgeInsets.all(Dimens.margin14),
          child: SvgPicture.asset(
            APPImages.icBankName,
          ),
        ),
        onChange: () {
          if (isBankNameError.value.isNotEmpty) {
            isBankNameError.value = '';
          }
        },
        errorText: isBankNameError.value,
        hintText: APPStrings.textEnterYourBankName.translate(),

        // hintText: 'Enter First Name',
      );
    }

    ///[textBankAccount] is used for text input of bank account  input in screen
    Widget textBankAccount() {
      return BaseTextFormFieldSuffix(
        controller: bankAccountController,
        focusNode: bankAccountFocus,
        nextFocusNode: achRoutingFocus,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        isRequired: true,
        titleText: APPStrings.textBankAccountNumber.translate(),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        suffixIcon: Container(
          padding: const EdgeInsets.all(Dimens.margin14),
          child: SvgPicture.asset(
            APPImages.icBankName,
          ),
        ),
        onChange: () {
          if (isBankAccountError.value.isNotEmpty) {
            isBankAccountError.value = '';
          }
        },
        errorText: isBankAccountError.value,
        hintText: APPStrings.textEnterBankAccountNumber.translate(),

        // hintText: 'Enter First Name',
      );
    }

    ///[textACHRouting] is used for text input of ach routing input in screen
    Widget textACHRouting() {
      return BaseTextFormFieldSuffix(
        controller: achRoutingController,
        focusNode: achRoutingFocus,
        nextFocusNode: bankAddressFocus,
        isRequired: true,
        maxLength: 9,
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textAchRoutingNumber.translate(),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        suffixIcon: Container(
          padding: const EdgeInsets.all(Dimens.margin14),
          child: SvgPicture.asset(
            APPImages.icBankName,
          ),
        ),
        onChange: () {
          if (isACHRoutingError.value.isNotEmpty) {
            isACHRoutingError.value = '';
          }
        },
        errorText: isACHRoutingError.value,
        hintText: APPStrings.textEnterYourAchRoutingNumber.translate(),

        // hintText: 'Enter First Name',
      );
    }

    ///[textBankAddress] is used for text input of ach bank address input in screen
    Widget textBankAddress() {
      return BaseTextFormFieldSuffix(
        controller: bankAddressController,
        focusNode: bankAddressFocus,
        nextFocusNode: bankAddressFocus,
        textInputAction: TextInputAction.next,
        isRequired: true,
        titleText: APPStrings.textBankAddress.translate(),
        onChange: () {
          if (isBankAddressError.value.isNotEmpty) {
            isBankAddressError.value = '';
          }
        },
        errorText: isBankAddressError.value,
        hintText: APPStrings.textAddress1.translate(),

        // hintText: 'Enter First Name',
      );
    }

    ///[textBankCountry] is used for text input of country name input in screen
    Widget textBankCountry() {
      return BaseTextFormFieldSuffix(
        controller: bankCountryController,
        focusNode: bankCountryFocus,
        nextFocusNode: bankStateFocus,
        isRequired: true,
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textCountry.translate(),
        onChange: () {
          if (isBankCountryError.value.isNotEmpty) {
            isBankCountryError.value = '';
          }
        },
        errorText: isBankCountryError.value,
        hintText: APPStrings.textEnterCountry.translate(),

        // hintText: 'Enter First Name',
      );
    }

    ///[textBankState] is used for text input of state name input in screen
    Widget textBankState() {
      return BaseTextFormFieldSuffix(
        controller: bankStateController,
        focusNode: bankStateFocus,
        nextFocusNode: bankCityFocus,
        isRequired: true,
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textState.translate(),
        onChange: () {
          if (isBankStateError.value.isNotEmpty) {
            isBankStateError.value = '';
          }
        },
        errorText: isBankStateError.value,
        hintText: APPStrings.textEnterState.translate(),

        // hintText: 'Enter First Name',
      );
    }

    ///[textBankCity] is used for text input of city name input in screen
    Widget textBankCity() {
      return BaseTextFormFieldSuffix(
        controller: bankCityController,
        focusNode: bankCityFocus,
        nextFocusNode: bankZipcodeFocus,
        isRequired: true,
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textCity.translate(),
        onChange: () {
          if (isBankCityError.value.isNotEmpty) {
            isBankCityError.value = '';
          }
        },
        errorText: isBankCityError.value,
        hintText: APPStrings.textEnterCity.translate(),

        // hintText: 'Enter First Name',
      );
    }

    ///[textBankZipCode] is used for text input of zipcode name input in screen
    Widget textBankZipCode() {
      return BaseTextFormFieldSuffix(
        controller: bankZipcodeController,
        focusNode: bankZipcodeFocus,
        isRequired: true,
        textInputAction: TextInputAction.done,
        titleText: APPStrings.textZipcode.translate(),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          MaskTextInputFormatter(mask: AppConfig.maskingZipCodeInput),
        ],
        onChange: () {
          if (isBankZipcodeError.value.isNotEmpty) {
            isBankZipcodeError.value = '';
          }
        },
        errorText: isBankZipcodeError.value,
        hintText: APPStrings.textEnterZipcode.translate(),

        // hintText: 'Enter First Name',
      );
    }

    ///[bankDetail] is used for bank detail part
    Widget bankDetail() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(APPStrings.textBankDetails.translate(),
              style: getTextStyleFontWeight(
                  AppFont.regularColorBlack, Dimens.margin15, FontWeight.w600)),
          const SizedBox(
            height: Dimens.margin10,
          ),
          textAccountHolder(),
          const SizedBox(
            height: Dimens.margin30,
          ),
          textBankName(),
          const SizedBox(
            height: Dimens.margin30,
          ),
          textBankAccount(),
          const SizedBox(
            height: Dimens.margin30,
          ),
          textACHRouting(),
          const SizedBox(
            height: Dimens.margin30,
          ),
          textBankAddress(),
          const SizedBox(
            height: Dimens.margin30,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: textBankCountry()),
              const SizedBox(width: Dimens.margin10),
              Expanded(child: textBankState())
            ],
          ),
          const SizedBox(
            height: Dimens.margin30,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: textBankCity()),
              const SizedBox(width: Dimens.margin10),
              Expanded(child: textBankZipCode())
            ],
          ),
        ],
      );
    }

    ///[textUploadFrontImage] is used for text input of front image input in screen
    Widget textUploadFrontImage() {
      return InkWell(
        onTap: () {
          selectDrivingLicence(true);
        },
        child: BaseTextFormFieldSuffix(
          textInputAction: TextInputAction.next,
          suffixIcon: Container(
            padding: const EdgeInsets.all(Dimens.margin14),
            child: SvgPicture.asset(
              APPImages.icUploadFile,
            ),
          ),
          enabled: false,
          isRequired: false,
          onChange: () {},
          hintText: selectFrontDrivingLicence != null
              ? selectFrontDrivingLicence!.path.split('/').last
              : APPStrings.textUploadFrontImage.translate(),
          hintStyle: selectFrontDrivingLicence != null
              ? getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.bodySmall!,
                  Dimens.textSize15,
                  FontWeight.normal)
              : null,

          // hintText: 'Enter First Name',
        ),
      );
    }

    ///[textUploadBackImage] is used for text input of back image input in screen
    Widget textUploadBackImage() {
      return InkWell(
        onTap: () {
          selectDrivingLicence(false);
        },
        child: BaseTextFormFieldSuffix(
          textInputAction: TextInputAction.next,
          suffixIcon: Container(
            padding: const EdgeInsets.all(Dimens.margin14),
            child: SvgPicture.asset(
              APPImages.icUploadFile,
            ),
          ),
          enabled: false,
          isRequired: false,
          onChange: () {},
          hintText: selectBackDrivingLicence != null
              ? selectBackDrivingLicence!.path.split('/').last
              : APPStrings.textUploadBackImage.translate(),
          hintStyle: selectBackDrivingLicence != null
              ? getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.bodySmall!,
                  Dimens.textSize15,
                  FontWeight.normal)
              : null,

          // hintText: 'Enter First Name',
        ),
      );
    }

    Widget drivingLicence() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(APPStrings.textDrivingLicense.translate(),
              style: getTextStyleFontWeight(
                  AppFont.regularColorBlack, Dimens.margin15, FontWeight.w600)),
          const SizedBox(
            height: Dimens.margin10,
          ),
          Text(APPStrings.textDrivingLicense1.translate(),
              style: getTextStyleFontWeight(AppFont.regularColor7E7E7E,
                  Dimens.margin12, FontWeight.w400)),
          const SizedBox(
            height: Dimens.margin20,
          ),
          textUploadFrontImage(),
          const SizedBox(
            height: Dimens.margin20,
          ),
          textUploadBackImage(),
          const SizedBox(
            height: Dimens.margin28,
          ),
          submitButton()
        ],
      );
    }

    ///[mobileSignUpForm] this method is used for mobile signUpn screen
    Widget mobileSignUpForm() {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Dimens.margin20),
            availability(),
            selectSkill(),
            const SizedBox(height: Dimens.margin20),
            Wrap(
              spacing: Dimens.margin10,
              runSpacing: Dimens.margin10,
              children: List.generate(
                  mSkillList.value.length,
                  (index) => mSkillList.value[index].isSelected!
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                padding: const EdgeInsets.all(Dimens.margin5),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceVariant,
                                  border: Border.all(
                                      width: Dimens.margin05,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceVariant),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(Dimens.margin25)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: Dimens.margin15),
                                      child: Text(
                                          mSkillList.value[index].name
                                              .toString(),
                                          style: getTextStyleFontWeight(
                                              Theme.of(context)
                                                  .primaryTextTheme
                                                  .labelSmall!,
                                              Dimens.margin12,
                                              FontWeight.w400)),
                                    ),
                                    const SizedBox(width: Dimens.margin8),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          right: Dimens.margin10),
                                      child: InkWell(
                                          onTap: () {
                                            mSkillList.value[index].isSelected =
                                                false;
                                            if (mSkillList
                                                    .value[index].isSelected! ==
                                                true) {
                                              mListSelectedSkill.value.add(
                                                  mSkillList.value[index].name
                                                      .toString());
                                            } else {
                                              mListSelectedSkill.value.remove(
                                                  mSkillList.value[index].name
                                                      .toString());
                                            }
                                            setState(() {});
                                          },
                                          child: const Icon(Icons.close,
                                              color: AppColors.color707070,
                                              size: Dimens.margin18)),
                                    ),
                                    const SizedBox(width: Dimens.margin3),
                                  ],
                                )),
                          ],
                        )
                      : const SizedBox()),
            ),
            const SizedBox(height: Dimens.margin10),
            textAddress(),
            const SizedBox(height: Dimens.margin30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: textCountry()),
                const SizedBox(width: Dimens.margin10),
                Expanded(child: textState())
              ],
            ),
            const SizedBox(height: Dimens.margin30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: textCity()),
                const SizedBox(width: Dimens.margin10),
                Expanded(child: textZipCode())
              ],
            ),
            const SizedBox(height: Dimens.margin30),
            dateOfBirth(),
            const SizedBox(height: Dimens.margin30),
            bankDetail(),
            const SizedBox(height: Dimens.margin30),
            drivingLicence(),
            const SizedBox(height: Dimens.margin40),
          ],
        ),
      );
    }

    ///[mBody] is used to get Mobile view body
    Widget mBody() {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: Dimens.margin16),
        color: Theme.of(context).colorScheme.background,
        child: mobileSignUpForm(),
      );
    }

    ///[getAppbar] is used to get Appbar for different views i.e. Mobile and Web
    BaseAppBar getAppbar() {
      return BaseAppBar(
        appBar: AppBar(
          toolbarHeight: Dimens.margin70,
        ),
        title: APPStrings.textCompleteYourProfile.translate(),
        mLeftImage: APPImages.icArrowBack,
        mLeftAction: () {
          goToHome();
        },
        textStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.titleLarge!,
            Dimens.textSize18,
            FontWeight.w600),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [textSkip()],
      );
    }

    return MultiValueListenableBuilder(
        valueListenables: [
          mLoading,
          isStartTimeError,
          isEndTimeError,
          selectedSourceProviderNotifier,
          isAddressError,
          isCountryError,
          isStateError,
          isCityError,
          isZipcodeError,
          isDateOfBirthError,
          isAccountHolderError,
          isBankNameError,
          isACHRoutingError,
          isBankAddressError,
          isAvailabilitySelected,
          mListWeekDay,
          mListSelectedWeek,
          isWeekDaysError,
          isBankAccountError,
          isBankCountryError,
          isBankStateError,
          isBankCityError,
          isBankZipcodeError,
          mSkillList,
          mListSelectedSkill,
          isSkillDaysError
        ],
        builder: (context, values, Widget? child) {
          return ModalProgressHUD(
            inAsyncCall: mLoading.value,
            progressIndicator: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
            child: WillPopScope(
              onWillPop: () async {
                goToHome();
                return true;
              },
              child: Scaffold(
                appBar: getAppbar(),
                backgroundColor: Theme.of(context).primaryColor,
                body: mBody(),
              ),
            ),
          );
        });
  }

  ///[_pickTime] this method use to Android, iOS and web date picker
  void _pickTime(bool isStart, {ValueNotifier<String>? errorNotifier}) async {
    DateTime mNewTime = DateTime.now();
    DateTime initialDateTime = DateTime.now();
    TimeOfDay initialTime = TimeOfDay.now();

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
                        setTime(TimeOfDay.fromDateTime(mNewTime), isStart,
                            errorNotifier: errorNotifier);
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
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
        initialEntryMode: TimePickerEntryMode.dial,
        helpText: '',
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
        setTime(value, isStart, errorNotifier: errorNotifier);
      }
    });*/
  }

  ///[_pickDate] this method use to Android, iOS and web date picker
  void _pickDate(bool isStart) async {
    FocusScope.of(context).requestFocus(FocusNode());

    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime.utc(1900),
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
    // dateOfBirthController.text =
    //     formatDate(setDate, AppConfig.dateFormatYYYYMMDD);
    dateOfBirthController.text =
        formatOnlyDate(formatDate(setDate, AppConfig.dateFormatDDMMYYYYHHMMSS));
    setState(() {});
  }

  ///[setTime] this method use to set date is per the picker status
  void setTime(TimeOfDay setDate, bool isStart,
      {ValueNotifier<String>? errorNotifier}) {
    if (errorNotifier != null) {
      errorNotifier.value = '';
    }
    if (isStart) {
      startTimeController.text =
          formatTime(setDate, AppConfig.timeFormatHHMMSS);
    } else {
      endTimeController.text = formatTime(setDate, AppConfig.timeFormatHHMMSS);
    }
    setState(() {});
  }

  Future<void> selectDrivingLicence(bool isFirst) async {
    await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
          content: Text(
            APPStrings.textChooseImageSource.translate(),
            style: getTextStyleFontWeight(
                Theme.of(context).primaryTextTheme.labelMedium!,
                Dimens.textSize18,
                FontWeight.w600),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              child: Text(APPStrings.textCamera.translate()),
              onPressed: () => Navigator.pop(context, ImageSource.camera),
            ),
            TextButton(
              child: Text(APPStrings.textGallery.translate()),
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ]),
    ).then((ImageSource? source) async {
      if (source != null) {
        await ImagePicker().pickImage(source: source).then((pickedFile) {
          if (pickedFile != null) {
            ImageCropper.platform.cropImage(
              sourcePath: pickedFile.path,
              compressQuality: 50,
              aspectRatioPresets: [CropAspectRatioPreset.square],
            ).then((croppedImage) {
              if (croppedImage != null) {
                setState(() {
                  if (isFirst) {
                    selectFrontDrivingLicence = File(croppedImage.path);
                  } else {
                    selectBackDrivingLicence = File(croppedImage.path);
                  }
                });
              }
            });
          }
        });
      }
    });
  }

  ///[validateSignUpData] this method is used to validate input formats of signUp data
  Future<void> validateProfileSubmitData(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (isAvailabilitySelected.value && startTimeController.text.isEmpty) {
      /// startTimeFocus.requestFocus();
      isStartTimeError.value = APPStrings.textStartTime.translate();
    }
    if (isAvailabilitySelected.value && endTimeController.text.isEmpty) {
      /// endTimeFocus.requestFocus();
      isEndTimeError.value = APPStrings.textEndTime.translate();
    }
    if (mListSelectedWeek.value.isEmpty) {
      isWeekDaysError.value = APPStrings.textSelectWeekDays.translate();

      /// ToastController.showToast(APPStrings.textSelectWeekDays.translate(), context, false);
    }
    if (mListSelectedSkill.value.isEmpty) {
      isSkillDaysError.value = APPStrings.textSelectYourSkills.translate();
    }
    if (addressController.text.isEmpty) {
      /// addressFocus.requestFocus();
      isAddressError.value = APPStrings.textAddress.translate();
    }
    if (countryController.text.isEmpty) {
      /// countryFocus.requestFocus();
      isCountryError.value = APPStrings.textEnterCountry.translate();
    }
    if (stateController.text.isEmpty) {
      ///  stateFocus.requestFocus();
      isStateError.value = APPStrings.textEnterState.translate();
    }
    if (cityController.text.isEmpty) {
      ///  cityFocus.requestFocus();
      isCityError.value = APPStrings.textEnterCity.translate();
    }
    if ((bankZipcodeController.text.isEmpty) ||
        (bankZipcodeController.text.length != 5 &&
            bankZipcodeController.text.length != 10)) {
      /// zipcodeFocus.requestFocus();
      isZipcodeError.value =
          ValidationString.validationInvalidZipCode.translate();
    }
    if (accountHolderController.text.isEmpty) {
      /// accountHolderFocus.requestFocus();
      isAccountHolderError.value =
          APPStrings.textEnterAccountHolderName.translate();
    }
    if (bankNameController.text.isEmpty) {
      /// bankNameFocus.requestFocus();
      isBankNameError.value = APPStrings.textEnterYourBankName.translate();
    }
    if (!validateBankAccount(bankAccountController.text)) {
      /// bankAccountFocus.requestFocus();
      isBankAccountError.value =
          ValidationString.validationInvalidBankAccountNumber.translate();
    }
    if (!validateACHAccount(achRoutingController.text)) {
      ///  achRoutingFocus.requestFocus();
      isACHRoutingError.value =
          ValidationString.validationInvalidAchRoutingNumber.translate();
    }
    if (bankAddressController.text.isEmpty) {
      /// bankAddressFocus.requestFocus();
      isBankAddressError.value = APPStrings.textAddress1.translate();
    }
    if (bankCountryController.text.isEmpty) {
      /// bankCountryFocus.requestFocus();
      isBankCountryError.value = APPStrings.textEnterCountry.translate();
    }
    if (bankStateController.text.isEmpty) {
      /// bankStateFocus.requestFocus();
      isBankStateError.value = APPStrings.textEnterState.translate();
    }
    if (bankCityController.text.isEmpty) {
      /// bankCityFocus.requestFocus();
      isBankCityError.value = APPStrings.textEnterCity.translate();
    }
    if ((bankZipcodeController.text.isEmpty) ||
        (bankZipcodeController.text.length != 5 &&
            bankZipcodeController.text.length != 10)) {
      ///  bankZipcodeFocus.requestFocus();
      isBankZipcodeError.value =
          ValidationString.validationInvalidZipCode.translate();
    }

    if (isAvailabilitySelected.value) {
      if (startTimeController.text.isNotEmpty &&
          endTimeController.text.isNotEmpty &&
          mListSelectedWeek.value.isNotEmpty &&
          mListSelectedSkill.value.isNotEmpty &&
          addressController.text.isNotEmpty &&
          countryController.text.isNotEmpty &&
          stateController.text.isNotEmpty &&
          cityController.text.isNotEmpty &&
          zipcodeController.text.isNotEmpty &&
          accountHolderController.text.isNotEmpty &&
          bankNameController.text.isNotEmpty &&
          bankAccountController.text.isNotEmpty &&
          achRoutingController.text.isNotEmpty &&
          bankAddressController.text.isNotEmpty &&
          bankCountryController.text.isNotEmpty &&
          bankStateController.text.isNotEmpty &&
          bankCityController.text.isNotEmpty &&
          bankZipcodeController.text.isNotEmpty) {
        Navigator.pushNamed(context, AppRoutes.routesSendRequestKYC);
      }
    } else {
      if (mListSelectedSkill.value.isNotEmpty &&
          addressController.text.isNotEmpty &&
          countryController.text.isNotEmpty &&
          stateController.text.isNotEmpty &&
          cityController.text.isNotEmpty &&
          zipcodeController.text.isNotEmpty &&
          accountHolderController.text.isNotEmpty &&
          bankNameController.text.isNotEmpty &&
          bankAccountController.text.isNotEmpty &&
          achRoutingController.text.isNotEmpty &&
          bankAddressController.text.isNotEmpty &&
          bankCountryController.text.isNotEmpty &&
          bankStateController.text.isNotEmpty &&
          bankCityController.text.isNotEmpty &&
          bankZipcodeController.text.isNotEmpty) {
        Navigator.pushNamed(context, AppRoutes.routesSendRequestKYC);
      }
    }
  }

  /// Navigating to the dashboard screen and removing all the screens from the stack.
  void goToHome() {
    NavigatorKey.navigatorKey.currentState!.pushNamedAndRemoveUntil(
      AppRoutes.routesDashboard,
      (route) => false,
    );
  }
}

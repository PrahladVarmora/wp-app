import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/model_picked_location.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/pick_result.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/place_picker.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/masters/model/model_skill.dart';
import 'package:we_pro/modules/profile/bloc/update_profile/update_profile_bloc.dart';
import 'package:we_pro/modules/profile/model/model_get_profile.dart';

import '../../core/utils/core_import.dart';

///[ScreenEditProfessionalDetail] this class is used for Profile Completion screen
class ScreenEditProfessionalDetail extends StatefulWidget {
  final bool isFromDashboard;

  const ScreenEditProfessionalDetail({Key? key, this.isFromDashboard = false})
      : super(key: key);

  @override
  State<ScreenEditProfessionalDetail> createState() =>
      _ScreenEditProfessionalDetailState();
}

class _ScreenEditProfessionalDetailState
    extends State<ScreenEditProfessionalDetail> {
  ValueNotifier<bool> mLoading = ValueNotifier(false);
  ValueNotifier<bool> isAvailabilitySelected = ValueNotifier(false);
  ValueNotifier<String> isWeekDaysError = ValueNotifier('');
  ValueNotifier<String> isSkillDaysError = ValueNotifier('');
  ValueNotifier<String> isSelectSourceError = ValueNotifier('');
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
  ValueNotifier<String> isACHRoutingError = ValueNotifier('');
  ValueNotifier<String> isBankAddressError = ValueNotifier('');
  ValueNotifier<String> isBankAccountError = ValueNotifier('');
  ValueNotifier<String> selectedSourceProviderNotifier =
      ValueNotifier<String>(APPStrings.warningSelectSourceProvider.translate());

  /// text edit controller
  // TextEditingController startTimeController = TextEditingController();
  // TextEditingController endTimeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController addressController1 = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();
  TextEditingController latLngController = TextEditingController();
  TextEditingController placeIdController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();

  /// focusable
  FocusNode startTimeFocus = FocusNode();
  FocusNode endTimeFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode addressFocus1 = FocusNode();
  FocusNode countryFocus = FocusNode();
  FocusNode stateFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode zipcodeFocus = FocusNode();
  FocusNode dateOfBirthFocus = FocusNode();

  List<Skills> listSkillModel = [];

  DateTime dateOfBirthDateTime = DateTime.now();

  ValueNotifier<File> selectFrontDrivingLicence = ValueNotifier(File(''));
  ValueNotifier<File> selectBackDrivingLicence = ValueNotifier(File(''));

  ValueNotifier<ModelPickedLocation> mModelPickedLocation =
      ValueNotifier(ModelPickedLocation());
  ValueNotifier<PickResult> mModelPickResult = ValueNotifier(PickResult());
  ModelGetProfile mModelGetProfile = ModelGetProfile();

  @override
  void initState() {
    mModelGetProfile = getProfileData();
    setInitData();
    super.initState();
  }

  void setInitData() {
    addressController.text = mModelGetProfile.profile?.address ?? '';
    addressController1.text = mModelGetProfile.profile?.location ?? '';
    countryController.text = mModelGetProfile.profile?.country ?? '';
    stateController.text = mModelGetProfile.profile?.state ?? '';
    cityController.text = mModelGetProfile.profile?.city ?? '';
    zipcodeController.text = mModelGetProfile.profile?.zip ?? '';
    dateOfBirthDateTime = convertStringToDateFormat(
        mModelGetProfile.profile?.dob ?? '', AppConfig.dateFormatYYYYMMDD);
    dateOfBirthController.text = formatOnlyDate(
        formatDate(dateOfBirthDateTime, AppConfig.dateFormatDDMMYYYYHHMMSS));
    mModelPickedLocation.value.longitude =
        double.tryParse(mModelGetProfile.profile?.lng) ??
            MyAppState.mCurrentPosition.value.longitude;
    mModelPickedLocation.value.latitude =
        double.tryParse(mModelGetProfile.profile?.lat) ??
            MyAppState.mCurrentPosition.value.latitude;
    mModelPickedLocation.value.addressZip = mModelGetProfile.profile?.zip ?? '';
    mModelPickedLocation.value.placeId =
        mModelGetProfile.profile?.placeId ?? '';
    mModelPickedLocation.value.addressCountry =
        mModelGetProfile.profile?.country ?? '';
    mModelPickedLocation.value.addressState =
        mModelGetProfile.profile?.state ?? '';
    mModelPickedLocation.value.addressCity =
        mModelGetProfile.profile?.city ?? '';
    mModelPickedLocation.value.addressLine =
        mModelGetProfile.profile?.formattedAddress ?? '';
  }

  ///[drivingLicenceUpdateEvent] this method is used to connect to update driving licence
  void drivingLicenceUpdateEvent() async {
    BlocProvider.of<UpdateProfileBloc>(context).add(DrivingLicenceUpdateProfile(
        url: AppUrls.apiDrivingLicence,
        backImageFile: selectBackDrivingLicence.value,
        frontImageFile: selectFrontDrivingLicence.value,
        isFromEdit: true));
  }

  ///[editProfessionalEvent] this method is used to connect to edit professional event api
  void editProfessionalEvent() async {
    Map<String, dynamic> mBody = {
      ApiParams.paramLat: mModelPickedLocation.value.latitude.toString(),
      ApiParams.paramLong: mModelPickedLocation.value.longitude.toString(),
      ApiParams.paramPlaceId: mModelPickedLocation.value.placeId.toString(),
      ApiParams.paramFormattedAddress:
          mModelPickedLocation.value.addressLine.toString(),
      ApiParams.paramLocation: addressController1.text,
      ApiParams.paramAddress: addressController.text,
      ApiParams.paramCity: cityController.text,
      ApiParams.paramZip: zipcodeController.text,
      ApiParams.paramState: stateController.text,
      ApiParams.paramCountry: countryController.text,
      ApiParams.paramDob:
          formatDate(dateOfBirthDateTime, AppConfig.dateFormatYYYYMMDD)
    };
    BlocProvider.of<UpdateProfileBloc>(context).add(UpdateProfileUser(
        body: mBody, url: AppUrls.apiUpdateProfessionalProfile));
  }

  @override
  Widget build(BuildContext context) {
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

/*    ///[startTime] is used for text input of date of start Time input in screen
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
            controller: tooltipWeekController,
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
                      mListSelectedWeekID.value
                          .add(mListWeekDay.value[i].weekId.toString());
                      printWrapped('WeekIdList---${mListSelectedWeekID.value}');
                    }
                  }
                  tooltipWeekController.hideTooltip();
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
                                                      mListSelectedWeekID.value
                                                          .add(mListWeekDay
                                                              .value[index]
                                                              .weekId
                                                              .toString());
                                                      printWrapped(
                                                          'WeekIdList---${mListSelectedWeekID.value}');
                                                    } else {
                                                      mListSelectedWeek.value
                                                          .remove(mListWeekDay
                                                              .value[index]
                                                              .weekName
                                                              .toString());
                                                      mListSelectedWeekID.value
                                                          .remove(mListWeekDay
                                                              .value[index]
                                                              .weekId
                                                              .toString());
                                                      printWrapped(
                                                          'WeekIdList---${mListSelectedWeekID.value}');
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
    }*/
/*

    /// [selectSkill]  is used to display multi selection skill
    Widget selectSkill() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
                text: APPStrings.textSkills.translate(),
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.displaySmall!,
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
*/

    ///[textAddress] is used for text input of address name input in screen
    Widget textAddress() {
      return InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return PlacePicker(
                    isSearch: true,
                    apiKey: AppConfig.googleMapKey,
                    onPickedLocation: (val) {
                      mModelPickedLocation.value = val;
                      addressController1.text =
                          mModelPickedLocation.value.addressLine ?? '';
                      countryController.text =
                          mModelPickedLocation.value.addressCountry ?? '';
                      stateController.text =
                          mModelPickedLocation.value.addressState ?? '';
                      cityController.text =
                          mModelPickedLocation.value.addressCity ?? '';
                      zipcodeController.text =
                          mModelPickedLocation.value.addressZip ?? '';
                      placeIdController.text =
                          mModelPickedLocation.value.placeId ?? '';
                      latLngController.text =
                          '${mModelPickedLocation.value.latitude},${mModelPickedLocation.value.longitude}';
                      Navigator.pop(context);
                    },
                    onPickedLocationResult: (val) {
                      mModelPickResult.value = val;
                      addressController.text = mModelPickResult.value.name ??
                          addressController1.text.substring(
                              0, addressController1.text.indexOf(",", 0));
                    },
                    mModelPickedLocation: mModelPickedLocation.value,
                    initialPosition: MyAppState.mCurrentPosition.value);
              });
        },
        child: BaseTextFormFieldSuffix(
          enabled: false,
          controller: addressController,
          focusNode: addressFocus,
          nextFocusNode: addressFocus1,
          isRequired: true,
          textInputAction: TextInputAction.next,
          titleText: APPStrings.textAddress.translate(),
          suffixIcon: Container(
            padding: const EdgeInsets.all(Dimens.margin14),
            child: SvgPicture.asset(
              APPImages.icUser,
              colorFilter: const ColorFilter.mode(
                  AppColors.color7E7E7E, BlendMode.srcIn),
            ),
          ),
          onChange: () {
            if (isAddressError.value.isNotEmpty) {
              isAddressError.value = '';
            }
          },
          errorText: isAddressError.value,
          hintText: APPStrings.textAddress1.translate(),
        ),
      );
    }

    Widget textAddress2() {
      return BaseTextFormFieldSuffix(
        controller: addressController1,
        focusNode: addressFocus1,
        nextFocusNode: countryFocus,
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textAddressLine2.translate(),
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
        hintText: APPStrings.textAddress2.translate(),
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
        maxLength: 8,
        isRequired: true,
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
      );
    }

    ///[dateOfBirth] is used for text input of date of birth input in screen
    Widget dateOfBirth() {
      return InkWell(
        onTap: () {
          _pickDate();
        },
        child: BaseTextFormFieldSuffix(
          controller: dateOfBirthController,
          focusNode: dateOfBirthFocus,
          // nextFocusNode: dateOfBirthFocus,
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

/*    ///[textAccountHolder] is used for text input of account holder name input in screen
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
      );
    }*/

/*    ///[bankDetail] is used for bank detail part
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
    }*/

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
          hintText: (selectFrontDrivingLicence.value.path).isNotEmpty
              ? selectFrontDrivingLicence.value.path.split('/').last
              : APPStrings.textUploadFrontImage.translate(),
          hintStyle: (selectFrontDrivingLicence.value.path).isNotEmpty
              ? getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.bodySmall!,
                  Dimens.textSize15,
                  FontWeight.normal)
              : null,
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
          hintText: (selectBackDrivingLicence.value.path).isNotEmpty
              ? selectBackDrivingLicence.value.path.split('/').last
              : APPStrings.textUploadBackImage.translate(),
          hintStyle: (selectBackDrivingLicence.value.path).isNotEmpty
              ? getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.bodySmall!,
                  Dimens.textSize15,
                  FontWeight.normal)
              : null,
        ),
      );
    }

    ///[drivingLicenceImages] this widget use for driving Licence for front image and back image for licence
    Widget drivingLicenceImages() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimens.margin30),
          Row(
            children: [
              selectFrontDrivingLicence.value.path.isNotEmpty
                  ? Stack(
                      children: [
                        SizedBox(
                            height: Dimens.margin100,
                            width: Dimens.margin120,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(Dimens.margin10),
                                  child: Image.file(
                                    selectFrontDrivingLicence.value,
                                    fit: BoxFit.fill,
                                  )),
                            )),
                        Positioned(
                          top: Dimens.margin0,
                          right: Dimens.margin0,
                          child: Container(
                            height: Dimens.margin26,
                            width: Dimens.margin26,
                            padding: const EdgeInsets.all(Dimens.margin5),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                                borderRadius:
                                    BorderRadius.circular(Dimens.margin100)),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: InkWell(
                              onTap: () {
                                selectFrontDrivingLicence.value = File('');
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(Dimens.margin2),
                                child: SvgPicture.asset(
                                  APPImages.icClose,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ((mModelGetProfile.profile?.imgDLF != null)
                      ? SizedBox(
                          height: Dimens.margin100,
                          width: Dimens.margin120,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                selectDrivingLicence(true);
                              },
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(Dimens.margin10),
                                  child: ImageViewerNetwork(
                                    url: mModelGetProfile.profile?.imgDLF ?? '',
                                    mFit: BoxFit.fill,
                                  )),
                            ),
                          ))
                      : const SizedBox()),
              const SizedBox(width: Dimens.margin15),
              selectBackDrivingLicence.value.path.isNotEmpty
                  ? Stack(
                      children: [
                        SizedBox(
                            height: Dimens.margin100,
                            width: Dimens.margin120,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(Dimens.margin10),
                                child: Image.file(
                                  selectBackDrivingLicence.value,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )),
                        Positioned(
                          top: Dimens.margin0,
                          right: Dimens.margin0,
                          child: Container(
                            height: Dimens.margin26,
                            width: Dimens.margin26,
                            padding: const EdgeInsets.all(Dimens.margin5),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                                borderRadius:
                                    BorderRadius.circular(Dimens.margin100)),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectBackDrivingLicence.value = File('');
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(Dimens.margin2),
                                child: SvgPicture.asset(
                                  APPImages.icClose,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ((mModelGetProfile.profile?.imgDLB != null)
                      ? SizedBox(
                          height: Dimens.margin100,
                          width: Dimens.margin120,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                selectDrivingLicence(false);
                              },
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(Dimens.margin10),
                                  child: ImageViewerNetwork(
                                    url: mModelGetProfile.profile?.imgDLB ?? '',
                                    mFit: BoxFit.fill,
                                  )),
                            ),
                          ))
                      : const SizedBox()),
            ],
          )
        ],
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
          selectFrontDrivingLicence.value.path.isEmpty &&
                  mModelGetProfile.profile?.imgDLF == null
              ? Column(
                  children: [
                    textUploadFrontImage(),
                    const SizedBox(
                      height: Dimens.margin20,
                    ),
                  ],
                )
              : const SizedBox(),
          selectBackDrivingLicence.value.path.isEmpty &&
                  mModelGetProfile.profile?.imgDLB == null
              ? Column(
                  children: [
                    textUploadBackImage(),
                    const SizedBox(
                      height: Dimens.margin10,
                    ),
                  ],
                )
              : const SizedBox(),
          drivingLicenceImages(),
          const SizedBox(
            height: Dimens.margin30,
          ),
          submitButton()
        ],
      );
    }

    ///[mobileSignUpForm] this method is used for mobile signUpn screen
    Widget mobileSignUpForm() {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: Dimens.margin20),
            textAddress(),
            const SizedBox(height: Dimens.margin30),
            textAddress2(),
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
            drivingLicence(),
            const SizedBox(height: Dimens.margin40),
          ],
        ),
      );
    }

    ///[mBody] is used to get Mobile view body
    Widget mBody() {
      return Container(
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
        title: APPStrings.textEditProfessionalDetails.translate(),
        mLeftImage: APPImages.icArrowBack,
        mLeftAction: () {
          Navigator.pop(context);
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
          mLoading,
          isAvailabilitySelected,
          isWeekDaysError,
          isSkillDaysError,
          isSelectSourceError,
          isStartTimeError,
          isEndTimeError,
          isCountryError,
          isStateError,
          isCityError,
          isZipcodeError,
          isDateOfBirthError,
          isAccountHolderError,
          isBankNameError,
          isACHRoutingError,
          isBankAddressError,
          isBankAccountError,
          selectedSourceProviderNotifier,
          isSkillDaysError,
          isAddressError
        ],
        builder: (context, values, Widget? child) {
          return BlocListener<UpdateProfileBloc, UpdateProfileState>(
            listener: (context, state) {
              mLoading.value = state is UpdateProfileLoading;
              if (state is DrivingLicenceUpdateResponse) {
                selectBackDrivingLicence.value = File('');
                selectFrontDrivingLicence.value = File('');
              } else if (state is UpdateProfileResponse) {
                if (selectFrontDrivingLicence.value.path.isNotEmpty ||
                    selectBackDrivingLicence.value.path.isNotEmpty) {
                  drivingLicenceUpdateEvent();
                } else {
                  Navigator.pop(context);
                }
              }
            },
            child: ModalProgressHUD(
              inAsyncCall: mLoading.value,
              progressIndicator: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
              child: Scaffold(
                appBar: getAppbar(),
                backgroundColor: Theme.of(context).primaryColor,
                body: mBody(),
              ),
            ),
          );
        });
  }

  ///[_pickDate] this method use to Android, iOS and web date picker
  void _pickDate() async {
    FocusScope.of(context).requestFocus(FocusNode());

    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime.utc(1900),
      lastDate: DateTime.now(),
      initialDate: dateOfBirthDateTime,
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
    dateOfBirthController.text =
        formatOnlyDate(formatDate(setDate, AppConfig.dateFormatDDMMYYYYHHMMSS));
    dateOfBirthDateTime = setDate;
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
            ImageCropper.platform
                .cropImage(
              sourcePath: pickedFile.path,
              compressQuality: 50,
            )
                .then((croppedImage) {
              if (croppedImage != null) {
                setState(() {
                  if (isFirst) {
                    selectFrontDrivingLicence.value = File(croppedImage.path);
                  } else {
                    selectBackDrivingLicence.value = File(croppedImage.path);
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

    // if (mListSelectedWeek.value.isEmpty) {
    //   isWeekDaysError.value = APPStrings.textSelectWeekDays.translate();
    // }
    // if (mListSelectedSkill.value.isEmpty) {
    //   isSkillDaysError.value = APPStrings.textSelectYourSkills.translate();
    // }
    if (addressController.text.isEmpty) {
      isAddressError.value = APPStrings.textAddress1.translate();
    }
    if (countryController.text.isEmpty) {
      isCountryError.value = APPStrings.textEnterCountry.translate();
    }
    if (stateController.text.isEmpty) {
      isStateError.value = APPStrings.textEnterState.translate();
    }
    if (cityController.text.isEmpty) {
      isCityError.value = APPStrings.textEnterCity.translate();
    }
    if ((zipcodeController.text.isEmpty) ||
        (zipcodeController.text.length != 5 &&
            zipcodeController.text.length != 10)) {
      isZipcodeError.value =
          ValidationString.validationInvalidZipCode.translate();
    }

    if (isAvailabilitySelected.value) {
      if (/*mListSelectedWeek.value.isNotEmpty &&
          mListSelectedSkill.value.isNotEmpty &&*/
          addressController.text.isNotEmpty &&
              countryController.text.isNotEmpty &&
              stateController.text.isNotEmpty &&
              cityController.text.isNotEmpty &&
              zipcodeController.text.isNotEmpty) {
        ///Navigator.pushNamed(context, AppRoutes.routesMyProfile);
        editProfessionalEvent();
      }
    } else {
      if (/*mListSelectedSkill.value.isNotEmpty &&*/
          addressController.text.isNotEmpty &&
              countryController.text.isNotEmpty &&
              stateController.text.isNotEmpty &&
              cityController.text.isNotEmpty &&
              zipcodeController.text.isNotEmpty) {
        editProfessionalEvent();
      }
    }
  }
}

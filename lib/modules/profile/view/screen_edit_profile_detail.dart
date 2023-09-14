import 'package:country_code_picker/country_code_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/profile/bloc/get_profile/get_profile_bloc.dart';
import 'package:we_pro/modules/profile/bloc/update_personal_profile/update_personal_profile_bloc.dart';
import 'package:we_pro/modules/profile/bloc/update_profile/update_profile_bloc.dart';
import 'package:we_pro/modules/profile/model/model_get_profile.dart';

import '../../core/utils/core_import.dart';

///[ScreenEditProfileDetail] this class is used for signUp screen
class ScreenEditProfileDetail extends StatefulWidget {
  const ScreenEditProfileDetail({Key? key}) : super(key: key);

  @override
  State<ScreenEditProfileDetail> createState() =>
      _ScreenEditProfileDetailState();
}

class _ScreenEditProfileDetailState extends State<ScreenEditProfileDetail> {
  ValueNotifier<bool> mLoading = ValueNotifier(false);

  ValueNotifier<File> mImages = ValueNotifier<File>(File(''));
  ValueNotifier<String> isFirstNameError = ValueNotifier('');
  ValueNotifier<String> isLastNameError = ValueNotifier('');
  ValueNotifier<String> isUserNameError = ValueNotifier('');
  ValueNotifier<String> isEmailError = ValueNotifier('');
  ValueNotifier<String> isDateOfBirth = ValueNotifier('');
  ValueNotifier<String> isContactNumberError = ValueNotifier('');

  ValueNotifier<CountryCode> mSelectedCountryCode =
      ValueNotifier(CountryCode());

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();

  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode contactNumberFocus = FocusNode();
  FocusNode dateOfBirthFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode countryFocus = FocusNode();
  FocusNode stateFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode zipcodeFocus = FocusNode();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  Uint8List? mWebFile;
  File? selectedProfilePic;
  PlatformFile? mPlatformFile;

  List<String> sourceProvider = [
    APPStrings.warningSelectSourceProvider.translate(),
    'One',
    'Two',
    'Three'
  ];

  /// get profile data
  late ModelGetProfile modelGetProfile;

  @override
  void initState() {
    modelGetProfile = getProfileData();
    updateField();
    super.initState();
  }

  /// get update data from api side
  void updateField() {
    firstNameController.text = modelGetProfile.profile!.firstname.toString();
    lastNameController.text = modelGetProfile.profile!.lastname.toString();
    emailController.text = modelGetProfile.profile!.email.toString();
    if (modelGetProfile.profile!.phoneNumberFormat?.countryCode == '+1') {
      mSelectedCountryCode.value = CountryCode.fromCountryCode('US');
    } else {
      mSelectedCountryCode.value = CountryCode.fromDialCode(
          modelGetProfile.profile!.phoneNumberFormat?.countryCode ?? '');
    }

    contactNumberController.text =
        modelGetProfile.profile!.phoneNumberFormat?.number ?? '';
    addressController.text = modelGetProfile.profile!.address.toString();
    countryController.text = modelGetProfile.profile!.country.toString();
    stateController.text = modelGetProfile.profile!.state.toString();
    cityController.text = modelGetProfile.profile!.city.toString();
    zipcodeController.text = modelGetProfile.profile!.zip.toString();
  }

  ///[profilePictureUpdateEvent] this method is used to connect to profile picture update
  void profilePictureUpdateEvent() async {
    BlocProvider.of<UpdateProfileBloc>(context).add(PictureUpdateProfile(
        url: AppUrls.apiPictureUpdateProfile, imageFile: selectedProfilePic));
  }

  @override
  Widget build(BuildContext context) {
    /// addingMobileUiStyles(context);

    /// [addProfilePicture()]  is used to display add profile picture text and select image button
    Widget addProfilePicture() {
      return InkWell(
        onTap: () {
          selectPicture(0, true);
        },
        child: SizedBox(
          height: Dimens.margin90,
          width: Dimens.margin90,
          child: Stack(
            children: [
              Container(
                height: Dimens.margin80,
                width: Dimens.margin80,
                padding: selectedProfilePic == null
                    ? const EdgeInsets.symmetric(
                        horizontal: Dimens.margin0,
                        vertical: Dimens.margin0,
                      )
                    : EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(
                    Dimens.margin100,
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: selectedProfilePic == null
                    ? CircleImageViewerNetwork(
                        url: modelGetProfile.profile!.picture.toString(),
                        mHeight: Dimens.margin35,
                      )
                    : Image.file(
                        selectedProfilePic!,
                        fit: BoxFit.fill,
                      ),
              ),
              Positioned(
                top: Dimens.margin60,
                left: Dimens.margin50,
                child: Container(
                  height: Dimens.margin30,
                  width: Dimens.margin30,
                  padding: const EdgeInsets.all(Dimens.margin5),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(Dimens.margin100)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: SvgPicture.asset(
                    APPImages.icCamera,
                    width: Dimens.margin18,
                    height: Dimens.margin15,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    ///[textFieldEmail] is used for text input of first name input in screen
    Widget textFieldFirstName() {
      return BaseTextFormFieldSuffix(
        controller: firstNameController,
        focusNode: firstNameFocus,
        nextFocusNode: lastNameFocus,
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textFirstName.translate(),
        titleStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.margin12,
            FontWeight.w400),
        suffixIcon: Container(
          padding: const EdgeInsets.all(Dimens.margin14),
          child: SvgPicture.asset(
            APPImages.icUser,
            colorFilter:
                const ColorFilter.mode(AppColors.color7E7E7E, BlendMode.srcIn),
          ),
        ),
        onChange: () {
          if (isFirstNameError.value.isNotEmpty) {
            isFirstNameError.value = '';
          }
        },
        errorText: isFirstNameError.value,
        hintText: APPStrings.warningEnterFirstName.translate(),
        hintStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.margin15,
            FontWeight.w400),
        isRequired: true,
      );
    }

    ///[textLastFirstName] is used for text input of last name input in screen
    Widget textLastFirstName() {
      return BaseTextFormFieldSuffix(
        controller: lastNameController,
        focusNode: lastNameFocus,
        nextFocusNode: emailFocus,
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textLastName.translate(),
        titleStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.margin12,
            FontWeight.w400),
        suffixIcon: Container(
          padding: const EdgeInsets.all(Dimens.margin14),
          child: SvgPicture.asset(
            APPImages.icUser,
            colorFilter:
                const ColorFilter.mode(AppColors.color7E7E7E, BlendMode.srcIn),
          ),
        ),
        onChange: () {
          if (isLastNameError.value.isNotEmpty) {
            isLastNameError.value = '';
          }
        },
        errorText: isLastNameError.value,
        hintText: APPStrings.warningEnterLastName.translate(),
        hintStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.margin15,
            FontWeight.w400),
        isRequired: true,
        // hintText: 'Enter First Name',
      );
    }

    ///[textFieldEmail] is used for text input of email on this screen
    Widget textFieldEmail() {
      return BaseTextFormFieldSuffix(
        enabled: false,
        controller: emailController,
        focusNode: emailFocus,
        nextFocusNode: contactNumberFocus,
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textEmailId.translate(),
        titleStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.margin12,
            FontWeight.w400),
        suffixIcon: Container(
          padding: const EdgeInsets.all(Dimens.margin14),
          child: SvgPicture.asset(
            APPImages.icEmail,
          ),
        ),
        onChange: () {
          if (isEmailError.value.isNotEmpty) {
            isEmailError.value = '';
          }
        },
        errorText: isEmailError.value,
        hintText: APPStrings.warningEnterEmailId.translate(),
        hintStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.margin15,
            FontWeight.w400),
        isRequired: true,
        // hintText: 'Enter First Name',
      );
    }

    ///[textFieldContactNumber] is used for text input of contact number on this screen
    Widget textFieldContactNumber() {
      return BaseTextFormFieldPrefix(
        controller: contactNumberController,
        focusNode: contactNumberFocus,
        fillColor: Theme.of(context).highlightColor,
        nextFocusNode: dateOfBirthFocus,
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
            initialSelection: mSelectedCountryCode.value.code,
            favorite: const ['United States'],
            countryFilter: const ['US', 'AU'],
            showCountryOnly: true,
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
            FontWeight.w400),
        isRequired: true,
        // hintText: 'Enter First Name',
      );
    }

    /*///[dateOfBirth] is used for text input of date of birth input in screen
    Widget dateOfBirth() {
      return InkWell(
        onTap: () {
          _pickDate();
        },
        child: BaseTextFormFieldSuffix(
          controller: dateOfBirthController,
          focusNode: dateOfBirthFocus,
          nextFocusNode: addressFocus,
          enabled: false,
          textInputAction: TextInputAction.next,
          titleText: APPStrings.textDateOfBirth.translate(),
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
          errorText: isDateOfBirth.value,
          hintText: APPStrings.warningSelectYourDateOfBirth.translate(),
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w400),
        ),
      );
    }

    ///[textAddress] is used for text input of address on this screen
    Widget textAddress() {
      return BaseTextFormFieldSuffix(
        controller: addressController,
        focusNode: addressFocus,
        nextFocusNode: countryFocus,
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textAddress.translate(),
        titleStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.margin12,
            FontWeight.w400),
        onChange: () {
          if (isAddressError.value.isNotEmpty) {
            isAddressError.value = '';
          }
        },
        errorText: isAddressError.value,
        hintText: APPStrings.textAddress.translate(),
        hintStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.margin15,
            FontWeight.w400),
        isRequired: true,
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
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w400)
          // hintText: 'Enter First Name',
          );
    }

    ///[textState] is used for text input of state name input in screen
    Widget textState() {
      return BaseTextFormFieldSuffix(
          controller: stateController,
          focusNode: stateFocus,
          nextFocusNode: cityFocus,
          textInputAction: TextInputAction.next,
          titleText: APPStrings.textState.translate(),
          onChange: () {
            if (isStateError.value.isNotEmpty) {
              isStateError.value = '';
            }
          },
          errorText: isStateError.value,
          hintText: APPStrings.textEnterState.translate(),
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w400)
          // hintText: 'Enter First Name',
          );
    }

    ///[textCity] is used for text input of city name input in screen
    Widget textCity() {
      return BaseTextFormFieldSuffix(
          controller: cityController,
          focusNode: cityFocus,
          nextFocusNode: zipcodeFocus,
          textInputAction: TextInputAction.next,
          titleText: APPStrings.textCity.translate(),
          onChange: () {
            if (isCityError.value.isNotEmpty) {
              isCityError.value = '';
            }
          },
          errorText: isCityError.value,
          hintText: APPStrings.textEnterCity.translate(),
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w400)
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
          titleText: APPStrings.textZipcode.translate(),
          onChange: () {
            if (isZipcodeError.value.isNotEmpty) {
              isZipcodeError.value = '';
            }
          },
          errorText: isZipcodeError.value,
          hintText: APPStrings.textEnterZipcode.translate(),
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w400)
          // hintText: 'Enter First Name',
          );
    }
*/

    ///[saveButton] is used for continue button on this screen
    Widget saveButton() {
      return CustomButton(
        height: Dimens.margin60,
        backgroundColor: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
        borderRadius: Dimens.margin15,
        onPress: () {
          validateProfileData(context);
        },
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displayMedium!,
            Dimens.textSize15,
            FontWeight.w500),
        buttonText: APPStrings.textSave.translate(),
      );
    }

    ///[mobileSignUpForm] this method is used for mobile signUpn screen
    Widget mobileSignUpForm() {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: Dimens.margin20),
                  addProfilePicture(),
                  const SizedBox(height: Dimens.margin30),
                  textFieldFirstName(),
                  const SizedBox(height: Dimens.margin20),
                  textLastFirstName(),
                  const SizedBox(height: Dimens.margin20),
                  textFieldEmail(),
                  const SizedBox(height: Dimens.margin20),
                  textFieldContactNumber(),
                  /* const SizedBox(height: Dimens.margin20),
                 dateOfBirth(),
                  const SizedBox(height: Dimens.margin20),
                  textAddress(),
                  const SizedBox(height: Dimens.margin20),
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
                  ),*/
                  const SizedBox(height: Dimens.margin30),
                  saveButton(),
                  const SizedBox(height: Dimens.margin30),
                ],
              ),
            ),
          ),
        ],
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
      ///
      return BaseAppBar(
        appBar: AppBar(),
        title: APPStrings.textEditPersonalDetails.translate(),
        mLeftImage: APPImages.icArrowBack,
        textStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.titleLarge!,
            Dimens.textSize15,
            FontWeight.w500),
        backgroundColor: Theme.of(context).colorScheme.primary,
        mLeftAction: () {
          Navigator.pop(context);
        },
      );
    }

    return MultiValueListenableBuilder(
        valueListenables: [
          mLoading,
          mSelectedCountryCode,
          isFirstNameError,
          isLastNameError,
          isUserNameError,
          isEmailError,
          isDateOfBirth,
          isContactNumberError,
          mImages,
        ],
        builder: (context, values, Widget? child) {
          return MultiBlocListener(
            listeners: [
              BlocListener<UpdateProfileBloc, UpdateProfileState>(
                listener: (context, state) {
                  mLoading.value = state is UpdateProfileLoading;
                },
              ),
              BlocListener<UpdatePersonalProfileBloc,
                  UpdatePersonalProfileState>(
                listener: (context, state) {
                  mLoading.value = state is UpdatePersonalProfileLoading;
                },
              ),
              BlocListener<GetProfileBloc, GetProfileState>(
                listener: (context, state) {
                  mLoading.value = state is GetProfileLoading;
                  if (state is GetProfileResponse) {
                    modelGetProfile = getProfileData();
                  }
                },
              ),
            ],
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

/*  @override
  void dispose() {
    addingMobileUiStyles(NavigatorKey.navigatorKey.currentContext!,
        isFromDispose: true);
    super.dispose();
  }*/

  /// Used by [SystemChrome] of app
  void addingMobileUiStyles(BuildContext context,
      {bool isFromDispose = false}) {
    /* if (isFromDispose) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
          statusBarColor: (Theme.of(context).brightness == Brightness.light)
              ? AppColors.colorPrimary
              : AppColors.colorWhite,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: */ /*(Theme.of(context).brightness == Brightness.light)
              ? AppColors.colorWhite
              :*/ /*
              AppColors.colorWhite,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark));
    }*/
  }

  ///[backPress] is used to go back to the previous URL
  void backPress(BuildContext context) {
    Navigator.pop(context);
  }

  /*///[_pickDate] this method use to Android, iOS and web date picker
  void _pickDate() async {
    FocusScope.of(context).requestFocus(FocusNode());

    await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
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
    ).then((date) {
      if (date != null) {
        setDate(date);
      }
    });
  }

  ///[setDate] this method use to set date is per the picker status
  void setDate(DateTime setDate) {
    dateOfBirthController.text =
        formatOnlyDate(formatDate(setDate, AppConfig.dateFormatDDMMYYYYHHMMSS));
    // dateOfBirthController.text =
    //     formatDate(setDate, AppConfig.dateFormatYYYYMMDD);
    setState(() {});
  }*/

  ///[validateProfileData] this method is used to validate input formats of validate Profile Data
  Future<void> validateProfileData(BuildContext context) async {
    if (firstNameController.text.toString().isEmpty) {
      isFirstNameError.value = APPStrings.warningEnterFirstName.translate();

      /// return;
    }
    if (lastNameController.text.toString().isEmpty) {
      isLastNameError.value = APPStrings.warningEnterLastName.translate();

      ///  return;
    }
    if (emailController.text.trim().toString().isEmpty) {
      isEmailError.value = APPStrings.warningEnterEmailId.translate();

      ///  return;
    }
    if (!validateEmail(emailController.text.trim())) {
      isEmailError.value = APPStrings.errorEmail.translate();

      /// return;
    }
    if (contactNumberController.text.trim().isEmpty) {
      isContactNumberError.value = APPStrings.warningContactNumber.translate();

      /// return;
    }
    if (!validatePhone(contactNumberController.text.trim())) {
      isContactNumberError.value =
          APPStrings.hintEnterValidContactNumber.translate();

      /// return;
    }
    /* if (addressController.text.trim().isEmpty) {
      isAddressError.value = APPStrings.textAddress.translate();

      /// return;
    }
    if (countryController.text.trim().isEmpty) {
      isCountryError.value = APPStrings.textEnterCountry.translate();

      ///  return;
    }*/

    if (firstNameController.text.isNotEmpty &&
            lastNameController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            validateEmail(emailController.text.trim()) &&
            validatePhone(contactNumberController.text.trim()) &&
            contactNumberController.text.isNotEmpty
        /* && addressController.text.isNotEmpty &&
        countryController.text.isNotEmpty*/
        ) {
      updateDetailsEvent(context);
      /*NavigatorKey.navigatorKey.currentState!
          .pushNamed(AppRoutes.routesMyProfile);*/
    }
  }

  ///[_onCountryChange] this method is used to display country selector dialog
  void _onCountryChange(CountryCode countryCode) {
    printWrapped("New Country selected: ${countryCode.dialCode}");
    mSelectedCountryCode.value = countryCode;
  }

  Future<void> selectPicture(int index, bool isFirst) async {
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
                    selectedProfilePic = File(croppedImage.path);
                  } else {
                    selectedProfilePic = File(croppedImage.path);
                  }

                  if (selectedProfilePic != null) {
                    profilePictureUpdateEvent();
                  }
                });
              }
            });
          }
        });
      }
    });
  }

  void updateDetailsEvent(BuildContext context) {
    Map<String, String> mBody = {
      ApiParams.paramFirstName: firstNameController.text.trim(),
      ApiParams.paramLastName: lastNameController.text.trim(),
      ApiParams.paramPhoneNumber:
          (mSelectedCountryCode.value.dialCode ?? '').replaceAll('+', '') +
              contactNumberController.text.trim(),
    };

    BlocProvider.of<UpdatePersonalProfileBloc>(context).add(
        UpdatePersonalProfileUser(
            url: AppUrls.apiUpdatePersonalProfile, body: mBody));
  }
}

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_pro/modules/auth/bloc/send_otp/otp_send_bloc.dart';
import 'package:we_pro/modules/auth/bloc/signUp/sign_up_bloc.dart';
import 'package:we_pro/modules/auth/model/mode_social_login.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/masters/model/model_sources.dart';
import 'package:we_pro/modules/masters/sources/bloc/assigned_sources_providers/sources_bloc.dart';

import '../../core/utils/core_import.dart';

///[ScreenSignUp] this class is used for signUp screen
class ScreenSignUp extends StatefulWidget {
  const ScreenSignUp({Key? key}) : super(key: key);

  @override
  State<ScreenSignUp> createState() => _ScreenSignUpState();
}

class _ScreenSignUpState extends State<ScreenSignUp> {
  ValueNotifier<bool> mLoading = ValueNotifier(false);
  ValueNotifier<bool> mAcceptTermsAndConditions = ValueNotifier(false);
  ValueNotifier<CountryCode> mSelectedCountry = ValueNotifier(
      CountryCode(code: 'US', dialCode: '+1', name: 'United States'));
  ValueNotifier<ModelSources> selectedSourceProviderNotifier =
      ValueNotifier(ModelSources());

  // ValueNotifier<String> selectedSourceProviderNotifier = ValueNotifier('');
  ValueNotifier<ModeSocialLogin> mModeSocialLogin =
      ValueNotifier<ModeSocialLogin>(ModeSocialLogin());
  ValueNotifier<bool> isShowPassword = ValueNotifier<bool>(true);
  ValueNotifier<File> mImages = ValueNotifier<File>(File(''));
  ValueNotifier<bool> isShowReEnterPassword = ValueNotifier<bool>(true);
  ValueNotifier<String> isFirstNameError = ValueNotifier('');
  ValueNotifier<String> isLastNameError = ValueNotifier('');
  ValueNotifier<String> isUserNameError = ValueNotifier('');
  ValueNotifier<String> isEmailError = ValueNotifier('');
  ValueNotifier<String> isCompanyCodeError = ValueNotifier('');
  ValueNotifier<String> isDateOfBirth = ValueNotifier('');
  ValueNotifier<String> isContactNumberError = ValueNotifier('');

  // ValueNotifier<String> isSourceProviderError = ValueNotifier('');
  ValueNotifier<String> isPasswordError = ValueNotifier('');
  ValueNotifier<String> isConfirmPasswordError = ValueNotifier('');
  ValueNotifier<String> isNoMatchPasswordError = ValueNotifier('');
  ValueNotifier<String> isTNCError = ValueNotifier('');

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  // TextEditingController companyCodeController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();

  // TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

  // FocusNode companyCodeFocus = FocusNode();
  FocusNode contactNumberFocus = FocusNode();
  FocusNode dateOfBirthFocus = FocusNode();

  // FocusNode sourceProviderFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  File? selectedProfilePic;

  ValueNotifier<List<String>> mAddedCompanies = ValueNotifier([]);

/*  List<String> sourceProvider = [
    APPStrings.warningSelectSourceProvider.translate(),
    'One',
    'Two',
    'Three'
  ];*/
  List<ModelSources> sourceProvider = [];

  @override
  void initState() {
    sourceProvider.addAll(
        BlocProvider.of<SourcesProvidersBloc>(getNavigatorKeyContext())
            .sources);
    // companyCodeController.text = 'Fsdfdw2323223fgg';
    super.initState();
  }

  ///[signupEvent] this method is used to connect to signup api
  void signupEvent() async {
    Map<String, dynamic> mBody = {
      ApiParams.paramFirstName: firstNameController.text,
      ApiParams.paramLastName: lastNameController.text,
      ApiParams.paramPhoneNumber:
          (mSelectedCountry.value.dialCode ?? '').replaceAll('+', '') +
              contactNumberController.text
                  .replaceAll('(', '')
                  .replaceAll(')', '')
                  .replaceAll('-', '')
                  .replaceAll(' ', '')
                  .trim(),

      ///   ApiParams.paramSources: [selectedSourceProviderNotifier.value.id].toList(),
      ApiParams.paramCompanyCode: mAddedCompanies.value.join(','),
      // ApiParams.paramCompanyCode: companyCodeController.text,
      ApiParams.paramEmail: emailController.text,
      ApiParams.paramPassword: passwordController.text,
      ApiParams.paramLat: MyAppState.mCurrentPosition.value.latitude.toString(),
      ApiParams.paramLong:
          MyAppState.mCurrentPosition.value.longitude.toString(),
    };

    /// BlocProvider.of<SignUpBloc>(context).add(SignUpSignUp(body: mBody, url: AppUrls.apSignUpApi, imageFile: selectedProfilePic));
    BlocProvider.of<SignUpBloc>(context).add(SignUpSignUp(
        body: mBody, url: AppUrls.apSignUpApi, imageFile: selectedProfilePic));
  }

  @override
  Widget build(BuildContext context) {
    /// addingMobileUiStyles(context);

    /// [addProfilePicture()]  is used to display add profile picture text and select image button
    Widget addProfilePicture() {
      return InkWell(
        onTap: () {
          selectPicture();
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
                    ? SvgPicture.asset(
                        APPImages.icProfile,
                        height: Dimens.margin35,
                        width: Dimens.margin30,
                      )
                    : Image.file(
                        selectedProfilePic!,
                        fit: BoxFit.fill,
                      ),
              ),
              Positioned(
                top: Dimens.margin55,
                left: Dimens.margin55,
                child: Container(
                  height: Dimens.margin30,
                  width: Dimens.margin30,
                  padding: const EdgeInsets.all(Dimens.margin5),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(100)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: SvgPicture.asset(
                    APPImages.icCamera,
                    width: Dimens.margin18,
                    height: Dimens.margin15,
                  ),
                ),
              ),
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
        keyboardType: TextInputType.name,
        titleStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.margin12,
            FontWeight.w400),
        suffixIcon: Container(
          padding: const EdgeInsets.all(Dimens.margin14),
          child: SvgPicture.asset(
            APPImages.icUser,
            colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface, BlendMode.srcIn),
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
        keyboardType: TextInputType.name,

        titleStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.margin12,
            FontWeight.w400),
        suffixIcon: Container(
          padding: const EdgeInsets.all(Dimens.margin14),
          child: SvgPicture.asset(
            APPImages.icUser,
            colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface, BlendMode.srcIn),
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
        controller: emailController,
        focusNode: emailFocus,
        nextFocusNode: contactNumberFocus,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
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
      );
    }

    ///[textFieldContactNumber] is used for text input of contact number on this screen
    Widget textFieldContactNumber() {
      return BaseTextFormFieldPrefix(
        controller: contactNumberController,
        focusNode: contactNumberFocus,
        nextFocusNode: dateOfBirthFocus,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        titleText: APPStrings.textContactNumber.translate(),
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
            textStyle: getTextStyleFontWeight(
                Theme.of(context).primaryTextTheme.bodySmall!,
                Dimens.textSize15,
                FontWeight.normal),
            dialogTextStyle: getTextStyleFontWeight(
                Theme.of(context).primaryTextTheme.bodySmall!,
                Dimens.textSize15,
                FontWeight.normal),
            searchStyle: getTextStyleFontWeight(
                Theme.of(context).primaryTextTheme.bodySmall!,
                Dimens.textSize15,
                FontWeight.normal),
            initialSelection: mSelectedCountry.value.name,
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
        hintText: APPStrings.warningContactNumber.translate(),
        hintStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.margin15,
            FontWeight.w400),
        isRequired: true,
      );
    }

    /*   ///[dateOfBirth] is used for text input of date of birth input in screen
    Widget dateOfBirth() {
      return InkWell(
        focusNode: dateOfBirthFocus,
        onTap: () {
          _pickDate(true);
        },
        child: BaseTextFormFieldSuffix(
          controller: dateOfBirthController,
          enabled: false,
          fillColor: Theme.of(context).highlightColor,
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
    }*/

    /// This function is likely to return a widget that displays text for adding a
    /// company code.
    Widget textAddCompanyCode() {
      return InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.routesAddCompanyCode,
                  arguments: mAddedCompanies.value)
              .then((value) {
            if (value != null) {
              isCompanyCodeError.value = '';
              mAddedCompanies.value = value as List<String>;
            }
          });
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  APPStrings.textAddCompanyCodeStar.translate(),
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
            if (isCompanyCodeError.value.isNotEmpty) ...[
              const SizedBox(height: Dimens.margin8),
              BaseTextFieldErrorIndicator(errorText: isCompanyCodeError.value)
            ]
          ],
        ),
      );
    }
    /*///[textFieldCompanyCode] is used for text input of company code input in screen
    Widget textFieldCompanyCode() {
      return BaseTextFormFieldSuffix(
        controller: companyCodeController,
        focusNode: companyCodeFocus,
        nextFocusNode: passwordFocus,
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textCompanyCodeName.translate(),
        keyboardType: TextInputType.name,
        titleStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.margin12,
            FontWeight.w400),
        */ /*suffixIcon: Container(
          padding: const EdgeInsets.all(Dimens.margin14),
          child: SvgPicture.asset(
            APPImages.icUser,
            colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface, BlendMode.srcIn),
          ),
        ),*/ /*
        onChange: () {
          if (isCompanyCodeError.value.isNotEmpty) {
            isCompanyCodeError.value = '';
          }
        },
        errorText: isCompanyCodeError.value,
        hintText: APPStrings.textEnterCompanyCode.translate(),
        hintStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.margin15,
            FontWeight.w400),
        isRequired: true,
      );
    }*/

    ///[textPassword] is used for text input of password on this screen
    Widget textPassword() {
      return BasePasswordTextFormField(
        controller: passwordController,
        focusNode: passwordFocus,
        nextFocusNode: confirmPasswordFocus,
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textNewPassword.translate(),
        titleStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.margin12,
            FontWeight.w400),
        isShowPassword: isShowPassword.value,
        pressShowPassword: () {
          isShowPassword.value = !isShowPassword.value;
        },

        onChange: () {
          if (isPasswordError.value.isNotEmpty) {
            isPasswordError.value = '';
          }
        },
        errorText: isPasswordError.value,
        hintText: APPStrings.textEnterNewPassword.translate(),
        hintStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.margin15,
            FontWeight.w400),
        isRequired: true,
        // hintText: 'Enter First Name',
      );
    }

    ///[textConfirmPassword] is used for text input of confirm password on this screen
    Widget textConfirmPassword() {
      return BasePasswordTextFormField(
        controller: confirmPasswordController,
        focusNode: confirmPasswordFocus,
        textInputAction: TextInputAction.done,
        titleText: APPStrings.textConfirmNewPassword.translate(),
        titleStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.margin12,
            FontWeight.w400),
        isShowPassword: isShowReEnterPassword.value,
        pressShowPassword: () {
          isShowReEnterPassword.value = !isShowReEnterPassword.value;
        },
        onChange: () {
          if (isConfirmPasswordError.value.isNotEmpty) {
            isConfirmPasswordError.value = '';
          }
        },
        errorText: isConfirmPasswordError.value,
        hintText: APPStrings.warningEnterConfirmPassword.translate(),
        hintStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.margin15,
            FontWeight.w400),
        isRequired: true,
        // hintText: 'Enter First Name',
      );
    }

    ///[acceptTermsAndConditions] is used for Accept Terms And Conditions widget
    Widget acceptTermsAndConditions() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ViewCheckBoxButton(
                  isCheck: mAcceptTermsAndConditions.value,
                  onPressed: () {
                    mAcceptTermsAndConditions.value =
                        !mAcceptTermsAndConditions.value;
                    if (mAcceptTermsAndConditions.value) {
                      isTNCError.value = '';
                    }
                  }),
              const SizedBox(
                width: Dimens.margin10,
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: APPStrings.textAgreeTermPolicy1.translate(),
                          style: getTextStyleFontWeight(
                              Theme.of(context).primaryTextTheme.displaySmall!,
                              Dimens.textSize12,
                              FontWeight.w400)),
                      TextSpan(
                        text: APPStrings.textAgreeTermPolicy2.translate(),
                        style: getTextStyleFontWeight(
                                Theme.of(context).textTheme.displayMedium!,
                                Dimens.textSize12,
                                FontWeight.w500)
                            .copyWith(decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            ///routesTermsCondition(true);
                            Navigator.pushNamed(
                                context, AppRoutes.routesCMSWebView,
                                arguments: {
                                  AppConfig.argumentsTitle: APPStrings
                                      .textTermsAndConditions
                                      .translate(),
                                  AppConfig.argumentsUrl:
                                      AppUrls.baseTermsAndConditions
                                });
                          },
                      ),
                      const TextSpan(
                        text: ' ',
                      ),
                      TextSpan(
                        text: APPStrings.textAgreeTermPolicy3.translate(),
                        style: getTextStyleFontWeight(
                            Theme.of(context).primaryTextTheme.displaySmall!,
                            Dimens.textSize12,
                            FontWeight.w400),
                      ),
                      const TextSpan(
                        text: ' ',
                      ),
                      TextSpan(
                        text: APPStrings.textAgreeTermPolicy4.translate(),
                        style: getTextStyleFontWeight(
                                Theme.of(context).textTheme.displayMedium!,
                                Dimens.textSize12,
                                FontWeight.w500)
                            .copyWith(decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            /// routesTermsCondition(false);
                            Navigator.pushNamed(
                                context, AppRoutes.routesCMSWebView,
                                arguments: {
                                  AppConfig.argumentsTitle:
                                      APPStrings.textPrivacyPolicy.translate(),
                                  AppConfig.argumentsUrl:
                                      AppUrls.basePrivacyPolicy
                                });
                          },
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          if (isTNCError.value.isNotEmpty) ...[
            const SizedBox(height: Dimens.margin9),
            BaseTextFieldErrorIndicator(errorText: isTNCError.value),
          ]
        ],
      );
    }

    ///[alreadySingUp] is used for Already SingUp widget
    Widget alreadySingUp() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: APPStrings.textAlreadyOnWePro.translate(),
                    style: getTextStyleFontWeight(AppFont.regularColorBlack,
                        Dimens.margin12, FontWeight.w400)),
                TextSpan(
                  text: APPStrings.textSignIn.translate(),
                  style: getTextStyleFontWeight(
                      AppFont.colorPrimaryBoldUnderline,
                      Dimens.margin12,
                      FontWeight.w600),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      NavigatorKey.navigatorKey.currentState!
                          .pushNamed(AppRoutes.routesSignIn);
                    },
                ),
                const TextSpan(
                  text: ' ',
                ),
              ],
            ),
            textAlign: TextAlign.left,
          ),
        ],
      );
    }

    ///[continueButton] is used for continue button on this screen
    Widget continueButton() {
      return CustomButton(
        height: Dimens.margin60,
        backgroundColor: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
        borderRadius: Dimens.margin15,
        onPress: () {
          validateSignUpData(context);
        },
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displayMedium!,
            Dimens.textSize15,
            FontWeight.w500),
        buttonText: APPStrings.textSignUp.translate(),
      );
    }

    ///[mobileSignUpForm] this method is used for mobile signUpn screen
    Widget mobileSignUpForm() {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
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
                  const SizedBox(height: Dimens.margin20),
                  // dateOfBirth(),
                  // const SizedBox(height: Dimens.margin20),
                  // textFieldCompanyCode(),
                  textAddCompanyCode(),
                  const SizedBox(height: Dimens.margin20),
                  textPassword(),
                  const SizedBox(height: Dimens.margin20),
                  textConfirmPassword(),
                  const SizedBox(height: Dimens.margin20),
                  acceptTermsAndConditions(),
                  const SizedBox(height: Dimens.margin30),
                  continueButton(),
                  const SizedBox(height: Dimens.margin30),
                  alreadySingUp(),
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
      return BaseAppBar(
        appBar: AppBar(),
        title: APPStrings.textSignUp.translate(),
        mLeftImage: APPImages.icArrowBack,
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
          mAcceptTermsAndConditions,
          isShowPassword,
          mModeSocialLogin,
          mSelectedCountry,
          isShowReEnterPassword,
          isFirstNameError,
          isLastNameError,
          isUserNameError,
          isEmailError,
          isDateOfBirth,
          isContactNumberError,
          isConfirmPasswordError,
          isPasswordError,
          isCompanyCodeError,
          isTNCError,
          // isSourceProviderError,
          isNoMatchPasswordError,
          // selectedSourceProviderNotifier,
          mImages,
          mAddedCompanies,
          isCompanyCodeError
        ],
        builder: (context, values, Widget? child) {
          return BlocListener<OtpSendBloc, OtpSendState>(
            listener: (context, state) {
              mLoading.value = state is OtpSendLoading;
            },
            child: BlocListener<SignUpBloc, SignUpState>(
              listener: (context, state) {
                printWrapped('SignUpState----$state');
                mLoading.value = state is SignUpLoading;
              },
              child: ModalProgressHUD(
                inAsyncCall: mLoading.value,
                progressIndicator: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor),
                child: SafeArea(
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
                      backgroundColor: Theme.of(context).primaryColor,
                      body: mBody(),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    addingMobileUiStyles(NavigatorKey.navigatorKey.currentContext!,
        isFromDispose: true);
    super.dispose();
  }

  /// Used by [SystemChrome] of app
  void addingMobileUiStyles(BuildContext context,
      {bool isFromDispose = false}) {
    if (isFromDispose) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
          statusBarColor: (Theme.of(context).brightness == Brightness.light)
              ? AppColors.colorPrimary
              : AppColors.colorWhite,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: /*(Theme.of(context).brightness == Brightness.light)
              ? AppColors.colorWhite
              :*/
              AppColors.colorWhite,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark));
    }
  }

  ///[backPress] is used to go back to the previous URL
  void backPress(BuildContext context) {
    Navigator.pop(context);
  }

/*  ///[_pickDate] this method use to Android, iOS and web date picker
  void _pickDate(bool isStart) async {
    FocusScope.of(context).requestFocus(FocusNode());

    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime.utc(1900),
      */ /*firstDate: isStart
          ? DateTime.now().subtract(const Duration(days: 180))
          : startDate,*/ /*
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
    dateOfBirthController.text =
        formatDate(setDate, AppConfig.dateFormatYYYYMMDD);

    // sourceProviderFocus.requestFocus();
  }
  */

  ///[validateSignUpData] this method is used to validate input formats of signUp data
  Future<void> validateSignUpData(BuildContext context) async {
    printWrapped(
        "Location - ${MyAppState.mCurrentPosition.value.latitude.toString()}");
    if (firstNameController.text.toString().isEmpty) {
      isFirstNameError.value = APPStrings.warningEnterFirstName.translate();
    }
    if (lastNameController.text.toString().isEmpty) {
      isLastNameError.value = APPStrings.warningEnterLastName.translate();
    }
    if (emailController.text.trim().toString().isEmpty) {
      isEmailError.value = APPStrings.warningEnterEmailId.translate();
    }
    if (!validateEmail(emailController.text.trim().toLowerCase())) {
      isEmailError.value = APPStrings.errorEmail.translate();
    }
    if (contactNumberController.text.trim().isEmpty) {
      isContactNumberError.value = APPStrings.warningContactNumber.translate();
    }
    if (!validatePhone(contactNumberController.text
        .replaceAll('(', '')
        .replaceAll('-', '')
        .replaceAll(')', '')
        .replaceAll(' ', ''))) {
      isContactNumberError.value =
          APPStrings.hintEnterValidContactNumber.translate();
    }
    if (mAddedCompanies.value.isEmpty) {
      isCompanyCodeError.value = APPStrings.textEnterCompanyCode.translate();
    }

    if (passwordController.text.trim().isEmpty) {
      isPasswordError.value = APPStrings.warningEnterPassword.translate();
    }
    if (!validatePassword(passwordController.text)) {
      isPasswordError.value =
          ValidationString.validationPasswordLength.translate();
    }
    if (confirmPasswordController.text.trim().toString().isEmpty) {
      isConfirmPasswordError.value =
          APPStrings.warningEnterConfirmPassword.translate();
    }
    if (confirmPasswordController.text.trim().toString() !=
        passwordController.text.trim().toString()) {
      isConfirmPasswordError.value = APPStrings.textNoMatchPassword.translate();
    }
    if (!mAcceptTermsAndConditions.value) {
      isTNCError.value =
          ValidationString.validationAgreeTermsCondition.translate();
      /* ToastController.showToast(
            ValidationString.validationAgreeTermsCondition.translate(),
            context,
            false);*/
    }
    if (firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        validateEmail(emailController.text.trim()) &&
        contactNumberController.text.isNotEmpty &&
        validatePhone(contactNumberController.text
            .replaceAll('(', '')
            .replaceAll('-', '')
            .replaceAll(')', '')
            .replaceAll(' ', '')) &&
        mAddedCompanies.value.isNotEmpty &&
        validatePassword(passwordController.text) &&
        (confirmPasswordController.text.trim().toString() ==
            passwordController.text.trim().toString()) &&
        mAcceptTermsAndConditions.value) {
      signupEvent();
    }
  }

  ///[_onCountryChange] this method is used to display country selector dialog
  void _onCountryChange(CountryCode countryCode) {
    mSelectedCountry.value = countryCode;
    printWrapped("New Country selected: $countryCode");
  }

  Future<void> selectPicture() async {
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
                  selectedProfilePic = File(croppedImage.path);
                });
              }
            });
          }
        });
      }
    });
  }
}

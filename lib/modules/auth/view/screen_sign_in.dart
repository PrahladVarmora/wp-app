import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:we_pro/modules/auth/bloc/signIn/auth_bloc.dart';
import 'package:we_pro/modules/core/api_service/firebase_notification_helper.dart';
import 'package:we_pro/modules/core/utils/email_validation.dart';

import '../../core/utils/core_import.dart';
import '../../profile/bloc/get_profile/get_profile_bloc.dart';
import '../../profile/model/model_get_profile.dart';

/// This class is a stateful widget that creates a screen for the user to sign in
class ScreenSignIn extends StatefulWidget {
  const ScreenSignIn({Key? key}) : super(key: key);

  @override
  State<ScreenSignIn> createState() => _ScreenSignInState();
}

class _ScreenSignInState extends State<ScreenSignIn> {
  /// * [isChecked] is use for showing check box
  ValueNotifier<bool> isChecked = ValueNotifier(false);

  /// * [passwordController] is use for get password from user
  TextEditingController passwordController = TextEditingController();

  /// * [emailIdController] is use for get email address from user
  TextEditingController emailIdController = TextEditingController();

  /// * [emailIdFocusNode] is use for focus Email focus
  FocusNode emailIdFocusNode = FocusNode();

  /// * [passwordFocusNode] is use for focus password
  FocusNode passwordFocusNode = FocusNode();

  /// * [isEmailError] is use for show email address error
  ValueNotifier<String> isEmailError = ValueNotifier('');

  /// * [isPasswordError] is use for show password error
  ValueNotifier<String> isPasswordError = ValueNotifier('');

  ValueNotifier<bool> mLoading = ValueNotifier(false);

  ValueNotifier<bool> isShowPassword = ValueNotifier<bool>(true);

  @override
  void initState() {
    if (kDebugMode) {
      /*emailIdController.text = 'nishant_tech@yopmail.com';
      passwordController.text = 'Test@123';*/

      emailIdController.text = 'tq101@yopmail.com';
      passwordController.text = 'Test@123';
    }
    getToken();
    super.initState();
  }

  ///[loginEvent] this method is used to connect to login api
  void loginEvent() async {
    Map<String, String> mBody = {
      ApiParams.paramEmail: emailIdController.text.trim(),
      ApiParams.paramPassword: passwordController.text.trim(),
      ApiParams.paramDeviceToken: PreferenceHelper.getString(
              PreferenceHelper.fcmToken,
              def: PreferenceHelper.fcmToken) ??
          PreferenceHelper.fcmToken,
    };
    BlocProvider.of<AuthBloc>(context)
        .add(AuthUser(body: mBody, url: AppUrls.apiUserLogin));
  }

  @override
  Widget build(BuildContext context) {
    ///[logoContainer] is used for emailId Text in screen
    Widget logoContainer() {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: Dimens.margin20),
            height: Dimens.margin196,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(Dimens.margin30),
                    bottomLeft: Radius.circular(Dimens.margin30))),
            child: InkWell(
              onTap: kDebugMode
                  ? () {
                      NavigatorKey.navigatorKey.currentState!
                          .pushNamedAndRemoveUntil(
                        AppRoutes.routesDashboard,
                        (route) => false,
                      );
                    }
                  : null,
              child: Image.asset(
                APPImages.icLogo,
                height: Dimens.margin32,
                width: Dimens.margin200,
              ),
            ),
          ),
        ],
      );
    }

    ///[signInText] is used for sign in text
    Widget signInText() {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(
              top: Dimens.margin30, bottom: Dimens.margin43),
          child: Text(
            APPStrings.textSignIn.translate(),
            style: getTextStyleFontWeight(
                AppFont.colorPrimarySemiBold, Dimens.margin24, FontWeight.bold),
          ),
        ),
      );
    }

    ///[textFieldEmailID] is used for text Field EmailID
    Widget textFieldEmailID() {
      return BaseTextFormFieldSuffix(
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textEmailID.translate(),
        controller: emailIdController,
        keyboardType: TextInputType.emailAddress,
        focusNode: emailIdFocusNode,
        nextFocusNode: passwordFocusNode,
        height: Dimens.margin50,
        hintText: APPStrings.textEnterYourEmailID.translate(),
        hintStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.margin15,
            FontWeight.w200),
        suffixIcon: Container(
          padding: const EdgeInsets.all(Dimens.margin14),
          child: SvgPicture.asset(
            APPImages.icMail,
          ),
        ),
        onChange: () {
          if (isEmailError.value.isNotEmpty) {
            isEmailError.value = '';
          }
        },
        errorText: isEmailError.value,
        isRequired: true,
      );
    }

    ///[textFieldPassword] is used for text Field Password
    Widget textFieldPassword() {
      return BasePasswordTextFormField(
        isShowPassword: isShowPassword.value,
        pressShowPassword: () {
          isShowPassword.value = !isShowPassword.value;
        },
        titleText: APPStrings.textPassword.translate(),
        controller: passwordController,
        focusNode: passwordFocusNode,
        textInputAction: TextInputAction.done,
        hintText: APPStrings.textEnterYourPassword.translate(),
        hintStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.margin15,
            FontWeight.w200),
        onChange: () {
          if (isEmailError.value.isNotEmpty) {
            isEmailError.value = '';
          }
        },
        errorText: isPasswordError.value,
        isRequired: true,
      );
    }

    ///[textForgotPassword] is used for text Forgot Password
    Widget textForgotPassword() {
      return Padding(
        padding: const EdgeInsets.only(
            top: Dimens.margin20, bottom: Dimens.margin26),
        child: Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {
              NavigatorKey.navigatorKey.currentState!
                  .pushNamed(AppRoutes.routesForgotPassword);
            },
            child: Text(APPStrings.textForgotPassword.translate(),
                style: getTextStyleFontWeight(AppFont.colorPrimaryBoldUnderline,
                    Dimens.margin12, FontWeight.bold)),
          ),
        ),
      );
    }

    ///[textInvalidEmailError] is used for Invalid or Incorrect Email ID or Password
    Widget textInvalidEmailError() {
      return /*isEmailIdError.value.isNotEmpty
          ? Row(
              children: [
                SvgPicture.asset(APPImages.icErrorInfo),
                const SizedBox(
                  width: Dimens.margin10,
                ),
                Text(isEmailIdError.value,
                    style: getTextStyleFontWeight(AppFont.regularColorRed,
                        Dimens.margin12, FontWeight.w200))
              ],
            )
          : */
          const SizedBox();
    }

    ///[newOnWeproSignUp] is used for New member sign up
    Widget newOnWeproSignUp() {
      return Center(
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: APPStrings.textNewOnWepro.translate(),
                  style: getTextStyleFontWeight(AppFont.regularColorBlack,
                      Dimens.margin12, FontWeight.w400)),
              const TextSpan(text: ' '),
              TextSpan(
                text: APPStrings.textSignUp.translate(),
                style: getTextStyleFontWeight(AppFont.colorPrimaryBoldUnderline,
                    Dimens.margin12, FontWeight.w600),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    NavigatorKey.navigatorKey.currentState!
                        .pushNamed(AppRoutes.routesSignUp);
                  },
              ),
            ],
          ),
        ),
      );
    }

    ///[signInButton] is used for Invalid or Incorrect Email ID or Password
    Widget signInButton() {
      return CustomButton(
          onPress: () {
            validateSignInData(context);
          },
          height: Dimens.margin50,
          backgroundColor: Theme.of(context).primaryColor,
          buttonText: APPStrings.textSignIn.translate(),
          style: getTextStyleFontWeight(
              AppFont.mediumColorWhite, Dimens.margin15, FontWeight.w500),
          borderRadius: Dimens.margin15_5);
    }

    ///[mobileSignInForm] this method is used for mobile signUpn screen
    Widget mobileSignInForm() {
      return Column(
        children: [
          logoContainer(),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: Dimens.margin16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    signInText(),
                    textFieldEmailID(),
                    const SizedBox(
                      height: Dimens.margin30,
                    ),
                    textFieldPassword(),
                    textForgotPassword(),
                    textInvalidEmailError(),
                    const SizedBox(
                      height: Dimens.margin20,
                    ),
                    signInButton(),
                    const SizedBox(
                      height: Dimens.margin30,
                    ),
                    newOnWeproSignUp(),
                    const SizedBox(
                      height: Dimens.margin10,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    ///[mBody] is used to get Mobile view body
    Widget mBody() {
      return Container(
        color: Theme.of(context).colorScheme.background,
        child: mobileSignInForm(),
      );
    }

    return MultiValueListenableBuilder(
      valueListenables: [
        mLoading,
        isShowPassword,
        isEmailError,
        isPasswordError,
      ],
      builder: (BuildContext context, List<dynamic> values, Widget? child) {
        return MultiBlocListener(
          listeners: [
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                mLoading.value = state is AuthLoading;
                if (state is AuthFailure) {
                  ToastController.showToast(
                      state.mError, getNavigatorKeyContext(), false);
                }
              },
              child: ModalProgressHUD(
                inAsyncCall: mLoading.value,
                progressIndicator: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Scaffold(
                    backgroundColor: Theme.of(context).primaryColor,
                    body: mBody(),
                  ),
                ),
              ),
            ),
            BlocListener<GetProfileBloc, GetProfileState>(
                listener: (context, state) {
              if (state is GetProfileFailure) {
                ToastController.showToast(
                    state.mError, getNavigatorKeyContext(), false);
              }
              if (state is GetProfileResponse) {
                String? data = PreferenceHelper.getString(
                    PreferenceHelper.userGetProfileData);
                if (data != null && data.isNotEmpty) {
                  ModelGetProfile streams =
                      ModelGetProfile.fromJson(json.decode(data));
                  if (streams.profile?.emailCheck != "Verified") {
                    Navigator.pushNamedAndRemoveUntil(
                      getNavigatorKeyContext(),
                      AppRoutes.routesOtpEmail,
                      arguments: "",
                      (route) => false,
                    );
                  } else if (streams.profile?.phoneNo != "Verified") {
                    Navigator.pushNamedAndRemoveUntil(
                      getNavigatorKeyContext(),
                      AppRoutes.routesOtpContact,
                      (route) => route.settings.name == AppRoutes.routesSignIn,
                    );
                  } else {
                    NavigatorKey.navigatorKey.currentState!
                        .pushNamedAndRemoveUntil(
                      AppRoutes.routesDashboard,
                      (route) => false,
                    );
                  }
                }
              }
            })
          ],
          child: ModalProgressHUD(
            inAsyncCall: mLoading.value,
            progressIndicator: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                backgroundColor: Theme.of(context).primaryColor,
                body: mBody(),
              ),
            ),
          ),
        );
      },
    );
  }

  /// [validateSignInData] This function is use for validate data
  void validateSignInData(BuildContext context) {
    if (emailIdController.text.toString().trim().isEmpty) {
      isEmailError.value = APPStrings.warningEnterEmailId.translate();
    } else if (!EmailValidation.validate(
        emailIdController.text.toString().trim())) {
      isEmailError.value = APPStrings.errorEmail.translate();
    } else if (passwordController.text.toString().trim().isEmpty) {
      isPasswordError.value = APPStrings.warningEnterPassword.translate();
    }
    /*else if (!validatePassword(passwordController.text.toString().trim())) {
      isPasswordError.value =
          ValidationString.validationPasswordLength.translate();
    } */
    else {
      loginEvent();
    }
  }

  Future<void> getToken() async {
    var token = await FirebaseNotificationHelper.getInstance().getFcmToken();
    PreferenceHelper.setString(PreferenceHelper.fcmToken, token ?? '12345');
    printWrapped("token $token");
  }
}

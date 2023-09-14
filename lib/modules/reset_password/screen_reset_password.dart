import 'package:we_pro/modules/auth/bloc/reset_password/reset_password_bloc.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';

import '../core/utils/core_import.dart';

/// This class is a stateful widget that creates a screen for the user to reset
/// their password.
class ScreenResetPassword extends StatefulWidget {
  const ScreenResetPassword({Key? key}) : super(key: key);

  @override
  State<ScreenResetPassword> createState() => _ScreenResetPasswordState();
}

class _ScreenResetPasswordState extends State<ScreenResetPassword> {
  ValueNotifier<bool> mLoading = ValueNotifier(false);

  /// Creating a controller for the password text field.
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  /// FocusNode is a class that manages the focus of nodes.
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();

  /// A state management technique.

  ValueNotifier<String> isNewPasswordError = ValueNotifier('');
  ValueNotifier<String> isConfirmPasswordError = ValueNotifier('');
  ValueNotifier<String> isNoMatchPasswordError = ValueNotifier('');
  ValueNotifier<bool> isShowNewPassword = ValueNotifier<bool>(true);
  ValueNotifier<bool> isShowConfirmPassword = ValueNotifier<bool>(true);

  ///[resetPasswordEvent] this method is used to connect to reset password api
  void resetPasswordEvent() async {
    Map<String, dynamic> mBody = {
      ApiParams.paramAccessToken:
          PreferenceHelper.getString(PreferenceHelper.accessToken),
      ApiParams.paramPassword: passwordController.text.trim().toString(),
      ApiParams.paramConfirmPassword:
          confirmPasswordController.text.trim().toString(),
    };
    BlocProvider.of<ResetPasswordBloc>(context)
        .add(ResetPasswordUser(body: mBody, url: AppUrls.apiResetPasswordApi));
  }

  @override
  Widget build(BuildContext context) {
    ///[getResetPasswordAppbar] is used to get Appbar for different views i.e. Mobile and Web
    BaseAppBar getResetPasswordAppbar() {
      return BaseAppBar(
        appBar: AppBar(),
        title: APPStrings.textRestPassword.translate(),
        mLeftImage: APPImages.icArrowBack,
        textStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.titleLarge!,
            Dimens.textSize18,
            FontWeight.w600),
        backgroundColor: Theme.of(context).colorScheme.primary,
        mLeftAction: () {
          NavigatorKey.navigatorKey.currentState!.pop();
        },
      );
    }

    ///[textFieldNewPassword] is used for text input of New password on this screen
    Widget textFieldNewPassword() {
      return BasePasswordTextFormField(
        isShowPassword: isShowNewPassword.value,
        pressShowPassword: () {
          isShowNewPassword.value = !isShowNewPassword.value;
        },
        controller: passwordController,
        focusNode: passwordFocus,
        nextFocusNode: confirmPasswordFocus,
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textNewPassword.translate(),
        onChange: () {
          if (isNewPasswordError.value.isNotEmpty) {
            isNewPasswordError.value = '';
          }
        },
        errorText: isNewPasswordError.value,
        hintText: APPStrings.textEnterNewPassword.translate(),
        hintStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.margin15,
            FontWeight.w400),
        isRequired: true,
        // hintText: 'Enter First Name',
      );
    }

    ///[textFieldConfirmNewPassword] is used for text input of confirm New password on this screen
    Widget textFieldConfirmNewPassword() {
      return BasePasswordTextFormField(
        isShowPassword: isShowConfirmPassword.value,
        pressShowPassword: () {
          isShowConfirmPassword.value = !isShowConfirmPassword.value;
        },
        controller: confirmPasswordController,
        focusNode: confirmPasswordFocus,
        textInputAction: TextInputAction.done,
        titleText: APPStrings.textConfirmNewPassword.translate(),
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

    ///[resetPasswordButton] is used for continue button on this screen
    Widget resetPasswordButton() {
      return CustomButton(
        height: Dimens.margin50,
        backgroundColor: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
        borderRadius: Dimens.margin15,
        onPress: () {
          validateResetPasswordData(context);
        },
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displayMedium!,
            Dimens.textSize15,
            FontWeight.w500),
        buttonText: APPStrings.textRestPassword.translate(),
      );
    }

    ///[resetPasswordDescription] is used to get description for forgot password
    Widget resetPasswordDescription() {
      return Text(
        APPStrings.textRestPasswordDes.translate(),
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.margin12,
            FontWeight.w200),
      );
    }

    ///[mobileSignUpForm] this method is used for mobile signUpn screen
    Widget mobileSignUpForm() {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: Dimens.margin20,
                  ),
                  textFieldNewPassword(),
                  const SizedBox(
                    height: Dimens.margin30,
                  ),
                  textFieldConfirmNewPassword(),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: Dimens.margin20, bottom: Dimens.margin68),
                    child: resetPasswordDescription(),
                  ),
                  resetPasswordButton(),
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

    return MultiValueListenableBuilder(
      valueListenables: [
        mLoading,
        isConfirmPasswordError,
        isNewPasswordError,
        isNoMatchPasswordError,
        isShowNewPassword,
        isShowConfirmPassword
      ],
      builder: (BuildContext context, List<dynamic> values, Widget? child) {
        return BlocListener<ResetPasswordBloc, ResetPasswordState>(
          listener: (context, state) {
            mLoading.value = state is ResetPasswordLoading;
            if (state is ResetPasswordFailure) {
              ToastController.showToast(
                  state.mError.toString(), context, false);
            }
          },
          child: ModalProgressHUD(
            inAsyncCall: mLoading.value,
            progressIndicator: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
            child: Scaffold(
              appBar: getResetPasswordAppbar(),
              backgroundColor: Theme.of(context).primaryColor,
              body: mBody(),
            ),
          ),
        );
      },
    );
  }

  ///[validateResetPasswordData] this method is used to validate input formats of Reset Password data
  Future<void> validateResetPasswordData(BuildContext context) async {
    if (passwordController.text.trim().toString().isEmpty) {
      isNewPasswordError.value = APPStrings.warningEnterNewPassword.translate();
      return;
    } else if (!validatePassword(passwordController.text.toString().trim())) {
      isNewPasswordError.value =
          APPStrings.warningEnterValidNewPassword.translate();
    } else if (confirmPasswordController.text.trim().toString().isEmpty) {
      isConfirmPasswordError.value =
          APPStrings.warningEnterConfirmPassword.translate();
      return;
    } else if (confirmPasswordController.text.trim().toString() !=
        passwordController.text.trim().toString()) {
      isConfirmPasswordError.value =
          APPStrings.warningPasswordNotMatch.translate();
      return;
    } else {
      resetPasswordEvent();
    }
  }
}

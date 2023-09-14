import 'package:we_pro/modules/change_password/bloc/change_password_bloc.dart';

import '../core/utils/api_import.dart';
import '../core/utils/core_import.dart';

/// A screen for changing password.
class ScreenChangePassword extends StatefulWidget {
  const ScreenChangePassword({Key? key}) : super(key: key);

  @override
  State<ScreenChangePassword> createState() => _ScreenChangePasswordState();
}

class _ScreenChangePasswordState extends State<ScreenChangePassword> {
  ValueNotifier<bool> mLoading = ValueNotifier(false);

  /// Creating a controller for the password text field.
  TextEditingController oldController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  /// FocusNode is a class that manages the focus of nodes.
  FocusNode oldPasswordFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();

  /// A state management technique.
  ValueNotifier<String> isOldPassError = ValueNotifier('');
  ValueNotifier<String> isNewPassError = ValueNotifier('');
  ValueNotifier<String> isConfirmPasswordError = ValueNotifier('');
  ValueNotifier<bool> isNewShowPassword = ValueNotifier<bool>(true);
  ValueNotifier<bool> isOldShowPassword = ValueNotifier<bool>(true);
  ValueNotifier<bool> isConfirmShowPassword = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    ///[getResetPasswordAppbar] is used to get Appbar for different views i.e. Mobile and Web
    BaseAppBar getChangePasswordAppbar() {
      return BaseAppBar(
        appBar: AppBar(),
        title: APPStrings.textChangePassword.translate(),
        mLeftImage: APPImages.icArrowBack,
        textStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.titleLarge!,
            Dimens.textSize15,
            FontWeight.w500),
        backgroundColor: Theme.of(context).colorScheme.primary,
        mLeftAction: () {
          NavigatorKey.navigatorKey.currentState!.pop();
        },
      );
    }

    ///[textFieldOldPassword] is used for text input of old password on this screen
    Widget textFieldOldPassword() {
      return BasePasswordTextFormField(
          controller: oldController,
          focusNode: oldPasswordFocus,
          nextFocusNode: passwordFocus,
          titleStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.labelSmall!,
              Dimens.margin12,
              FontWeight.w400),
          textInputAction: TextInputAction.next,
          titleText: APPStrings.textOldPassword.translate(),
          onChange: () {
            if (isOldPassError.value.isNotEmpty) {
              isOldPassError.value = '';
            }
          },
          pressShowPassword: () {
            isOldShowPassword.value = !isOldShowPassword.value;
          },
          fillColor: Theme.of(context).highlightColor,
          errorText: isOldPassError.value,
          hintText: APPStrings.warningEnterOldPassword.translate(),
          hintStyle: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displaySmall!,
              Dimens.margin15,
              FontWeight.w400),
          isRequired: true,
          isShowPassword: isOldShowPassword.value);
    }

    ///[textFieldNewPassword] is used for text input of New password on this screen
    Widget textFieldNewPassword() {
      return BasePasswordTextFormField(
        controller: passwordController,
        focusNode: passwordFocus,
        nextFocusNode: confirmPasswordFocus,
        pressShowPassword: () {
          isNewShowPassword.value = !isNewShowPassword.value;
        },
        titleStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.margin12,
            FontWeight.w400),
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textNewPassword.translate(),
        isShowPassword: isNewShowPassword.value,
        onChange: () {
          if (isNewPassError.value.isNotEmpty) {
            isNewPassError.value = '';
          }
        },
        fillColor: Theme.of(context).highlightColor,
        errorText: isNewPassError.value,
        hintText: APPStrings.warningEnterNewPassword.translate(),
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
        pressShowPassword: () {
          isConfirmShowPassword.value = !isConfirmShowPassword.value;
        },
        fillColor: Theme.of(context).highlightColor,
        isShowPassword: isConfirmShowPassword.value,
        controller: confirmPasswordController,
        focusNode: confirmPasswordFocus,
        textInputAction: TextInputAction.next,
        titleText: APPStrings.textConfirmNewPassword.translate(),
        titleStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.margin12,
            FontWeight.w400),
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

    /// A button to save the password.
    Widget savePasswordButton() {
      return CustomButton(
        height: Dimens.margin50,
        backgroundColor: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
        borderRadius: Dimens.margin15,
        onPress: () {
          validateData(context);
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: Dimens.margin20,
                  ),
                  textFieldOldPassword(),
                  const SizedBox(
                    height: Dimens.margin30,
                  ),
                  textFieldNewPassword(),
                  const SizedBox(
                    height: Dimens.margin30,
                  ),
                  textFieldConfirmNewPassword(),
                  const SizedBox(
                    height: Dimens.margin43,
                  ),
                  savePasswordButton(),
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
        isOldPassError,
        isNewPassError,
        isConfirmPasswordError,
        isNewShowPassword,
        isOldShowPassword,
        isConfirmShowPassword
      ],
      builder: (BuildContext context, List<dynamic> values, Widget? child) {
        return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
          builder: (context, state) {
            return ModalProgressHUD(
              inAsyncCall: state is ChangePasswordLoading,
              progressIndicator: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
              child: Scaffold(
                appBar: getChangePasswordAppbar(),
                backgroundColor: Theme.of(context).primaryColor,
                body: mBody(),
              ),
            );
          },
        );
      },
    );
  }

  ///[validateData] this method is used to validate input formats of Change Password data
  Future<void> validateData(BuildContext context) async {
    if (oldController.text.trim().toString().isEmpty) {
      isOldPassError.value = APPStrings.warningEnterOldPassword.translate();
      return;
    } else if (!validatePassword(oldController.text.toString().trim())) {
      isOldPassError.value =
          APPStrings.warningEnterValidOldPassword.translate();
    } else if (passwordController.text.trim().toString().isEmpty) {
      isNewPassError.value = APPStrings.warningEnterNewPassword.translate();
      return;
    } else if (!validatePassword(passwordController.text.toString().trim())) {
      isNewPassError.value =
          APPStrings.warningEnterValidNewPassword.translate();
    } else if (oldController.text.trim().toString() ==
        passwordController.text.trim().toString()) {
      isNewPassError.value = APPStrings.warningPasswordOldMatch.translate();
      return;
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
      //Todo: Change Password API call
      Map<String, dynamic> mBody = {
        ApiParams.paramOldPassword: oldController.text,
        ApiParams.paramPassword: passwordController.text,
        ApiParams.paramConfirmPassword: confirmPasswordController.text,
      };
      BlocProvider.of<ChangePasswordBloc>(context)
          .add(ChangePasswordUser(body: mBody, url: AppUrls.apiChangePassword));
    }
  }
}

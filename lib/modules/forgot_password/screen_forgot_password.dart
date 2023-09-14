import 'package:we_pro/modules/auth/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';

import '../core/utils/core_import.dart';

/// This class is a stateful widget that creates a screen for the user to enter
/// their email address to reset their password.
class ScreenForgotPassword extends StatefulWidget {
  const ScreenForgotPassword({Key? key}) : super(key: key);

  @override
  State<ScreenForgotPassword> createState() => _ScreenForgotPasswordState();
}

class _ScreenForgotPasswordState extends State<ScreenForgotPassword> {
  /// A state management technique.
  ValueNotifier<bool> mLoading = ValueNotifier(false);
  ValueNotifier<String> isEmailError = ValueNotifier('');
  ValueNotifier<bool> isShowPassword = ValueNotifier<bool>(true);

  /// * [emailIdController] is use for get email address from user
  TextEditingController emailIdController = TextEditingController();

  /// * [emailIdFocusNode] is use for focus Email focus
  FocusNode emailIdFocusNode = FocusNode();

  /// Creating a controller for the password text field.
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  ///[forgotPasswordEvent] this method is used to connect to forgot password api
  void forgotPasswordEvent() async {
    Map<String, dynamic> mBody = {
      ApiParams.paramEmail: emailIdController.text.trim().toString(),
    };
    BlocProvider.of<ForgotPasswordBloc>(context).add(
        ForgotPasswordUser(body: mBody, url: AppUrls.apiForgotPasswordApi));
  }

  @override
  Widget build(BuildContext context) {
    ///[textFieldEmail] is used for text input of email on this screen
    ///[textFieldEmail] is used for text input of email on this screen
    Widget textFieldEmail() {
      return BaseTextFormFieldSuffix(
        controller: emailIdController,
        focusNode: emailIdFocusNode,
        textInputAction: TextInputAction.done,
        titleText: APPStrings.textEmailId.translate(),
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
        keyboardType: TextInputType.emailAddress,
        hintText: APPStrings.warningEnterEmailId.translate(),
        hintStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.margin15,
            FontWeight.w400),
        isRequired: true,
        // hintText: 'Enter First Name',
      );
    }

    ///[getAppbar] is used to get Appbar for different views i.e. Mobile and Web
    BaseAppBar getAppbar() {
      return BaseAppBar(
        appBar: AppBar(),
        title: APPStrings.textForgotPassword1.translate(),
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

    ///[forgotPasswordDescription] is used to get description for forgot password
    Widget forgotPasswordDescription() {
      return Text(
        APPStrings.textForgotPasswordDes.translate(),
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.margin12,
            FontWeight.w200),
      );
    }

    ///[sendVerificationCodeButton] is used for continue button on this screen
    Widget sendVerificationCodeButton() {
      return CustomButton(
        height: Dimens.margin50,
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
        buttonText: APPStrings.textSendVerificationCode.translate(),
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
                  Padding(
                    padding: const EdgeInsets.only(
                        top: Dimens.margin20, bottom: Dimens.margin30),
                    child: forgotPasswordDescription(),
                  ),
                  textFieldEmail(),
                  const SizedBox(height: Dimens.margin30),
                  sendVerificationCodeButton()
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
        isEmailError,
      ],
      builder: (BuildContext context, List<dynamic> values, Widget? child) {
        return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (context, state) {
            mLoading.value = state is ForgotPasswordLoading;
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
      },
    );
  }

  ///[validateResetPasswordData] this method is used to validate input formats of Reset Password data
  Future<void> validateSignUpData(BuildContext context) async {
    if (emailIdController.text.trim().toString().isEmpty) {
      isEmailError.value = APPStrings.warningEnterEmailId.translate();
      return;
    } else if (!validateEmail(emailIdController.text.trim())) {
      isEmailError.value = APPStrings.errorEmail.translate();
      /*  return;
    } else if (emailIdController.text.trim().toString() !=
        emailIdController.text.trim().toString()) {
      isEmailError.value = APPStrings.textNoMatchPassword.translate();*/
      return;
    } else {
      forgotPasswordEvent();
    }
  }
}

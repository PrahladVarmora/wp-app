import 'package:flutter/gestures.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:we_pro/modules/auth/bloc/send_otp/otp_send_bloc.dart';
import 'package:we_pro/modules/auth/bloc/verify_otp/verify_otp_bloc.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';

import '../../core/utils/core_import.dart';

///[ScreenContactOtpVerification] is used for otp verification screen
class ScreenContactOtpVerification extends StatefulWidget {
  const ScreenContactOtpVerification({
    Key? key,
  }) : super(key: key);

  @override
  State<ScreenContactOtpVerification> createState() =>
      _ScreenOtpVerificationState();
}

class _ScreenOtpVerificationState extends State<ScreenContactOtpVerification> {
  final formKey = GlobalKey<FormState>();
  FocusNode otpFocusNode = FocusNode();
  StreamController<ErrorAnimationType>? errorController;
  TextEditingController otpController = TextEditingController();

  ValueNotifier<bool> mLoading = ValueNotifier(false);
  ValueNotifier<String> mOtpError = ValueNotifier('');

  ValueNotifier<bool> isResend = ValueNotifier(false);
  ValueNotifier<int> start = ValueNotifier(AppConfig.resendOtpTime);
  ValueNotifier<String> timerStart =
      ValueNotifier('00:${AppConfig.resendOtpTime}');

  late Timer _timer;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///[getAppbar] is used to get Appbar for different views i.e. Mobile and We
    PreferredSizeWidget getAppBar() {
      return AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          APPStrings.textVerifyYourContactNumber.translate(),
          style: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.titleLarge!,
              Dimens.textSize18,
              FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: Dimens.margin70,
      );
    }

    /// [textVerificationCodeIsSent()]  is used to display verification description text
    Widget textVerificationCodeIsSent() {
      return Text(
        APPStrings.textVerifyYourContactNumberDesc.translate(),
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displaySmall!,
            Dimens.textSize12,
            FontWeight.w400),
      );
    }

    /// [otpBody]  is used to display otp input field
    Widget otpBody() {
      return Container(
        padding: EdgeInsets.symmetric(
            horizontal:
                (MediaQuery.of(context).size.width - Dimens.margin262) / 2),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: PinCodeTextField(
                scrollPadding: EdgeInsets.zero,
                errorTextSpace: Dimens.margin0,
                errorTextMargin: EdgeInsets.zero,
                appContext: context,
                textStyle: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.bodySmall!,
                    Dimens.textSize15,
                    FontWeight.w400),
                hintCharacter: '0',
                showCursor: true,
                length: 4,
                autoDismissKeyboard: true,
                blinkWhenObscuring: true,
                animationType: AnimationType.fade,
                pastedTextStyle: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.bodySmall!,
                    Dimens.textSize15,
                    FontWeight.normal),
                hintStyle: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.displaySmall!,
                    Dimens.margin15,
                    FontWeight.w400),
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(Dimens.margin15),
                  fieldHeight: Dimens.margin50,
                  fieldWidth: Dimens.margin50,
                  activeColor: Theme.of(context).dividerColor,
                  activeFillColor: Theme.of(context).dividerColor,
                  inactiveColor: Theme.of(context).dividerColor,
                  inactiveFillColor: Theme.of(context).dividerColor,
                  selectedFillColor: Theme.of(context).dividerColor,
                  selectedColor: Theme.of(context).dividerColor,
                  borderWidth: Dimens.margin0,
                ),
                autoFocus: true,
                boxShadows: const [
                  BoxShadow(
                    offset: Offset(0, 0),
                    color: Colors.transparent,
                    blurRadius: 0,
                  )
                ],
                cursorColor: AppColors.colorPrimary,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                errorAnimationController: errorController,
                controller: otpController,
                focusNode: otpFocusNode,
                keyboardType: TextInputType.text,
                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onCompleted: (v) {},
                beforeTextPaste: (text) {
                  return true;
                },
                onChanged: (String value) {},
              ),
            ),
            if (mOtpError.value.isNotEmpty) ...[
              const SizedBox(height: Dimens.margin9),
              BaseTextFieldErrorIndicator(errorText: mOtpError.value),
            ],
          ],
        ),
      );
    }

    /// [textTimer]  is used to display timer text
    Widget textTimer() {
      return Center(
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: timerStart.value,
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize15,
                    Responsive.isDesktop(context)
                        ? FontWeight.w400
                        : FontWeight.w500),
              ),
            ],
          ),
        ),
      );
    }

    /// [resendOtpButton]  is used to display resend otp button
    Widget resendOtpButton() {
      return Center(
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: APPStrings.textResend.translate(),
                style: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.labelSmall!,
                  Dimens.textSize15,
                  FontWeight.w600,
                ).copyWith(
                    decoration: TextDecoration.underline, color: Colors.black),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    if (isResend.value) {
                      start.value = AppConfig.resendOtpTime;
                      isResend.value = false;
                      otpController.clear();
                      resendOtpEvent();

                      ///  sendOtpEvent(context);
                      // startTimer();
                    }
                  },
              ),
            ],
          ),
        ),
      );
    }

    ///[submitButton] is used for submit button on this screen
    Widget submitButton() {
      return CustomButton(
        height: Dimens.margin50,
        backgroundColor: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
        borderRadius: Dimens.margin15,
        onPress: () {
          verifyOtpEvent(context);
        },
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displayMedium!,
            Dimens.textSize15,
            FontWeight.normal),
        buttonText: APPStrings.textVerify.translate(),
      );
    }

    ///[mobileSignUpForm] this method is used for mobile signUpn screen
    Widget mobileSignUpForm() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: Dimens.margin11),
          textVerificationCodeIsSent(),
          const SizedBox(height: Dimens.margin30),
          otpBody(),
          const SizedBox(height: Dimens.margin10),
          // textTimer(),
          // const SizedBox(height: Dimens.margin10),
          isResend.value ? resendOtpButton() : textTimer(),
          const SizedBox(height: Dimens.margin19),
          submitButton(),
          const SizedBox(height: Dimens.margin30),
        ],
      );
    }

    ///[mBody] is used to get Mobile view body
    Widget mBody() {
      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.margin16),
          color: Theme.of(context).colorScheme.background,
          child: mobileSignUpForm(),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        ToastController.showToast(
            ValidationString.validationOtpScreenBack.translate(),
            context,
            false);

        return false;
      },
      child: MultiValueListenableBuilder(
          valueListenables: [
            mLoading,
            mOtpError,
            isResend,
            start,
            start,
            timerStart,
          ],
          builder: (context, values, Widget? child) {
            return BlocListener<OtpSendBloc, OtpSendState>(
              listener: (context, state) {
                mLoading.value = state is OtpSendLoading;
                if (state is OtpSendResponse) {
                  startTimer();
                }
              },
              child: BlocListener<VerifyOtpBloc, VerifyOtpState>(
                listener: (context, state) {
                  mLoading.value = state is VerifyOtpLoading;
                },
                child: ModalProgressHUD(
                  inAsyncCall: mLoading.value,
                  progressIndicator: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                  child: Scaffold(
                    appBar: getAppBar(),
                    backgroundColor: Theme.of(context).colorScheme.background,
                    body: mBody(),
                  ),
                ),
              ),
            );
          }),
    );
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }

  ///[backPress] is used to go back to the previous URL
  void backPress(BuildContext context) {
    /// RouteGenerator.historyBack(context);
  }

  void otpVerifySignUpEvent() async {
    Map<String, dynamic> mBody = {
      ApiParams.paramCode: otpController.text,
      ApiParams.paramCodeType: 'sms',
    };
    BlocProvider.of<VerifyOtpBloc>(context)
        .add(VerifyOtpUserSMS(body: mBody, url: AppUrls.apiVerifyOTPApi));
  }

  ///[verifyOtpEvent] is used for verify otp api call
  Future<void> verifyOtpEvent(BuildContext context) async {
    if (otpController.text.isEmpty) {
      mOtpError.value = ValidationString.validationOtpBlank.translate();

      return;
    } else if (otpController.text.length < 4) {
      mOtpError.value = ValidationString.validationInvalidOtp.translate();
      return;
    } else {
      /*  Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.routesSignIn, (route) => false);*/
      otpVerifySignUpEvent();
      /*Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.routesProfileCompletion, (route) => false);*/
    }

    /*PreferenceHelper.setString(AppConfig.paramFcmToken,
        await FirebaseNotificationHelper().getFcmToken() ?? '12345');
    printWrapped(
        'AppConfig.paramFcmToken----------${PreferenceHelper.getString(AppConfig.paramFcmToken)}');
    Map<String, dynamic> mBody = {
      AppConfig.paramMobile:
          PreferenceHelper.getString(PreferenceHelper.userContact),
      AppConfig.paramUser: PreferenceHelper.getString(AppConfig.paramUser),
      AppConfig.paramOtpMobile: otpController.text,
      AppConfig.paramFcmToken:
          PreferenceHelper.getString(AppConfig.paramFcmToken),
    };
    BlocProvider.of<LoginBloc>(getNavigatorKeyContext()).add(VerifyLoginOtp(
      body: mBody,
    ));*/
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (start.value == 0) {
          timer.cancel();
          isResend.value = true;
        } else {
          if (start.value > 10) {
            start.value--;
            timerStart.value = "00:${start.value}";
          } else {
            start.value--;
            timerStart.value = "00:0${start.value}";
          }
          // setState(() {
          //   start.value--;
          // });
        }
      },
    );
  }

  void cancelTimer() {
    _timer.cancel();
  }

  void resendOtpEvent() {
    BlocProvider.of<OtpSendBloc>(getNavigatorKeyContext())
        .add(ResendOtpSendUser(url: AppUrls.apiSendOTPApi, body: const {
      ApiParams.paramVerifyBy: 'sms',
    }));
  }
}

import 'package:lottie/lottie.dart';

import '../../core/utils/core_import.dart';

/// This is a stateful widget for a screen that displays a successful job acceptance
/// message.
class ScreenJobAcceptedSuccessfully extends StatefulWidget {
  const ScreenJobAcceptedSuccessfully({Key? key}) : super(key: key);

  @override
  State<ScreenJobAcceptedSuccessfully> createState() =>
      _ScreenJobAcceptedSuccessfullyState();
}

class _ScreenJobAcceptedSuccessfullyState
    extends State<ScreenJobAcceptedSuccessfully> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        goToJobDetails();
        return true;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.margin15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: Dimens.margin20),
                child: Lottie.asset(APPImages.icSuccessCheck),
              ),
              const SizedBox(
                height: Dimens.margin23,
              ),
              Text(
                APPStrings.textJobSuccessfullyAccepted.translate(),
                textAlign: TextAlign.center,
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize18,
                    FontWeight.bold),
              ),
              const SizedBox(
                height: Dimens.margin23,
              ),
              const Spacer(),
              CustomButton(
                  onPress: () {
                    goToJobDetails();
                  },
                  height: Dimens.margin50,
                  backgroundColor: Theme.of(context).primaryColor,
                  buttonText: APPStrings.textContinue.translate(),
                  style: getTextStyleFontWeight(AppFont.mediumColorWhite,
                      Dimens.margin15, FontWeight.w400),
                  borderRadius: Dimens.margin15_5),
              const SizedBox(
                height: Dimens.margin40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void goToJobDetails() {
    NavigatorKey.navigatorKey.currentState!.pushNamedAndRemoveUntil(
        AppRoutes.routesJobDetail,
        (route) => route.settings.name == AppRoutes.routesDashboard,
        arguments: 2);
  }
}

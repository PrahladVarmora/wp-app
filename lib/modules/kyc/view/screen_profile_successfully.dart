import 'package:lottie/lottie.dart';

import '../../core/utils/core_import.dart';

/// A screen that shows a message to the user that their profile has been successfully updated.
class ScreenProfileSuccessfully extends StatefulWidget {
  const ScreenProfileSuccessfully({Key? key}) : super(key: key);

  @override
  State<ScreenProfileSuccessfully> createState() =>
      _ScreenProfileSuccessfullyState();
}

class _ScreenProfileSuccessfullyState extends State<ScreenProfileSuccessfully> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        goToHome();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.margin15),
          child: Column(
            children: [
              const Expanded(child: SizedBox()),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: Dimens.margin20),
                child: Lottie.asset(APPImages.icSuccessCheck),
              ),
              const SizedBox(
                height: Dimens.margin23,
              ),
              Text(
                APPStrings.textProfileSuccessfully.translate(),
                textAlign: TextAlign.center,
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize18,
                    FontWeight.bold),
              ),
              const SizedBox(
                height: Dimens.margin23,
              ),
              Text(
                APPStrings.textProfileSuccessfullyDesc.translate(),
                textAlign: TextAlign.center,
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize15,
                    FontWeight.normal),
              ),
              const SizedBox(
                height: Dimens.margin120,
              ),
              CustomButton(
                  onPress: () {
                    goToHome();
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

  /// Navigating to the dashboard screen and removing all the screens from the stack.
  void goToHome() {
    NavigatorKey.navigatorKey.currentState!.pushNamedAndRemoveUntil(
      AppRoutes.routesDashboard,
      (route) => false,
    );
  }
}

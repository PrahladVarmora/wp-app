import 'package:lottie/lottie.dart';

import '../../core/utils/core_import.dart';

/// [ScreenAcceptSuccessfully] this screen used for accept my job
class ScreenAcceptSuccessfully extends StatefulWidget {
  final String jobId;

  const ScreenAcceptSuccessfully({Key? key, required this.jobId})
      : super(key: key);

  @override
  State<ScreenAcceptSuccessfully> createState() =>
      _ScreenAcceptSuccessfullyState();
}

class _ScreenAcceptSuccessfullyState extends State<ScreenAcceptSuccessfully> {
  @override
  void initState() {
    super.initState();
    printWrapped('jobId--${widget.jobId}');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        closeJob();
        return true;
      },
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(
              bottom: Dimens.margin25,
              left: Dimens.margin15,
              right: Dimens.margin15),
          child: CustomButton(
              onPress: () {
                closeJob();
              },
              height: Dimens.margin50,
              backgroundColor: Theme.of(context).primaryColor,
              buttonText: APPStrings.textContinue.translate(),
              style: getTextStyleFontWeight(
                  AppFont.mediumColorWhite, Dimens.margin15, FontWeight.w400),
              borderRadius: Dimens.margin15),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.margin15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // const Expanded(child: SizedBox()),
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
              const SizedBox(height: Dimens.margin65),
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
  void closeJob() {
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.routesJobDetail,
        (route) => route.settings.name == AppRoutes.routesDashboard,
        arguments: {
          AppConfig.jobStatus: statusJobCollectPaymentSendInvoice,
          AppConfig.jobId: widget.jobId.toString()
        });
  }
}

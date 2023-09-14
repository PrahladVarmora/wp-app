import 'package:lottie/lottie.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';

import '../../core/utils/core_import.dart';

class ScreenPaymentSuccessfully extends StatefulWidget {
  final JobData mJobData;

  const ScreenPaymentSuccessfully({Key? key, required this.mJobData})
      : super(key: key);

  @override
  State<ScreenPaymentSuccessfully> createState() =>
      _ScreenPaymentSuccessfullyState();
}

class _ScreenPaymentSuccessfullyState extends State<ScreenPaymentSuccessfully> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        closeJob();
        return true;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.margin15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                APPStrings.textPaymentReceived.translate(),
                textAlign: TextAlign.center,
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize18,
                    FontWeight.bold),
              ),
              const SizedBox(height: Dimens.margin65),
              CustomButton(
                  onPress: () {
                    closeJob();
                  },
                  height: Dimens.margin50,
                  backgroundColor: Theme.of(context).primaryColor,
                  buttonText: APPStrings.textDone.translate(),
                  style: getTextStyleFontWeight(AppFont.mediumColorWhite,
                      Dimens.margin15, FontWeight.w400),
                  borderRadius: Dimens.margin30),
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
    Navigator.popAndPushNamed(context, AppRoutes.routesCloseJob,
        arguments: widget.mJobData);
  }
}

import '../../core/utils/core_import.dart';

/// This class is a stateful widget that is used to send a request to the KYC server.
class ScreenSendRequestKYC extends StatefulWidget {
  const ScreenSendRequestKYC({Key? key}) : super(key: key);

  @override
  State<ScreenSendRequestKYC> createState() => _ScreenSendRequestKYCState();
}

class _ScreenSendRequestKYCState extends State<ScreenSendRequestKYC> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.margin15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: SvgPicture.asset(APPImages.icUserKyc)),
            const SizedBox(
              height: Dimens.margin28,
            ),
            Text(
              APPStrings.textDocumentKyc.translate(),
              textAlign: TextAlign.center,
              style: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.labelSmall!,
                  Dimens.textSize15,
                  FontWeight.normal),
            ),
            const SizedBox(
              height: Dimens.margin26,
            ),
            CustomButton(
                onPress: () {
                  NavigatorKey.navigatorKey.currentState!
                      .pushNamedAndRemoveUntil(
                    AppRoutes.routesProfileSuccessfully,
                    (route) => false,
                  );
                },
                height: Dimens.margin50,
                backgroundColor: Theme.of(context).primaryColor,
                buttonText: APPStrings.textRequestKyc.translate(),
                style: getTextStyleFontWeight(
                    AppFont.mediumColorWhite, Dimens.margin15, FontWeight.w400),
                borderRadius: Dimens.margin15_5)
          ],
        ),
      ),
    );
  }
}

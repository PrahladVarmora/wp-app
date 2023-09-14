import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';
import 'package:webviewx/webviewx.dart';

///[ScreenChargeNowPayment] widget is use to show privacy policy screen in my my account tab
class ScreenChargeNowPayment extends StatefulWidget {
  ///[ScreenChargeNowPayment] widget is use to show privacy policy screen in my my account tab
  final String mWebUrl;
  final JobData mJobData;
  final bool isPartial;

  const ScreenChargeNowPayment(
      {Key? key,
      required this.mJobData,
      required this.mWebUrl,
      required this.isPartial})
      : super(key: key);

  @override
  State<ScreenChargeNowPayment> createState() => _ScreenChargeNowPaymentState();
}

class _ScreenChargeNowPaymentState extends State<ScreenChargeNowPayment> {
  ValueNotifier<bool> mLoading = ValueNotifier(true);
  late WebViewXController webViewController;
  final initialContent = '<html>';

  Size get screenSize => MediaQuery.of(context).size;

  @override
  void dispose() {
    webViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///[getResetPasswordAppbar] is used to get Appbar for different views i.e. Mobile and Web
    BaseAppBar getAppbar() {
      return BaseAppBar(
        appBar: AppBar(),
        title: '',
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

    ///[_buildWebViewX] This Widget use to build Web ViewX
    Widget buildWebViewX() {
      return WebViewX(
        key: const ValueKey('webviewx'),
        initialContent: initialContent,
        initialSourceType: SourceType.html,
        height: screenSize.height,
        width: screenSize.width,
        onPageFinished: (value) {
          mLoading.value = false;
        },
        onWebViewCreated: (controller) {
          webViewController = controller;
          _setUrl();
        },
        jsContent: const {
          EmbeddedJsContent(
            js: "function testPlatformIndependentMethod() { console.log('Hi from JS') }",
          ),
          EmbeddedJsContent(
            webJs:
                "function testPlatformSpecificMethod(msg) { TestDartCallback('Web callback says: ' + msg) }",
            mobileJs:
                "function testPlatformSpecificMethod(msg) { TestDartCallback.postMessage('Mobile callback says: ' + msg) }",
          ),
        },
        webSpecificParams: const WebSpecificParams(
          printDebugInfo: true,
        ),
        mobileSpecificParams: const MobileSpecificParams(
          androidEnableHybridComposition: true,
        ),
        navigationDelegate: (navigation) {
          printWrapped(
              'navigation.content.sourceType----${navigation.content.sourceType.toString()}');
          printWrapped(
              'navigation.content.source---${navigation.content.source}');
          if (navigation.content.source
              .contains('https://pay.stripe.com/receipts/payment')) {
            if (widget.isPartial) {
              Navigator.popUntil(
                  context,
                  (route) =>
                      route.settings.name == AppRoutes.routesCollectPayment);
            } else {
              Navigator.pushNamed(
                  getNavigatorKeyContext(), AppRoutes.routesPaymentSuccessfully,
                  arguments: widget.mJobData);
            }
          }

          return NavigationDecision.navigate;
        },
      );
    }

    return Scaffold(
      appBar: getAppbar(),
      backgroundColor: Theme.of(context).primaryColor,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            buildWebViewX(),
          ],
        ),
      ),
    );
  }

  ///[_setUrl] This method use to set URL of webview
  void _setUrl() {
    webViewController.loadContent(
      widget.mWebUrl,
      SourceType.urlBypass,
    );
  }
}

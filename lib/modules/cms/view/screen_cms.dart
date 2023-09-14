import 'package:webviewx/webviewx.dart';

import '../../core/utils/core_import.dart';

///[ScreenCMSWebView] widget is use to show privacy policy screen in my my account tab
class ScreenCMSWebView extends StatefulWidget {
  ///[ScreenCMSWebView] widget is use to show privacy policy screen in my my account tab
  final String mTitle;
  final String mWebUrl;

  const ScreenCMSWebView(
      {Key? key, required this.mTitle, required this.mWebUrl})
      : super(key: key);

  @override
  State<ScreenCMSWebView> createState() => _ScreenCMSWebViewState();
}

class _ScreenCMSWebViewState extends State<ScreenCMSWebView> {
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
        title: widget.mTitle,
        mLeftImage: APPImages.icArrowBack,
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
          return NavigationDecision.navigate;
        },
      );
    }

    return Scaffold(
      appBar: getAppbar(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ValueListenableBuilder(
            valueListenable: mLoading,
            builder: (context, value, child) {
              return Stack(
                children: [
                  buildWebViewX(),
                  if (mLoading.value)
                    ValueListenableBuilder(
                        valueListenable: mLoading,
                        builder: (context, value, child) {
                          return ModalProgressHUD(
                            inAsyncCall: mLoading.value,
                            child: Container(
                              color: Colors.transparent,
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          );
                        }),
                ],
              );
            }),
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

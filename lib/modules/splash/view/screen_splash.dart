import 'package:video_player/video_player.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';

import '../../profile/model/model_get_profile.dart';

/// This class is a stateless widget that displays a splash screen
class ScreenSplash extends StatefulWidget {
  const ScreenSplash({Key? key}) : super(key: key);

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  ValueNotifier<bool> mLoading = ValueNotifier(false);
  late VideoPlayerController controller;

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() {
    controller = VideoPlayerController.asset(APPImages.introVideo)
      ..initialize().then((_) {
        controller.play();
        setState(() {});
      });
    Future.delayed(const Duration(milliseconds: 1500)).whenComplete(() async {
      if (isLoginUser()) {
        String? data =
            PreferenceHelper.getString(PreferenceHelper.userGetProfileData);
        if (data != null && data.isNotEmpty) {
          ModelGetProfile streams = getProfileData();
          printWrapped("profile Splash:- ${streams.profile!.toJson()}");

          if (streams.profile?.emailCheck != "Verified" ||
              streams.profile?.phoneNo != "Verified") {
            printWrapped("profile Splash:- ${streams.profile!.toJson()}");
            checkBackgroundLocation();
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.routesSignIn,
              (route) => false,
            );
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.routesDashboard,
              (route) => false,
            );
          }
        }
      } else {
        checkBackgroundLocation();
        //TODO: Login Page
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.routesSignIn,
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorPrimary,
      body: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: 0.46,
            child: VideoPlayer(
              controller,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.margin100),
            child: SvgPicture.asset(APPImages.weproLogo),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

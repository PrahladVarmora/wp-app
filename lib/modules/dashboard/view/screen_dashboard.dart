import 'package:background_fetch/background_fetch.dart';
import 'package:background_location/background_location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:we_pro/modules/core/api_service/lifecycle_event_handler.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/dashboard/bloc/job_types_filter/job_types_filter_bloc.dart';
import 'package:we_pro/modules/dashboard/view/tabs/tab_account.dart';
import 'package:we_pro/modules/dashboard/view/tabs/tab_home.dart';
import 'package:we_pro/modules/dashboard/view/tabs/tab_job_card.dart';
import 'package:we_pro/modules/dashboard/view/tabs/tab_messages.dart';
import 'package:we_pro/modules/dashboard/view/tabs/tab_wallet.dart';
import 'package:we_pro/modules/masters/get_status/get_status_bloc.dart';
import 'package:we_pro/modules/masters/sources/bloc/assigned_sources_providers/sources_bloc.dart';
import 'package:we_pro/modules/profile/bloc/get_profile/get_profile_bloc.dart';
import 'package:we_pro/modules/profile/bloc/skills/industry/industry_bloc.dart';
import 'package:we_pro/modules/profile/bloc/skills/make_model_year/make_model_year_bloc.dart';
import 'package:we_pro/modules/profile/bloc/update_live_location/update_live_location_bloc.dart';

import '../../core/utils/core_import.dart';

/// It's a placeholder for the dashboard screen.
class ScreenDashboard extends StatefulWidget {
  const ScreenDashboard({Key? key}) : super(key: key);

  @override
  State<ScreenDashboard> createState() => ScreenDashboardState();
}

class ScreenDashboardState extends State<ScreenDashboard>
    with WidgetsBindingObserver {
  static ValueNotifier<int> mCurrentPage = ValueNotifier(0);
  StreamSubscription<Position>? mLocationStream;
  bool isMocked = true;
  Timer? time;
  Timer? timer;
  AppLifecycleState appState = AppLifecycleState.resumed;

  @override
  void initState() {
    initData();

    WidgetsBinding.instance.addObserver(this);
    if (Platform.isIOS) {
      WidgetsBinding.instance.addObserver(
        LifecycleEventHandler(
          resumeCallBack: () async {
            stopBackgroundLocation();
          },
          pausedCallBack: () async {
            startBackgroundLocation();
          },
          suspendingCallBack: () async {
            startBackgroundLocation();
          },
          inactiveCallBack: () async {
            startBackgroundLocation();
          },
        ),
      );
    } else if (Platform.isAndroid) {
      initPlatformState();
    }
    super.initState();
  }

  Future<void> startBackgroundLocation() async {
    await MyAppState.platformChannel
        .invokeMethod('startBackgroundLocationFetch', [
      (await MyAppState.apiProvider
          .getHeaderValueWithUserToken())[AppConfig.xAuthorization],
      AppUrls.apiUpdateLiveLocation,
    ]);
  }

  Future<void> stopBackgroundLocation() async {
    MyAppState.platformChannel.invokeMethod('stopBackgroundLocationFetch');
  }

  Future<void> initPlatformState() async {
// Configure BackgroundFetch.

    await BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 0,
          forceAlarmManager: false,
          stopOnTerminate: false,
          startOnBoot: true,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.NONE,
        ),
        _onBackgroundFetch,
        _onBackgroundFetchTimeout);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    printWrapped("state $state");
    appState = state;
    if (state == AppLifecycleState.resumed) {
      printWrapped("state foreground");
      if (time != null) {
        time!.cancel();
        time = null;
        printWrapped("Timer Stop");
      }
      if (timer != null) {
        timer!.cancel();
        timer = null;
        printWrapped("Timer Stop");
      }
      // BackgroundLocation.stopLocationService();
    } else if (state == AppLifecycleState.paused) {
      if (await Permission.location.isGranted) {
        try {
          await BackgroundLocation.startLocationService(
              forceAndroidLocationManager: true);
        } catch (e) {
          printWrapped(e.toString());
        }
        timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
          printWrapped("state background");
          BackgroundFetch.scheduleTask(TaskConfig(
              taskId: 'updateLocation',
              delay: 1000,
              periodic: false,
              stopOnTerminate: false,
              enableHeadless: true));
          time = timer;
        });
      }
    }
  }

  void _onBackgroundFetch(String taskId) async {
    // var permission = await Geolocator.checkPermission();
    if (await Permission.location.isGranted &&
        appState == AppLifecycleState.paused) {
      if (taskId == 'updateLocation') {
        var location = await Geolocator.getCurrentPosition();
        printWrapped('location ${location.latitude} ${location.longitude}');
        if (Geolocator.distanceBetween(
                location.latitude,
                location.longitude,
                MyAppState.mCurrentPosition.value.latitude,
                MyAppState.mCurrentPosition.value.longitude) >
            0.0) {
          MyAppState.mCurrentPosition.value =
              LatLng(location.latitude, location.longitude);
          Map<String, String> mBody = {
            ApiParams.paramLat: location.latitude.toString(),
            ApiParams.paramLong: location.longitude.toString(),
          };
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          final SharedPreferences pref = await SharedPreferences.getInstance();
          var token = pref.getString(PreferenceHelper.authToken)!;
          var version = packageInfo.version;
          var acceptType = AppConfig.xAcceptDeviceAndroid;
          String acceptLanguage = MaterialAppWidget.notifier.value.languageCode;
          if (kIsWeb) {
            acceptType = AppConfig.xAcceptDeviceWeb;
          } else if (Platform.isIOS) {
            acceptType = AppConfig.xAcceptDeviceIOS;
          }
          var hea = {
            AppConfig.xAcceptAppVersion: version,
            AppConfig.xAcceptDeviceType: acceptType,
            AppConfig.xContentType: "multipart/form-data",
            AppConfig.xAcceptLanguage: acceptLanguage,
            AppConfig.xAuthorization: 'Bearer $token',
          };

          var request = http.MultipartRequest(
              'POST',
              Uri.parse(
                  "https://api.devasapcrm.com/technicians/users/update_live_location"));

          request.headers.addAll(hea);
          mBody.forEach((k, v) {
            request.fields[k] = v;
          });
          printWrapped("request.fields ${request.fields.toString()}");
          var streamedResponse = await request.send();
          var response = await http.Response.fromStream(streamedResponse);
          printWrapped("response -- ${jsonEncode(response.body)}");
        }
      }
    }
    BackgroundFetch.finish(taskId);
  }

  void _onBackgroundFetchTimeout(String taskId) {
    printWrapped('[BackgroundFetch] TIMEOUT: $taskId');

    BackgroundLocation.stopLocationService();
    BackgroundFetch.finish(taskId);
  }

  void initData() {
    getLatLong();
    getMasterAPI();
    mCurrentPage.value = 0;
    getPositionStreamSubscribe();
  }

  @override
  onResume() {
    BackgroundLocation.stopLocationService();
  }

  @override
  onRestart() {
    BackgroundLocation.stopLocationService();
  }

  Future<void> getPositionStreamSubscribe() async {
    await determinePosition().then((value) {
      if (value != null) {
        if (value.isMocked && !Platform.isIOS) {
          if (!faKeGpsDialog) {
            faKeGpsDialog = true;
            ToastController.showToast(APPStrings.textFakeLocation.translate(),
                getNavigatorKeyContext(), false, okBtnFunction: () {
              faKeGpsDialog = false;
              Navigator.pop(getNavigatorKeyContext());
              // SystemNavigator.pop(animated: true);
            }, barrierDismissible: false);
          }
          return;
        } else {
          MyAppState.mCurrentPosition.value =
              LatLng(value.latitude, value.longitude);
          mLocationStream = Geolocator.getPositionStream(
                  locationSettings: const LocationSettings(distanceFilter: 10))
              .listen((event) {
            MyAppState.mCurrentPosition.value =
                LatLng(event.latitude, event.longitude);
            if (event.isMocked) {
              if (!faKeGpsDialog) {
                faKeGpsDialog = true;
                ToastController.showToast(
                    APPStrings.textFakeLocation.translate(),
                    getNavigatorKeyContext(),
                    false, okBtnFunction: () {
                  faKeGpsDialog = false;
                  Navigator.pop(getNavigatorKeyContext());
                  // SystemNavigator.pop(animated: true);
                }, barrierDismissible: false);
              }
            }

            if (mounted) {
              Map<String, String> mBody = {
                ApiParams.paramLat: event.latitude.toString(),
                ApiParams.paramLong: event.longitude.toString(),
              };
              BlocProvider.of<UpdateLiveLocationBloc>(context).add(
                  UpdateLiveLocationUser(
                      url: AppUrls.apiUpdateLiveLocation, body: mBody));
            }

            // mLocation.value = event;
          });
        }
      }
    });
  }

  ///[getMasterAPI] this method is used to all master apis
  void getMasterAPI() async {
    await getProfileEvent();
    // await sourcesEvent();
    // await skillEvent();
    await getStatusEvent();
    await getUpdateDispatchStatusEvent();
    getMakeModelYearListEvent();
    getIndustryList();
    sourcesEvent();
    getJobTypesHistoryFilter();
  }

/*  ///[sourcesEvent] this method is used to connect to sources api
  sourcesEvent() async {
    BlocProvider.of<SourcesBloc>(context)
        .add(Sources(url: AppUrls.apiSourcesDispatchApi));
  }*/

  // ///[skillEvent] this method is used to connect to skill api
  // skillEvent() async {
  //   BlocProvider.of<SkillBloc>(getNavigatorKeyContext())
  //       .add(Skill(url: AppUrls.apiSkillApi));
  // }

  ///[getProfileEvent] this method is used to connect to get profile api
  getProfileEvent() async {
    BlocProvider.of<GetProfileBloc>(context)
        .add(GetProfileUser(url: AppUrls.apiGetProfileApi));
  }

  ///[getStatusEvent] this method is used to connect to get status api [Pending, Rejected etc.]
  getStatusEvent() async {
    BlocProvider.of<GetStatusBloc>(context)
        .add(GetStatusList(url: AppUrls.apiGetStatusApi));
  }

  ///[getUpdateDispatchStatusEvent] this method is used to connect to get status api [Pending, Rejected etc.]
  getUpdateDispatchStatusEvent() async {
    BlocProvider.of<GetStatusBloc>(context).add(GetStatusList(
        url: AppUrls.apiGetUpdateDispatchStatusApi,
        isUpdateDispatchStatus: true));
  }

  getMakeModelYearListEvent() {
    BlocProvider.of<MakeModelYearBloc>(context)
        .add(GetMakeModelYearList(url: AppUrls.apiDispatchSourcesCarInfo));
  }

  void getIndustryList() {
    BlocProvider.of<IndustryBloc>(context)
        .add(GetIndustryList(url: AppUrls.apiDispatchSourcesIndustry));
  }

  void getJobTypesHistoryFilter() {
    BlocProvider.of<JobTypesFilterBloc>(context)
        .add(JobTypesFilterList(url: AppUrls.apiJobTypesHistoryFilter));
  }

  ///[sourcesEvent] this method is used to connect to sources api
  sourcesEvent() async {
    BlocProvider.of<SourcesProvidersBloc>(context)
        .add(GetSourcesList(url: AppUrls.apiSourcesDispatchApi));
  }

  @override
  Widget build(BuildContext context) {
    // addingMobileUiStyles(context);

    /// It returns a widget.
    Widget bottomNavigationBar() {
      return BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: AnimatedContainer(
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.only(top: Dimens.margin10),
                child: mCurrentPage.value == 0
                    ? SvgPicture.asset(
                        APPImages.icUserHomeActive,
                        height: Dimens.margin24,
                        width: Dimens.margin24,
                      )
                    : SvgPicture.asset(
                        APPImages.icUserHome,
                        height: Dimens.margin24,
                        width: Dimens.margin24,
                      ),
              ),
              label: '',
              backgroundColor: Theme.of(context).primaryColor,
            ),
            BottomNavigationBarItem(
              icon: AnimatedContainer(
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 150),
                margin: EdgeInsets.only(
                    top: mCurrentPage.value == 1
                        ? Dimens.margin8
                        : Dimens.margin10),
                child: mCurrentPage.value == 1
                    ? SvgPicture.asset(
                        APPImages.icUserMessagesActive,
                        height: Dimens.margin24,
                        width: Dimens.margin24,
                      )
                    : SvgPicture.asset(
                        APPImages.icUserMessages,
                        height: Dimens.margin24,
                        width: Dimens.margin24,
                      ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: AnimatedContainer(
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.only(top: Dimens.margin10),
                child: SvgPicture.asset(
                  mCurrentPage.value == 2
                      ? APPImages.icWalletActive
                      : APPImages.icWallet,
                  height: Dimens.margin24,
                  width: Dimens.margin24,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: AnimatedContainer(
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 150),
                margin: EdgeInsets.only(
                    top: mCurrentPage.value == 3
                        ? Dimens.margin8
                        : Dimens.margin10),
                child: mCurrentPage.value == 3
                    ? SvgPicture.asset(
                        APPImages.icHistoryActive,
                        height: Dimens.margin24,
                        width: Dimens.margin24,
                      )
                    : SvgPicture.asset(
                        APPImages.icHistory,
                        height: Dimens.margin24,
                        width: Dimens.margin24,
                      ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: AnimatedContainer(
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.only(top: Dimens.margin10),
                child: (mCurrentPage.value == 4)
                    ? SvgPicture.asset(
                        APPImages.icUserAccountActive,
                        height: Dimens.margin24,
                        width: Dimens.margin24,
                      )
                    : SvgPicture.asset(
                        APPImages.icUserAccount,
                        height: Dimens.margin24,
                        width: Dimens.margin24,
                      ),
              ),
              label: '',
            ),
          ],
          currentIndex: mCurrentPage.value,
          selectedItemColor: Colors.black,
          iconSize: 40,
          type: BottomNavigationBarType.fixed,
          backgroundColor: MyAppState.themeChangeValue
              ? AppColors.colorPrimary
              : AppColors.colorPrimary,
          onTap: _onItemTapped,
          elevation: 5);
    }

    /// A placeholder for the body of the screen.
    Widget getBody() {
      switch (mCurrentPage.value) {
        case 0:
          return const TabHome();
        case 1:
          PreferenceHelper.setString(
              PreferenceHelper.currentRoute, AppRoutes.routesChat);
          return const TabMessages();
        case 2:
          return const TabWallet();
        case 3:
          return const TabJobCard();
        case 4:
          return const TabAccount();
      }
      return Container();
    }

    return MultiValueListenableBuilder(
        valueListenables: [
          mCurrentPage,
          // mLocation,
        ],
        builder: (context, values, Widget? child) {
          return WillPopScope(
            onWillPop: () async {
              if (mCurrentPage.value == 0) {
                return true;
              } else {
                mCurrentPage.value -= 1;
                return false;
              }
            },
            child: Scaffold(
              body: getBody(),
              bottomNavigationBar: bottomNavigationBar(),
            ),
          );
        });
  }

  @override
  void dispose() {
    if (mLocationStream != null) {
      mLocationStream?.cancel();
    }
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  /// A method that is used to set the status bar color and icon brightness.
  void addingMobileUiStyles(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: (Theme.of(context).brightness == Brightness.dark)
            ? Colors.transparent
            : Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));
  }

  /// A function that is called when the user taps on a tab.
  ///
  /// Args:
  ///   index (int): The index of the selected bottom navigation bar item.
  void _onItemTapped(int index) {
    if (index != 1) {
      PreferenceHelper.remove(PreferenceHelper.currentRoute);
    }
    mCurrentPage.value = index;
  }

  /// It changes the tab index.
  ///
  /// Args:
  ///   tabIndex (int): The index of the tab to change to.
  static void changeTab(int tabIndex) {
    mCurrentPage.value = tabIndex;
  }

  Future<void> getLatLong() async {
    if (Platform.isIOS) {
      var location = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (MyAppState.mCurrentPosition.value.latitude != location.latitude) {
        MyAppState.mCurrentPosition.value =
            LatLng(location.latitude, location.longitude);
      }
    } else {
      var location = await Geolocator.getCurrentPosition();
      if (MyAppState.mCurrentPosition.value.latitude != location.latitude) {
        MyAppState.mCurrentPosition.value =
            LatLng(location.latitude, location.longitude);
      }
    }
  }
}

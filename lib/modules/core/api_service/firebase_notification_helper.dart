import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:we_pro/modules/core/common/modelCommon/model_chat_notification.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/view/screen_dashboard.dart';
import 'package:we_pro/modules/dashboard/view/tabs/tab_home.dart';

import '../../dashboard/view/tabs/tab_job_card.dart';
import 'lifecycle_event_handler.dart';

/// [FirebaseNotificationHelper] This class use to Firebase Notification Helper
class FirebaseNotificationHelper {
  static final FirebaseNotificationHelper _instance =
      FirebaseNotificationHelper.getInstance();

  factory FirebaseNotificationHelper() {
    return _instance;
  }

  static StreamController<ModalNotificationData> chatStreamController =
      StreamController.broadcast();

  FirebaseNotificationHelper.getInstance();

  static int appStatus = 0; // 0 - foreground , 2 - background , 3 - terminate

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
      APPStrings.appName, APPStrings.appName,
      importance: Importance.high,
      showBadge: true,
      enableVibration: true,
      playSound: true);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// use the returned token to send messages to users from your custom server
  Future<String?> getFcmToken() async {
    return await _firebaseMessaging.getToken();
  }

  /// Init method Background Message Handler
  init({BackgroundMessageHandler? handler}) async {
    if (handler != null) {
      FirebaseMessaging.onBackgroundMessage(handler);
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_wepro_logo');

    DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        if (details.payload != null) {
          notificationClick(details.payload ?? '');
        }
      },
    );
    printWrapped('fcm init');
    String? token;
    token = await _firebaseMessaging.getToken();

    printWrapped('fcm token: $token');
    PreferenceHelper.setString(PreferenceHelper.fcmToken, token ?? '12345');
    PreferenceHelper.getString(PreferenceHelper.fcmToken);

    /// For Save Token
    ///_firebaseMessaging.onTokenRefresh.listen(_saveTokenToPreference);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      checkAppState();
      if (Platform.isAndroid && appStatus == 0) {
        showNotification(message);
      } else {
        showNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      notificationClickIOS(message.data);
    });
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          notificationClickIOS(message.data);
        });
      }
    });
  }

  ///[checkAppState] This method use to check App State
  void checkAppState() {
    appStatus = 0;
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        resumeCallBack: () async {
          appStatus = 0;

          // return ;
        },
        pausedCallBack: () async {
          appStatus = 1;

          // return ;
        },
        suspendingCallBack: () async {
          appStatus = 2;

          // return ;
        },
      ),
    );
  }

  ///[showNotification] This method use to show Notification
  void showNotification(RemoteMessage message) async {
    printWrapped('Message Received ||-->>${json.encode(message.toMap())}');
    // notificationJob
    if (message.data['notification_type'] == notificationJob) {
      TabHomeState.refreshJobDataExternal();
      TabJobCardState.refreshJobDataExternal();
    }
    if ((message.data['notification_type'] == notificationChat &&
            (PreferenceHelper.getString(PreferenceHelper.currentRoute) ==
                    AppRoutes.routesMessageDetails ||
                PreferenceHelper.getString(PreferenceHelper.currentRoute) ==
                    AppRoutes.routesChat)) ||
        (message.data['notification_type'] == notificationCompanyChat &&
            (PreferenceHelper.getString(PreferenceHelper.currentRoute) ==
                    AppRoutes.routesMessageDetails ||
                PreferenceHelper.getString(PreferenceHelper.currentRoute) ==
                    AppRoutes.routesChat)) ||
        (message.data['notification_type'] == notificationAdminChat &&
            (PreferenceHelper.getString(PreferenceHelper.currentRoute) ==
                    AppRoutes.routesMessageAdminDetails ||
                PreferenceHelper.getString(PreferenceHelper.currentRoute) ==
                    AppRoutes.routesChat))) {
      chatStreamController.add(ModalNotificationData.fromJson(message.data));
    } else {
      try {
        if (Platform.isAndroid) {
          NotificationDetails notificationDetails = NotificationDetails(
              android: AndroidNotificationDetails(
                _channel.id,
                _channel.name,
                icon: 'ic_wepro_logo',
                importance: Importance.max,
                priority: Priority.high,
                playSound: true,
              ),
              iOS: const DarwinNotificationDetails(presentSound: true));
          Map<String, dynamic> data = message.data;

          if (data['alert'] != null) {
            flutterLocalNotificationsPlugin.show(
                Random().nextInt(100),
                APPStrings.appName,
                data['alert'] ?? data['message'],
                notificationDetails,
                payload: data['alert'] != null
                    ? json.encode(data)
                    : message.data['sendbird']);
          }
        }
      } catch (e) {
        printWrapped('showNotification error----$e');
      }
    }
  }

  ///[notificationClick] This method use to notification Click
  Future<String> notificationClick(String payload) async {
    notificationRedirection(jsonDecode(payload));
    return '';
  }

  ///[notificationClickIOS] This method use to notification Click IOS
  Future<String> notificationClickIOS(Map<String, dynamic> payload) async {
    notificationRedirection(payload);
    return '';
  }

  static void notificationRedirection(Map payload) {
    printWrapped('notificationRedirection------$payload');
    BuildContext context = getNavigatorKeyContext();
    switch (payload['notification_type']) {
      case notificationJob:
        //TODO: Change Status and Id
        Navigator.pushNamed(context, AppRoutes.routesJobDetail, arguments: {
          AppConfig.jobStatus: statusJobAcceptReject,
          AppConfig.jobId: payload['job_id'],
        });
        break;
      case notificationAdminChat:
        ScreenDashboardState.changeTab(1);
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.routesMessageAdminDetails,
          (route) => route.settings.name == AppRoutes.routesDashboard,
        );
        break;
      case notificationChat:
        ScreenDashboardState.changeTab(1);
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.routesMessageDetails,
          arguments: {
            'jobId': payload['job_id'],
            'clientName': payload['client_name'],
            'chat_type': payload['notification_type'] == 'Company Admin'
                ? 'Company'
                : 'Client',
            'compId': payload['compId'] ?? "",
            'company': payload['company'] ?? "",
          },
          (route) => route.settings.name == AppRoutes.routesDashboard,
        );
        break;
      case notificationCompanyChat:
        ScreenDashboardState.changeTab(1);
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.routesMessageDetails,
          arguments: {
            'jobId': payload['job_id'] ?? "",
            'clientName': payload['notification_type'] == 'Company Admin'
                ? payload['company']
                : payload['client_name'],
            'chat_type': payload['notification_type'] == 'Company Admin'
                ? 'Company'
                : 'Client',
            'compId': payload['compId'] ?? "",
            'company': payload['company'] ?? "",
          },
          (route) => route.settings.name == AppRoutes.routesDashboard,
        );
        break;
      case notificationWallet:
        //TODO: Change clientName and Id
        ScreenDashboardState.changeTab(2);
        Navigator.popUntil(
          context,
          (route) => route.settings.name == AppRoutes.routesDashboard,
        );
        break;
      case notificationPayment:
        //TODO: notificationPayment Redirection
        // ScreenDashboardState.changeTab(2);
        Navigator.popUntil(
          context,
          (route) => route.settings.name == AppRoutes.routesDashboard,
        );
        break;
      default:
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.routesDashboard, (route) => false);
        break;
    }
  }

  void clearAllNotification() {
    flutterLocalNotificationsPlugin.cancelAll();
  }
}

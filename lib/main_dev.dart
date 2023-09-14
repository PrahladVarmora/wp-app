import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:we_pro/firebase_options.dart';
import 'package:we_pro/modules/core/api_service/firebase_notification_helper.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';

import 'modules/core/utils/core_import.dart';

// [Android-only] This "Headless Task" is run when the Android app is terminated with `enableHeadless: true`
// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
      name: APPStrings.appName);
  await Hive.initFlutter();
  await Hive.openBox(AppConfig.hiveThemeBox);
  await PreferenceHelper.load();

  ///This is use for Android iOS
  FirebaseNotificationHelper.getInstance()
      .init(handler: firebaseMessagingBackgroundHandler);
  FlavorConfig(
    variables: {
      "env": "dev",
      "base": "https://api.devasapcrm.com/",
      "api_key": "BqQ7v1ihXGwToiZx",
    },
  );

  runApp(const MyApp());
}

/// If you're going to use other Firebase service in the background, such as Firestore,
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  /// make sure you call initializeApp before using other Firebase .
  printWrapped('RemoteMessage--');
  if (Platform.isAndroid) {
    await Firebase.initializeApp();
  }

  // FirebaseNotificationHelper.getInstance().showNotification(message);
}

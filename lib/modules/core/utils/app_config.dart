import 'dart:io';

import 'package:flutter_flavor/flutter_flavor.dart';

/// Used by [AppConfig] of app and web
class AppConfig {
  static String googleMapKey = Platform.isAndroid
      ? 'AIzaSyAbcpGoG1u2DESVsJPS8rRY4Ox5GAVxHtw'
      : 'AIzaSyAbcpGoG1u2DESVsJPS8rRY4Ox5GAVxHtw';

  static String stripeApiKey =
      FlavorConfig.instance.variables["stripe_api_key"] ?? '';

  static const String facebookAppId = '886289726075838';
  static const String pageLimit = '10';
  static const int pageLimitCount = 10;
  static const String pageLimitMessage = '50';
  static const int pageLimitCountMessage = 50;

  /// Job Status
  static const String jobStatusPending = 'Pending';
  static const String jobStatusConfirmed = 'Confirmed';
  static const String jobStatusNotConfirmed = 'Not Confirmed';
  static const String jobStatusAll = 'All';
  static const String jobStatusMyJob = 'My_Job';

  /// params for jobDetail this use to route for argument
  static const String jobStatus = 'status';
  static const String jobId = 'jobId';

  ///CMS arguments
  static const String argumentsTitle = 'title';
  static const String argumentsUrl = 'url';
  static const String argumentsJob = 'job';
  static const String argumentsIsPartial = 'is_partial';

  /// OTP Timer
  static const int resendOtpTime = 60;

  /// Chicago city location
  static const String defaultLat = '41.8781';
  static const String defaultLong = '87.6298';

  ///Header Key and Value
  static const String xContentType = 'Content-Type';
  static const String xApplicationJson = 'application/json';
  static const String xMultiPartFormData = 'multipart/form-data';
  static const String xAcceptDeviceType = 'accept-device-type';
  static const String xAuthorization = 'Authorization';
  static const String xAcceptAppVersion = 'accept-version';
  static const String xAcceptLanguage = 'accept-language';
  static const String xPage = 'page';
  static const String xAcceptDeviceIOS = '2';
  static const String xAcceptDeviceAndroid = '1';
  static const String xAcceptDeviceWeb = '3';
  static const String xGoogleApiKey = 'X-Goog-Api-Key';
  static const String xGoogleFieldMask = 'X-Goog-FieldMask';
  static const String xGoogleFieldMaskValue =
      'routes.polyline,routes.optimizedIntermediateWaypointIndex,routes.localizedValues';

  /// Date format
  static const String dateFormatYYYYMMDD = 'yyyy-MM-dd';
  static const String dateFormatDDMMYYYY = 'dd-MM-yyyy';
  static const String dateFormatDDMMYYYYHHMMSS = 'dd-MM-yyyy HH:mm:ss';
  static const String dateFormatYYYYMMDDHHMM = 'yyyy-MM-dd HH:mm:ss';
  static const String dateFormatMMDDYYYYHHMM = 'MM-dd-yyyy HH:mm:ss';
  static const String dateFormatHHMMDDMMMYYYY = 'hh:mm a | dd MMM yyyy';
  static const String timeFormatHHMMSS = 'HH:mm:ss';
  static const String dateFormatYYYYMMDDHHMMA = 'yyyy-MM-dd HH:mm a';

  /// Dark Theme Hive
  static const String hiveThemeBox = 'themeBox';
  static const String hiveThemeData = 'themeData';

  /// Hive User Data
  static const String hiveModelUserBox = 'modelUserBox';
  static const String hiveModelUser = 'modelUser';

  /// Masking Format
  static const String maskingMobileInput = '(###) ###-####';
  static const String maskingZipCodeInput = '#####-####';

  /// Regex
  static RegExp regExpAllowDouble =
      RegExp(r'[0-9[0-9]+\.?[0-9]*|\.[0-9]]+\.?[0-9]*|\.[0-9]');
  static RegExp regUserName = RegExp(r'^(?![0-9._])[a-zA-Z0-9_]+$');

  static const String time24Opening = '00:00:00';
  static const String time24Closing = '23:59:59';

  /// chatbot url endpoint for web debug mode
  static const String chatBotEndpoint = '/files/chatbot/index.html';
  static const String onfidoWeb = '/files/fido.html';

  static const String htmlInterpolate =
      '<!DOCTYPE html> <html> <head> <title>Page Title</title> </head> <body>{#}</body> </html>';

  static const String appStoreUrl =
      'https://apps.apple.com/us/app/we_pro-app/id1563835358';

  static const String googlePlayUrl =
      'https://play.google.com/store/apps/details?id=com.app.we_pro';

  static const String googleMapsLocationUrl =
      "https://www.google.com/maps/dir/?api=1&destination={#}";
  static const String branchLinkType = 'branch_link_type';
  static const String branchProviderId = 'branch_provider_id';
  static const String branchReferralCode = 'branch_referral_code';
  static const String kommunicateAppID = '2691fd8fd12fd59dd92d4d8cbb5610a16';
  static const String googleMapsMultipleLocationUrl =
      "https://www.google.com/maps/dir/?api=1&origin={#}&destination={#}&destination_place_id={#}&waypoints={#}&waypoint_place_ids={#}&provideRouteAlternatives=false&travelMode=DRIVING";
}

import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:we_pro/modules/auth/model/model_user.dart';
import 'package:we_pro/modules/core/theme_cubit/theme_cubit.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/model/model_job_types_history_filter.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';
import 'package:we_pro/modules/masters/model/model_get_status.dart';
import 'package:we_pro/modules/profile/model/model_get_profile.dart';

import '../../dashboard/model/model_way_point.dart';
import '../common/dialog/custom_alert_dialog.dart';

bool isPermissionDialogOpen = false;
bool faKeGpsDialog = false;

/// A [maskStringWithMaskFormat] This Method use to get masked string
String maskStringWithMaskFormat(String mMaskFormat, String mInputString) {
  return InterpolateString.interpolate(
      mMaskFormat.replaceAll('#', '{#}'), mInputString.split(''));
}

///[printWrapped] this function is used to print only in debug mode
void printWrapped(String text) {
  final pattern = RegExp('.{1,800}');
  // ignore: avoid_print
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

///[getNavigatorKeyContext] is used to getting current context
BuildContext getNavigatorKeyContext() {
  return NavigatorKey.navigatorKey.currentContext ??
      NavigatorKey.navigatorKey.currentState!.context;
}

/// A [formatTime24H] widget is a widget that describes part of the formatTime
/// * [mTime] which contains the time
/// * [mTimeFormat] which contains the Format
String formatTime24H(var mTime) {
  try {
    DateTime now = DateTime.now();
    var pickUpDateTime =
        DateTime(now.year, now.month, now.day, mTime.hour, mTime.minute);
    String dateFormatted = '';
    if (DateFormat('hh:mm a')
        .format(pickUpDateTime)
        .toLowerCase()
        .contains('pm')) {
      String tmp = DateFormat('hh:mm:ss').format(pickUpDateTime);
      if (int.parse(tmp.split(':').first) == 12) {
        tmp = (int.parse(tmp.split(':').first)).toString() +
            tmp.replaceAll(tmp.split(':').first, '');
      } else {
        tmp = (int.parse(tmp.split(':').first) + 12).toString() +
            tmp.replaceAll(tmp.split(':').first, '');
      }
      dateFormatted = tmp;
    } else if (DateFormat('hh:mm a')
            .format(pickUpDateTime)
            .toLowerCase()
            .contains('am') &&
        DateFormat('hh:mm:ss').format(pickUpDateTime).split(':').first ==
            '12') {
      String tmp = DateFormat('hh:mm:ss').format(pickUpDateTime);
      tmp = (int.parse(tmp.split(':').first) - 12).toString() +
          tmp.replaceAll(tmp.split(':').first, '');
      dateFormatted = tmp;
    } else {
      dateFormatted = DateFormat('hh:mm:ss').format(pickUpDateTime);
    }

    return dateFormatted;
  } catch (e) {
    return mTime.toString();
  }
}

String formatTime12H(var mTime) {
  try {
    DateTime now = DateTime.now();
    var pickUpDateTime =
        DateTime(now.year, now.month, now.day, mTime.hour, mTime.minute);
    String dateFormatted = '';
    /* if (DateFormat('hh:mm a')
        .format(pickUpDateTime)
        .toLowerCase()
        .contains('pm')) {
      String tmp = DateFormat('hh:mm:ss').format(pickUpDateTime);
      if (int.parse(tmp.split(':').first) == 12) {
        tmp = (int.parse(tmp.split(':').first)).toString() +
            tmp.replaceAll(tmp.split(':').first, '');
      } else {
        tmp = (int.parse(tmp.split(':').first) + 12).toString() +
            tmp.replaceAll(tmp.split(':').first, '');
      }
      dateFormatted = tmp;
    } else if (DateFormat('hh:mm a')
            .format(pickUpDateTime)
            .toLowerCase()
            .contains('am') &&
        DateFormat('hh:mm:ss').format(pickUpDateTime).split(':').first ==
            '12') {
      String tmp = DateFormat('hh:mm:ss').format(pickUpDateTime);
      tmp = (int.parse(tmp.split(':').first) - 12).toString() +
          tmp.replaceAll(tmp.split(':').first, '');
      dateFormatted = tmp;
    } else {
      dateFormatted = DateFormat('hh:mm:ss').format(pickUpDateTime);
    }*/
    dateFormatted = DateFormat('hh:mm a').format(pickUpDateTime);
    return dateFormatted;
  } catch (e) {
    return mTime.toString();
  }
}

/// A [formatDate] widget is a widget that describes part of the formatDate
/// * [mDate] which contains the mDate
/// * [mDateFormat] which contains the mDateFormat
String formatDate(var mDate, String mDateFormat) {
  try {
    var dateFormatter = DateFormat(mDateFormat);
    String dateFormatted = dateFormatter.format(mDate);
    return dateFormatted;
  } catch (e) {
    printWrapped('formatDate error-----$e');
    return mDate.toString();
  }
}

///[formatDateWithSuffix] This method use to format Date WithSuffix
String formatDateWithSuffix(String dateStr) {
  try {
    ///19-07-2022 05:25:23
    ///17th Jan 2022 | 02:45 PM
    DateTime parseDate;
    try {
      parseDate = DateFormat(AppConfig.dateFormatDDMMYYYYHHMMSS).parse(dateStr);
      var suffix = 'th';
      var digit = parseDate.day % 10;
      if ((digit > 0 && digit < 4) &&
          (parseDate.day < 11 || parseDate.day > 13)) {
        suffix = ['st', 'nd', 'rd'][digit - 1];
      }
      return DateFormat("MMM d'$suffix' yyyy | hh:mm a").format(parseDate);
    } catch (e) {
      parseDate = DateFormat(AppConfig.dateFormatDDMMYYYY).parse(dateStr);
      var suffix = 'th';
      var digit = parseDate.day % 10;
      if ((digit > 0 && digit < 4) &&
          (parseDate.day < 11 || parseDate.day > 13)) {
        suffix = ['st', 'nd', 'rd'][digit - 1];
      }
      return DateFormat("MMM d'$suffix'").format(parseDate);
    }
  } catch (e) {
    return '-';
  }
}

///[formatOnlyDate] This method use to format Date WithSuffix
String formatOnlyDate(String dateStr,
    {String putInFormat = AppConfig.dateFormatDDMMYYYYHHMMSS}) {
  try {
    ///19-07-2022 05:25:23
    ///17th Jan 2022 | 02:45 PM
    DateTime parseDate = DateFormat(putInFormat).parse(dateStr);
    var suffix = 'th';
    var digit = parseDate.day % 10;
    if ((digit > 0 && digit < 4) &&
        (parseDate.day < 11 || parseDate.day > 13)) {
      suffix = ['st', 'nd', 'rd'][digit - 1];
    }
    return DateFormat("MMM d'$suffix' yyyy").format(parseDate);
  } catch (e) {
    return '-';
  }
}

String formatOnlyDateWallet(String dateStr,
    {String putInFormat = AppConfig.dateFormatMMDDYYYYHHMM}) {
  try {
    ///19-07-2022 05:25:23
    ///17th Jan 2022 | 02:45 PM
    DateTime parseDate = DateFormat(putInFormat).parse(dateStr);
    var suffix = 'th';
    var digit = parseDate.day % 10;
    if ((digit > 0 && digit < 4) &&
        (parseDate.day < 11 || parseDate.day > 13)) {
      suffix = ['st', 'nd', 'rd'][digit - 1];
    }
    return DateFormat("MMM d'$suffix' yyyy").format(parseDate);
  } catch (e) {
    return '-';
  }
}

///[formatOnlyDate] This method use to format Date WithSuffix
String getDateForCustomDisplayFormat(
    String dateStr, String dateFormat, String displayFormat) {
  try {
    ///19-07-2022 05:25:23
    ///17th Jan 2022 | 02:45 PM
    DateTime parseDate = DateFormat(dateFormat).parse(dateStr);
    return DateFormat(displayFormat).format(parseDate);
  } catch (e) {
    return '-';
  }
}

///[formatOnlyDate] This method use to format Date WithSuffix
String getDateForCustomDisplayFormatChat(
    String dateStr, String dateFormat, String displayFormat) {
  try {
    ///19-07-2022 05:25:23
    ///17th Jan 2022 | 02:45 PM
    DateTime parseDate = DateFormat(dateFormat).parse(dateStr, true);
    var dateLocal = parseDate.toUtc().toLocal();
    return DateFormat(displayFormat).format(dateLocal);
  } catch (e) {
    return '-';
  }
}

DateTime getDateForFormatDateString(String dateStr, String dateFormat) {
  ///19-07-2022 05:25:23
  ///17th Jan 2022 | 02:45 PM
  DateTime parseDate = DateFormat(dateFormat).parse(dateStr);
  printWrapped("Date :- $parseDate");
  return parseDate;
}

///[getTimeDurations] This method use to get time for min and hours display
String getTimeDurations(String dateStr, String dateFormat) {
  try {
    ///05:25:23
    ///5h - 25 min
    DateTime parseDate = DateFormat(dateFormat).parse(dateStr);
    int hours = parseDate.hour;
    int minutes = parseDate.minute;
    String durations = '';

    if (hours > 0) {
      durations = '${hours}h';
    }
    if (minutes > 0) {
      if (hours > 0) {
        durations = '${hours}h  $minutes m';
      } else {
        durations = '$minutes m ';
      }
    }
    return durations;
  } catch (e) {
    return '-';
  }
}

///[timeAgoSinceDate] This function is use for display time ago
String timeAgoSinceDate(String dateString, String dateFormat,
    {bool numericDates = true}) {
  try {
    List<String> dateArr = [];
    if (dateString.contains('.')) {
      dateArr = dateString.split('.');
    } else {
      dateString = dateString.replaceAll('Z', '');
      dateArr.add(dateString);
    }
    String finalDate = dateArr[0];

    DateTime notificationDate = DateFormat(dateFormat).parse(finalDate, true);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate.toLocal());

    if (difference.inDays > 8) {
      try {
        return formatDateWithSuffix(dateString);
      } catch (e) {
        return dateString;
      }
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1w ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1d ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours}h ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1h ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1m ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds}s ago';
    } else {
      return 'Just now';
    }
  } catch (e) {
    return dateString;
  }
}

/// [getUser] login user data
ModelUser getUser() {
  String? data = PreferenceHelper.getString(PreferenceHelper.userData);
  if (data != null && data.isNotEmpty) {
    ModelUser streams = ModelUser.fromJson(json.decode(data));
    return streams;
  } else {
    return ModelUser();
  }
}

/// [getProfileData] get profile data
ModelGetProfile getProfileData() {
  String? data =
      PreferenceHelper.getString(PreferenceHelper.userGetProfileData);
  if (data != null && data.isNotEmpty) {
    ModelGetProfile streams = ModelGetProfile.fromJson(json.decode(data));
    return streams;
  } else {
    return ModelGetProfile();
  }
}

/// [setUser] login user data
void setUser(ModelUser user) {
  PreferenceHelper.setString(
      PreferenceHelper.userData, jsonEncode(user.toJson()));
}

/// [isLoginUser] is LoginUser
bool isLoginUser() {
  String? data =
      PreferenceHelper.getString(PreferenceHelper.userGetProfileData);
  if (data != null && data.isNotEmpty) {
    ModelGetProfile streams = ModelGetProfile.fromJson(json.decode(data));
    if (streams.profile?.email != null &&
        (streams.profile?.email ?? '').isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

/// A [formatTime] widget is a widget that describes part of the formatTime
/// * [mTime] which contains the time
/// * [mTimeFormat] which contains the Format
String formatTime(var mTime, String mTimeFormat) {
  try {
    String selTime = '${mTime.hour}:${mTime.minute}:00';

    ///  String dateFormatted = DateFormat.jm().format(DateFormat(mTimeFormat).parse(selTime));
    return selTime;
  } catch (e) {
    return mTime.toString();
  }
}

/// A [formatDate] widget is a widget that describes part of the formatDate
/// * [dateStr] which contains the mDate
/// * [inPutDateFormat] which contains the input
/// * [outPutDateFormat] which contains the output
String convertDateFormat(
    String dateStr, String inPutDateFormat, String outPutDateFormat) {
  try {
    DateTime tempDate = DateFormat(inPutDateFormat).parse(dateStr);
    var date = tempDate.toUtc();
    var dateLocal = date.toLocal();
    String newDate = DateFormat(outPutDateFormat).format(dateLocal);
    return newDate;
  } catch (e) {
    return '-';
  }
}

/// A [convertStringToDateFormat] widget is a widget that describes part of the convertStringToDateFormat
/// * [dateStr] which contains the mDate
/// * [inPutDateFormat] which contains the input
DateTime convertStringToDateFormat(String dateStr, String inPutDateFormat) {
  try {
    DateTime newDate = DateFormat(inPutDateFormat).parse(dateStr);
    return newDate;
  } catch (e) {
    return DateTime.now();
  }
}

/// A [convertStringToTimeOfDay] widget is a widget that describes part of the convertStringToTimeOfDay
/// * [dateStr] which contains the mDate
TimeOfDay convertStringToTimeOfDay(String dateStr) {
  try {
    TimeOfDay newDate = TimeOfDay(
      hour: int.parse(dateStr.split(':')[0]),
      minute: int.parse(dateStr.split(':')[1]),
    );

    return newDate;
  } catch (e) {
    return TimeOfDay.now();
  }
}

///[randomImage] This method use to random Image
String randomImage() {
  var rng = Random();
  return "https://picsum.photos/500/500?random=${rng.nextInt(500)}";
}

///[getNetworkMediaUrl] This method use to getNetworkMediaUrl
String getNetworkMediaUrl(String url) {
  return AppUrls.base + url.replaceFirst('/', '');
}

///[getHtmlContent] This method use to getHtmlContent from html source
String getHtmlContent(String html) {
  return InterpolateString.interpolate(AppConfig.htmlInterpolate, [html]);
}

///[randomNumber] This method use to random Number
int randomNumber({required int maxNum, int? min}) {
  var rng = Random();
  return rng.nextInt(
        maxNum - (min ?? 0),
      ) +
      (min ?? 0);
}

///[setCurrency] This method use to set Currency code in text
String setCurrency(String value) {
  return '\$$value';
}

///[setPercentage] This method use to set Percentage code in text
String setPercentage(dynamic value) {
  return '$value%';
}

///[getPercentage] This method use to get Percentage code in double
double getPercentage({
  required double value,
  required double percentage,
}) {
  return (value * percentage) / 100;
}

///[makeCallAndMail] This method use to make call and send mail
void makeCallAndMail(bool isCall, String data) {
  try {
    if (isCall) {
      launchUrl(Uri.parse('tel:+$data'));
    } else {
      launchUrl(Uri.parse('mailto:$data'));
    }
  } catch (e) {
    ToastController.showToast(ValidationString.validationInternalServerIssue,
        NavigatorKey.navigatorKey.currentContext!, false);
  }
}

///[clickLink] This method use to click Link
void clickLink(String data) {
  try {
    launchUrl(Uri.parse(data), mode: LaunchMode.externalApplication);
  } catch (e) {
    ToastController.showToast(ValidationString.validationInternalServerIssue,
        NavigatorKey.navigatorKey.currentContext!, false);
  }
}

///[clickLink] This method use to click Link
void clickMap(LatLng data, String? address, double lat, double long) {
  try {
    if (address != null && address.isNotEmpty && address.trim().length > 2) {
      printWrapped("address $address");
      launchUrl(
          Uri.parse(InterpolateString.interpolate(
              AppConfig.googleMapsLocationUrl, [address])),
          mode: LaunchMode.externalApplication);
    } else {
      launchUrl(
          Uri.parse(InterpolateString.interpolate(
              AppConfig.googleMapsLocationUrl, ["$lat,$long"])),
          mode: LaunchMode.externalApplication);
    }
  } catch (e) {
    ToastController.showToast(ValidationString.validationInternalServerIssue,
        NavigatorKey.navigatorKey.currentContext!, false);
  }
}

///[clickLink] This method use to click Link
void clickMapMultipleLocation(String data, String? address,
    List<ModelWayPoint> list, String originId, String destinationID) {
  var waypointsLocation = "";
  var waypointsPlaceId = "";
  for (var element in list) {
    if (waypointsLocation.isEmpty) {
      waypointsLocation = element.location.trim();
      waypointsPlaceId = element.placeId;
    } else {
      waypointsLocation = "$waypointsLocation|${element.location.trim()}";
      waypointsPlaceId = "$waypointsPlaceId|${element.placeId}";
    }
    printWrapped(
        "waypoint ${InterpolateString.interpolate(AppConfig.googleMapsMultipleLocationUrl, [
          Uri.encodeFull(data),
          Uri.encodeFull(address!),
          Uri.encodeFull(destinationID),
          Uri.encodeFull(waypointsLocation),
          Uri.encodeFull(waypointsPlaceId),
        ])}");
  }
  try {
    launchUrl(
        Uri.parse(InterpolateString.interpolate(
            AppConfig.googleMapsMultipleLocationUrl, [
          Uri.encodeFull(data),
          Uri.encodeFull(address!),
          Uri.encodeFull(destinationID),
          Uri.encodeFull(waypointsLocation),
          Uri.encodeFull(waypointsPlaceId),
        ])),
        mode: LaunchMode.externalApplication);
  } catch (e) {
    printWrapped(e.toString());
    ToastController.showToast(ValidationString.validationInternalServerIssue,
        NavigatorKey.navigatorKey.currentContext!, false);
  }
}

/// A [checkConnectivity] widget is a widget that describes part of check Connectivity
Future<bool> checkConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    return true;
  } else {
    return false;
  }
}

/// A [getTextStyleFontWeight] This Method Use to get Text Style with FontWeight
TextStyle getTextStyleFontWeight(
    TextStyle mainTextStyle, double size, FontWeight fontWeight) {
  return mainTextStyle.copyWith(fontSize: size, fontWeight: fontWeight);
}

/// A [getFileImageSize] is a method that calculates MB from bytes
double getFileImageSize(var bytes) {
  final mb = bytes / (1048576);
  return mb;
}

///[getThemeData] is used to get current theme data
bool getThemeData({bool def = false}) {
  bool result =
      Hive.box(AppConfig.hiveThemeBox).get(AppConfig.hiveThemeData) ?? def;

  return result;
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
///[determinePosition] this method use to determine Position
Future<Position?> determinePosition() async {
  bool serviceEnabled;

  /// Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    /// Location services are not enabled don't continue
    /// accessing the position and request users of the
    /// App to enable the location services.
    ToastController.showToast(
        ValidationString.errorLocationServicesAreDisabled.translate(),
        NavigatorKey.navigatorKey.currentContext!,
        false);
    PreferenceHelper.setString(
        PreferenceHelper.currentLat, AppConfig.defaultLat);
    PreferenceHelper.setString(
        PreferenceHelper.currentLong, AppConfig.defaultLong);
    return Future.error(
        ValidationString.errorLocationServicesAreDisabled.translate());
  }

  var status = await Permission.locationWhenInUse.status;
  if (status.isDenied) {
    //var locationWhenInUse = await Permission.locationWhenInUse.;
    if (await Permission.locationWhenInUse.isDenied) {
      /// Permissions are denied, next time you could try
      /// requesting permissions again (this is also where
      /// Android's shouldShowRequestPermissionRationale
      /// returned true. According to Android guidelines
      /// your App should show an explanatory UI now.
      PreferenceHelper.setString(
          PreferenceHelper.currentLat, AppConfig.defaultLat);
      PreferenceHelper.setString(
          PreferenceHelper.currentLong, AppConfig.defaultLong);
      // ToastController.showToast(
      //     ValidationString.errorLocationServicesAreDenied.translate(),
      //     NavigatorKey.navigatorKey.currentContext!,
      //     false);
      if (!isPermissionDialogOpen) {
        checkBackgroundLocation();
      }
      return Future.error(
          ValidationString.errorLocationServicesAreDenied.translate());
    } else if (await Permission.locationAlways.status.isDenied) {
      // var locationAlways = await Permission.locationAlways.request();
      // if (locationAlways.isDenied) {
      //   checkBackgroundLocation();
      // }
    }
  }

  if (status.isPermanentlyDenied) {
    /// Permissions are denied forever, handle appropriately.
    PreferenceHelper.setString(
        PreferenceHelper.currentLat, AppConfig.defaultLat);
    PreferenceHelper.setString(
        PreferenceHelper.currentLong, AppConfig.defaultLong);
    // ToastController.showToast(
    //     ValidationString.errorLocationServicesArePermanentlyDenied.translate(),
    //     NavigatorKey.navigatorKey.currentContext!,
    //     false);
    CustomAlertDialog.showCustomDialog(
      getNavigatorKeyContext(),
      content: ValidationString.errorLocationServicesArePermanentlyDenied
          .translate(),
      okBtnText: 'Ok',
      barrierDismissible: false,
      okBtnFunction: () async {
        await Geolocator.openAppSettings();
        Navigator.pop(getNavigatorKeyContext());
      },
    );
    return Future.error(
        ValidationString.errorLocationServicesArePermanentlyDenied.translate());
  }

  /// When we reach here, permissions are granted and we can
  /// continue accessing the position of the device.
  Position mPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      forceAndroidLocationManager: true);
  if (mPosition.isMocked) {
    if (!faKeGpsDialog) {
      faKeGpsDialog = true;
      ToastController.showToast(APPStrings.textFakeLocation.translate(),
          getNavigatorKeyContext(), false, okBtnFunction: () {
        faKeGpsDialog = false;
        Navigator.pop(getNavigatorKeyContext());
        // SystemNavigator.pop(animated: true);
      }, barrierDismissible: false);
    }
    return mPosition;
  } else {
    return mPosition;
  }
}

Future<Position> determinePositionIos() async {
  bool serviceEnabled;
  LocationPermission permission;

  /// Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    /// Location services are not enabled don't continue
    /// accessing the position and request users of the
    /// App to enable the location services.
    ToastController.showToast(
        ValidationString.errorLocationServicesAreDisabled.translate(),
        NavigatorKey.navigatorKey.currentContext!,
        false);
    PreferenceHelper.setString(
        PreferenceHelper.currentLat, AppConfig.defaultLat);
    PreferenceHelper.setString(
        PreferenceHelper.currentLong, AppConfig.defaultLong);
    return Future.error(
        ValidationString.errorLocationServicesAreDisabled.translate());
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      /// Permissions are denied, next time you could try
      /// requesting permissions again (this is also where
      /// Android's shouldShowRequestPermissionRationale
      /// returned true. According to Android guidelines
      /// your App should show an explanatory UI now.
      PreferenceHelper.setString(
          PreferenceHelper.currentLat, AppConfig.defaultLat);
      PreferenceHelper.setString(
          PreferenceHelper.currentLong, AppConfig.defaultLong);
      ToastController.showToast(
          ValidationString.errorLocationServicesAreDenied.translate(),
          NavigatorKey.navigatorKey.currentContext!,
          false);

      return Future.error(
          ValidationString.errorLocationServicesAreDenied.translate());
    }
  }

  if (permission == LocationPermission.deniedForever) {
    /// Permissions are denied forever, handle appropriately.
    PreferenceHelper.setString(
        PreferenceHelper.currentLat, AppConfig.defaultLat);
    PreferenceHelper.setString(
        PreferenceHelper.currentLong, AppConfig.defaultLong);
    // ToastController.showToast(
    //     ValidationString.errorLocationServicesArePermanentlyDenied.translate(),
    //     NavigatorKey.navigatorKey.currentContext!,
    //     false);
    CustomAlertDialog.showCustomDialog(
      getNavigatorKeyContext(),
      content: ValidationString.errorLocationServicesArePermanentlyDenied
          .translate(),
      okBtnText: 'Ok',
      barrierDismissible: false,
      okBtnFunction: () async {
        await Geolocator.openAppSettings();
        Navigator.pop(getNavigatorKeyContext());
      },
    );
    return Future.error(
        ValidationString.errorLocationServicesArePermanentlyDenied.translate());
  }

  /// When we reach here, permissions are granted and we can
  /// continue accessing the position of the device.
  Position mPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      forceAndroidLocationManager: true);
  if (mPosition.isMocked) {
    if (!faKeGpsDialog) {
      faKeGpsDialog = true;
      ToastController.showToast(APPStrings.textFakeLocation.translate(),
          getNavigatorKeyContext(), false, okBtnFunction: () {
        faKeGpsDialog = false;
        Navigator.pop(getNavigatorKeyContext());
        // SystemNavigator.pop(animated: true);
      }, barrierDismissible: false);
    }
    return Future.error(APPStrings.textFakeLocation.translate());
  } else {
    return mPosition;
  }
}

// Future<Position> determinePositionIos() async {
//   bool serviceEnabled;
//   LocationPermission permission;
//
//   /// Test if location services are enabled.
//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     /// Location services are not enabled don't continue
//     /// accessing the position and request users of the
//     /// App to enable the location services.
//     ToastController.showToast(
//         ValidationString.errorLocationServicesAreDisabled.translate(),
//         NavigatorKey.navigatorKey.currentContext!,
//         false);
//     PreferenceHelper.setString(
//         PreferenceHelper.currentLat, AppConfig.defaultLat);
//     PreferenceHelper.setString(
//         PreferenceHelper.currentLong, AppConfig.defaultLong);
//     return Future.error(
//         ValidationString.errorLocationServicesAreDisabled.translate());
//   }
//
//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       /// Permissions are denied, next time you could try
//       /// requesting permissions again (this is also where
//       /// Android's shouldShowRequestPermissionRationale
//       /// returned true. According to Android guidelines
//       /// your App should show an explanatory UI now.
//       PreferenceHelper.setString(
//           PreferenceHelper.currentLat, AppConfig.defaultLat);
//       PreferenceHelper.setString(
//           PreferenceHelper.currentLong, AppConfig.defaultLong);
//       ToastController.showToast(
//           ValidationString.errorLocationServicesAreDenied.translate(),
//           NavigatorKey.navigatorKey.currentContext!,
//           false);
//
//       return Future.error(
//           ValidationString.errorLocationServicesAreDenied.translate());
//     }
//   }
//
//   if (permission == LocationPermission.deniedForever) {
//     /// Permissions are denied forever, handle appropriately.
//     PreferenceHelper.setString(
//         PreferenceHelper.currentLat, AppConfig.defaultLat);
//     PreferenceHelper.setString(
//         PreferenceHelper.currentLong, AppConfig.defaultLong);
//     // ToastController.showToast(
//     //     ValidationString.errorLocationServicesArePermanentlyDenied.translate(),
//     //     NavigatorKey.navigatorKey.currentContext!,
//     //     false);
//     CustomAlertDialog.showCustomDialog(
//       getNavigatorKeyContext(),
//       content: ValidationString.errorLocationServicesArePermanentlyDenied
//           .translate(),
//       okBtnText: 'Ok',
//       barrierDismissible: false,
//       okBtnFunction: () async {
//         await Geolocator.openAppSettings();
//         Navigator.pop(getNavigatorKeyContext());
//       },
//     );
//     return Future.error(
//         ValidationString.errorLocationServicesArePermanentlyDenied.translate());
//   }
//
//   /// When we reach here, permissions are granted and we can
//   /// continue accessing the position of the device.
//   Position mPosition = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.bestForNavigation,
//       forceAndroidLocationManager: true);
//   if (mPosition.isMocked) {
//     ToastController.showToast(APPStrings.textFakeLocation.translate(),
//         getNavigatorKeyContext(), false, okBtnFunction: () {
//       Navigator.pop(getNavigatorKeyContext());
//       // SystemNavigator.pop(animated: true);
//     }, barrierDismissible: false);
//     return Future.error(APPStrings.textFakeLocation.translate());
//   } else {
//     return mPosition;
//   }
// }

///[setThemeData] is used to set current theme data
void setThemeData(BuildContext context, {bool isDark = false}) {
  isDark
      ? BlocProvider.of<ThemeCubit>(context).setThemeDataDark()
      : BlocProvider.of<ThemeCubit>(context).setThemeDataLight();
}

/// A [isInteger] method is a check Integer value
bool isInteger(num value) => value is int || value == value.roundToDouble();

/// A [validateACHAccount] widget is a widget that describes part of validate Bank ACH Account Number
bool validateACHAccount(String data) =>
    RegExp(r'(^(?:[+0]9)?[0-9]{8,9}$)').hasMatch(data);

/// A [validateBankAccount] widget is a widget that describes part of validate Bank Account Number
bool validateBankAccount(String data) =>
    RegExp(r'(^(?:[+0]9)?[0-9]{6,17}$)').hasMatch(data);

/// A [validatePhone] widget is a widget that describes part of validate Phone number
bool validatePhone(String data) =>
    RegExp(r'(^(?:[+0]9)?[0-9]{8,12}$)').hasMatch(data);

/// A [validateEmail] widget is a widget that describes part of validate Phone number
bool validateEmail(String data) => RegExp(
        r'^[a-z0-9](\.?[a-z0-9_-]){0,}@[a-z0-9-]+\.([a-z]{2,6}\.)?[a-z]{2,6}$')
    .hasMatch(data.toLowerCase());

/// A [validatePassword] widget is a widget that describes part of validate Phone number
bool validatePassword(String data) => RegExp(
        r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,16}$)')
    .hasMatch(data);

/// A [checkIsValidUrl] widget is a widget that describes part of validate URL
bool checkIsValidUrl(String value) {
  var isValid = false;
  if (RegExp(
          r"https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)")
      .hasMatch(value)) {
    isValid = true;
  }
  return isValid;
}

///[signInView] This widget use to mScreen ExceptionView
Widget signInView(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.colorTransparent,
    body: InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimens.margin10, vertical: Dimens.margin10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.margin10),
              color: Theme.of(context).colorScheme.background,
            ),
            height: Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.height - 150
                : MediaQuery.of(context).size.height - Dimens.margin100,
            width: Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width * 0.3
                : MediaQuery.of(context).size.width - Dimens.margin30,
            child: ScreenExceptionView(
                mImage: APPImages.icNoData,
                keyText: ValidationString.errorPleaseSignInWithUser.translate(),
                mButton: CustomButton(
                  height: Dimens.margin60,
                  width: Responsive.isMobile(context)
                      ? double.infinity
                      : Dimens.margin300,
                  backgroundColor: Theme.of(context).primaryColor,
                  borderColor: Theme.of(context).primaryColor,
                  borderRadius: Dimens.margin15,
                  onPress: () {
                    //TODO: Logout clear data
                  },
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.displayMedium!,
                      Dimens.textSize15,
                      FontWeight.w500),
                  buttonText: APPStrings.textSignIn.translate(),
                )),
          ),
        ),
      ),
    ),
  );
}

///[rateUs] is used for rate us function
void rateUs() {
  if (Platform.isAndroid) {
    clickLink(AppConfig.googlePlayUrl);
  } else if (Platform.isIOS) {
    clickLink(AppConfig.appStoreUrl);
  }
}

/// It returns a list of strings.
List<String> getAvailabilityStatus() {
  return [
    APPStrings.textAvailable,
    APPStrings.textOnTask,
    APPStrings.textOnBreak,
  ];
}

/// It returns a list of strings.
List<String> getSortByText() {
  return [
    APPStrings.textDistance,
    APPStrings.textNewest,
    APPStrings.textOldest,
    APPStrings.textUpcoming,
  ];
}

/// It returns a TextStyle object based on the status.
///
/// Args:
///   status (int): The status of the message.
TextStyle getTextStyleStatus(String status) {
  switch (status) {
    case statusAvailable:
      return AppFont.mediumBold
          .copyWith(color: AppColors.color50E666, fontSize: Dimens.textSize12);
    case statusOnTask:
      return AppFont.mediumBold
          .copyWith(color: AppColors.color007FFF, fontSize: Dimens.textSize12);
    case statusOnBreak:
      return AppFont.mediumBold
          .copyWith(color: AppColors.colorD95151, fontSize: Dimens.textSize12);
    default:
      return AppFont.mediumBold
          .copyWith(color: AppColors.colorD95151, fontSize: Dimens.textSize12);
  }
}

/// It returns a color based on the status.
///
/// Args:
///   status (int): The status of the current cell.
Color getColorStatus(String status) {
  switch (status) {
    case statusAvailable:
      return AppColors.color50E666;

    case statusOnTask:
      return AppColors.color007FFF;

    case statusOnBreak:
      return AppColors.colorD95151;

    default:
      return AppColors.colorD95151;
  }
}

Color getColorStatusJobType(String status) {
  switch (status) {
    case statusPending:
      return AppColors.color50E666;
    case statusConfirmed:
      return AppColors.color50E666;
    case statusNotConfirmed:
      return AppColors.colorD95151;
    case statusAppointments:
      return AppColors.color007FFF;
    case statusSubmitted:
      return AppColors.color007FFF;
    case statusInProgress:
      return AppColors.color007FFF;
    case statusDone:
      return AppColors.colorE56E07;
    case statusCanceled:
      return AppColors.colorD95151;
    case statusNoAnswer:
      return AppColors.colorD95151;
    case statusRejected:
      return AppColors.colorD95151;
    default:
      return AppColors.colorD95151;
  }
}

Color getBackgroundColorStatusJobType(String status) {
  switch (status) {
    case statusPending:
      return AppColors.color50E666.withOpacity(0.3);
    case statusConfirmed:
      return AppColors.color50E666.withOpacity(0.3);
    case statusNotConfirmed:
      return AppColors.colorD95151.withOpacity(0.3);
    case statusAppointments:
      return AppColors.colorDEEEFF;
    case statusSubmitted:
      return AppColors.colorDEEEFF;
    case statusInProgress:
      return AppColors.colorDEEEFF;
    case statusDone:
      return AppColors.colorFDE4CE;
    case statusCanceled:
      return AppColors.colorD95151.withOpacity(0.3);
    case statusNoAnswer:
      return AppColors.colorD95151.withOpacity(0.3);
    case statusRejected:
      return AppColors.colorD95151.withOpacity(0.3);
    default:
      return AppColors.colorD95151.withOpacity(0.3);
  }
}

/// [getStatus] get status
getStatus(String status) {
  String? data = PreferenceHelper.getString(PreferenceHelper.userGetStatusList);
  if (data != null && data.isNotEmpty) {
    ModelGetStatus streams = ModelGetStatus.fromJson(json.decode(data));
    for (int i = 0; i < streams.jobStatus!.length; i++) {
      if (streams.jobStatus![i].status == status) {
        return streams.jobStatus![i].jsId;
      }
    }
  }
}

List<JobStatus> getStatusList() {
  String? data = PreferenceHelper.getString(PreferenceHelper.userGetStatusList);
  if (data != null && data.isNotEmpty) {
    ModelGetStatus streams = ModelGetStatus.fromJson(json.decode(data));
    return streams.jobStatus ?? [];
  }
  return [];
}

List<JobStatus> getUpdateDispatchStatusList() {
  String? data = PreferenceHelper.getString(
      PreferenceHelper.userGetUpdateDispatchStatusList);
  if (data != null && data.isNotEmpty) {
    ModelGetStatus streams = ModelGetStatus.fromJson(json.decode(data));
    return streams.jobStatus ?? [];
  }
  return [];
}

List<JobTypeFilter> getJobTypesHistoryFilterList() {
  String? data =
      PreferenceHelper.getString(PreferenceHelper.jobTypesHistoryFilter);
  if (data != null && data.isNotEmpty) {
    ModelJobTypesHistoryFilter streams =
        ModelJobTypesHistoryFilter.fromJson(json.decode(data));
    return streams.jobTypeFilter ?? [];
  }
  return [];
}

List<JobData> getMyJobList() {
  String? data = PreferenceHelper.getString(PreferenceHelper.myJob);
  List<JobData> jobData = <JobData>[];
  if (data != null && data.isNotEmpty) {
    jsonDecode(data).forEach((v) {
      jobData.add(JobData.fromJson(v));
    });
  }

  return jobData;
}

void setMyJobList(List<JobData> jobData) {
  final data = jobData.map((v) => v.toJson()).toList();
  PreferenceHelper.setString(PreferenceHelper.myJob, jsonEncode(data));
  PreferenceHelper.getString(PreferenceHelper.myJob);
}

List<ModelCommonSelect> paymentMethodList() {
  return [
    ModelCommonSelect(title: 'Cash', value: payCash),
    ModelCommonSelect(title: 'Check', value: payCheque),
    ModelCommonSelect(title: 'Charge Now', value: payChargeNow),
    ModelCommonSelect(title: 'Credit/Debit Card', value: payCreditCard),
    ModelCommonSelect(title: 'CashApp', value: payCashApp),
    ModelCommonSelect(title: 'Zelle', value: payZelle),
    ModelCommonSelect(title: 'Venmo', value: payVenom),
  ];
}

List<ModelCommonSelect> paymentMethodListForInvoice() {
  return [
    ModelCommonSelect(title: 'Cash', value: payCash),
    ModelCommonSelect(title: 'Check', value: payCheque),
    ModelCommonSelect(title: 'Credit/Debit Card', value: payCreditCard),
    ModelCommonSelect(title: 'CashApp', value: payCashApp),
    ModelCommonSelect(title: 'Zelle', value: payZelle),
    ModelCommonSelect(title: 'Venmo', value: payVenom),
  ];
}

ModelCommonSelect paymentMethodFromList(
    String pMethod, List<ModelCommonSelect> methods) {
  try {
    return methods.firstWhere((element) => element.value == pMethod);
  } catch (e) {
    return ModelCommonSelect(title: pMethod, value: pMethod);
  }
}

List<ModelCommonSelect> sendInvoiceTypeList() {
  return [
    ModelCommonSelect(title: 'None', value: 'None'),
    ModelCommonSelect(title: 'Email', value: 'Email'),
    ModelCommonSelect(title: 'Phone', value: 'SMS'),
    ModelCommonSelect(title: 'Email and Phone', value: 'Both')
  ];
}

int getJobStatus(String data) {
  ///[mStatus] 1 = before accept, 2 = Accepted(In Progress), 3 = completed
  switch (data) {
    case 'Not Confirmed':
      return statusJobAcceptReject;
    case 'Pending':
      return statusJobAcceptReject;
    case 'Confirmed':
      return statusJobCollectPaymentSendInvoice;
    case 'Appointments':
      return statusJobCollectPaymentSendInvoice;
    case 'Submitted':
      return statusJobCollectPaymentSendInvoice;
    case 'In Progress':
      return statusJobCollectPaymentSendInvoice;
    case 'Done':
      return statusJobMarkAsDone;
    case 'Canceled':
      return statusJobClosed;
    case 'No Answer':
      return statusJobCollectPaymentSendInvoice;
    case 'locksmith':
      return statusJobCollectPaymentSendInvoice;
    case 'Rejected':
      return statusJobAcceptReject;
    default:
      return statusJobAcceptReject;
  }
}

Future<void> checkBackgroundLocation() async {
  var status = await Permission.locationWhenInUse.status;
  if (Platform.isAndroid) {
    if (!status.isGranted && !isPermissionDialogOpen) {
      isPermissionDialogOpen = true;
      CustomAlertDialog.showCustomPermissionDialog(getNavigatorKeyContext(),
          content:
              "WePro Tech App collects location data to enable identification of nearby jobs and request the job even when app is closed or not in use.",
          okBtnText: 'ACCEPT',
          barrierDismissible: false,
          okBtnFunction: () async {
            isPermissionDialogOpen = false;
            printWrapped("tesdt print --> 1");
            final requested = await [
              Permission.location,
              Permission.locationWhenInUse,
            ].request();
            printWrapped(
                "tesdt print --> 2 ${requested[Permission.location].toString()}");
            // if (requested[Permission.locationAlways] ==
            //     PermissionStatus.permanentlyDenied) {
            //   printWrapped(
            //       "tesdt print -->3  ${requested[Permission.locationAlways].toString()}");
            //   openAppSettings();
            // }
            if (requested[Permission.locationWhenInUse] ==
                PermissionStatus.granted) {
              printWrapped("tesdt print -->4  ");
              final requested = await Permission.locationAlways.request();
              if (requested.isGranted) {
                printWrapped("tesdt print -->5  ");
                determinePosition().then((value) {
                  if (value != null) {
                    MyAppState.mCurrentPosition.value =
                        LatLng(value.latitude, value.longitude);
                  }
                });
              } else if (requested.isPermanentlyDenied) {
                openAppSettings();
              }
            }
            Navigator.pop(getNavigatorKeyContext());
          },
          cancelBtnText: "DENY",
          cancelBtnFunction: () {
            isPermissionDialogOpen = false;
            Navigator.pop(getNavigatorKeyContext());
          }
          // checkBackgroundPermission();
          );
    } else {
      determinePosition().then((value) {
        if (value != null) {
          MyAppState.mCurrentPosition.value =
              LatLng(value.latitude, value.longitude);
        }
      });
    }
  } else if (Platform.isIOS) {
    determinePositionIos();
  }
}

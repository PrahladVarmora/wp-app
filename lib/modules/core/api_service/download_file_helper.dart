// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/app_string.dart';

///[DownloadFileHelper] This class is use to android DownloadFileHelper
class DownloadFileHelper {
  // next three lines makes this class a Singleton
  static final DownloadFileHelper _instance = DownloadFileHelper.getInstance();

  DownloadFileHelper.getInstance();

  factory DownloadFileHelper() => _instance;

  Future<String> downloadFile(String url) async {
    final response = await http.get(Uri.parse(url));
    final responseJson = response.bodyBytes;
    String name = url.substring(url.lastIndexOf("/") + 1);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;
    String localPath = (await _findLocalPath())
        .toString()
        .replaceAll("/Android/data/", "")
        .replaceAll(packageName.toString(), "")
        .replaceAll("/files", "");
    localPath = localPath + APPStrings.androidDownloadPath;
    final savedDir = Directory(localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    final file = File('$localPath/${name.split('?').first}');
    file.writeAsBytes(responseJson);
    return file.path;
  }

  _findLocalPath() async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    return directory!.path;
  }
}

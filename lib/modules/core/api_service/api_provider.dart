import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:we_pro/modules/auth/model/model_user.dart';
import 'package:we_pro/modules/core/common/modelCommon/model_common_authorised.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';

/// A [ApiProvider] class is used to network API call
/// Allows all classes implementing [Client] to be mutually composable.
class ApiProvider {
  static final ApiProvider _singletonApiProvider = ApiProvider._internal();

  factory ApiProvider() {
    return _singletonApiProvider;
  }

  ApiProvider._internal();

  Future<Map<String, String>> getHeaderValueWithAccessToken() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var version = packageInfo.version;
    var acceptType = AppConfig.xAcceptDeviceAndroid;
    String acceptLanguage =
        MaterialAppWidget.notifier.value.languageCode.toString();

    if (kIsWeb) {
      acceptType = AppConfig.xAcceptDeviceWeb;
    } else if (Platform.isIOS) {
      acceptType = AppConfig.xAcceptDeviceIOS;
    }

    return {
      AppConfig.xAcceptAppVersion: version,
      AppConfig.xAcceptDeviceType: acceptType,
      AppConfig.xContentType: AppConfig.xMultiPartFormData,
      AppConfig.xAcceptLanguage: acceptLanguage,
      AppConfig.xAuthorization:
          'Bearer ${FlavorConfig.instance.variables["api_key"] ?? ''}',
    };
  }

  Future<Map<String, String>> getHeaderValueWithUserToken() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    ModelUser mUser = getUser();
    var version = packageInfo.version;
    var acceptType = AppConfig.xAcceptDeviceAndroid;
    String acceptLanguage = MaterialAppWidget.notifier.value.languageCode;
    if (kIsWeb) {
      acceptType = AppConfig.xAcceptDeviceWeb;
    } else if (Platform.isIOS) {
      acceptType = AppConfig.xAcceptDeviceIOS;
    }
    return {
      AppConfig.xAcceptAppVersion: version,
      AppConfig.xAcceptDeviceType: acceptType,
      AppConfig.xContentType: "multipart/form-data",
      // AppConfig.xContentType: AppConfig.xApplicationJson,
      AppConfig.xAcceptLanguage: acceptLanguage,
      AppConfig
              .xAuthorization: /*kDebugMode
          ? 'Bearer dGv8l_CsTlSkL6R-7hQBij:APA91bGnl-gawV7cq-0RDsMDuDNo-VQmJscfUZQqeiv0EHl1yIOhkYZryYMC0FNJuRr4jKgvT6zycphAq6wjPCMXE95taEzJHbcuRFR1jqlmT6-MWv3anGFtQBhOgGx1JHlSmfTo1xXN'
          :*/
          'Bearer ${mUser.accessToken}',
    };
  }

  Map<String, String> getHeaderValueForGoogleMapAPI() {
    return {
      AppConfig.xContentType: AppConfig.xApplicationJson,
      AppConfig.xGoogleApiKey: AppConfig.googleMapKey,
      AppConfig.xGoogleFieldMask: AppConfig.xGoogleFieldMaskValue,
    };
  }

  /// HTTP methods

  /// It takes a url, a map of parameters, a map of headers and a client as parameters and returns a
  /// Future of either a dynamic or a ModelCommonAuthorised
  ///
  /// Args:
  ///   client (http): http.Client object
  ///   url (String): The url of the API
  ///   params (Map<String, dynamic>): The parameters to be sent to the server.
  ///   mHeader (Map<String, String>): This is the header that you want to pass to the API.
  ///
  /// Returns:
  ///   A Future<Either<dynamic, ModelCommonAuthorised>>

  Future<Either<dynamic, ModelCommonAuthorised>> callPostMethod(
      http.Client client,
      String url,
      Map<String, dynamic> params,
      Map<String, String> mHeader) async {
    var baseUrl = Uri.parse(url);
    printWrapped('Method---POST');
    printWrapped('baseUrl--$baseUrl');
    printWrapped('mHeader--${jsonEncode(mHeader)}');
    printWrapped('requestBody--${jsonEncode(params)}');
    if (MyAppState.isConnected.value) {
      return await client
          .post(baseUrl, body: jsonEncode(params), headers: mHeader)
          .timeout(const Duration(seconds: 500))
          .then((Response response) {
        printWrapped(
            'response of ----$baseUrl \nresponse body==: ${response.body}\nstatus code==: ${response.statusCode}');

        return getResponse(response, url);
      });
    } else {
      return left(null);
    }
  }

  Future<Either<dynamic, ModelCommonAuthorised>> callPostMultipartMethod(
      String url,
      Map<String, dynamic> params,
      Map<String, String> mHeader,
      List<ModelMultiPartFile> mFiles) async {
    if (MyAppState.isConnected.value) {
      var baseUrl = Uri.parse(url);
      printWrapped('Method---POST-Multipart mobile');
      printWrapped('baseUrl--$baseUrl');
      printWrapped('mHeader--${mHeader.toString()}');
      printWrapped('requestBody--${jsonEncode(params)}');

      var request = http.MultipartRequest('POST', baseUrl);
      for (int i = 0; i < mFiles.length; i++) {
        request.files.add(await http.MultipartFile.fromPath(
          mFiles[i].apiKey,
          mFiles[i].filePath,
        ));
        printWrapped(
            'requestFiles--$i--${mFiles[i].apiKey}-----${mFiles[i].filePath}');
        printWrapped(
            'requestFiles--size--${await File(mFiles[i].filePath).length()}');
      }
      request.headers.addAll(mHeader);
      params.forEach((k, v) {
        request.fields[k] = v;
      });
      var streamedResponse =
          await request.send().timeout(const Duration(seconds: 500));
      final response = await http.Response.fromStream(streamedResponse);
      printWrapped(
          'response of ----$baseUrl \nresponse body==: ${response.body}\nstatus code==: ${response.statusCode}');

      return await getResponse(response, url);
    } else {
      return left(null);
    }
  }

  Future<Either<dynamic, ModelCommonAuthorised>> callGetMethod(
      http.Client client, String url, Map<String, String> mHeader) async {
    if (MyAppState.isConnected.value) {
      var baseUrl = Uri.parse(url);
      printWrapped('Method---GET');
      printWrapped('baseUrl--$baseUrl');
      printWrapped('mHeader--${mHeader.toString()}');
      return await client
          .get(baseUrl, headers: mHeader)
          .timeout(const Duration(seconds: 500))
          .then((Response response) {
        printWrapped(
            'response of ----$baseUrl \nresponse body==: ${response.body}\nstatus code==: ${response.statusCode}');

        return getResponse(response, url);
      });
    } else {
      return left(null);
    }
  }

  Future<Either<dynamic, ModelCommonAuthorised>>
      callPostMultipartMethodForDownload(
    String url,
    Map<String, dynamic> params,
    Map<String, String> mHeader,
  ) async {
    if (MyAppState.isConnected.value) {
      var baseUrl = Uri.parse(url);
      printWrapped('Method---POST-Multipart Download File');
      printWrapped('baseUrl--$baseUrl');
      printWrapped('mHeader--${mHeader.toString()}');
      printWrapped('requestBody--${jsonEncode(params)}');

      var request = http.MultipartRequest('POST', baseUrl);
      request.headers.addAll(mHeader);
      params.forEach((k, v) {
        request.fields[k] = v;
      });
      var streamedResponse =
          await request.send().timeout(const Duration(seconds: 500));
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        printWrapped(
            'response of ----$baseUrl \nstatus code==: ${response.statusCode}');
        return left(response.bodyBytes);
      } else {
        printWrapped(
            'response of ----$baseUrl \nresponse body==: ${response.body}\nstatus code==: ${response.statusCode}');
        return getResponse(response, url);
      }
    } else {
      return left(null);
    }
  }

  Future<Either<dynamic, ModelCommonAuthorised>> callPutMethod(
      http.Client client,
      String url,
      Map<String, dynamic> params,
      Map<String, String> mHeader) async {
    if (MyAppState.isConnected.value) {
      var baseUrl = Uri.parse(url);
      printWrapped('Method---PUT');
      printWrapped('baseUrl--$baseUrl');
      printWrapped('mHeader--${mHeader.toString()}');
      printWrapped('requestBody--${jsonEncode(params)}');
      return await client
          .put(baseUrl, body: jsonEncode(params), headers: mHeader)
          .timeout(const Duration(seconds: 500))
          .then((Response response) {
        printWrapped(
            'response of ----$baseUrl \nresponse body==: ${response.body}\nstatus code==: ${response.statusCode}');
        return getResponse(response, url);
      });
    } else {
      return left(null);
    }
  }

  Future<Either<dynamic, ModelCommonAuthorised>> callDeleteMethod(
      http.Client client,
      String url,
      Map<String, dynamic> params,
      Map<String, String> mHeader) async {
    if (MyAppState.isConnected.value) {
      var baseUrl = Uri.parse(url);
      printWrapped('Method---DELETE');
      printWrapped('baseUrl--$baseUrl');
      printWrapped('mHeader--${mHeader.toString()}');
      printWrapped('requestBody--${jsonEncode(params)}');
      return await client
          .delete(baseUrl, body: jsonEncode(params), headers: mHeader)
          .timeout(const Duration(seconds: 500))
          .then((Response response) {
        printWrapped(
            'response of ----$baseUrl \nresponse body==: ${response.body}\nstatus code==: ${response.statusCode}');
        return getResponse(response, url);
      });
    } else {
      return left(null);
    }
  }

  /// this function use for List
  Future<Either<dynamic, ModelCommonAuthorised>>
      callPutMethodWithTokenJsonEncodeContentTypeWithList(
          http.Client client,
          String url,
          List<dynamic>? params,
          Map<String, String> mHeader) async {
    if (MyAppState.isConnected.value) {
      var baseUrl = Uri.parse(url);
      printWrapped('Method---PUT with List of Model');
      printWrapped('baseUrl--$baseUrl');
      printWrapped('mHeader--${mHeader.toString()}');
      params?.forEach((element) {
        printWrapped('requestBody Element--${jsonEncode(element.toJson())}');
      });

      return await http
          .put(
            baseUrl,
            body: json.encode(params),
            headers: mHeader,
          )
          .timeout(const Duration(seconds: 500))
          .then((http.Response response) {
        printWrapped(
            'response of ----$baseUrl \nresponse body==: ${response.body}\nstatus code==: ${response.statusCode}');
        return getResponse(response, url);
      });
    } else {
      return left(null);
    }
  }

  /// this function use for List
  Future<Either<dynamic, ModelCommonAuthorised>> callPostMethodWithList(
      http.Client client,
      String url,
      List<dynamic>? params,
      Map<String, String> mHeader) async {
    if (MyAppState.isConnected.value) {
      var baseUrl = Uri.parse(url);
      printWrapped('Method---POST with List of Model');
      printWrapped('baseUrl--$baseUrl');
      printWrapped('mHeader--${mHeader.toString()}');
      params?.forEach((element) {
        printWrapped('requestBody Element--${jsonEncode(element.toJson())}');
      });

      return await http
          .post(
            baseUrl,
            body: json.encode(params),
            headers: mHeader,
          )
          .timeout(const Duration(seconds: 500))
          .then((http.Response response) {
        printWrapped(
            'response of ----$baseUrl \nresponse body==: ${response.body}\nstatus code==: ${response.statusCode}');
        return getResponse(response, url);
      });
    } else {
      return left(null);
    }
  }

  /// A function that returns a Future of type Either<dynamic, ModelCommonAuthorised>
  ///
  /// Args:
  ///   response: The response from the server.
  ///
  /// Returns:
  ///   The response is being returned.
  Future<Either<dynamic, ModelCommonAuthorised>> getResponse(
      var response, var baseUrl) async {
    final int statusCode = response.statusCode!;
    if (statusCode == 500 || statusCode == 502) {
      ModelCommonAuthorised streams = ModelCommonAuthorised.fromJson(json.decode(
          '{"status":"error","msg":"${jsonDecode(response.body)['msg'] ?? ValidationString.validationInternalServerIssue}"}'));
      return right(
        streams,
      );
    } else if (statusCode == 401) {
      RouteGenerator.logoutClearData(getNavigatorKeyContext());
      ModelCommonAuthorised streams = ModelCommonAuthorised.fromJson(json.decode(
          '{"status":"error","msg":"${jsonDecode(response.body)['msg']}"}'));
      return right(
        streams,
      );
    } else if (statusCode == 403 ||
        statusCode == 400 ||
        statusCode == 422 ||
        statusCode == 505) {
      ModelCommonAuthorised streams = ModelCommonAuthorised.fromJson(json.decode(
          '{"status":"error","msg":"${jsonDecode(response.body)['msg'].toString().trim()}"}'));
      return right(
        streams,
      );
    } else if (statusCode == 405) {
      String error = ValidationString.validationThisMethodNotAllowed;
      ModelCommonAuthorised streams = ModelCommonAuthorised.fromJson(json.decode(
          '{"status":"error","msg":"${(jsonDecode(response.body)['msg'] ?? error).toString().trim()}"}'));
      return right(
        streams,
      );
    } else if (statusCode < 200 || statusCode > 404) {
      String error = response.headers!['message'].toString();
      ModelCommonAuthorised streams = ModelCommonAuthorised.fromJson(
          json.decode('{"status":"error","msg":"$error"}'));
      return right(
        streams,
      );
    }
    /* else if (statusCode == 200) {
      ModelCommonAuthorised streams = ModelCommonAuthorised.fromJson(json.decode(
          '{"status":"${jsonDecode(response.body)['status']}","msg":"${jsonDecode(response.body)['msg']}"}'));
      if (streams.status != null && streams.status == "error") {
        return right(
          streams,
        );
      } else {
        return left(
          response.body,
        );
      }
    }*/
    return left(
      response.body,
    );
  }
}

///[ModelMultiPartFile] is used for file value
class ModelMultiPartFile {
  String filePath;
  String apiKey;

  ModelMultiPartFile({required this.filePath, required this.apiKey});
}

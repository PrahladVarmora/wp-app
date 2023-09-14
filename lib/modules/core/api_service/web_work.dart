import 'package:universal_html/html.dart' as html;
import 'package:we_pro/modules/core/api_service/common_service.dart';
import 'package:we_pro/modules/core/api_service/web_image_downloader.dart';
import 'package:we_pro/modules/core/utils/string_extension.dart';

///[downloadFile] This method is use to download File for web
void downloadFile(String url) async {
  try {
    if (!url.isPdf()) {
      await WebImageDownloader().downloadImageFromWeb(url);
    } else {
      html.window.open(url, "_blank");
    }
  } catch (e) {
    ///Error
    printWrapped('download error---$e');
  }
}

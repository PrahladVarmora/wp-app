import 'package:cached_network_image/cached_network_image.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';

/// [ImageViewerNetwork] which is a  use to Circle Image Viewer Network
/// [String] which is a url
/// [Function] that a click event.
/// [double] that a mHeight of image
class ImageViewerNetwork extends StatelessWidget {
  final String url;

  final double? mHeight;
  final double? mWidth;
  final BoxFit? mFit;

  const ImageViewerNetwork({
    Key? key,
    required this.url,
    this.mHeight,
    this.mFit,
    this.mWidth,
    // this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        height: mHeight,
        width: mWidth,
        fit: mFit ?? BoxFit.cover,
        errorWidget: (context, url, error) => SvgPicture.asset(
              APPImages.icPlaceholder,
              height: mHeight,
              width: mWidth,
              fit: mFit ?? BoxFit.cover,
            ),
        placeholder: (context, url) => SizedBox(
              height: Dimens.margin50,
              width: Dimens.margin50,
              child: Container(
                  height: Dimens.margin50,
                  width: Dimens.margin50,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  )),
            ),
        imageUrl: url);
  }
}

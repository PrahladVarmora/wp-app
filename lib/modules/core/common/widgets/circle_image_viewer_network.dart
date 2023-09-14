import 'package:cached_network_image/cached_network_image.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';

/// [CircleImageViewerNetwork] which is a  use to Circle Image Viewer Network
/// [String] which is a url
/// [Function] that a click event.
/// [double] that a mHeight of image
class CircleImageViewerNetwork extends StatelessWidget {
  final String? url;
  final Function? onPressed;
  final double? mHeight;

  const CircleImageViewerNetwork({
    Key? key,
    this.url,
    this.mHeight,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(mHeight! / 2),
      child: url == null
          ? const SizedBox()
          : CachedNetworkImage(
              height: mHeight,
              width: mHeight,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Image.asset(
                    APPImages.icPlaceholder,
                    height: mHeight,
                    width: mHeight,
                    fit: BoxFit.cover,
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
              imageUrl: url ?? ''),
    );
  }
}

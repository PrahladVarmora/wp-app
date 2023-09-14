import 'package:we_pro/modules/core/utils/core_import.dart';

///[ScreenExceptionView] this class used to any type of  Exception View UI
///[EdgeInsets] Use to Image Padding
///[double] Use to Image Size
///[TextStyle] Use to Text style
///[String] Use to image file
///[String] Use to key Text
///[Color] Use to bg Color
class ScreenExceptionView extends StatelessWidget {
  final EdgeInsets? mEdgeInsets;
  final double? mSize;
  final TextStyle? style;
  final Widget? mButton;
  final String? mImage;
  final String keyText;
  final Color? bgColor;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? textPadding;

  const ScreenExceptionView(
      {Key? key,
      this.bgColor,
      this.mButton,
      this.style,
      this.mSize,
      this.mEdgeInsets,
      this.alignment,
      this.textPadding,
      this.mImage = '',
      required this.keyText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor ?? Theme.of(context).colorScheme.background,
      alignment: alignment ?? Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: textPadding ?? const EdgeInsets.all(Dimens.margin20),
            child: Text(
              keyText,
              textAlign: TextAlign.center,
              style: style ??
                  getTextStyleFontWeight(
                      Theme.of(context).textTheme.labelSmall!,
                      Dimens.margin25,
                      FontWeight.w600),
            ),
          ),
          mImage != ''
              ? Padding(
                  padding: mEdgeInsets ?? const EdgeInsets.all(Dimens.margin16),
                  child: SvgPicture.asset(
                    mImage!,
                    height: mSize ?? Dimens.margin200,
                    width: mSize ?? Dimens.margin200,
                  ),
                )
              : const SizedBox(),
          mButton != null
              ? Padding(
                  padding: const EdgeInsets.only(bottom: Dimens.margin20),
                  child: mButton,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

import 'package:we_pro/modules/core/utils/core_import.dart';

/// A [CustomButton] widget is a widget that describes part of the user interface by button
/// * [buttonText] which contains the button Text
/// * [height] which contains the button height
/// * [width] which contains the button width
/// * [backgroundColor] which contains the button backgroundColor
/// * [borderColor] which contains the button borderColor
/// * [borderRadius] which contains the button borderRadius
/// * [onPress] which contains the button onPress
/// * [style] which contains the button TextStyle
// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton({
    Key? key,
    this.buttonText,
    this.height,
    this.width,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.onPress,
    this.style,
    this.isLoading = false,
  }) : super(key: key);

  String? buttonText;
  double? height;
  double? width;
  Color? backgroundColor;
  Color? borderColor;
  double? borderRadius;
  TextStyle? style;
  final bool isLoading;
  final Function? onPress;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            height: height ?? 50,
            width: width,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: backgroundColor,
            ),
          )
        : InkWell(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 0)),
            splashColor: AppColors.colorTransparent,
            hoverColor: AppColors.colorTransparent,
            highlightColor: AppColors.colorTransparent,
            onTap: () {
              if (onPress != null) {
                FocusScope.of(context).unfocus();
                onPress!();
              }
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.zero,
              height: height ?? 50,
              width: width,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(borderRadius ?? 0)),
                color:
                    backgroundColor ?? Theme.of(context).colorScheme.background,
                border: Border.all(
                    color: borderColor ??
                        backgroundColor ??
                        Theme.of(context).colorScheme.background),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '$buttonText',
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: style ??
                      AppFont.mediumColorWhite
                          .copyWith(fontSize: Dimens.textSize12),
                ),
              ),
            ),
          );
  }
}

/// A [CustomButton] widget is a widget that describes part of the user interface by button
/// * [buttonText] which contains the button Text
/// * [height] which contains the button height
/// * [width] which contains the button width
/// * [backgroundColor] which contains the button backgroundColor
/// * [borderColor] which contains the button borderColor
/// * [borderRadius] which contains the button borderRadius
/// * [onPress] which contains the button onPress
/// * [style] which contains the button TextStyle
/// * [Widget] for widgets that always build the same way given a

class CustomChildButton extends StatelessWidget {
  const CustomChildButton({
    Key? key,
    this.buttonText,
    this.height,
    this.width,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.onPress,
    this.style,
    this.isLoading = false,
    this.child,
  }) : super(key: key);

  final String? buttonText;
  final double? height;
  final double? width;
  final bool? isLoading;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final Widget? child;
  final TextStyle? style;
  final Function? onPress;

  @override
  Widget build(BuildContext context) {
    return isLoading!
        ? Container(
            height: height ?? 50,
            width: width ?? MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          )
        : InkWell(
            onTap: () {
              if (onPress != null) {
                FocusScope.of(context).unfocus();
                onPress!();
              }
            },
            splashColor: AppColors.colorTransparent,
            hoverColor: AppColors.colorTransparent,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 0)),
            child: Container(
              alignment: Alignment.center,
              height: height ?? 50,
              width: width ?? MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(borderRadius ?? 0)),
                color:
                    backgroundColor ?? Theme.of(context).colorScheme.background,
                border: Border.all(
                    color: borderColor ??
                        Theme.of(context).colorScheme.background),
              ),
              child: child,
            ),
          );
  }
}

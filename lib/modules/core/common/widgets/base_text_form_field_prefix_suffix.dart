import 'package:we_pro/modules/core/utils/core_import.dart';

/// A [BaseTextFormFieldPrefixSuffix] widget is a widget that describes part of the user interface by button
/// A [TextInputFormatter] can be optionally injected into an [EditableText]
/// to provide as-you-type validation and formatting of the text being edited.
/// * [TextInputType]  can specify whether it supports decimal numbers and/or signed numbers.
/// * [TextInputAction] does not necessarily cause any specific behavior to
/// * [maxLength] which contains the max Length of text
/// * [hintText] which contains the hint text
/// * [labelStyle] the widget that specifies the text styles. It is combined with the `fontFamily` argument to set the
/// * [FocusNode] a widget that manages a [FocusNode] and provides access to focus
///   information and actions to its descendant widgets.
/// * [TextEditingController] Creates a controller for an editable text field.
class BaseTextFormFieldPrefixSuffix extends StatelessWidget {
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final String? hintText;
  final String? titleText;
  final String? errorText;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? titleStyle;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final bool? enabled;
  final double? height;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Function? onChange;
  final Function? onSubmit;
  final double borderRadius;

  const BaseTextFormFieldPrefixSuffix({
    Key? key,
    this.suffixIcon,
    this.prefixIcon,
    this.height,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.hintText,
    this.focusNode,
    this.controller,
    this.nextFocusNode,
    this.enabled,
    this.titleStyle,
    this.titleText,
    this.errorText,
    this.labelStyle,
    this.hintStyle,
    this.fillColor,
    this.onChange,
    this.onSubmit,
    this.borderRadius = Dimens.margin12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder mOutlineInputBorder() {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
            color: Theme.of(context).highlightColor, width: Dimens.margin0),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleText != null && titleText!.isNotEmpty
            ? Text(
                titleText ?? '',
                style: titleStyle ??
                    getTextStyleFontWeight(
                        Theme.of(context).primaryTextTheme.displaySmall!,
                        Dimens.margin15,
                        FontWeight.normal),
              )
            : const SizedBox(),
        SizedBox(
          height: titleText != null && titleText!.isNotEmpty
              ? Dimens.margin8
              : Dimens.margin0,
        ),
        SizedBox(
          // height: height ?? Dimens.margin60,
          child: TextField(
            maxLines: 3,
            minLines: 1,
            enabled: enabled ?? true,
            inputFormatters: inputFormatters ?? [],
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            maxLength: maxLength,
            focusNode: focusNode,
            controller: controller,
            onSubmitted: (val) {
              if (val.isNotEmpty && onSubmit != null) {
                onSubmit!();
              }
            },
            onChanged: (val) {
              if (val.isNotEmpty && onChange != null) {
                onChange!();
              }
            },
            onEditingComplete: () {
              if (nextFocusNode != null) {
                FocusScope.of(context).requestFocus(nextFocusNode);
              } else {
                FocusScope.of(context).unfocus();
              }
            },
            decoration: InputDecoration(
              hoverColor: AppColors.colorTransparent,
              counterText: '',
              filled: true,
              fillColor: fillColor ??
                  (enabled != null && enabled!
                      ? Theme.of(context).hintColor
                      : Theme.of(context).dividerColor),
              enabledBorder: mOutlineInputBorder(),
              focusedBorder: mOutlineInputBorder(),
              disabledBorder: mOutlineInputBorder(),
              border: mOutlineInputBorder(),
              prefixIcon: prefixIcon ?? const SizedBox(),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: Dimens.margin15),
              suffixIcon: suffixIcon ?? const SizedBox(),
              contentPadding: const EdgeInsets.all(Dimens.margin15),
              hintText: hintText,
              labelStyle: enabled == false
                  ? hintStyle
                  : labelStyle ??
                      getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.bodySmall!,
                          Dimens.textSize15,
                          FontWeight.normal),
              hintStyle: hintStyle ??
                  getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.displaySmall!,
                      Dimens.margin15,
                      FontWeight.w400),
            ),
            style: labelStyle ??
                getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.bodySmall!,
                    Dimens.textSize15,
                    FontWeight.normal),
          ),
        ),
        SizedBox(
          height: errorText != null && errorText!.isNotEmpty
              ? Dimens.margin9
              : Dimens.margin0,
        ),
        errorText != null && errorText!.isNotEmpty
            ? BaseTextFieldErrorIndicator(
                errorText: errorText,
              )
            : const SizedBox(),
      ],
    );
  }
}

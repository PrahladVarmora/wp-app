import 'package:we_pro/modules/core/utils/core_import.dart';

/// A [BaseTextFormField] widget is a widget that describes part of the user interface by button
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
/// * [isShowPassword] isShowPassword call [function] with the specified show or hide text.
/// * [Function] Dynamically call [function] with the specified arguments.
class BasePasswordTextFormField extends StatelessWidget {
  final List<TextInputFormatter>? inputFormatters;
  final Function pressShowPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final String? hintText;
  final String? titleText;
  final bool isShowPassword;
  final String? errorText;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? titleStyle;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final bool? enabled;
  final double? height;
  final TextEditingController? controller;
  final Function? onChange;
  final Function? onSubmit;
  final bool isRequired;

  final Color? fillColor;

  const BasePasswordTextFormField(
      {Key? key,
      required this.isRequired,
      this.height,
      required this.pressShowPassword,
      required this.isShowPassword,
      this.inputFormatters,
      this.keyboardType = TextInputType.visiblePassword,
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
      this.onChange,
      this.onSubmit,
      this.fillColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder mOutlineInputBorder() {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.margin12),
        borderSide: BorderSide(
            color: Theme.of(context).highlightColor, width: Dimens.margin1),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleText != null && titleText!.isNotEmpty
            ? RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: titleText ?? '',
                      style: titleStyle ??
                          getTextStyleFontWeight(
                              Theme.of(context).primaryTextTheme.bodySmall!,
                              Dimens.margin12,
                              FontWeight.normal),
                    ),
                    const TextSpan(text: '  '),
                    TextSpan(
                      text: isRequired ? '*' : '',
                      style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.headlineMedium!,
                          Dimens.margin15,
                          FontWeight.normal),
                    )
                  ],
                ),
              )
            : const SizedBox(),
        SizedBox(
          height: titleText != null && titleText!.isNotEmpty
              ? Dimens.margin8
              : Dimens.margin0,
        ),
        Container(
          height: height ?? Dimens.margin50,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(Dimens.margin16),
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: TextField(
            maxLines: 1,
            enabled: enabled ?? true,
            inputFormatters: inputFormatters ?? [],
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            maxLength: maxLength,
            focusNode: focusNode,
            controller: controller,
            onChanged: (val) {
              if (val.isNotEmpty && onChange != null) {
                onChange!();
              }
            },
            obscureText: isShowPassword,
            onEditingComplete: () {
              if (nextFocusNode != null) {
                FocusScope.of(context).requestFocus(nextFocusNode);
              } else {
                FocusScope.of(context).unfocus();
              }
            },
            onSubmitted: (val) {
              if (onSubmit != null) {
                onSubmit!();
              }
            },
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              suffixIcon: InkWell(
                onTap: () {
                  pressShowPassword();
                },
                child: Container(
                  padding: const EdgeInsets.all(Dimens.margin15),
                  width: 20,
                  height: 15,
                  child: SvgPicture.asset(
                    isShowPassword ? APPImages.icEye : APPImages.iccHideEye,
                  ),
                ),
              ),
              fillColor: fillColor ??
                  (enabled != null && enabled!
                      ? Theme.of(context).hintColor
                      : Theme.of(context).highlightColor),
              enabledBorder: mOutlineInputBorder(),
              focusedBorder: mOutlineInputBorder(),
              disabledBorder: mOutlineInputBorder(),
              border: mOutlineInputBorder(),
              contentPadding: const EdgeInsets.all(Dimens.margin15),
              hintText: hintText,
              labelStyle: enabled == false
                  ? hintStyle
                  : labelStyle ??
                      Theme.of(context)
                          .primaryTextTheme
                          .bodySmall!
                          .copyWith(fontSize: Dimens.textSize15),
              hintStyle: hintStyle ??
                  getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.displaySmall!,
                      Dimens.margin15,
                      FontWeight.w400),
            ),
            style: labelStyle ??
                Theme.of(context)
                    .primaryTextTheme
                    .bodySmall!
                    .copyWith(fontSize: Dimens.textSize15),
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

import '../../utils/core_import.dart';

/// This class is a stateless widget that displays an error indicator for a text
/// field
class BaseTextFieldErrorIndicator extends StatelessWidget {
  final String? errorText;

  const BaseTextFieldErrorIndicator({Key? key, this.errorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(APPImages.icErrorInfo, fit: BoxFit.contain),
        const SizedBox(
          width: Dimens.margin10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: (errorText != null && errorText != '')
                    ? Dimens.margin2
                    : Dimens.margin0,
              ),
              Text(
                errorText ?? '',
                style: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.headlineMedium!,
                  Dimens.textSize12,
                  FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

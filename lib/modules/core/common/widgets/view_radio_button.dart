import 'package:we_pro/modules/core/utils/core_import.dart';

///[ViewRadioButton] This class use to View Radio Button
class ViewRadioButton extends StatelessWidget {
  final Function onPressed;
  final bool isCheck;

  const ViewRadioButton(
      {Key? key, required this.onPressed, required this.isCheck})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: () {
          onPressed();
        },
        icon: isCheck
            ? const Icon(
                Icons.radio_button_checked_outlined,
                color: AppColors.colorSecondary,
              )
            : const Icon(Icons.radio_button_off_outlined,
                color: AppColors.colorBlack));
  }
}

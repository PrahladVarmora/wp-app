import 'package:we_pro/modules/core/utils/core_import.dart';

///[ViewCheckBoxButton] This class use to View Check Box Button
class ViewCheckBoxButton extends StatelessWidget {
  final Function? onPressed;
  final bool isCheck;
  final Color? checkedColor;

  const ViewCheckBoxButton(
      {Key? key, this.checkedColor, this.onPressed, this.isCheck = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onPressed!();
        },
        child: isCheck
            ? Icon(
                Icons.check_box_rounded,
                color: checkedColor ?? AppColors.color7E7E7E,
              )
            : const Icon(Icons.check_box_outline_blank_outlined,
                color: AppColors.color7E7E7E));
  }
}

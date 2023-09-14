import 'package:we_pro/modules/core/utils/core_import.dart';

///[CustomSwitch] This class use to Custom Switch
class CustomSwitch extends StatelessWidget {
  const CustomSwitch({Key? key, this.onPress, this.isSwitchOn, this.size = 30})
      : super(key: key);

  final Function? onPress;
  final bool? isSwitchOn;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: AppColors.colorTransparent,
      highlightColor: AppColors.colorTransparent,
      hoverColor: AppColors.colorTransparent,
      splashColor: AppColors.colorTransparent,
      onTap: () {
        onPress!();
      },
      child: isSwitchOn!
          ? Icon(
              Icons.toggle_on_rounded,
              color: AppColors.color50E666,
              size: size!,
            )
          : Icon(Icons.toggle_off_rounded,
              size: size!, color: Theme.of(context).primaryColor),
    );
  }
}

import 'package:we_pro/modules/core/utils/core_import.dart';

/// A [CustomSwitch] widget is a widget that describes part of the user interface by button
/// * [onPress] which contains the button onPress
/// * [isSwitchOn] which contains the status of switch
class CustomSwitch extends StatelessWidget {
  const CustomSwitch({Key? key, this.onPress, this.isSwitchOn})
      : super(key: key);

  final Function? onPress;
  final bool? isSwitchOn;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onPress!();
        },
        child: SvgPicture.asset(
          isSwitchOn! ? APPImages.icSwitchOn : APPImages.icSwitchOff,
          width: Dimens.margin36,
          height: Dimens.margin20,
        ));
  }
}

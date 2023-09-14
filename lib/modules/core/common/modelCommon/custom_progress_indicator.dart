import 'package:we_pro/modules/core/utils/core_import.dart';

///[CustomProgressIndicator] this  class use to Custom Progress Indicator
class CustomProgressIndicator extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? indicatorColor;

  const CustomProgressIndicator(
      {Key? key, this.height, this.width, this.indicatorColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            indicatorColor ?? Theme.of(context).dividerColor,
          ),
          backgroundColor: Colors.transparent),
    );
  }
}

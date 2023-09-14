import 'package:we_pro/modules/core/utils/core_import.dart';

/// [CiProgressIndicatorWidgetrcleImageViewerNetwork] which is a  use to Progress Indicator Widget
class ProgressIndicatorWidget extends StatefulWidget {
  const ProgressIndicatorWidget({Key? key}) : super(key: key);

  @override
  ProgressIndicatorWidgetState createState() => ProgressIndicatorWidgetState();
}

class ProgressIndicatorWidgetState extends State<ProgressIndicatorWidget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.background),
    );
  }
}

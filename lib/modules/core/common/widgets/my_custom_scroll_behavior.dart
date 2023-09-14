import 'package:flutter/gestures.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';

/// Override behavior methods and getters like dragDevices
/// [PointerDeviceKind] The kind of pointer device.
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

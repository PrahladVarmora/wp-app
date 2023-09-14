import 'package:fluttertoast/fluttertoast.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';

import '../dialog/custom_alert_dialog.dart';

/// A [ToastController] widget is a widget that describes part of the user interface by ToastController
/// * [mModelStaffMember] which contains the Toast Text
/// * [BuildContext] which contains the Toast context
/// * [bool] which contains the isSuccess or not
class ToastController {
  static showToast(
    String message,
    BuildContext context,
    bool isSuccess, {
    int time = 2,
    VoidCallback? okBtnFunction,
    bool barrierDismissible = true,
  }) {
    CustomAlertDialog.showCustomDialog(
      context,
      content: message,
      okBtnText: 'Ok',
      barrierDismissible: barrierDismissible,
      okBtnFunction: okBtnFunction ??
          () {
            Navigator.pop(context);
          },
    );
  }

  static showToastMessage(
    String message,
    BuildContext context,
    bool isSuccess, {
    Toast toastLength = Toast.LENGTH_LONG,
    VoidCallback? okBtnFunction,
    bool barrierDismissible = true,
  }) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: toastLength,
        gravity: ToastGravity.CENTER,
        backgroundColor: AppColors.color7E7E7E,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static removeToast(BuildContext context) {
    if (kIsWeb) {
      Fluttertoast.cancel();
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
    }
  }
}

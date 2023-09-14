import '../utils/core_import.dart';

///[LifecycleEventHandler] This class use to Lifecycle Event Handler
class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler(
      {this.resumeCallBack,
      this.suspendingCallBack,
      this.pausedCallBack,
      this.inactiveCallBack});

  final AsyncCallback? pausedCallBack;
  final AsyncCallback? inactiveCallBack;
  final AsyncCallback? resumeCallBack;
  final AsyncCallback? suspendingCallBack;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:

        /// LifecycleEventHandler notResume
        if (inactiveCallBack != null) await inactiveCallBack!();
        break;
      case AppLifecycleState.paused:

        /// LifecycleEventHandler paused
        if (pausedCallBack != null) await pausedCallBack!();
        break;
      case AppLifecycleState.detached:

        /// LifecycleEventHandler detached
        if (suspendingCallBack != null) await suspendingCallBack!();
        break;
      case AppLifecycleState.resumed:

        /// LifecycleEventHandler detached
        if (resumeCallBack != null) await resumeCallBack!();
        break;
    }
  }
}

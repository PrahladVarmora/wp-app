import 'package:flutter/material.dart';

import 'app_dimens.dart';

/// Used by [Responsive] of app and web
class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;

  const Responsive({
    Key? key,
    required this.mobile,
    required this.desktop,
  }) : super(key: key);

  /// This size work fine on my design, maybe you need some customization depends on your design

  /// This isMobile, isMobileTablet, isDesktop help us later
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <
      1100 - Dimens.navigationDrawerWidthWeb;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >=
      1100 - Dimens.navigationDrawerWidthWeb;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      /// If our width is more than 1100 then we consider it a desktop
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1100 - Dimens.navigationDrawerWidthWeb) {
          return desktop;
        }

        /// If width it less then 1100 and more then 650 we consider it as tablet mobile
        // else if (constraints.maxWidth >= 650) {
        //   return mobile;
        // }

        /// Or less then that we called it mobile
        else {
          return mobile;
        }
      },
    );
  }
}

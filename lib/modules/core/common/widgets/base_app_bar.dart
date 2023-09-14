import 'package:we_pro/modules/core/theme_cubit/theme_cubit.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';

/// The fill color to use for an app bar's [Material].
///
/// If null, then the [AppBarTheme.backgroundColor] is used. If that value is also
/// null, then [AppBar] uses the overall theme's [ColorScheme.primary] if the
class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? mLeftImage, title;
  final Function? mLeftAction;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Color? backButtonColor;
  final AppBar appBar;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;

  const BaseAppBar(
      {Key? key,
      this.title,
      required this.appBar,
      this.mLeftImage,
      this.backgroundColor,
      this.actions,
      this.mLeftAction,
      this.bottom,
      this.textStyle,
      this.backButtonColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor != null
          ? backgroundColor!
          : Theme.of(context).colorScheme.primary,
      titleSpacing: 0,
      leading: mLeftImage != null && mLeftImage!.isNotEmpty
          ? BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return InkWell(
                    onTap: () {
                      if (mLeftAction != null) {
                        mLeftAction!();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: Dimens.margin8, bottom: Dimens.margin8),
                      padding: const EdgeInsets.only(
                          top: Dimens.margin8, bottom: Dimens.margin8),
                      width: Dimens.margin30,
                      height: Dimens.margin30,
                      child: SvgPicture.asset(
                        mLeftImage!,
                        width: Dimens.margin30,
                        height: Dimens.margin30,

                        ///colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                        /*color: backButtonColor ??
                            (MyAppState.themeChangeValue
                                ? AppColors.colorWhite
                                : AppColors.colorBlack),*/
                      ),
                    ));
              },
            )
          : null,
      automaticallyImplyLeading: false,
      title: Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.margin16),
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: Text(
            title.toString(),
            textAlign: TextAlign.left,
            style: textStyle ??
                getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.titleLarge!,
                    Dimens.textSize18,
                    FontWeight.w400),
          )),
      bottom: bottom,
      elevation: 0,
      actions: actions ?? [],

      //actions: widgets,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}

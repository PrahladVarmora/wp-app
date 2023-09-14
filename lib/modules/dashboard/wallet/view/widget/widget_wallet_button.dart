import 'package:we_pro/modules/core/utils/core_import.dart';

/// This class is a stateless widget that creates a button that, when pressed, will open the wallet
class WidgetWalletButton extends StatelessWidget {
  final String mTitle;
  final String mImage;
  final Function onPress;

  const WidgetWalletButton(
      {Key? key,
      required this.mTitle,
      required this.mImage,
      required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onPress(),
        child: Column(
          children: [
            Container(
              height: Dimens.margin50,
              padding: const EdgeInsets.all(Dimens.margin15),
              width: Dimens.margin50,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(Dimens.margin15)),
              child: SvgPicture.asset(mImage),
            ),
            const SizedBox(
              height: Dimens.margin10,
            ),
            Text(
              mTitle,
              style: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.displayMedium!,
                  Dimens.textSize12,
                  FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}

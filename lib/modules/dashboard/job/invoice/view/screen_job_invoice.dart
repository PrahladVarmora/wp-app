import '../../../../core/utils/core_import.dart';

/// A screen that shows the invoice for a job.
class ScreenJobInvoice extends StatefulWidget {
  const ScreenJobInvoice({Key? key}) : super(key: key);

  @override
  State<ScreenJobInvoice> createState() => _ScreenJobInvoiceState();
}

class _ScreenJobInvoiceState extends State<ScreenJobInvoice> {
  @override
  Widget build(BuildContext context) {
    ///[getAppbar] is used to get Appbar for different views i.e. Mobile
    BaseAppBar getAppbar() {
      return BaseAppBar(
        appBar: AppBar(),
        title: APPStrings.textJobInvoice.translate(),
        mLeftImage: APPImages.icArrowBack,
        backgroundColor: Theme.of(context).colorScheme.primary,
        mLeftAction: () {
          Navigator.pop(context);
        },
      );
    }

    /// A function that returns a widget.
    Widget shareReceipt() {
      return CustomButton(
        height: Dimens.margin50,
        width: double.infinity,
        backgroundColor: Theme.of(context).colorScheme.background,
        borderColor: Theme.of(context).primaryColor,
        borderRadius: Dimens.margin30,
        onPress: () {
          Navigator.pop(context);
        },
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.textSize15,
            FontWeight.w500),
        buttonText: APPStrings.textShareReceipt.translate(),
      );
    }

    /// A function that returns a widget.
    Widget collectPayment() {
      return CustomButton(
        height: Dimens.margin50,
        width: double.infinity,
        backgroundColor: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
        borderRadius: Dimens.margin30,
        onPress: () {
          // Navigator.pushNamed(context, AppRoutes.routesJobInvoice);
        },
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displayMedium!,
            Dimens.textSize15,
            FontWeight.w500),
        buttonText: APPStrings.textCollectPayment.translate(),
      );
    }

    return Scaffold(
      appBar: getAppbar(),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
            left: Dimens.margin15,
            right: Dimens.margin15,
            bottom: Dimens.margin30),
        child: Row(
          children: [
            Expanded(child: shareReceipt()),
            const SizedBox(
              width: Dimens.margin10,
            ),
            Expanded(child: collectPayment()),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(
          left: Dimens.margin15,
          right: Dimens.margin15,
          top: Dimens.margin20,
        ),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '12123456789000',
                    style: getTextStyleFontWeight(
                        Theme.of(context).primaryTextTheme.labelSmall!,
                        Dimens.margin15,
                        FontWeight.normal),
                  ),
                ),
                Text(
                  InterpolateString.interpolate(
                      APPStrings.textCurrency.translate(), ['100']),
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.labelSmall!,
                      Dimens.margin18,
                      FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: Dimens.margin7,
            ),
            Text(
              'Locksmith',
              style: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.labelSmall!,
                  Dimens.margin15,
                  FontWeight.w600),
            ),
            const SizedBox(
              height: Dimens.margin5,
            ),
            Text(
              'Car Lockout | ID1234567890',
              style: getTextStyleFontWeight(
                  Theme.of(context).textTheme.titleSmall!,
                  Dimens.margin12,
                  FontWeight.normal),
            ),
            const SizedBox(
              height: Dimens.margin14,
            ),
            Container(
              height: Dimens.margin1,
              color: Theme.of(context).highlightColor,
            ),
            const SizedBox(
              height: Dimens.margin16,
            ),
            Text(
              'Robert Stepson',
              style: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.labelSmall!,
                  Dimens.margin15,
                  FontWeight.normal),
            ),
            const SizedBox(
              height: Dimens.margin6,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(APPImages.icEmail),
                const SizedBox(
                  width: Dimens.margin10,
                ),
                Expanded(
                  child: Text(
                    'robert@gmail.com',
                    style: getTextStyleFontWeight(
                        Theme.of(context).primaryTextTheme.labelSmall!,
                        Dimens.margin12,
                        FontWeight.normal),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: Dimens.margin16,
            ),
            Container(
              height: Dimens.margin1,
              color: Theme.of(context).highlightColor,
            ),
            const SizedBox(
              height: Dimens.margin15,
            ),
            Text(
              InterpolateString.interpolate(
                  APPStrings.textGeneratedOn.translate(),
                  ['12:45 PM, 6 Mar 2023']),
              style: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.labelSmall!,
                  Dimens.margin12,
                  FontWeight.normal),
            ),
            const SizedBox(
              height: Dimens.margin20,
            ),
            Container(
              padding: const EdgeInsets.all(Dimens.margin20),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(Dimens.margin15)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          APPStrings.textAdditionalExpense.translate(),
                          style: getTextStyleFontWeight(
                              Theme.of(context).primaryTextTheme.labelSmall!,
                              Dimens.margin15,
                              FontWeight.normal),
                        ),
                      ),
                      Text(
                        InterpolateString.interpolate(
                            APPStrings.textCurrency.translate(), ['100']),
                        style: getTextStyleFontWeight(
                            Theme.of(context).primaryTextTheme.labelSmall!,
                            Dimens.margin15,
                            FontWeight.normal),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: Dimens.margin10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          APPStrings.textTip.translate(),
                          style: getTextStyleFontWeight(
                              Theme.of(context).primaryTextTheme.labelSmall!,
                              Dimens.margin15,
                              FontWeight.normal),
                        ),
                      ),
                      Text(
                        InterpolateString.interpolate(
                            APPStrings.textCurrency.translate(), ['10']),
                        style: getTextStyleFontWeight(
                            Theme.of(context).primaryTextTheme.labelSmall!,
                            Dimens.margin15,
                            FontWeight.normal),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: Dimens.margin10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          APPStrings.textTax.translate(),
                          style: getTextStyleFontWeight(
                              Theme.of(context).primaryTextTheme.labelSmall!,
                              Dimens.margin15,
                              FontWeight.normal),
                        ),
                      ),
                      Text(
                        InterpolateString.interpolate(
                            APPStrings.textCurrency.translate(), ['10']),
                        style: getTextStyleFontWeight(
                            Theme.of(context).primaryTextTheme.labelSmall!,
                            Dimens.margin15,
                            FontWeight.normal),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: Dimens.margin10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          APPStrings.textGrandTotal.translate(),
                          style: getTextStyleFontWeight(
                              Theme.of(context).primaryTextTheme.labelSmall!,
                              Dimens.margin15,
                              FontWeight.w600),
                        ),
                      ),
                      Text(
                        InterpolateString.interpolate(
                            APPStrings.textCurrency.translate(), ['120']),
                        style: getTextStyleFontWeight(
                            Theme.of(context).primaryTextTheme.labelSmall!,
                            Dimens.margin15,
                            FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

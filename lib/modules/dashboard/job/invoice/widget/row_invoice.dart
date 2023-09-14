import 'package:we_pro/modules/dashboard/model/model_my_job.dart';

import '../../../../core/utils/core_import.dart';

/// A placeholder for a `Row` widget that will be used to display an invoice.
class RowInvoice extends StatelessWidget {
  final int mIndex;
  final InvoiceData invoiceList;

  const RowInvoice({Key? key, required this.mIndex, required this.invoiceList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: Dimens.margin15,
        right: Dimens.margin15,
        bottom: Dimens.margin20,
      ),
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
                  invoiceList.dueDate ?? '',
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.labelSmall!,
                      Dimens.margin15,
                      FontWeight.normal),
                ),
              ),
              Text(
                paymentMethodFromList(invoiceList.pMethod ?? '',
                            paymentMethodListForInvoice())
                        .title ??
                    '',
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.margin12,
                    FontWeight.normal),
              ),
            ],
          ),
          const SizedBox(
            height: Dimens.margin8,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  InterpolateString.interpolate(
                      APPStrings.textCurrency.translate(),
                      [invoiceList.totalAmount]),
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.labelSmall!,
                      Dimens.margin15,
                      FontWeight.w900),
                ),
              ),
              Text(
                ///   mStatus[randomNumber(maxNum: 3)],
                invoiceList.status.toString(),
                style: getTextStyleFontWeight(
                    Theme.of(context).textTheme.labelSmall!,
                    Dimens.margin12,
                    FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

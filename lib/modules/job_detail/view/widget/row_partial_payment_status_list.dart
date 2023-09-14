import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';

class RowPartialPaymentStatusList extends StatelessWidget {
  final InvoiceData mInvoice;

  const RowPartialPaymentStatusList({Key? key, required this.mInvoice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimens.margin20, vertical: Dimens.margin14),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(Dimens.margin15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment ${mInvoice.id}',
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize15,
                    FontWeight.w400),
              ),
              const SizedBox(height: Dimens.margin6),
              Text(
                setCurrency('${mInvoice.totalAmount}'),
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelMedium!,
                    Dimens.textSize15,
                    FontWeight.w700),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${paymentMethodFromList(mInvoice.pMethod ?? '', paymentMethodList()).title}',
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize12,
                    FontWeight.w400),
              ),
              const SizedBox(height: Dimens.margin6),
              Text(
                '${mInvoice.sendStatus}',
                style: getTextStyleFontWeight(
                        Theme.of(context).primaryTextTheme.labelMedium!,
                        Dimens.textSize12,
                        FontWeight.w600)
                    .copyWith(color: getColorStatus('${mInvoice.sendStatus}')),
                // .copyWith(color: getColorStatus(randomNumber(maxNum: 3))),
              ),
              const SizedBox(height: Dimens.margin6),
              Text(
                '${mInvoice.status}',
                style: getTextStyleFontWeight(
                        Theme.of(context).primaryTextTheme.labelMedium!,
                        Dimens.textSize12,
                        FontWeight.w600)
                    .copyWith(color: getColorStatus('${mInvoice.status}')),
                // .copyWith(color: getColorStatus(randomNumber(maxNum: 3))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';

class RowPartialPaymentAddedList extends StatelessWidget {
  final InvoiceData invoiceList;

  const RowPartialPaymentAddedList({Key? key, required this.invoiceList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimens.margin20),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(Dimens.margin15)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment - ${invoiceList.id}',
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize15,
                    FontWeight.w400),
              ),
              Text(
                '${paymentMethodFromList(invoiceList.pMethod ?? '', paymentMethodList()).title}',
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize12,
                    FontWeight.w400),
              ),
            ],
          ),
          const SizedBox(height: Dimens.margin6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                setCurrency('${invoiceList.totalAmount}'),
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelMedium!,
                    Dimens.textSize15,
                    FontWeight.w700),
              ),
              Text(
                '${invoiceList.status}',
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

import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';

/// This class is a StatefulWidget widget that creates a row for Recent Job
class RowRecentJob extends StatelessWidget {
  final JobData mJobData;

  const RowRecentJob({super.key, required this.mJobData});

  @override
  Widget build(BuildContext context) {
    /// It returns a widget that shows Category Name.
    Widget getCategoryName() {
      return Text(
        mJobData.jobCategory ?? "",
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelMedium!,
            Dimens.textSize15,
            FontWeight.w600),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    /// It returns a widget that displays the text "Job Status".
    Widget textJobStatus() {
      return Container(
        height: Dimens.margin26,
        decoration: BoxDecoration(
          color: AppColors.colorFDE4CE,
          borderRadius: BorderRadius.circular(Dimens.margin13),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
            horizontal: Dimens.margin10, vertical: Dimens.margin5),
        child: Text(
          mJobData.status ?? "",
          style: AppFont.semiBold.copyWith(
            color: AppColors.colorE56E07,
            fontSize: Dimens.textSize12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    /// Returning a widget that displays the text Service Type.
    Widget textServiceType() {
      return Text(
        mJobData.jobType ?? "",
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.textSize15,
            FontWeight.w400),
      );
    }

    /// Returning a widget that displays the text Customer Name.
    Widget getCustomerName() {
      return Text(
        mJobData.clientName ?? "",
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.textSize15,
            FontWeight.w400),
      );
    }

    /// Returning a widget that displays the text job Time And Date.
    Widget jobTimeAndDate() {
      return Text(
        mJobData.scheduleInfo ?? "",
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.textSize12,
            FontWeight.w400),
      );
    }

    Widget jobId() {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Job Id: ',
              style: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.labelMedium!,
                  Dimens.textSize15,
                  FontWeight.w600),
            ),
            TextSpan(
                text: mJobData.jobId ?? '',
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize15,
                    FontWeight.w400))
          ],
        ),
      );
    }

    Widget jobAmount() {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Amount: ',
              style: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.labelMedium!,
                  Dimens.textSize15,
                  FontWeight.w600),
            ),
            TextSpan(
                text: mJobData.invoice?.first.totalAmount ?? '',
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize15,
                    FontWeight.w400))
          ],
        ),
      );
    }

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.routesJobHistoryDetail,
            arguments: {
              AppConfig.jobStatus: statusJobCollectPaymentSendInvoice,
              AppConfig.jobId: mJobData.jobId.toString()
            });
      },
      child: Container(
        padding: const EdgeInsets.all(Dimens.margin20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.margin15),
          border:
              Border.all(color: Theme.of(context).colorScheme.onErrorContainer),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: getCategoryName()),
                textJobStatus(),
              ],
            ),
            const SizedBox(height: Dimens.margin4),
            jobId(),
            const SizedBox(height: Dimens.margin8),
            if ((mJobData.invoice ?? []).isNotEmpty) ...[
              jobAmount(),
              const SizedBox(height: Dimens.margin8),
            ],
            textServiceType(),
            const SizedBox(height: Dimens.margin16),
            getCustomerName(),
            const SizedBox(height: Dimens.margin8),
            jobTimeAndDate(),
            const SizedBox(height: Dimens.margin15),
            // SizedBox(
            //   height: Dimens.margin30,
            //   child: rowLocationAndEta(),
            // )
          ],
        ),
      ),
    );
  }
}

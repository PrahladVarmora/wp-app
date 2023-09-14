import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';
import 'package:we_pro/modules/job_detail/dialog/dialog_call.dart';

/// This class is a stateless widget that creates a row of job cards
class RowJobCard extends StatelessWidget {
  final JobData mJobData;
  final Function() callUpdateJobList;

  const RowJobCard(
      {Key? key, required this.mJobData, required this.callUpdateJobList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// It returns a widget that shows Service Name.

    /// It returns a widget that shows Category Name.
    Widget getCategoryName() {
      return Expanded(
        child: Text(
          mJobData.jobCategory.toString(),
          style: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.labelMedium!,
              Dimens.textSize15,
              FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
      );
    }

    /// It returns a widget that displays the text "Job Status".
    Widget textJobStatus() {
      return Text(
        mJobData.status.toString(),
        style: getTextStyleFontWeight(
                Theme.of(context).primaryTextTheme.labelMedium!,
                Dimens.textSize12,
                FontWeight.w600)
            .copyWith(color: getColorStatusJobType(mJobData.status ?? '')),
      );
    }

    /// Returning a widget that displays the text Service Type.
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

    /// Returning a widget that displays the text Service Type.
    Widget textServiceType() {
      return Text(
        mJobData.jobType ?? '',
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.textSize15,
            FontWeight.w400),
      );
    }

    Widget sourceTitle() {
      return Text(
        mJobData.sourceTitle ?? '',
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.textSize15,
            FontWeight.w400),
      );
    }
/*
    /// Returning a widget that displays the text Customer Name.
    Widget getCustomerName() {
      return Text(
        mJobData.clientName.toString(),
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.textSize15,
            FontWeight.w400),
      );
    }*/

    /// Returning a widget that displays the text job Time And Date.
    Widget jobTimeAndDate() {
      return Text(
        mJobData.scheduleInfo.toString(),
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.textSize12,
            FontWeight.w400),
      );
    }

    /// Returning a row of location and ETA.
    Widget rowLocationAndEta() {
      return Row(
        children: [
          Expanded(
            child: Row(
              children: [
                SvgPicture.asset(APPImages.icLocationPin),
                const SizedBox(width: Dimens.margin10),
                Expanded(
                  flex: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(APPStrings.textZipCodeWithColon.translate(),
                          style: getTextStyleFontWeight(
                              Theme.of(context).primaryTextTheme.labelSmall!,
                              Dimens.textSize12,
                              FontWeight.w400)),
                      Text(
                        mJobData.zip.toString(),
                        style: getTextStyleFontWeight(
                            Theme.of(context).primaryTextTheme.labelMedium!,
                            Dimens.textSize12,
                            FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Dimens.margin20),
                Container(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                  width: Dimens.margin1,
                  height: Dimens.margin30,
                ),
                const SizedBox(width: Dimens.margin20),
                SvgPicture.asset(APPImages.icEta),
                const SizedBox(width: Dimens.margin10),
                Expanded(
                  flex: 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(APPStrings.textEtaWithColon.translate(),
                          style: getTextStyleFontWeight(
                              Theme.of(context).primaryTextTheme.labelSmall!,
                              Dimens.textSize12,
                              FontWeight.w400)),
                      Text(
                        '${mJobData.duration} | ${mJobData.distance}',
                        style: getTextStyleFontWeight(
                            Theme.of(context).primaryTextTheme.labelMedium!,
                            Dimens.textSize12,
                            FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Dimens.margin10),
          InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogCall(jobData: mJobData);
                  },
                );
              },
              child: SvgPicture.asset(
                APPImages.icCallCustomer,
                height: Dimens.margin20,
                width: Dimens.margin20,
              )),
          const SizedBox(width: Dimens.margin20),
          if (mJobData.latitude != null && mJobData.longitude != null)
            InkWell(
              onTap: () {
                clickMap(
                    LatLng(double.parse(mJobData.latitude ?? '0'),
                        double.parse(mJobData.longitude ?? '0')),
                    mJobData.address,
                    double.parse(mJobData.latitude!),
                    double.parse(mJobData.longitude!));
              },
              child: SvgPicture.asset(
                APPImages.icDirection,
                height: Dimens.margin24,
                width: Dimens.margin24,
              ),
            ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(Dimens.margin20),
      decoration: BoxDecoration(
        color: AppColors.colorTransparent,
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
              getCategoryName(),
              textJobStatus(),
            ],
          ),
          const SizedBox(height: Dimens.margin8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              jobId(),
              if ((mJobData.invoice ?? []).isNotEmpty &&
                  (mJobData.invoice
                          ?.every((element) => element.status != 'Paid') ??
                      false))
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.routesInvoiceList,
                            arguments: mJobData)
                        .then((value) {
                      callUpdateJobList();
                    });
                  },
                  child: SvgPicture.asset(
                    APPImages.icInvoice,
                    height: Dimens.margin24,
                    width: Dimens.margin24,
                  ),
                )
            ],
          ),
          const SizedBox(height: Dimens.margin8),
          textServiceType(),
          const SizedBox(height: Dimens.margin8),
          sourceTitle(),

          /*  const SizedBox(height: Dimens.margin8),
          getCustomerName(),*/
          const SizedBox(height: Dimens.margin8),
          jobTimeAndDate(),
          const SizedBox(height: Dimens.margin15),
          SizedBox(
            height: Dimens.margin30,
            child: rowLocationAndEta(),
          )
        ],
      ),
    );
  }
}

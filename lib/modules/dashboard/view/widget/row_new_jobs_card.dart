import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';

/// This class is a stateless widget that creates a row of cards that display the
/// new jobs that are available.
class RowNewJobsCard extends StatelessWidget {
  final JobData mJobData;
  final Function() onAccept;
  final Function() onReject;

  const RowNewJobsCard(
      {Key? key,
      required this.mJobData,
      required this.onAccept,
      required this.onReject})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.routesJobDetail, arguments: {
          AppConfig.jobStatus: statusJobAcceptReject,
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
              children: [
                Expanded(
                  child: Text(
                    mJobData.jobCategory.toString(),
                    style: getTextStyleFontWeight(
                        Theme.of(context).primaryTextTheme.labelMedium!,
                        Dimens.textSize15,
                        FontWeight.w600),
                  ),
                ),
                CustomButton(
                  buttonText: mJobData.status.toString(),
                  style: getTextStyleFontWeight(
                          Theme.of(context).textTheme.bodyMedium!,
                          Dimens.textSize12,
                          FontWeight.w600)
                      .copyWith(
                          color: getColorStatusJobType(mJobData.status ?? '')),
                  backgroundColor:
                      getBackgroundColorStatusJobType(mJobData.status ?? ''),
                  borderColor:
                      getBackgroundColorStatusJobType(mJobData.status ?? ''),
                  borderRadius: Dimens.margin13,
                  height: Dimens.margin26,
                ),
              ],
            ),
            Text.rich(
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
            ),
            const SizedBox(height: Dimens.margin8),
            Text(
              mJobData.jobType.toString(),
              style: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.labelSmall!,
                  Dimens.textSize15,
                  FontWeight.w400),
            ),
            const SizedBox(height: Dimens.margin12),
            Row(
              children: [
                SvgPicture.asset(APPImages.icLocationPin),
                const SizedBox(width: Dimens.margin10),
                Expanded(
                  flex: 15,
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
                      Text(mJobData.zip.toString(),
                          style: getTextStyleFontWeight(
                              Theme.of(context).primaryTextTheme.labelMedium!,
                              Dimens.textSize12,
                              FontWeight.w600)),
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
                          '${mJobData.distance ?? 'NA'} | ${mJobData.duration ?? 'NA'}',
                          style: getTextStyleFontWeight(
                              Theme.of(context).primaryTextTheme.labelMedium!,
                              Dimens.textSize12,
                              FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimens.margin20),
            Row(
              children: [
                Expanded(
                    child: CustomButton(
                  onPress: () {
                    onReject();
                  },
                  style: getTextStyleFontWeight(
                      Theme.of(context).textTheme.titleLarge!,
                      Dimens.textSize15,
                      FontWeight.w500),
                  buttonText: APPStrings.textReject.translate(),
                  borderRadius: Dimens.margin30,
                  height: Dimens.margin40,
                  borderColor: Theme.of(context).colorScheme.inverseSurface,
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                )),
                const SizedBox(width: Dimens.margin10),
                Expanded(
                    child: CustomButton(
                  onPress: () {
                    onAccept();
                  },
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.displayLarge!,
                      Dimens.textSize15,
                      FontWeight.w500),
                  height: Dimens.margin40,
                  buttonText: APPStrings.textAccept.translate(),
                  borderRadius: Dimens.margin30,
                  backgroundColor: Theme.of(context).primaryColor,
                  borderColor: Theme.of(context).primaryColor,
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

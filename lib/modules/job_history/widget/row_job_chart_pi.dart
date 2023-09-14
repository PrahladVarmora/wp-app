import 'package:fl_chart/fl_chart.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/model/model_job_history.dart';
import 'package:we_pro/modules/job_history/widget/indicator.dart';

/// This class is a StatefulWidget widget that creates a row for JobPiChart
class JobPiChart extends StatefulWidget {
  final ModelJobHistory jobHistory;

  const JobPiChart({super.key, required this.jobHistory});

  @override
  State<JobPiChart> createState() => _JobPiChartState();
}

class _JobPiChartState extends State<JobPiChart> {
  ValueNotifier<ModelJobHistory> mJobHistory = ValueNotifier(ModelJobHistory());

  @override
  void initState() {
    mJobHistory.value = widget.jobHistory;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant JobPiChart oldWidget) {
    mJobHistory.value = widget.jobHistory;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    /// [showingSections] thi widget use for Pie chart section
    List<PieChartSectionData> showingSections() {
      return List.generate(4, (i) {
        /// final fontSize = isTouched ? 25.0 : 16.0;
        const radius = Dimens.margin50;

        /// const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
        switch (i) {
          case 0:
            return PieChartSectionData(
                color: AppColors.color4F6ADB,
                radius: radius,
                value: double.parse(mJobHistory.value.totalAccepted ?? "0"),
                title: ""

                /// title: '40%',
                );
          case 1:
            return PieChartSectionData(
                color: AppColors.colorC7A445,
                radius: radius,
                value: double.parse(mJobHistory.value.totalDone ?? "0"),
                title: "");
          case 2:
            return PieChartSectionData(
              color: AppColors.color61C6DE,
              radius: radius,
              title: "",
              value: double.parse(mJobHistory.value.totalRejected ?? "0"),
            );
          case 3:
            return PieChartSectionData(
                color: AppColors.colorD95151,
                radius: radius,
                value: double.parse(mJobHistory.value.totalCanceled ?? "0"),
                title: "");
          default:
            throw Error();
        }
      });
    }

    return Container(
      height: Dimens.margin396,
      padding: const EdgeInsets.all(Dimens.margin20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onInverseSurface,
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(Dimens.margin30),
            bottomRight: Radius.circular(Dimens.margin30)),
        border:
            Border.all(color: Theme.of(context).colorScheme.onInverseSurface),
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: Dimens.margin0,
                    centerSpaceRadius: Dimens.margin70,
                    startDegreeOffset: (Dimens.margin270),
                    sections: showingSections(),
                    centerSpaceColor:
                        Theme.of(context).colorScheme.onInverseSurface,
                  ),
                ),
                Container(
                  height: Dimens.margin110,
                  width: Dimens.margin110,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.background),
                      shape: BoxShape.circle),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Center(
                    child: Text(
                      doneJobPercentage(),
                      style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.displayMedium!,
                          Dimens.textSize26,
                          FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimens.margin20),
          Column(
            children: [
              Text(
                mJobHistory.value.totalEarning == null
                    ? "0"
                    : setCurrency(mJobHistory.value.totalEarning.toString()),
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.bodyLarge!,
                    Dimens.textSize24,
                    FontWeight.w700),
              ),
              const SizedBox(height: Dimens.margin5),
              Text(
                APPStrings.textTotalEarning.translate(),
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.displayMedium!,
                    Dimens.textSize12,
                    FontWeight.w400),
              )
            ],
          ),
          const SizedBox(height: Dimens.margin20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    Indicator(
                      color: AppColors.color4F6ADB,
                      text: mJobHistory.value.totalAccepted ?? "",
                      isSquare: false,
                    ),
                    const SizedBox(
                      height: Dimens.margin5,
                    ),
                    Text(
                      APPStrings.textJobsAccepted.translate(),
                      style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.displayMedium!,
                          Dimens.textSize12,
                          FontWeight.w400),
                    )
                  ],
                ),
                const SizedBox(
                  width: Dimens.margin20,
                ),
                Column(
                  children: [
                    Indicator(
                      color: AppColors.colorC7A445,
                      text: mJobHistory.value.totalDone ?? "",
                      isSquare: false,
                    ),
                    const SizedBox(
                      height: Dimens.margin5,
                    ),
                    Text(
                      APPStrings.textJobsCompleted.translate(),
                      style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.displayMedium!,
                          Dimens.textSize12,
                          FontWeight.w400),
                    )
                  ],
                ),
                const SizedBox(
                  width: Dimens.margin20,
                ),
                Column(
                  children: [
                    Indicator(
                      color: AppColors.color61C6DE,
                      text: mJobHistory.value.totalRejected ?? "",
                      isSquare: false,
                    ),
                    const SizedBox(
                      height: Dimens.margin5,
                    ),
                    Text(
                      APPStrings.textJobsRejected.translate(),
                      style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.displayMedium!,
                          Dimens.textSize12,
                          FontWeight.w400),
                    )
                  ],
                ),
                const SizedBox(
                  width: Dimens.margin20,
                ),
                Column(
                  children: [
                    Indicator(
                      color: AppColors.colorD95151,
                      text: mJobHistory.value.totalCanceled ?? "",
                      isSquare: false,
                    ),
                    const SizedBox(
                      height: Dimens.margin5,
                    ),
                    Text(
                      APPStrings.textJobsCanceled.translate(),
                      style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.displayMedium!,
                          Dimens.textSize12,
                          FontWeight.w400),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: Dimens.margin10),
        ],
      ),
    );
  }

  String doneJobPercentage() {
    printWrapped(
        'mJobHistory.value.totalAccepted---${mJobHistory.value.totalAccepted}');
    dynamic percentage = (int.parse(mJobHistory.value.totalDone ?? "0") == 0 ||
            int.parse(mJobHistory.value.totalJobs ?? "0") == 0)
        ? 0
        : ((int.parse(mJobHistory.value.totalDone ?? "0") * 100) /
            int.parse(mJobHistory.value.totalJobs ?? "1"));
    if (percentage.isNaN) {
      return "${0} %";
    } else {
      return "${percentage.round()} %";
    }
  }
}

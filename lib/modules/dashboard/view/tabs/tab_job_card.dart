// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:we_pro/modules/dashboard/model/model_filter_job_history.dart';
import 'package:we_pro/modules/dashboard/model/model_job_history.dart';
import 'package:we_pro/modules/job_history/bloc/job_history_bloc.dart';
import 'package:we_pro/modules/job_history/bloc/job_history_status_event.dart';
import 'package:we_pro/modules/job_history/bloc/job_history_status_state.dart';
import 'package:we_pro/modules/job_history/widget/bottom_sheet_recent_job_filter.dart';
import 'package:we_pro/modules/job_history/widget/row_job_chart_pi.dart';
import 'package:we_pro/modules/job_history/widget/row_recent_job.dart';
import 'package:we_pro/modules/masters/model/model_get_status.dart';

import '../../../core/utils/core_import.dart';
import '../../model/model_my_job.dart';
import '../../notifications/bloc/notifications_list/notifications_list_bloc.dart';

/// This class is a stateful widget that creates a card for each job in the list of
/// jobs
class TabJobCard extends StatefulWidget {
  const TabJobCard({Key? key}) : super(key: key);

  @override
  State<TabJobCard> createState() => TabJobCardState();
}

class TabJobCardState extends State<TabJobCard> with WidgetsBindingObserver {
  static ValueNotifier<bool> mLoading = ValueNotifier(false);
  ValueNotifier<List<JobData>> jobList = ValueNotifier([]);
  ValueNotifier<List<JobStatus>> mJobStatusList = ValueNotifier([]);
  ValueNotifier<ModelJobHistory> mJobHistory = ValueNotifier(ModelJobHistory());
  ValueNotifier<bool> mPagination = ValueNotifier(false);
  ValueNotifier<String> mSortValue = ValueNotifier('');
  static ValueNotifier<int> mNextPage = ValueNotifier(1);
  static ValueNotifier<ModelFilterJobHistory> mModelFilterJobHistory =
      ValueNotifier(ModelFilterJobHistory());
  final ScrollController _scrollController = ScrollController();
  bool isNextPage = false;
  double positionValue = 0.0;

  @override
  void initState() {
    _scrollController.addListener(scrollListener);
    mModelFilterJobHistory.value.duration = "";
    mNextPage.value = 1;
    mModelFilterJobHistory.value = ModelFilterJobHistory();
    getJobHistoryList();
    super.initState();
  }

  Future<void> initCalled() async {
    await getJobHistoryList();
  }

  static void refreshJobDataExternal() {
    mNextPage.value = 1;
    getJobHistoryList();
  }

  @override
  Widget build(BuildContext context) {
    ///[getJobHistoryAppbar] is used to get Appbar for different views i.e. Mobile and Web
    BaseAppBar getJobHistoryAppbar() {
      return BaseAppBar(
        appBar: AppBar(
          toolbarHeight: Dimens.margin70,
        ),
        title: APPStrings.textJobHistory.translate(),
        textStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.titleLarge!,
            Dimens.textSize18,
            FontWeight.w500),
        backgroundColor: Theme.of(context).colorScheme.primary,
      );
    }

    ///[rowFilter] is used to get row filter
    Widget rowFilter() {
      return Row(
        children: [
          Expanded(
            child: Text(
              APPStrings.textRecentJobs.translate(),
              style: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.labelSmall!,
                  Dimens.textSize18,
                  FontWeight.w600),
            ),
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet<dynamic>(
                isScrollControlled: true,
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimens.margin30),
                      topRight: Radius.circular(Dimens.margin30)),
                ),
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return BottomSheetRecentJobFilter(
                        modelFilterJobHistory: mModelFilterJobHistory.value);
                  });
                },
              ).then((value) {
                if (value != null) {
                  mNextPage.value = 1;
                  mModelFilterJobHistory.value = value as ModelFilterJobHistory;
                  getJobHistoryList();
                }
              });
            },
            icon: SvgPicture.asset(APPImages.icFilter),
          ),
        ],
      );
    }

    ///[recentJobList] is used to get recent job list
    Widget recentJobList() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.margin15),
        child: Column(
          children: [
            rowFilter(),
            const SizedBox(height: Dimens.margin10),
            if (jobList.value.isNotEmpty && mLoading.value == false)
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                // controller: _scrollController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: jobList.value.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Column(
                        children: [
                          RowRecentJob(mJobData: jobList.value[index]),
                          const SizedBox(height: Dimens.margin20),
                        ],
                      ),
                      if ((index == jobList.value.length - 1) && isNextPage)
                        CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        )
                    ],
                  );
                },
              )
            else
              Container(
                margin: const EdgeInsets.symmetric(vertical: Dimens.margin50),
                child: Center(
                  child: mLoading.value == false
                      ? Text(APPStrings.textNoDataFound.translate(),
                          style: const TextStyle(
                              color: AppColors.colorPrimary,
                              fontSize: Dimens.textSize25))
                      : const SizedBox.shrink(),
                ),
              ),
          ],
        ),
      );
    }

    /// It returns a widget.
    Widget getRecentJobView() {
      return SingleChildScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            JobPiChart(jobHistory: mJobHistory.value),
            const SizedBox(height: Dimens.margin20),
            recentJobList()
          ],
        ),
      );
    }

    ///[mBody] is used to get Mobile view body
    Widget mBody() {
      return Container(
        color: Theme.of(context).colorScheme.background,
        child: getRecentJobView(),
      );
    }

    return MultiValueListenableBuilder(
      valueListenables: [
        mLoading,
        jobList,
        mJobHistory,
        mPagination,
        mSortValue,
        mNextPage,
      ],
      builder: (BuildContext context, values, Widget? child) {
        return MultiBlocListener(
            listeners: [
              // BlocListener<ClockInOutBloc, ClockInOutState>(
              //   listener: (context, state) {
              //     mLoading.value = state is ClockInOutLoading;
              //   },
              // ),
              BlocListener<JobHistoryBloc, JobHistoryStatusState>(
                  listener: (context, state) {
                mLoading.value =
                    (state is JobHistoryLoading) && (mNextPage.value == 1);
                mPagination.value =
                    (state is JobHistoryLoading) && (mNextPage.value > 1);

                if (state is JobHistoryResponse) {
                  if (mNextPage.value == 1) {
                    jobList.value = [];
                    mJobHistory.value = state.mModelJobHistory;
                    jobList.value.addAll(state.mModelJobHistory.data ?? []);
                  }

                  if (mNextPage.value > 1) {
                    mJobHistory.value = state.mModelJobHistory;
                    jobList.value.addAll(state.mModelJobHistory.data ?? []);
                  }
                  mJobHistory.notifyListeners();
                  jobList.notifyListeners();
                  isNextPage = ((state.mModelJobHistory.data ?? []).length ==
                      AppConfig.pageLimitCount);
                }

                if (jobList.value.isNotEmpty && mNextPage.value > 1) {
                  try {
                    _scrollController.jumpTo(
                      positionValue,
                    );
                  } catch (e) {
                    printWrapped('_scrollController--$e');
                  }
                }
              }),
            ],
            child: ModalProgressHUD(
                inAsyncCall: mLoading.value && !mPagination.value,
                progressIndicator: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor),
                child: Scaffold(
                  appBar: getJobHistoryAppbar(),
                  body: mBody(),
                )));
      },
    );
  }

  static getJobHistoryList() {
    Map<String, dynamic> mBody = {
      //  ApiParams.paramOrderBy: "Newest",
      ApiParams.paramPage: mNextPage.value.toString(),
      ApiParams.paramLimit: AppConfig.pageLimit,
      /*ApiParams.paramPage: 1,
      ApiParams.paramLimit: 10,*/
    };
    mBody.addAll(mModelFilterJobHistory.value.toJson());
    BlocProvider.of<JobHistoryBloc>(getNavigatorKeyContext())
        .add(GetJobHistory(url: AppUrls.apiJobHistory, body: mBody));
    mLoading.value = false;
  }

  void scrollListener() {
    printWrapped("_scrollController.offset--${_scrollController.offset}");
    printWrapped(
        "_scrollController.position.maxScrollExtent--${_scrollController.position.maxScrollExtent}");
    if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent &&
        isNextPage &&
        !mPagination.value) {
      mPagination.value = true;
      mNextPage.value += 1;
      positionValue = _scrollController.offset;

      /// api called
      getJobHistoryList();
    }
  }

  void getNotificationListEvent() async {
    Map<String, String> mBody = {
      ApiParams.paramPage: '1',
      ApiParams.paramLimit: AppConfig.pageLimitMessage,
    };
    BlocProvider.of<NotificationsListBloc>(getNavigatorKeyContext())
        .add(GetNotificationsList(
      body: mBody,
      url: AppUrls.apiNotificationsList,
    ));
  }

  @override
  void dispose() {
    // mPagination.value = false;
    // mModelFilterJobHistory.value = ModelFilterJobHistory();
    //mNextPage.value = 1;
    super.dispose();
  }
}

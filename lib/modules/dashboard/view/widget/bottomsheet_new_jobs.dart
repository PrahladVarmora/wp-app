// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/bloc/my_job_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/update_job_bloc.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';
import 'package:we_pro/modules/dashboard/view/widget/row_new_jobs_card.dart';

/// This class is a stateful widget that creates a bottom sheet that allows the user
/// to create a new job
class BottomSheetNewJobs extends StatefulWidget {
  const BottomSheetNewJobs({Key? key}) : super(key: key);

  @override
  State<BottomSheetNewJobs> createState() => _BottomSheetNewJobsState();
}

class _BottomSheetNewJobsState extends State<BottomSheetNewJobs> {
  ValueNotifier<bool> mLoading = ValueNotifier(false);
  ValueNotifier<int> mSortBy = ValueNotifier(0);
  ValueNotifier<bool> mPagination = ValueNotifier(false);
  ValueNotifier<String> mSortValue = ValueNotifier('');
  ValueNotifier<int> mNextPage = ValueNotifier(1);

  ValueNotifier<List<JobData>> mJobList = ValueNotifier([]);

  /// this is used to pagination scroll controller
  final ScrollController _scrollController = ScrollController();
  bool isNextPage = false;
  double positionValue = 0.0;

  /// String jobIdValue = '';

  @override
  void initState() {
    /// sort by first value selected.
    mSortValue.value = getSortByText()[mSortBy.value].translate();
    _scrollController.addListener(scrollListener);

    /// api called for first time load
    getNewJobEvent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
        valueListenables: [
          mSortBy,
          mPagination,
          mSortValue,
          mJobList,
          mNextPage,
          mLoading,
        ],
        builder: (context, values, child) {
          return MultiBlocListener(
            listeners: [
              BlocListener<MyJobBloc, MyJobState>(
                listener: (context, state) {
                  mLoading.value =
                      (state is MyJobLoading) && (mNextPage.value == 1);
                  mPagination.value =
                      (state is MyJobLoading) && (mNextPage.value > 1);
                  if (state is NewJobResponse) {
                    mJobList.value = state.mModelNewJob.jobData!;
                  }
                  if (state is NewJobResponse) {
                    mLoading.value = false;
                    mJobList.value.addAll(state.mModelNewJob.jobData ?? []);
                    mJobList.notifyListeners();
                    mPagination.value = false;

                    /// isNextPage = (state.mModelMyJob.next != null);

                    if (mJobList.value.isNotEmpty) {
                      _scrollController.jumpTo(
                        positionValue,
                      );
                    }
                  }
                },
              ),
              BlocListener<UpdateJobBloc, UpdateJobState>(
                listener: (context, state) {
                  if (state is UpdateJobLoading) {
                    mLoading.value = true;
                  } else if (state is UpdateJobAcceptResponse) {
                    mLoading.value = false;
                  }
                },
              ),
            ],
            child: ModalProgressHUD(
              inAsyncCall: mLoading.value,
              progressIndicator: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: Dimens.margin16),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(Dimens.margin30),
                      topRight: Radius.circular(Dimens.margin30),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: Dimens.margin16),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                APPStrings.textNewJobs.translate(),
                                style: getTextStyleFontWeight(
                                    Theme.of(context)
                                        .primaryTextTheme
                                        .labelMedium!,
                                    Dimens.textSize18,
                                    FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              padding:
                                  const EdgeInsets.only(right: Dimens.margin20),
                              icon: SvgPicture.asset(APPImages.icClose))
                        ],
                      ),
                    ),
                    Expanded(
                      child: mJobList.value.isNotEmpty
                          ? ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: mJobList.value.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RowNewJobsCard(
                                          mJobData: mJobList.value[index],
                                          onAccept: () {
                                            Map<String, dynamic> mBody = {
                                              ApiParams.paramJobId:
                                                  mJobList.value[index].jobId,
                                              ApiParams.paramJobUpdateStatus:
                                                  AppConfig.jobStatusConfirmed
                                            };
                                            BlocProvider.of<UpdateJobBloc>(
                                                    context)
                                                .add(UpdateJobAcceptFromList(
                                              body: mBody,
                                              url: AppUrls.apiUpdateJob,
                                            ));
                                            /*   Navigator.pushNamed(context,
                                                AppRoutes.routesJobDetail,
                                                arguments: {
                                                  AppConfig.jobStatus:
                                                      statusJobAcceptReject,
                                                  AppConfig.jobId: mJobList
                                                      .value[index].jobId
                                                      .toString()
                                                });*/

                                            ///  openConfirm(mJobList.value[index].jobId!);
                                          },
                                          onReject: () {
                                            Navigator.popAndPushNamed(context,
                                                AppRoutes.routesRejectService,
                                                arguments: mJobList
                                                    .value[index].jobId
                                                    .toString());
                                            /*  Navigator.pushNamed(context,
                                                AppRoutes.routesJobDetail,
                                                arguments: {
                                                  AppConfig.jobStatus:
                                                      statusJobAcceptReject,
                                                  AppConfig.jobId: mJobList
                                                      .value[index].jobId
                                                      .toString()
                                                });*/
                                          },
                                        ),
                                        const SizedBox(height: Dimens.margin20),
                                      ],
                                    ),
                                    if ((index == mJobList.value.length - 1) &&
                                        isNextPage)
                                      CircularProgressIndicator(
                                        color: Theme.of(context).primaryColor,
                                      )
                                  ],
                                );
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void scrollListener() {
    if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent &&
        isNextPage &&
        !mPagination.value) {
      mPagination.value = true;
      mNextPage.value += 1;
      positionValue = _scrollController.offset;

      /// api called
      getNewJobEvent();
    }
  }

  ///[getNewJobEvent] this method is used to connect to my job list Event api
  void getNewJobEvent() async {
    Map<String, dynamic> mBody = {
      ApiParams.paramOrderBy: mSortValue.value,
      ApiParams.paramPage: mNextPage.value.toString(),
      ApiParams.paramLimit: AppConfig.pageLimit,
      ApiParams.paramLatitude:
          MyAppState.mCurrentPosition.value.latitude.toString(),
      ApiParams.paramLongitude:
          MyAppState.mCurrentPosition.value.longitude.toString(),
      ApiParams.paramJobStatus: AppConfig.jobStatusPending
    };
    BlocProvider.of<MyJobBloc>(context).add(NewJobMyJob(
      body: mBody,
      url: AppUrls.apiJobs,
    ));
  }
}

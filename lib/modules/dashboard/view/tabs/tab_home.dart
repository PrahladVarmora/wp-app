// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:we_pro/modules/dashboard/bloc/add_job/add_job_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/change_priority/change_priority_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/my_job_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/rejected_job_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/update_job_bloc.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';
import 'package:we_pro/modules/dashboard/notifications/bloc/notifications_list/notifications_list_bloc.dart';
import 'package:we_pro/modules/dashboard/view/widget/bottom_sheet_update_status.dart';
import 'package:we_pro/modules/dashboard/view/widget/bottomsheet_new_jobs.dart';
import 'package:we_pro/modules/dashboard/view/widget/row_job_card.dart';
import 'package:we_pro/modules/profile/bloc/get_profile/get_profile_bloc.dart';
import 'package:we_pro/modules/profile/bloc/update_live_location/update_live_location_bloc.dart';

import '../../../core/utils/core_import.dart';
import '../../../profile/model/model_get_profile.dart';

/// This class is a stateful widget that creates a stateful widget called TabHome
class TabHome extends StatefulWidget {
  const TabHome({Key? key}) : super(key: key);

  @override
  State<TabHome> createState() => TabHomeState();
}

class TabHomeState extends State<TabHome> with WidgetsBindingObserver {
  ValueNotifier<bool> mLoading = ValueNotifier(false);

  /*ValueNotifier<bool> mClockIn =
      ValueNotifier(getProfileData().profile?.isClockIn != 'Yes');*/
  // ValueNotifier<String> mStatus =
  //     ValueNotifier(getProfileData().profile?.userStatus ?? '');
  // ValueNotifier<int> mSortBy = ValueNotifier(0);
  static ValueNotifier<bool> mPagination = ValueNotifier(false);
  static ValueNotifier<String> mSortValue = ValueNotifier('');
  static ValueNotifier<int> mNextPage = ValueNotifier(1);

  ValueNotifier<List<JobData>> mJobList = ValueNotifier([]);
  ValueNotifier<String> mTotalCountJob = ValueNotifier('0');

  /// this is used to pagination scroll controller
  final ScrollController _scrollController = ScrollController();
  bool isNextPage = false;
  double positionValue = 0.0;
  ModelGetProfile? modelProfile;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    /// sort by first value selected.
    mSortValue.value = getSortByText().first;
    if (mJobList.value.isEmpty) {
      mJobList.value = getMyJobList();
    }
    mNextPage.value = 1;
    _scrollController.addListener(scrollListener);

    initCalled();
    super.initState();
  }

  /// [initCalled] this function is called for first time
  initCalled() async {
    getNotificationListEvent();
    resetPaginationAndGetList();

    /* if (MyAppState.mCurrentPosition.value.latitude == 0.0 &&
        !isPermissionDialogOpen) {
      if (Platform.isAndroid) {
        await determinePosition().then((value) {
          if (value != null) {
            MyAppState.mCurrentPosition.value =
                LatLng(value.latitude, value.longitude);
            resetPaginationAndGetList();
          }
        });
      } else if (Platform.isIOS) {
        await determinePositionIos().then((value) {
          MyAppState.mCurrentPosition.value =
              LatLng(value.latitude, value.longitude);
          resetPaginationAndGetList();
        });
      }*/

    if (Platform.isAndroid) {
      await determinePosition().then((value) {
        if (value != null) {
          MyAppState.mCurrentPosition.value =
              LatLng(value.latitude, value.longitude);
          resetPaginationAndGetList();
        }
      });
    } else if (Platform.isIOS) {
      /* await determinePositionIos().then((value) {
          MyAppState.mCurrentPosition.value =
              LatLng(value.latitude, value.longitude);

                  resetPaginationAndGetList();
      });*/

      iOSLocation();
    }
    // else {
    await getMyJobEvent();
    // await getNewJobEvent();
    // }
  }

  void iOSLocation() async {
    printWrapped('iOSLocationDetect---');
    determinePositionIos().then((value) {
      MyAppState.mCurrentPosition.value =
          LatLng(value.latitude, value.longitude);
      getMyJobEvent();
    });

    printWrapped('iOSLocationDetect1---');

    resetPaginationAndGetList();
  }

  ///[getProfileEvent] this method is used to connect to get profile api
  getProfileEvent() async {
    BlocProvider.of<GetProfileBloc>(context)
        .add(GetProfileUser(url: AppUrls.apiGetProfileApi));
  }

  @override
  Widget build(BuildContext context) {
    /// If the user has not completed their profile, show a warning
    Widget getCompleteProfileWarning() {
      return Container(
        color: Theme.of(context).colorScheme.errorContainer,
        height: Dimens.margin70,
        padding: const EdgeInsets.all(Dimens.margin16),
        // alignment: Alignment.center,
        child: Row(
          children: [
            Expanded(
              child: Text(
                APPStrings.textCompleteProfileDesc.translate(),
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.displayMedium!,
                    Dimens.textSize15,
                    FontWeight.w400),
              ),
            ),
            const SizedBox(width: Dimens.margin20),
            CustomButton(
              width: Dimens.margin130,
              onPress: () {
                Navigator.pushNamed(context, AppRoutes.routesProfileCompletion,
                    arguments: true);
              },
              backgroundColor: Theme.of(context).primaryColor,
              borderColor: Theme.of(context).primaryColor,
              height: Dimens.margin40,
              borderRadius: Dimens.margin30,
              buttonText: APPStrings.textCompleteProfile.translate(),
            )
          ],
        ),
      );
    }

    /// It returns a widget.
    Widget getNewJobsButton() {
      return InkWell(
        onTap: () {
          if (mTotalCountJob.value != '0') {
            showModalBottomSheet(
              context: context,
              useSafeArea: true,
              isScrollControlled: true,
              backgroundColor: AppColors.colorTransparent,
              builder: (context) {
                return const BottomSheetNewJobs();
              },
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(Dimens.margin16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.margin16),
              color: Theme.of(context).colorScheme.primaryContainer,
              border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: Dimens.margin1)),
          height: Dimens.margin60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                    text: APPStrings.textNewJobs.translate(),
                    style: getTextStyleFontWeight(
                        Theme.of(context).primaryTextTheme.labelMedium!,
                        Dimens.textSize18,
                        FontWeight.w600),
                    children: [
                      const TextSpan(text: ' '),
                      TextSpan(
                          text: '(${mTotalCountJob.value})',
                          style: getTextStyleFontWeight(
                            Theme.of(context).primaryTextTheme.titleMedium!,
                            Dimens.textSize18,
                            FontWeight.w600,
                          )),
                    ]),
              ),
              SvgPicture.asset(APPImages.icArrowRight),
            ],
          ),
        ),
      );
    }

    /// It returns a row with two widgets.
    Widget getMyJobsAndMapViewRow() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            APPStrings.textMyJobs.translate(),
            style: getTextStyleFontWeight(
                Theme.of(context).primaryTextTheme.labelMedium!,
                Dimens.textSize18,
                FontWeight.w600),
          ),
          CustomButton(
            onPress: () {
              Navigator.pushNamed(context, AppRoutes.routesMapPreview,
                  arguments: mJobList.value);
            },
            width: Dimens.margin100,
            borderRadius: Dimens.margin30,
            height: Dimens.margin30,
            backgroundColor: Theme.of(context).primaryColor,
            buttonText: APPStrings.textMapView.translate(),
          ),
        ],
      );
    }

    /// Returning a row with a container.
    Widget getSortByButton() {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: Dimens.margin50,
            padding: const EdgeInsets.all(Dimens.margin16),
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.all(Radius.circular(Dimens.margin16)),
              color: Theme.of(context).highlightColor,
            ),
            clipBehavior: Clip.hardEdge,
            child: DropdownButton2<String>(
              isDense: true,
              underline: Container(),
              items: getSortByText().map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value.translate(),
                    style: getTextStyleFontWeight(
                        Theme.of(context).primaryTextTheme.labelSmall!,
                        Dimens.margin16,
                        FontWeight.w400),
                  ),
                );
              }).toList(),
              value: mSortValue.value,
              onChanged: (newValue) {
                mSortValue.value = newValue!;
                mNextPage.value = 1;
                getMyJobEvent();
              },
            ),
          ),
        ],
      );
      /*return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              if (mSortBy.value == 1) {
                mSortBy.value = 0;
                mSortValue.value = getSortByText()[mSortBy.value].translate();
              } else {
                mSortBy.value += 1;
                mSortValue.value = getSortByText()[mSortBy.value].translate();
              }

              setFilter();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.margin15,
                vertical: Dimens.margin12,
              ),
              height: Dimens.margin40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.margin13),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      width: Dimens.margin1)),
              alignment: Alignment.center,
              child: Text.rich(
                TextSpan(
                  text: APPStrings.textSortByWithColon.translate(),
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.labelSmall!,
                      Dimens.textSize12,
                      FontWeight.w400),
                  children: [
                    TextSpan(
                      text: getSortByText()[mSortBy.value].translate(),
                      style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.labelMedium!,
                          Dimens.textSize12,
                          FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );*/
    }

    /// It returns a widget.
    Widget getHomePageView() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.margin16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            getNewJobsButton(),
            const SizedBox(height: Dimens.margin20),
            getMyJobsAndMapViewRow(),
            const SizedBox(height: Dimens.margin10),
            getSortByButton(),
            const SizedBox(height: Dimens.margin10),
            if (mJobList.value.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ((mSortValue.value == getSortByText().first)
                      ? ReorderableListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: mJobList.value.length,
                          proxyDecorator: (child, index, anim) {
                            return Material(
                              color: Colors.transparent,
                              child: AnimatedContainer(
                                duration: Duration(seconds: anim.value.toInt()),
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).highlightColor,
                                    borderRadius:
                                        BorderRadius.circular(Dimens.margin25)),
                                child: RowJobCard(
                                    mJobData: mJobList.value[index],
                                    callUpdateJobList: () {
                                      resetPaginationAndGetList();
                                    }),
                              ),
                            );
                          },
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              color: AppColors.colorTransparent,
                              key: ValueKey(
                                  mJobList.value[index].jobId.toString()),
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              AppRoutes.routesJobDetail,
                                              arguments: {
                                                AppConfig.jobStatus:
                                                    statusJobCollectPaymentSendInvoice,
                                                AppConfig.jobId: mJobList
                                                    .value[index].jobId
                                                    .toString()
                                              }).then((value) {
                                            resetPaginationAndGetList();
                                          });
                                        },
                                        child: RowJobCard(
                                            mJobData: mJobList.value[index],
                                            callUpdateJobList: () {
                                              resetPaginationAndGetList();
                                            }),
                                      ),
                                      Container(
                                          height: Dimens.margin20,
                                          color: AppColors.colorTransparent),
                                    ],
                                  ),
                                  if ((index == mJobList.value.length - 1) &&
                                      isNextPage)
                                    CircularProgressIndicator(
                                      color: Theme.of(context).primaryColor,
                                    )
                                ],
                              ),
                            );
                          },
                          onReorder: (int oldIndex, int newIndex) {
                            Map<String, dynamic> mBody = {
                              ApiParams.paramJobId:
                                  mJobList.value[oldIndex].jobId,
                              ApiParams.paramPriorityIndex: (newIndex > oldIndex
                                      ? (newIndex)
                                      : (newIndex + 1))
                                  .toString(),
                            };
                            BlocProvider.of<ChangePriorityBloc>(context).add(
                                ChangePriority(
                                    url: AppUrls.apiChangePriority,
                                    body: mBody));
                            JobData mTmp = mJobList.value.removeAt(oldIndex);
                            if (newIndex > mJobList.value.length) {
                              mJobList.value.add(mTmp);
                            } else {
                              mJobList.value.insert(newIndex, mTmp);
                            }
                            mJobList.notifyListeners();
                            /* ToastController.showToast(
                          'moved from ${oldIndex + 1} to ${newIndex + 1}',
                          context,
                          true);*/
                          },
                        )
                      : ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: mJobList.value.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              color: AppColors.colorTransparent,
                              key: ValueKey(
                                  mJobList.value[index].jobId.toString()),
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              AppRoutes.routesJobDetail,
                                              arguments: {
                                                AppConfig.jobStatus:
                                                    statusJobCollectPaymentSendInvoice,
                                                AppConfig.jobId: mJobList
                                                    .value[index].jobId
                                                    .toString()
                                              }).then((value) {
                                            resetPaginationAndGetList();
                                          });
                                        },
                                        child: RowJobCard(
                                            mJobData: mJobList.value[index],
                                            callUpdateJobList: () {
                                              resetPaginationAndGetList();
                                            }),
                                      ),
                                      Container(
                                          height: Dimens.margin20,
                                          color: AppColors.colorTransparent),
                                    ],
                                  ),
                                  if ((index == mJobList.value.length - 1) &&
                                      mPagination.value)
                                    const CircularProgressIndicator()
                                ],
                              ),
                            );
                          },
                        )),
                ],
              )
            else
              Container(
                padding: const EdgeInsets.only(top: Dimens.margin50),
                alignment: Alignment.center,
                child: Text(
                    /*(!mLoading.value && mJobList.value.length > 1
                        ? "No ${mSortValue.value.translate()} Job found"
                        : APPStrings.textLoading.translate()),*/
                    (mLoading.value
                        ? APPStrings.textLoading.translate()
                        : "No ${mSortValue.value.translate()} Job found"),
                    style: const TextStyle(
                      color: AppColors.colorPrimary,
                      fontSize: Dimens.textSize25,
                    ),
                    textAlign: TextAlign.center),
              )
          ],
        ),
      );
    }

    /// It returns a widget
    Widget getBody() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (getProfileData().profile?.profileStatus == 'Incomplete') ...[
            getCompleteProfileWarning(),
          ],
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Container(
                  margin: const EdgeInsets.only(top: Dimens.margin20),
                  child: getHomePageView()),
            ),
          ),
        ],
      );
    }

    /// This function returns a widget that is the app bar for the app.
    PreferredSizeWidget getAppBar() {
      return AppBar(
        title: Row(
          children: [
            Expanded(
              child: BlocBuilder<GetProfileBloc, GetProfileState>(
                builder: (context, state) {
                  state is GetProfileLoading;

                  if (state is GetProfileResponse) {
                    if (modelProfile != null) {
                      if (modelProfile?.profile?.picture !=
                          state.modelGetProfile.profile?.picture) {
                        modelProfile?.profile?.picture =
                            state.modelGetProfile.profile?.picture;
                      }
                      if (modelProfile?.profile?.firstname !=
                          state.modelGetProfile.profile?.firstname) {
                        modelProfile?.profile?.firstname =
                            state.modelGetProfile.profile?.firstname;
                      }
                      if (modelProfile?.profile?.userStatus !=
                          state.modelGetProfile.profile?.userStatus) {
                        modelProfile?.profile?.userStatus =
                            state.modelGetProfile.profile?.userStatus;
                      }
                    } else {
                      modelProfile = state.modelGetProfile;
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Stack(
                          children: [
                            CircleImageViewerNetwork(
                              url: state.modelGetProfile.profile?.picture !=
                                      modelProfile!.profile?.picture
                                  ? state.modelGetProfile.profile?.picture!
                                  : modelProfile!.profile?.picture,
                              mHeight: Dimens.margin50,
                            ),
                            Positioned(
                              right: Dimens.margin3,
                              bottom: Dimens.margin3,
                              child: Container(
                                height: Dimens.margin10,
                                width: Dimens.margin10,
                                decoration: BoxDecoration(
                                  color: getColorStatus(state.modelGetProfile
                                          .profile?.userStatus ??
                                      ''),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: Dimens.margin10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              InterpolateString.interpolate(
                                APPStrings.textHelloInterpolate.translate(),
                                [
                                  getProfileData()
                                      .profile!
                                      .firstname!
                                      .toString()
                                ],
                              ),
                              style: getTextStyleFontWeight(
                                  Theme.of(context)
                                      .primaryTextTheme
                                      .titleLarge!,
                                  Dimens.textSize18,
                                  FontWeight.w600),
                            ),
                            InkWell(
                              focusColor: AppColors.colorTransparent,
                              highlightColor: AppColors.colorTransparent,
                              hoverColor: AppColors.colorTransparent,
                              splashColor: AppColors.colorTransparent,
                              onTap: () {
                                showAvailabilityStatus();
                              },
                              child: Row(
                                children: [
                                  Text(
                                    state.modelGetProfile.profile?.userStatus ??
                                        '',
                                    // getAvailabilityStatus()[mStatus.value]
                                    //     .translate(),
                                    style: getTextStyleStatus(state
                                            .modelGetProfile
                                            .profile
                                            ?.userStatus ??
                                        ''),
                                  ),
                                  SvgPicture.asset(APPImages.icNext),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return modelProfile != null
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Stack(
                                children: [
                                  CircleImageViewerNetwork(
                                    url: modelProfile!.profile?.picture ?? "",
                                    mHeight: Dimens.margin50,
                                  ),
                                  Positioned(
                                    right: Dimens.margin3,
                                    bottom: Dimens.margin3,
                                    child: Container(
                                      height: Dimens.margin10,
                                      width: Dimens.margin10,
                                      decoration: BoxDecoration(
                                        color: getColorStatus(
                                            modelProfile!.profile?.userStatus ??
                                                ''),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: Dimens.margin10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    InterpolateString.interpolate(
                                      APPStrings.textHelloInterpolate
                                          .translate(),
                                      [
                                        getProfileData()
                                            .profile!
                                            .firstname!
                                            .toString()
                                      ],
                                    ),
                                    style: getTextStyleFontWeight(
                                        Theme.of(context)
                                            .primaryTextTheme
                                            .titleLarge!,
                                        Dimens.textSize18,
                                        FontWeight.w600),
                                  ),
                                  InkWell(
                                    focusColor: AppColors.colorTransparent,
                                    highlightColor: AppColors.colorTransparent,
                                    hoverColor: AppColors.colorTransparent,
                                    splashColor: AppColors.colorTransparent,
                                    onTap: () {
                                      showAvailabilityStatus();
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          modelProfile!.profile?.userStatus ??
                                              '',
                                          // getAvailabilityStatus()[mStatus.value]
                                          //     .translate(),
                                          style: getTextStyleStatus(
                                              modelProfile!
                                                      .profile?.userStatus ??
                                                  ''),
                                        ),
                                        SvgPicture.asset(APPImages.icNext),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : const SizedBox();
                  }
                },
              ),
            ),
            IconButton(
              onPressed: () {
                printWrapped(
                    'PreferenceHelper.fcmToken----${PreferenceHelper.getString(PreferenceHelper.fcmToken)}');
                Navigator.pushNamed(context, AppRoutes.routesNotifications);
              },
              icon: BlocBuilder<NotificationsListBloc, NotificationsListState>(
                builder: (context, state) {
                  if (state is NotificationsListResponse &&
                      (state.mModelNotificationsList.totalRecords != '0')) {
                    return IconButton(
                      onPressed: () {
                        printWrapped(
                            'PreferenceHelper.fcmToken----${PreferenceHelper.getString(PreferenceHelper.fcmToken)}');
                        Navigator.pushNamed(
                                context, AppRoutes.routesNotifications)
                            .then((value) {
                          getNotificationListEvent();
                        });
                      },
                      icon: Badge(
                        label: Text(
                            state.mModelNotificationsList.totalRecords ?? ''),
                        backgroundColor: AppColors.colorD95151,
                        isLabelVisible:
                            state.mModelNotificationsList.totalRecords != '0',
                        child: SvgPicture.asset(APPImages.icNotification),
                      ),
                    );
                  } else {
                    return IconButton(
                      onPressed: () {
                        printWrapped(
                            'PreferenceHelper.fcmToken----${PreferenceHelper.getString(PreferenceHelper.fcmToken)}');
                        Navigator.pushNamed(
                                context, AppRoutes.routesNotifications)
                            .then((value) {
                          getNotificationListEvent();
                        });
                      },
                      icon: SvgPicture.asset(APPImages.icNotification),
                    );
                  }
                },
              ),
            ),
            CustomButton(
              height: Dimens.margin30,
              onPress: () {
                Navigator.pushNamed(context, AppRoutes.routesAddJob);
              },
              borderRadius: Dimens.margin30,
              buttonText: APPStrings.textAddJob.translate(),
              style: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.labelSmall!,
                  Dimens.textSize12,
                  FontWeight.w400),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: Dimens.margin70,
      );
    }

    return MultiValueListenableBuilder(
        valueListenables: [
          mLoading,
          mPagination,
          mSortValue,
          mJobList,
          mNextPage,
          mTotalCountJob
        ],
        builder: (context, values, child) {
          return MultiBlocListener(
            listeners: [
              BlocListener<AddJobBloc, AddJobState>(
                listener: (context, state) {
                  if (state is AddJobResponse) {
                    resetPaginationAndGetList();
                  }
                },
              ),
              BlocListener<UpdateJobBloc, UpdateJobState>(
                listener: (context, state) {
                  if ((state is UpdateJobAcceptResponse)) {
                    resetPaginationAndGetList();
                  }
                },
              ),
              BlocListener<RejectedJobBloc, RejectedJobState>(
                listener: (context, state) {
                  if ((state is RejectedJobResponse)) {
                    resetPaginationAndGetList();
                  }
                },
              ),
              /*BlocListener<ClockInOutBloc, ClockInOutState>(
                listener: (context, state) {
                  mLoading.value = state is ClockInOutLoading;
                },
              ),*/
              BlocListener<ChangePriorityBloc, ChangePriorityState>(
                listener: (context, state) {
                  if (state is ChangePriorityResponse) {
                    // resetPaginationAndGetList();
                  }
                },
              ),
              BlocListener<UpdateLiveLocationBloc, UpdateLiveLocationState>(
                listener: (context, state) {
                  if (state is UpdateLiveLocationResponse) {
                    resetPaginationAndGetList();
                  }
                },
              ),
              BlocListener<MyJobBloc, MyJobState>(
                listener: (context, state) {
                  if ((state is MyJobLoading) &&
                      (mNextPage.value == 1) &&
                      mJobList.value.isEmpty) {
                    mLoading.value = true;
                  }
                  if ((state is MyJobLoading) && (mNextPage.value > 1)) {
                    mPagination.value = true;
                  }
                  if (state is MyJobResponse) {
                    if (mNextPage.value == 1) {
                      mJobList.value = state.mModelMyJob.jobData!;
                    }

                    if (mNextPage.value > 1) {
                      mJobList.value.addAll(state.mModelMyJob.jobData ?? []);
                      mJobList.notifyListeners();
                    }

                    isNextPage = (state.mModelMyJob.jobData ?? []).length ==
                        AppConfig.pageLimitCount;

                    if (mJobList.value.isNotEmpty && mNextPage.value > 1) {
                      try {
                        _scrollController.jumpTo(
                          positionValue,
                        );
                      } catch (e) {
                        printWrapped('_scrollController--$e');
                      }
                    }
                    mLoading.value = false;
                    mPagination.value = false;

                    setMyJobList(mJobList.value);
                  }
                  if (state is NewJobResponse) {
                    mTotalCountJob.value =
                        state.mModelNewJob.totalRecords.toString();
                  }
                },
              ),
            ],
            child: ModalProgressHUD(
              inAsyncCall: mLoading.value,
              progressIndicator: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
              child: Scaffold(
                appBar: getAppBar(),
                body: getBody(),
              ),
            ),
          );
        });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    printWrapped('didChangeAppLifecycleState-----${state.name}');
    if (state == AppLifecycleState.resumed) {
      resetPaginationAndGetList();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// It shows the availability status of the product.
  void showAvailabilityStatus() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      // isScrollControlled: true,
      backgroundColor: AppColors.colorTransparent,
      builder: (context) {
        return const BottomSheetUpdateStatus();
      },
    );
  }

  void scrollListener() {
    if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent &&
        isNextPage &&
        !mPagination.value) {
      mPagination.value = true;

      mNextPage.value += 1;
      positionValue = _scrollController.offset;
      printWrapped('scrollListener---');
      getMyJobEvent();
    }
  }

  void setFilter() {
    mNextPage.value = 1;
    getMyJobEvent();
  }

  ///[getMyJobEvent] this method is used to connect to my job list Event api
  static getMyJobEvent() async {
    try {
      //   if (Platform.isIOS) {
      //     // var location = await Geolocator.getCurrentPosition(
      //     //     desiredAccuracy: LocationAccuracy.high);
      //     // if (MyAppState.mCurrentPosition.value.latitude != location.latitude) {
      //     //   MyAppState.mCurrentPosition.value =
      //     //       LatLng(location.latitude, location.longitude);
      //     // }
      //   } else {
      //     var location = await Geolocator.getCurrentPosition();
      //     if (MyAppState.mCurrentPosition.value.latitude != location.latitude) {
      //       MyAppState.mCurrentPosition.value =
      //           LatLng(location.latitude, location.longitude);
      //     }
      //   }

      Map<String, dynamic> mBody = {
        ApiParams.paramOrderBy: mSortValue.value.translate(),
        ApiParams.paramPage: mNextPage.value.toString(),
        ApiParams.paramLimit: AppConfig.pageLimit,
        ApiParams.paramLatitude:
            MyAppState.mCurrentPosition.value.latitude.toString(),
        ApiParams.paramLongitude:
            MyAppState.mCurrentPosition.value.longitude.toString(),
        ApiParams.paramJobStatus: AppConfig.jobStatusMyJob
      };
      BlocProvider.of<MyJobBloc>(getNavigatorKeyContext()).add(MyJobMyJob(
        body: mBody,
        url: AppUrls.apiJobs,
      ));
    } catch (e) {
      printWrapped("eror :- $e");
      // getMyJobEvent();
    }
  }

  ///[getNewJobEvent] this method is used to connect to my job list Event api
  static getNewJobEvent() async {
    Map<String, dynamic> mBody = {
      ApiParams.paramOrderBy: 'Newest',
      ApiParams.paramPage: '1',
      ApiParams.paramLimit: AppConfig.pageLimit,
      ApiParams.paramLatitude:
          MyAppState.mCurrentPosition.value.latitude.toString(),
      ApiParams.paramLongitude:
          MyAppState.mCurrentPosition.value.longitude.toString(),
      ApiParams.paramJobStatus: AppConfig.jobStatusPending
    };
    BlocProvider.of<MyJobBloc>(getNavigatorKeyContext()).add(NewJobMyJob(
      body: mBody,
      url: AppUrls.apiJobs,
    ));
  }

  void resetPaginationAndGetList() {
    if (mNextPage.value > 1) {
      mNextPage.value = 1;
      getMyJobEvent();
      getNewJobEvent();
    }
  }

  static void refreshJobDataExternal() {
    mNextPage.value = 1;
    getMyJobEvent();
    getNewJobEvent();
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
}

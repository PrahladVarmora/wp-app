// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/notifications/bloc/notifications_list/notifications_list_bloc.dart';
import 'package:we_pro/modules/dashboard/notifications/bloc/notifications_update_status/notifications_update_status_bloc.dart';
import 'package:we_pro/modules/dashboard/notifications/modal/modal_notification_list.dart';
import 'package:we_pro/modules/dashboard/notifications/view/widget/row_notification_item.dart';

import '../bloc/notifications_clear_list/notifications_clear_list_bloc.dart';

class ScreenNotifications extends StatefulWidget {
  const ScreenNotifications({Key? key}) : super(key: key);

  @override
  State<ScreenNotifications> createState() => _ScreenNotificationsState();
}

class _ScreenNotificationsState extends State<ScreenNotifications> {
  ValueNotifier<bool> mLoading = ValueNotifier(false);
  ValueNotifier<List<ModalNotificationData>> mModalNotificationData =
      ValueNotifier([]);

  static ValueNotifier<bool> mPagination = ValueNotifier(false);
  static ValueNotifier<int> mNextPage = ValueNotifier(1);
  final ScrollController _scrollController = ScrollController();
  bool isNextPage = false;
  double positionValue = 0.0;

  @override
  void initState() {
    mNextPage.value = 1;
    printWrapped('mNextPage-----${mNextPage.value}');
    _scrollController.addListener(scrollListener);
    getNotificationListEvent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget mBody() {
      return Container(
        padding: const EdgeInsets.all(Dimens.margin16),
        child: mModalNotificationData.value.isNotEmpty && !mLoading.value
            ? ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: mModalNotificationData.value.length,
                itemBuilder: (context, mIndex) {
                  return Column(
                    children: [
                      RowNotificationItem(
                          mIndex: mIndex,
                          mModalNotificationData:
                              mModalNotificationData.value[mIndex]),
                      if ((mIndex == mModalNotificationData.value.length - 1) &&
                          mPagination.value)
                        const CircularProgressIndicator()
                    ],
                  );
                },
              )
            : !mLoading.value
                ? Container(
                    padding: const EdgeInsets.only(top: Dimens.margin50),
                    alignment: Alignment.center,
                    child: const Text("No Notification found",
                        style: TextStyle(
                            color: AppColors.colorPrimary,
                            fontSize: Dimens.textSize25)),
                  )
                : const SizedBox.shrink(),
      );
    }

    PreferredSizeWidget getAppbar() {
      return BaseAppBar(
        mLeftImage: APPImages.icArrowBack,
        mLeftAction: () {
          Navigator.pop(context);
        },
        title: APPStrings.textNotifications.translate(),
        actions: [
          if (mModalNotificationData.value.isNotEmpty)
            IconButton(
              onPressed: () {
                clearListEvent(context);
                // Navigator.pop(context);
              },
              iconSize: Dimens.margin70,
              icon: Text(
                APPStrings.textClearAll.translate(),
                style: AppFont.mediumBold.copyWith(
                    color: AppColors.color50E666, fontSize: Dimens.textSize15),
              ),
            )
        ],
        appBar: AppBar(),
      );
    }

    return MultiValueListenableBuilder(
        valueListenables: [
          mLoading,
          mPagination,
          mNextPage,
          mModalNotificationData,
        ],
        builder: (context, values, child) {
          return MultiBlocListener(
            listeners: [
              BlocListener<NotificationsListBloc, NotificationsListState>(
                listener: (context, state) {
                  if ((state is NotificationsListLoading) &&
                      (mNextPage.value == 1)) {
                    mLoading.value = true;
                  }
                  if ((state is NotificationsListLoading) &&
                      (mNextPage.value > 1)) {
                    mPagination.value = true;
                  }
                  if (state is NotificationsListResponse) {
                    if (mNextPage.value == 1) {
                      mModalNotificationData.value =
                          state.mModelNotificationsList.notificationDataList ??
                              [];
                    }

                    if (mNextPage.value > 1) {
                      mModalNotificationData.value.addAll(
                          state.mModelNotificationsList.notificationDataList ??
                              []);
                      mModalNotificationData.notifyListeners();
                    }

                    isNextPage =
                        (state.mModelNotificationsList.notificationDataList ??
                                    [])
                                .length ==
                            AppConfig.pageLimitCountMessage;

                    if (mModalNotificationData.value.isNotEmpty &&
                        mNextPage.value > 1) {
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
                  }
                },
              ),
              BlocListener<NotificationsUpdateStatusBloc,
                  NotificationsUpdateStatusState>(
                listener: (context, state) {
                  if (state is NotificationsUpdateStatusResponse) {
                    mModalNotificationData.value
                        .remove(state.mModalNotificationData);
                    mModalNotificationData.notifyListeners();
                  }
                },
              ),
              BlocListener<NotificationsClearListBloc,
                  NotificationsClearListState>(listener: (context, state) {
                mLoading.value = state is NotificationsClearListLoading;
                if (state is NotificationsClearListResponse) {
                  mNextPage.value = 1;
                  mModalNotificationData.value = [];
                  getNotificationListEvent();
                }
              })
            ],
            child: ModalProgressHUD(
              inAsyncCall: mLoading.value,
              progressIndicator: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
              child: Scaffold(
                appBar: getAppbar(),
                body: mBody(),
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
      printWrapped('scrollListener---');
      getNotificationListEvent();
    }
  }

  void getNotificationListEvent() async {
    Map<String, String> mBody = {
      ApiParams.paramPage: mNextPage.value.toString(),
      ApiParams.paramLimit: AppConfig.pageLimitMessage,
    };
    BlocProvider.of<NotificationsListBloc>(getNavigatorKeyContext())
        .add(GetNotificationsList(
      body: mBody,
      url: AppUrls.apiNotificationsList,
    ));
  }

  void clearListEvent(BuildContext context) {
    BlocProvider.of<NotificationsClearListBloc>(context)
        .add(NotificationsClearList(url: AppUrls.apiNotificationsClearList));
  }
}

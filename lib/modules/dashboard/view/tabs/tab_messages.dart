// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:async';

import 'package:we_pro/modules/core/common/widgets/base_text_form_field_prefix_suffix.dart';
import 'package:we_pro/modules/dashboard/messages/bloc/message_chat_list/message_bloc.dart';
import 'package:we_pro/modules/dashboard/messages/bloc/message_chat_list/message_event.dart';
import 'package:we_pro/modules/dashboard/messages/model/model_chat_list.dart';
import 'package:we_pro/modules/dashboard/messages/view/widget/row_message.dart';

import '../../../core/api_service/firebase_notification_helper.dart';
import '../../../core/common/modelCommon/model_chat_notification.dart';
import '../../../core/utils/core_import.dart';
import '../../messages/bloc/message_chat_list/message_state.dart';

/// This class is a stateful widget that creates a tab for the messages page
class TabMessages extends StatefulWidget {
  const TabMessages({Key? key}) : super(key: key);

  @override
  State<TabMessages> createState() => _TabMessagesState();
}

class _TabMessagesState extends State<TabMessages> {
  ValueNotifier<bool> mLoading = ValueNotifier(false);
  ValueNotifier<bool> isSearch = ValueNotifier(false);
  ValueNotifier<ModelChatList> modelChatData = ValueNotifier(ModelChatList());
  ValueNotifier<List<Chats>> chatList = ValueNotifier([]);
  TextEditingController searchController = TextEditingController();
  ValueNotifier<bool> mPagination = ValueNotifier(false);
  ValueNotifier<bool> isNotification = ValueNotifier(false);
  ValueNotifier<String> mSortValue = ValueNotifier('');
  ValueNotifier<int> mNextPage = ValueNotifier(1);
  final ScrollController _scrollController = ScrollController();
  bool isNextPage = false;
  double positionValue = 0.0;
  late StreamSubscription<ModalNotificationData> chatStream;

  @override
  void initState() {
    _scrollController.addListener(scrollListener);
    getChatList();
    subscribeChatNotificationStream();
    super.initState();
  }

  void scrollListener() {
    if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent &&
        isNextPage &&
        !mPagination.value) {
      mPagination.value = true;
      mNextPage.value += 1;
      positionValue = _scrollController.offset;
      getChatList();
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Returning a container.
    Widget getBody() {
      return Container(
        padding: const EdgeInsets.all(Dimens.margin16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BaseTextFormFieldPrefixSuffix(
              controller: searchController,
              textInputAction: TextInputAction.done,
              hintText: APPStrings.textSearch.translate(),
              onSubmit: () {
                isSearch.value = true;
                getChatList();
              },
              fillColor: AppColors.colorEAEAEA,
              borderRadius: Dimens.margin50,
              hintStyle: getTextStyleFontWeight(
                  Theme.of(context).textTheme.titleSmall!,
                  Dimens.textSize15,
                  FontWeight.w400),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(Dimens.margin15),
                child: SvgPicture.asset(
                  APPImages.icSearch,
                  height: Dimens.margin20,
                  width: Dimens.margin20,
                ),
              ),
              suffixIcon:
                  searchController.value.text.isNotEmpty && isSearch.value
                      ? InkWell(
                          onTap: () {
                            searchController.text = "";
                            getChatList();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(Dimens.margin15),
                            child: SvgPicture.asset(
                              APPImages.icClose,
                              height: Dimens.margin20,
                              width: Dimens.margin20,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
            ),
            const SizedBox(height: Dimens.margin16),
            if (chatList.value.isNotEmpty)
              Expanded(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: chatList.value.length,
                    itemBuilder: (context, index) {
                      return RowMessage(
                          mIndex: index,
                          chat: chatList.value[index],
                          refreshList: () {
                            mNextPage.value = 1;
                            getChatList();
                          });
                    }),
              )
            else if (mLoading.value == false)
              Container(
                padding: const EdgeInsets.only(top: Dimens.margin50),
                alignment: Alignment.center,
                child: Text(APPStrings.textNoDataFound.translate(),
                    style: const TextStyle(
                        color: AppColors.colorPrimary,
                        fontSize: Dimens.textSize25)),
              ),
          ],
        ),
      );
    }

    /// This function returns a widget that is the app bar for the app.
    PreferredSizeWidget getAppBar() {
      return BaseAppBar(
        appBar: AppBar(),
        title: APPStrings.textMessages.translate(),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.routesMessageAdminDetails)
                  .then((value) {
                mNextPage.value = 1;
                getChatList();
              });
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  APPImages.icAdd,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.surfaceTint,
                      BlendMode.srcIn),
                  height: Dimens.margin15,
                  width: Dimens.margin15,
                ),
                const SizedBox(width: Dimens.margin10),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Text(
                      APPStrings.textContactAdmin.translate(),
                      style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.labelLarge!,
                          Dimens.textSize12,
                          FontWeight.w700),
                    ),
                    (int.parse(modelChatData.value.totalUnreadAdmin ?? "0") > 0)
                        ? Positioned(
                            right: -7,
                            top: -13,
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: Dimens.margin18,
                                minHeight: Dimens.margin18,
                              ),
                              child: Text(
                                modelChatData.value.totalUnreadAdmin ?? "0",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimens.textSize14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ))
                        : const SizedBox.shrink(),
                  ],
                ),
                const SizedBox(width: Dimens.margin10),
              ],
            ),
          )
        ],
      );
    }

    // return Scaffold(
    //   appBar: getAppBar(),
    //   body: getBody(),
    // );
    return MultiValueListenableBuilder(
        valueListenables: [
          chatList,
          modelChatData,
          mLoading,
          isNotification,
          mPagination,
          mSortValue,
          mNextPage,
        ],
        builder: (BuildContext context, value, Widget? child) {
          return MultiBlocListener(
              listeners: [
                BlocListener<MessageBloc, MessageState>(
                    listener: (context, state) {
                  printWrapped(
                      'notification status -- ${isNotification.value}');
                  mLoading.value = (state is MessageLoading) &&
                      (mNextPage.value == 1) &&
                      !isNotification.value;
                  mPagination.value =
                      (state is MessageLoading) && (mNextPage.value > 1);

                  if (state is MessageGetChatListResponse) {
                    isNotification.value = false;
                    if (mNextPage.value == 1) {
                      chatList.value = [];
                      modelChatData.value = state.modelChatList;
                      chatList.value.addAll(state.modelChatList.chats ?? []);
                    }

                    if (mNextPage.value > 1) {
                      modelChatData.value = state.modelChatList;
                      chatList.value.addAll(state.modelChatList.chats ?? []);
                    }
                    modelChatData.notifyListeners();
                    chatList.notifyListeners();
                    isNextPage = ((state.modelChatList.chats ?? []).length ==
                        AppConfig.pageLimitCount);
                  }

                  if (chatList.value.isNotEmpty && mNextPage.value > 1) {
                    try {
                      _scrollController.jumpTo(
                        positionValue,
                      );
                    } catch (e) {
                      printWrapped('_scrollController--$e');
                    }
                  }
                })
              ],
              child: ModalProgressHUD(
                  inAsyncCall: mLoading.value && !mPagination.value,
                  progressIndicator: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                  child: Scaffold(
                    appBar: getAppBar(),
                    body: getBody(),
                  )));
        });
  }

  void getChatList() {
    if (mounted) {
      Map<String, dynamic> mBody = {
        //  ApiParams.paramOrderBy: "Newest",
        ApiParams.paramPage: mNextPage.value.toString(),
        ApiParams.paramLimit: AppConfig.pageLimit,
        ApiParams.multipartSearch: searchController.text,
      };
      BlocProvider.of<MessageBloc>(context).add(
          MessageGetChatList(url: AppUrls.apiGetClientChatList, body: mBody));
    }
  }

  void subscribeChatNotificationStream() {
    chatStream =
        FirebaseNotificationHelper.chatStreamController.stream.listen((event) {
      isNotification.value = true;
      printWrapped('notification status 1 -- ${isNotification.value}');
      mNextPage.value = 1;
      mPagination.value = false;
      getChatList();
    });
  }
}

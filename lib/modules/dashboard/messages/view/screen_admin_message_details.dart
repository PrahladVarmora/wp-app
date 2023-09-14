// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:file_picker/file_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_pro/modules/core/api_service/firebase_notification_helper.dart';
import 'package:we_pro/modules/core/common/modelCommon/model_chat_notification.dart';
import 'package:we_pro/modules/core/common/widgets/base_text_form_field_prefix_suffix.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/messages/model/model_message_detail_response.dart';
import 'package:we_pro/modules/dashboard/messages/view/widget/row_received_message.dart';
import 'package:we_pro/modules/dashboard/messages/view/widget/row_sent_message.dart';

import '../bloc/message_admin_send/message_admin_send_bloc.dart';
import '../bloc/message_admin_send/message_admin_send_event.dart';
import '../bloc/message_admin_send/message_admin_send_state.dart';
import '../bloc/message_chat_admin_detail/message_admin_detail_bloc.dart';
import '../bloc/message_chat_admin_detail/message_admin_detail_event.dart';
import '../bloc/message_chat_admin_detail/message_admin_detail_state.dart';

/// This class is a StatefulWidget that displays a message's details
class ScreenAdminMessageDetails extends StatefulWidget {
  final String? mCopyData;

  const ScreenAdminMessageDetails({Key? key, this.mCopyData}) : super(key: key);

  @override
  State<ScreenAdminMessageDetails> createState() =>
      _ScreenAdminMessageDetailsState();
}

class _ScreenAdminMessageDetailsState extends State<ScreenAdminMessageDetails> {
  ValueNotifier<bool> mChatLoading = ValueNotifier(true);
  ValueNotifier<bool> mChatSending = ValueNotifier(false);
  ValueNotifier<bool> mPagination = ValueNotifier(false);
  ValueNotifier<bool> isNotification = ValueNotifier(false);
  ValueNotifier<ModelMessageDetailResponse?> mModelChatDetail =
      ValueNotifier(null);
  bool isNextPage = false;
  double positionValue = 0.0;
  ValueNotifier<int> mNextPage = ValueNotifier(1);
  ValueNotifier<List<ChatDetail>?> chatDetailList = ValueNotifier([]);
  ValueNotifier<bool> mLoading = ValueNotifier(false);
  ScrollController chatScrollController = ScrollController();
  TextEditingController messageTextController = TextEditingController();
  FocusNode messageTextFocus = FocusNode();

  File? selectedProfilePic;

  late StreamSubscription<ModalNotificationData> chatStream;

  @override
  void initState() {
    if (widget.mCopyData != null) {
      printWrapped(" widget.mCopyData ${widget.mCopyData}");
      messageTextController.text = widget.mCopyData ?? '';
      messageTextController.notifyListeners();
      messageTextController.selection =
          TextSelection.collapsed(offset: messageTextController.text.length);
      printWrapped("messageTextController.text ${messageTextController.text}");
    }

    PreferenceHelper.setString(
        PreferenceHelper.currentRoute, AppRoutes.routesMessageAdminDetails);
    subscribeChatNotificationStream();
    chatScrollController.addListener(scrollListener);
    PreferenceHelper.getString(PreferenceHelper.currentRoute);

    getChatList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///[chatMessageList] is Used to for message chat list
    Widget chatMessageList() {
      return InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView.builder(
          reverse: true,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          controller: chatScrollController,
          itemCount: chatDetailList.value?.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                if (index ==
                        (49 /*mModelStartChatList.value.message!.results!.length - 1*/) &&
                    mPagination.value)
                  CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                /*mModelStartChatList.value.message!.results![index].sender ==
                        mModelStartChatList.value.userId*/
                /*(randomNumberData == 1)
                    ?*/
                if (chatDetailList.value?[index].direction == "Outbound")
                  (RowSentMessageItem(
                    imageChat: chatDetailList.value?[index].img ?? "",
                    messageTime: chatDetailList.value?[index].date ?? "",
                    messageText: chatDetailList.value?[index].message ?? "",
                  ))
                else
                  RowReceivedMessageItem(
                    messageTime: chatDetailList.value?[index].date ?? "",
                    messageText: chatDetailList.value?[index].message ?? "",
                    imageChat: chatDetailList.value?[index].img ?? "",
                  ),
                /*: randomNumberData == 2
                        ? (RowSentMessageItem(
                            imageChat: randomImage(),
                            messageTime: '9:41 PM | 9 Mar 2023',
                            messageText:
                                chatDetailList.value?[index].message ?? "",
                          ))*/
                /* : Text(
                            APPStrings.textNow.translate(),
                            style: getTextStyleFontWeight(
                                Theme.of(context).textTheme.titleSmall!,
                                Dimens.textSize12,
                                FontWeight.w400),
                          ),*/
                const SizedBox(height: Dimens.margin20)
              ],
            );
          },
        ),
      );
    }

    /// It returns a widget that contains a text input field and a button.
    Widget bottomActionAndTextInputField() {
      return BaseTextFormFieldPrefixSuffix(
        height: Dimens.margin100,
        controller: messageTextController,
        focusNode: messageTextFocus,
        borderRadius: Dimens.margin50,
        maxLength: 1600,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.send,
        fillColor: Theme.of(context).colorScheme.error,
        prefixIcon: const SizedBox(width: Dimens.margin30),
        onChange: () {
          printWrapped(messageTextController.text);
        },
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                pickImageAndSend(false);
              },
              child: Container(
                padding: const EdgeInsets.only(left: Dimens.margin15),
                child: SvgPicture.asset(
                  APPImages.icGallery,
                  width: Dimens.margin20,
                  height: Dimens.margin20,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                pickImageAndSend(true);
              },
              child: Container(
                padding: const EdgeInsets.only(left: Dimens.margin15),
                child: SvgPicture.asset(
                  APPImages.icCamera,
                  width: Dimens.margin20,
                  height: Dimens.margin20,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                pickAttachmentFileAndSend();
              },
              child: Container(
                padding: const EdgeInsets.only(left: Dimens.margin15),
                child: SvgPicture.asset(
                  APPImages.icAttachment,
                  width: Dimens.margin20,
                  height: Dimens.margin20,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (messageTextController.text.trim().toString().isNotEmpty) {
                  printWrapped(messageTextController.text.trim());

                  eventSendMessage();
                } else {
                  ToastController.showToast(
                      APPStrings.textPleaseEnterMessage.translate(),
                      context,
                      false);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(Dimens.margin15),
                child: mChatSending.value
                    ? Container(
                        width: Dimens.margin20,
                        height: Dimens.margin20,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : SvgPicture.asset(
                        APPImages.icSend,
                        width: Dimens.margin20,
                        height: Dimens.margin20,
                      ),
              ),
            ),
          ],
        ),
        onSubmit: () {
          printWrapped(messageTextController.text.trim());
          eventSendMessage();
        },
        hintText: APPStrings.hintWriteHere.translate(),
        hintStyle: getTextStyleFontWeight(
            Theme.of(context).textTheme.titleSmall!,
            Dimens.textSize15,
            FontWeight.w400),
      );
    }

    /// It returns a widget.
    Widget getMessageBody() {
      return Container(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimens.margin16, vertical: Dimens.margin20),
        child: Column(
          children: [
            Expanded(child: chatMessageList()),
            bottomActionAndTextInputField(),
          ],
        ),
      );
    }

    /// This function returns a widget that is the app bar for the app.
    PreferredSizeWidget getAppBar() {
      return AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.only(
                  top: Dimens.margin8, bottom: Dimens.margin8),
              padding: const EdgeInsets.only(
                  top: Dimens.margin8, bottom: Dimens.margin8),
              width: Dimens.margin30,
              height: Dimens.margin30,
              child: SvgPicture.asset(
                APPImages.icArrowBack,
                width: Dimens.margin30,
                height: Dimens.margin30,
              ),
            )),
        automaticallyImplyLeading: false,
        title: Text(
          'Admin',
          textAlign: TextAlign.left,
          style: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.titleLarge!,
              Dimens.textSize18,
              FontWeight.w600),
        ),
        actions: [
          IconButton(
              onPressed: () {
                mNextPage.value = 1;
                getChatList();
              },
              icon: Icon(
                Icons.refresh,
                color: Theme.of(context).colorScheme.surfaceTint,
              ))
        ],
      );
    }

    return MultiValueListenableBuilder(
      valueListenables: [mLoading, mModelChatDetail, chatDetailList],
      builder: (context, values, child) {
        return MultiBlocListener(
            listeners: [
              BlocListener<MessageAdminSendBloc, MessageAdminSendState>(
                  listener: (context, state) {
                mLoading.value =
                    state is MessageAdminSendLoading && !isNotification.value;

                if (state is MessageAdminSendResponse) {
                  ChatDetail chat = ChatDetail(
                      date: formatDate(DateTime.now().toUtc(),
                          AppConfig.dateFormatMMDDYYYYHHMM),
                      direction: "Outbound",
                      img: selectedProfilePic?.path,
                      jobId: null,
                      message: messageTextController.text);
                  chatDetailList.value?.insert(0, chat);
                  chatDetailList.notifyListeners();
                  selectedProfilePic = null;
                  messageTextController.text = "";
                }

                if (state is MessageAdminSendFailure) {
                  ToastController.showToast(state.mError, context, false);
                }
              }),
              BlocListener<MessageAdminDetailBloc, MessageAdminDetailState>(
                  listener: (context, state) {
                mLoading.value = state is MessageAdminDetailLoading &&
                    (mNextPage.value == 1) &&
                    !isNotification.value;
                mPagination.value = (state is MessageAdminDetailLoading) &&
                    (mNextPage.value > 1);
                printWrapped('mPagination${mPagination.value}');

                if (state is MessageAdminGetChatDetailResponse) {
                  mModelChatDetail.value = state.modelChatDetailList;
                  isNotification.value = false;
                  // if (mModelChatDetail.value!.chats!.isEmpty) {
                  //   messageTextController.text = widget.mCopyData ?? '';
                  // }else{
                  //   messageTextController.text ="";
                  // }
                  if (mNextPage.value == 1) {
                    chatDetailList.value = [];
                    var data = mModelChatDetail.value?.chats?.reversed.toList();
                    chatDetailList.value?.addAll(data ?? []);
                  }

                  if (mNextPage.value > 1) {
                    var data = mModelChatDetail.value?.chats?.reversed.toList();
                    chatDetailList.value?.addAll(data ?? []);
                  }
                  chatDetailList.notifyListeners();
                  mModelChatDetail.notifyListeners();
                  isNextPage =
                      ((state.modelChatDetailList.chats ?? []).length ==
                          AppConfig.pageLimitCountMessage);
                  if (chatDetailList.value != null &&
                      chatDetailList.value!.isNotEmpty &&
                      mNextPage.value > 1) {
                    try {
                      chatScrollController.jumpTo(
                        positionValue - 50,
                      );
                    } catch (e) {
                      printWrapped('_scrollController--$e');
                    }
                  }
                }
                if (state is MessageAdminDetailFailure) {
                  ToastController.showToast(state.mError, context, false);
                }
              })
            ],
            child: ModalProgressHUD(
              inAsyncCall: mLoading.value,
              child: Scaffold(
                appBar: getAppBar(),
                body: getMessageBody(),
              ),
            ));
      },
    );
  }

  /// It picks an image from the gallery or camera and sends it to the server.
  ///
  /// Args:
  ///   isCamera (bool): true if you want to use the camera, false if you want to
  /// use the gallery.
  Future<void> pickImageAndSend(bool isCamera) async {
    await ImagePicker()
        .pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery)
        .then((pickedFile) {
      if (pickedFile != null) {
        ImageCropper.platform.cropImage(
          sourcePath: pickedFile.path,
          compressQuality: 50,
          aspectRatioPresets: [CropAspectRatioPreset.square],
        ).then((croppedImage) {
          if (croppedImage != null) {
            selectedProfilePic = File(croppedImage.path);
            eventSendMessage();
          }
        });
      }
    });
  }

  /// It picks an attachment file and sends it.
  Future<void> pickAttachmentFileAndSend() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'odt',
        'doc',
        'docx',
        'pdf',
        'jpg',
        'jpeg',
        'png',
        'ppt',
        'pptx'
      ],
    );

    if (result != null) {
      File file = File(result.files.single.path ?? '');
      if (file.path.split(".").last.toLowerCase() == "odt" ||
          file.path.split(".").last.toLowerCase() == "doc" ||
          file.path.split(".").last.toLowerCase() == "docx" ||
          file.path.split(".").last.toLowerCase() == "pdf" ||
          file.path.split(".").last.toLowerCase() == "jpg" ||
          file.path.split(".").last.toLowerCase() == "jpeg" ||
          file.path.split(".").last.toLowerCase() == "png" ||
          file.path.split(".").last.toLowerCase() == "ppt" ||
          file.path.split(".").last.toLowerCase() == "pptx") {
        selectedProfilePic = file;
        eventSendMessage();
      } else {
        ToastController.showToast(
            APPStrings.txtPleaseSelectValidFile.translate(),
            getNavigatorKeyContext(),
            true);
      }
    }
  }

  /// It sends a message to the server.
  Future<void> eventSendMessage() async {
    Map<String, dynamic> mBody = {
      ApiParams.paramMsg: messageTextController.text.trim().toString(),
    };
    if (selectedProfilePic != null) {
      if (getFileImageSize(await File(selectedProfilePic!.path).length()) <=
          5) {
        BlocProvider.of<MessageAdminSendBloc>(getNavigatorKeyContext()).add(
            MessageAdminSendRequest(
                url: AppUrls.apiSendAdminMessage,
                body: mBody,
                imageFile: selectedProfilePic));
      } else {
        ToastController.showToast(APPStrings.textFileSizeError.translate(),
            getNavigatorKeyContext(), false);
      }
    } else {
      BlocProvider.of<MessageAdminSendBloc>(getNavigatorKeyContext()).add(
          MessageAdminSendRequest(
              url: AppUrls.apiSendAdminMessage, body: mBody, imageFile: null));
    }
  }

  void getChatList() {
    Map<String, dynamic> mBody = {
      ApiParams.paramPage: mNextPage.value.toString(),
      ApiParams.paramLimit: AppConfig.pageLimitCountMessage.toString(),
    };
    BlocProvider.of<MessageAdminDetailBloc>(context).add(
        MessageAdminGetChatDetail(
            url: AppUrls.apiChatAdminHistory, body: mBody));
  }

  void scrollListener() {
    // printWrapped("_scrollController.offset--${chatScrollController.offset}");
    // printWrapped("isNextPage--$isNextPage");
    // printWrapped("!mPagination.value--${!mPagination.value}");
    // printWrapped(
    //     "_scrollController.position.minScrollExtent--${chatScrollController.position.minScrollExtent}");
    if (chatScrollController.offset >=
            chatScrollController.position.minScrollExtent &&
        isNextPage &&
        !mPagination.value) {
      mPagination.value = true;
      mNextPage.value += 1;
      positionValue = chatScrollController.offset;

      /// api called
      getChatList();
    }
  }

  void subscribeChatNotificationStream() {
    chatStream =
        FirebaseNotificationHelper.chatStreamController.stream.listen((event) {
      mPagination.value = false;
      mNextPage.value = 1;
      isNotification.value = true;
      getChatList();
      // chatDetailList.value?.insert(
      //     0,
      //     ChatDetail(
      //         message: event.message,
      //         direction: 'Inbound',
      //         date: formatDate(
      //             DateTime.now().copyWith(
      //                 hour: TimeOfDay.now().hour,
      //                 minute: TimeOfDay.now().minute),
      //             AppConfig.dateFormatMMDDYYYYHHMM)));
      // chatDetailList.notifyListeners();
      // // List<String> aa = (event.messageCreatedTs ?? '').split(' ');
      // // aa.removeAt(0);
      //
      // /*var mList = mModelStartChatList.value;
      // mList.message?.results = mList.message?.results?.reversed.toList();
      // if (!kIsWeb && Platform.isIOS) {
      //   mModelStartChatList.value.message?.results?.add(
      //     MessageList(
      //       date: event.messageCreatedTs?.split(' ').first,
      //       id: int.parse(event.msgId ?? '0'),
      //       image: event.messageImage,
      //       message: event.message,
      //       sender: int.parse(event.fromId ?? '0'),
      //       time: event.messageCreatedTs?.split(' ').last,
      //     ),
      //   );
      // }
      // mList.message?.results = mList.message?.results?.reversed.toList();
      // BlocProvider.of<StartChatListBloc>(getNavigatorKeyContext())
      //     .add(ReceivedChat(mMessageList: mList));*/
    });
  }

  @override
  void dispose() {
    PreferenceHelper.remove(PreferenceHelper.currentRoute);
    super.dispose();
  }
}

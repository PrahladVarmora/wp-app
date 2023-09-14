// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_pro/modules/core/common/widgets/base_text_form_field_prefix_suffix.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/messages/bloc/message_chat_detail/message_detail_bloc.dart';
import 'package:we_pro/modules/dashboard/messages/bloc/message_chat_detail/message_detail_state.dart';
import 'package:we_pro/modules/dashboard/messages/bloc/message_send/message_send_bloc.dart';
import 'package:we_pro/modules/dashboard/messages/bloc/message_send/message_send_state.dart';
import 'package:we_pro/modules/dashboard/messages/model/model_message_detail_response.dart';
import 'package:we_pro/modules/dashboard/messages/view/widget/row_received_message.dart';
import 'package:we_pro/modules/dashboard/messages/view/widget/row_sent_message.dart';

import '../../../core/api_service/firebase_notification_helper.dart';
import '../../../core/common/modelCommon/model_chat_notification.dart';
import '../bloc/message_chat_detail/message_detail_event.dart';
import '../bloc/message_send/message_send_event.dart';

/// This class is a StatefulWidget that displays a message's details
class ScreenMessageDetails extends StatefulWidget {
  final String jobId;
  final String companyId;
  final String company;
  final String chatType;
  final String name;
  final String? copyData;

  const ScreenMessageDetails(
      {Key? key,
      required this.jobId,
      required this.name,
      required this.companyId,
      required this.company,
      required this.copyData,
      required this.chatType})
      : super(key: key);

  @override
  State<ScreenMessageDetails> createState() => _ScreenMessageDetailsState();
}

class _ScreenMessageDetailsState extends State<ScreenMessageDetails> {
  ValueNotifier<bool> mChatLoading = ValueNotifier(true);
  ValueNotifier<bool> mChatSending = ValueNotifier(false);
  ValueNotifier<bool> mPagination = ValueNotifier(false);
  ValueNotifier<bool> isNotification = ValueNotifier(false);
  ValueNotifier<ModelMessageDetailResponse?> mModelChatDetail =
      ValueNotifier(null);
  bool isNextPage = false;
  late StreamSubscription<ModalNotificationData> chatStream;
  double positionValue = 0.0;
  ValueNotifier<int> mNextPage = ValueNotifier(1);
  ValueNotifier<List<ChatDetail>?> chatDetailList = ValueNotifier([]);
  String? mJobId;
  String? mCompanyId;
  String? mCompany;
  String? mChatType;
  String? mCopyData;
  ValueNotifier<bool> mLoading = ValueNotifier(false);
  ScrollController chatScrollController = ScrollController();
  TextEditingController messageTextController = TextEditingController();
  FocusNode messageTextFocus = FocusNode();

  File? selectedProfilePic;

  // ///[mMessages] is used for random texts
  // List<String> mMessages = [
  //   '',
  //   'Lorem ipsum',
  //   'dolor ipsum',
  //   'orem ipsum dolor sit amet, co',
  //   'fugiat nulla pariatur.',
  //   'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum',
  //   'Section 1.10.32 ',
  //   'Finibus',
  //   'Hello',
  //   'How are you doing?',
  //   'I am doing fine',
  //   'Hello',
  // ];

  @override
  void initState() {
    chatScrollController.addListener(scrollListener);
    subscribeChatNotificationStream();
    mJobId = widget.jobId;
    mCompanyId = widget.companyId;
    mChatType = widget.chatType;
    mCompany = widget.company;
    mCopyData = widget.copyData;
    printWrapped("mCompanyId $mCompanyId");
    getChatList();
    if (mCopyData != null && mCopyData!.isNotEmpty) {
      printWrapped(" widget.mCopyData $mCopyData");
      messageTextController.text = mCopyData ?? '';
      messageTextController.notifyListeners();
      messageTextController.selection =
          TextSelection.collapsed(offset: messageTextController.text.length);
      printWrapped("messageTextController.text ${messageTextController.text}");
    }
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
        height: Dimens.margin50,
        controller: messageTextController,
        focusNode: messageTextFocus,
        borderRadius: Dimens.margin50,
        maxLength: 1600,
        textInputAction: TextInputAction.send,
        fillColor: Theme.of(context).colorScheme.error,
        prefixIcon: const SizedBox(width: Dimens.margin30),
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
        margin: const EdgeInsets.only(bottom: Dimens.margin20),
        padding: const EdgeInsets.symmetric(horizontal: Dimens.margin16),
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.name,
              textAlign: TextAlign.left,
              style: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.titleLarge!,
                  Dimens.textSize18,
                  FontWeight.w600),
            ),
            mChatType == "Company"
                ? const SizedBox()
                : InkWell(
                    focusColor: AppColors.colorTransparent,
                    highlightColor: AppColors.colorTransparent,
                    hoverColor: AppColors.colorTransparent,
                    splashColor: AppColors.colorTransparent,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.routesJobDetail,
                          arguments: {
                            AppConfig.jobStatus:
                                statusJobCollectPaymentSendInvoice,
                            AppConfig.jobId: mJobId.toString(),
                          });
                    },
                    child: Text(
                      'Job $mJobId',
                      textAlign: TextAlign.left,
                      style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.displayMedium!,
                          Dimens.textSize12,
                          FontWeight.w400),
                    ),
                  ),
          ],
        ),
        actions: [
          mChatType == "Company"
              ? const SizedBox()
              : TextButton(
                  onPressed: () {
                    // Navigator.pushNamed(
                    //     context, AppRoutes.routesMessageAdminDetailsFromJob,
                    //     arguments:
                    //         'Job Id: ${widget.jobId}\nName: ${widget.name}');
                    Navigator.pushNamed(context, AppRoutes.routesMessageDetails,
                        arguments: {
                          'jobId': mJobId ?? "",
                          'clientName': mCompany,
                          'chat_type': 'Company',
                          'compId': mCompanyId,
                          'company': mCompany,
                          'copyData':
                              'Job Id: ${widget.jobId}\nName: ${widget.name}',
                        }).then((value) {
                      chatDetailList.value?.clear();
                      chatDetailList.notifyListeners();
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
                      Text(
                        APPStrings.textContactAdmin.translate(),
                        style: getTextStyleFontWeight(
                            Theme.of(context).primaryTextTheme.labelLarge!,
                            Dimens.textSize12,
                            FontWeight.w700),
                      ),
                    ],
                  ),
                ),
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
              BlocListener<MessageSendBloc, MessageSendState>(
                  listener: (context, state) {
                mLoading.value = state is MessageSendLoading;

                if (state is MessageSendResponse) {
                  mNextPage.value = 1;
                  getChatList(showLoader: false);

                  /* ChatDetail chat = ChatDetail(
                      date: formatDate(
                          DateTime.now(), AppConfig.dateFormatMMDDYYYYHHMM),
                      direction: "Outbound",
                      img: selectedProfilePic?.path,
                      jobId: mJobId,
                      message: messageTextController.text);
                  chatDetailList.value?.insert(0, chat);
                  chatDetailList.notifyListeners();*/
                  selectedProfilePic = null;
                  messageTextController.text = "";
                }
              }),
              BlocListener<MessageDetailBloc, MessageDetailState>(
                  listener: (context, state) {
                mLoading.value = state is MessageDetailLoading &&
                    (mNextPage.value == 1) &&
                    !isNotification.value;
                mPagination.value =
                    (state is MessageDetailLoading) && (mNextPage.value > 1);
                printWrapped('mPagination${mPagination.value}');

                if (state is MessageGetChatDetailResponse) {
                  mModelChatDetail.value = state.modelChatDetailList;
                  isNotification.value = false;
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
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    FocusScope.of(context).requestFocus(messageTextFocus);
                  });
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
      ApiParams.paramJobId: mChatType == "Company" ? "" : mJobId,
      ApiParams.paramMsg: messageTextController.text.trim().toString(),
      ApiParams.chatType: mChatType.toString(),
      ApiParams.compId: mChatType == "Company" ? mCompanyId.toString() : ""
    };
    if (selectedProfilePic != null) {
      if (getFileImageSize(await File(selectedProfilePic!.path).length()) <=
          5) {
        BlocProvider.of<MessageSendBloc>(getNavigatorKeyContext()).add(
            MessageSendRequest(
                url: AppUrls.apiSendMessage,
                body: mBody,
                imageFile: selectedProfilePic));
      } else {
        ToastController.showToast(APPStrings.textFileSizeError.translate(),
            getNavigatorKeyContext(), false);
      }
    } else {
      BlocProvider.of<MessageSendBloc>(getNavigatorKeyContext()).add(
          MessageSendRequest(
              url: AppUrls.apiSendMessage, body: mBody, imageFile: null));
    }
  }

  void getChatList({bool showLoader = true}) {
    Map<String, dynamic> mBody = {
      ApiParams.paramJobId: mChatType == "Company" ? "" : mJobId,
      ApiParams.paramPage: mNextPage.value.toString(),
      ApiParams.paramLimit: AppConfig.pageLimitCountMessage.toString(),
      ApiParams.chatType: mChatType.toString(),
      ApiParams.compId: mChatType == "Company" ? mCompanyId.toString() : ""
    };
    BlocProvider.of<MessageDetailBloc>(context).add(MessageGetChatDetail(
        url: AppUrls.apiChatHistory, body: mBody, showLoader: showLoader));
  }

  void scrollListener() {
    printWrapped("_scrollController.offset--${chatScrollController.offset}");
    printWrapped("isNextPage--$isNextPage");
    printWrapped("!mPagination.value--${!mPagination.value}");
    printWrapped(
        "_scrollController.position.minScrollExtent--${chatScrollController.position.minScrollExtent}");
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
      mPagination.value = false;
      mNextPage.value = 1;
      isNotification.value = true;
      getChatList();
    });
  }
}

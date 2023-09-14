import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/utils/core_import.dart';

///[RowSentMessageItem] is used to generate sent message layout on chat screen
class RowSentMessageItem extends StatelessWidget {
  final String messageText;
  final String messageTime;
  final String imageChat;

  const RowSentMessageItem({
    Key? key,
    required this.messageText,
    required this.messageTime,
    required this.imageChat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    (imageChat).isEmpty
                        ? InkWell(
                            onLongPress: () {
                              Clipboard.setData(ClipboardData(
                                      text: messageText.utf8convert()))
                                  .then((value) =>
                                      ToastController.showToastMessage(
                                          APPStrings.textMessageCopied
                                              .translate(),
                                          context,
                                          true));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimens.margin20,
                                  vertical: Dimens.margin10),
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft:
                                          Radius.circular(Dimens.margin20),
                                      topLeft: Radius.circular(Dimens.margin20),
                                      topRight:
                                          Radius.circular(Dimens.margin20))),
                              child: Text(
                                messageText.utf8convert(),
                                style: getTextStyleFontWeight(
                                  Theme.of(context)
                                      .primaryTextTheme
                                      .labelSmall!,
                                  Dimens.textSize15,
                                  FontWeight.w400,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          )
                        : Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimens.margin5)),
                            child: InkWell(
                              onTap: () {
                                viewUserImage(imageChat, context);
                              },
                              child: (imageChat.split(".").last == "odt" ||
                                      imageChat.split(".").last == "doc" ||
                                      imageChat.split(".").last == "docx" ||
                                      imageChat.split(".").last == "pdf" ||
                                      imageChat.split(".").last == "ppt" ||
                                      imageChat.split(".").last == "pptx")
                                  ? SvgPicture.asset(
                                      imageChat.split(".").last == "odt"
                                          ? APPImages.icOdt
                                          : imageChat.split(".").last == "doc"
                                              ? APPImages.icDoc
                                              : imageChat.split(".").last ==
                                                      "docx"
                                                  ? APPImages.icDocX
                                                  : imageChat.split(".").last ==
                                                          "pdf"
                                                      ? APPImages.icPdf
                                                      : imageChat
                                                                  .split(".")
                                                                  .last ==
                                                              "jpg"
                                                          ? APPImages.icJpg
                                                          : imageChat
                                                                      .split(
                                                                          ".")
                                                                      .last ==
                                                                  "jpeg"
                                                              ? APPImages.icJpeg
                                                              : imageChat
                                                                          .split(
                                                                              ".")
                                                                          .last ==
                                                                      "png"
                                                                  ? APPImages
                                                                      .icPng
                                                                  : imageChat.split(".").last ==
                                                                              "ppt" ||
                                                                          imageChat.split(".").last ==
                                                                              "pptx"
                                                                      ? APPImages
                                                                          .icPpt
                                                                      : APPImages
                                                                          .icError,
                                      height: Dimens.margin150,
                                      width: Dimens.margin80,
                                    )
                                  : imageChat.contains("https")
                                      ? ImageViewerNetwork(
                                          url:
                                              imageChat /*getNetworkMediaUrl(senderImageUrl)*/,
                                          mHeight: Dimens.margin150,
                                          mWidth: Dimens.margin150,
                                          mFit: BoxFit.contain,
                                        )
                                      : Image.file(
                                          File(imageChat),
                                          height: Dimens.margin150,
                                          width: Dimens.margin150,
                                        ),
                            ),
                          ),
                    const SizedBox(height: Dimens.margin7),
                    Padding(
                      padding: const EdgeInsets.only(left: Dimens.margin20),
                      child: Text(
                        getDateForCustomDisplayFormatChat(
                            messageTime,
                            AppConfig.dateFormatMMDDYYYYHHMM,
                            AppConfig.dateFormatHHMMDDMMMYYYY),
                        style: getTextStyleFontWeight(
                            Theme.of(context).textTheme.titleSmall!,
                            Dimens.textSize10,
                            FontWeight.w400),
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///[viewUserImage]  this method use to view Select Service
  void viewUserImage(String url, BuildContext context) async {
    if ((url.split(".").last == "odt" ||
        url.split(".").last == "doc" ||
        url.split(".").last == "docx" ||
        url.split(".").last == "pdf" ||
        imageChat.split(".").last == "mp3")) {
      if (url.startsWith('https:') || url.startsWith('http:')) {
        printWrapped('url---$url');
        launchUrlString(url, mode: LaunchMode.externalApplication);
        //  launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
      // } else {
      //   ToastController.showToast("File Not Found ", context, false);
      // }
    } else {
      showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) {
          return SafeArea(
            child: Scaffold(
                backgroundColor: AppColors.colorTransparent,
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: Dimens.margin13,
                        bottom: Dimens.margin13,
                        right: Dimens.margin23,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            splashColor: AppColors.colorTransparent,
                            highlightColor: AppColors.colorTransparent,
                            child: SvgPicture.asset(
                              APPImages.icClose,
                              height: Dimens.margin20,
                              width: Dimens.margin20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimens.margin16),
                        child: url.contains("http")
                            ? ImageViewerNetwork(
                                url: url /*getNetworkMediaUrl(url)*/,
                                mHeight: MediaQuery.of(context).size.height -
                                    Dimens.margin200,
                                mWidth: MediaQuery.of(context).size.width -
                                    Dimens.margin32,
                                mFit: BoxFit.contain,
                              )
                            : Image.file(
                                File(imageChat),
                                height: Dimens.margin200,
                                width: Dimens.margin200,
                              ),
                      ),
                    ),
                    const SizedBox(height: 50)
                  ],
                )),
          );
        },
      );
    }
  }
}

import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/utils/core_import.dart';

///[RowReceivedMessageItem] is used to generate received message layout on chat screen
class RowReceivedMessageItem extends StatelessWidget {
  final String messageText;
  final String messageTime;

  final String? imageChat;

  const RowReceivedMessageItem({
    Key? key,
    this.imageChat,
    required this.messageText,
    required this.messageTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width / 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (imageChat ?? '').isEmpty
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
                                    .onInverseSurface,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(Dimens.margin20),
                                  topLeft: Radius.circular(Dimens.margin20),
                                  bottomRight: Radius.circular(Dimens.margin20),
                                ),
                              ),
                              height: Dimens.margin40,
                              child: Text(
                                messageText.utf8convert(),
                                style: getTextStyleFontWeight(
                                    Theme.of(context)
                                        .primaryTextTheme
                                        .displayMedium!,
                                    Dimens.textSize15,
                                    FontWeight.w400),
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
                                viewUserImage(imageChat ?? '', context);
                              },
                              child: (imageChat?.split(".").last == "odt" ||
                                      imageChat?.split(".").last == "doc" ||
                                      imageChat?.split(".").last == "docx" ||
                                      imageChat?.split(".").last == "pdf" ||
                                      imageChat?.split(".").last == "mp3")
                                  ? SvgPicture.asset(
                                      imageChat?.split(".").last == "odt"
                                          ? APPImages.icOdt
                                          : imageChat?.split(".").last == "doc"
                                              ? APPImages.icDoc
                                              : imageChat?.split(".").last ==
                                                      "docx"
                                                  ? APPImages.icDocX
                                                  : imageChat
                                                              ?.split(".")
                                                              .last ==
                                                          "pdf"
                                                      ? APPImages.icPdf
                                                      : APPImages.icError,
                                      height: Dimens.margin150,
                                      width: Dimens.margin150,
                                    )
                                  : ImageViewerNetwork(
                                      url: imageChat ??
                                          '' /*getNetworkMediaUrl(imageChat ?? '')*/,
                                      mHeight: Dimens.margin150,
                                      mWidth: Dimens.margin150,
                                      mFit: BoxFit.contain,
                                    ),
                            ),
                          ),
                    const SizedBox(height: Dimens.margin8),
                    Text(
                      getDateForCustomDisplayFormatChat(
                          messageTime,
                          AppConfig.dateFormatMMDDYYYYHHMM,
                          AppConfig.dateFormatHHMMDDMMMYYYY),
                      style: getTextStyleFontWeight(
                          Theme.of(context).textTheme.titleSmall!,
                          Dimens.textSize10,
                          FontWeight.w400),
                      textAlign: TextAlign.start,
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
        url.split(".").last == "jpg" ||
        url.split(".").last == "jpeg" ||
        url.split(".").last == "png" ||
        url.split(".").last == "ppt" ||
        url.split(".").last == "pptx")) {
      launchUrlString(url, mode: LaunchMode.externalApplication);
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
                                colorFilter: const ColorFilter.mode(
                                    AppColors.colorWhite, BlendMode.srcIn),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimens.margin16),
                          child: (url.split(".").last == "odt" ||
                                  url.split(".").last == "doc" ||
                                  url.split(".").last == "docx" ||
                                  url.split(".").last == "pdf" ||
                                  url.split(".").last == "ppt" ||
                                  url.split(".").last == "pptx")
                              ? SvgPicture.asset(
                                  url.split(".").last == "odt"
                                      ? APPImages.icOdt
                                      : url.split(".").last == "doc"
                                          ? APPImages.icDoc
                                          : url.split(".").last == "docx"
                                              ? APPImages.icDocX
                                              : url.split(".").last == "pdf"
                                                  ? APPImages.icPdf
                                                  : url.split(".").last == "jpg"
                                                      ? APPImages.icJpg
                                                      : url.split(".").last ==
                                                              "jpeg"
                                                          ? APPImages.icJpeg
                                                          : url
                                                                      .split(
                                                                          ".")
                                                                      .last ==
                                                                  "png"
                                                              ? APPImages.icPng
                                                              : url.split(".").last ==
                                                                          "ppt" ||
                                                                      url.split(".").last ==
                                                                          "pptx"
                                                                  ? APPImages
                                                                      .icPpt
                                                                  : APPImages
                                                                      .icError,
                                  height: Dimens.margin150,
                                  width: Dimens.margin80,
                                )
                              : ImageViewerNetwork(
                                  url: url /*getNetworkMediaUrl(url)*/,
                                  mHeight: MediaQuery.of(context).size.height -
                                      Dimens.margin200,
                                  mWidth: MediaQuery.of(context).size.width -
                                      Dimens.margin32,
                                  mFit: BoxFit.contain,
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimens.margin16,
                            vertical: Dimens.margin30),
                        child: CustomButton(
                          height: Dimens.margin60,
                          backgroundColor: Theme.of(context).primaryColor,
                          borderColor: Theme.of(context).primaryColor,
                          borderRadius: Dimens.margin15,
                          onPress: () {
                            /*      fileDownload(
                                getNetworkMediaUrl(documents.document ?? ''));*/
                          },
                          style: getTextStyleFontWeight(
                              Theme.of(context).primaryTextTheme.titleSmall!,
                              Dimens.textSize15,
                              FontWeight.w500),
                          buttonText: APPStrings.textDownload.translate(),
                        ),
                      )
                    ],
                  )),
            );
          });
    }
  }
}

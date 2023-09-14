import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/bloc/add_image/add_image_bloc.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';

/// This class is a stateful widget that selected multiple job images a screen
///
//ignore: must_be_immutable
class ScreenJobImages extends StatefulWidget {
  var mJobData = JobData();

  ScreenJobImages({Key? key, required this.mJobData}) : super(key: key);

  @override
  State<ScreenJobImages> createState() => _ScreenJobImagesState();
}

class _ScreenJobImagesState extends State<ScreenJobImages> {
  ValueNotifier<bool> mLoading = ValueNotifier(false);

  ValueNotifier<List<File>> selectedJobImagesImages = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    double imageSize =
        (MediaQuery.of(context).size.width - Dimens.margin50) / 3;

    ///[getJobDetailAppbar] is used to get Appbar for different views i.e. Mobile and Web
    BaseAppBar getJobImagesAppbar() {
      return BaseAppBar(
        appBar: AppBar(),
        title: APPStrings.textJobImages.translate(),
        mLeftImage: APPImages.icArrowBack,
        backgroundColor: Theme.of(context).colorScheme.primary,
        mLeftAction: () {
          NavigatorKey.navigatorKey.currentState!.pop();
        },
      );
    }

    ///[uploadJobImages] is used for image selection on this screen
    Widget uploadJobImages() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: Dimens.margin20),
          Wrap(
            spacing: Dimens.margin10,
            runSpacing: Dimens.margin10,
            children: List.generate(
                selectedJobImagesImages.value.length +
                    ((selectedJobImagesImages.value.length < 20) ? 1 : 0),
                (index) {
              return (index == 0 && selectedJobImagesImages.value.length < 20)
                  ? SizedBox(
                      height: imageSize,
                      width: imageSize,
                      child: InkWell(
                        onTap: () {
                          selectPicture();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              ///   clipBehavior: Clip.antiAlias,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.outline),
                                borderRadius:
                                    BorderRadius.circular(Dimens.margin20),
                              ),
                              height: imageSize,
                              width: imageSize,
                              child: SvgPicture.asset(
                                APPImages.icAdd,
                                height: Dimens.margin20,
                                width: Dimens.margin20,
                              ),
                            ),
                            /* const SizedBox(height: Dimens.margin10),
                            Center(
                              child: Text(
                                APPStrings.textJobAddImage.translate(),
                                style: getTextStyleFontWeight(
                                    Theme.of(context)
                                        .primaryTextTheme
                                        .labelSmall!,
                                    Dimens.textSize12,
                                    FontWeight.w400),
                              ),
                            ),*/
                          ],
                        ),
                      ),
                    )
                  : SizedBox(
                      height: imageSize,
                      width: imageSize,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimens.margin20),
                        child: Image.file(
                          selectedJobImagesImages.value[
                              (selectedJobImagesImages.value.length < 20)
                                  ? (index - 1)
                                  : (index)],
                          height: Dimens.margin100,
                          width: Dimens.margin100,
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
            }),
          ),
        ],
      );
    }

    /// It returns a widget.
    Widget getJobImages() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimens.margin20),
          Text(
            APPStrings.textJobImageUploadMaxContent.translate(),
            style: getTextStyleFontWeight(
                Theme.of(context).textTheme.titleSmall!,
                Dimens.textSize12,
                FontWeight.w400),
          ),
          const SizedBox(height: Dimens.margin10),
          Expanded(
            child: SingleChildScrollView(
              child: uploadJobImages(),
            ),
          ),
        ],
      );
    }

    ///[btnContinues] is used for Send Images
    Widget btnContinues() {
      return CustomButton(
        height: Dimens.margin50,
        backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
        borderColor: Theme.of(context).colorScheme.onInverseSurface,
        borderRadius: Dimens.margin25,
        onPress: () {
          validateImages(context);
        },
        style: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.displayMedium!,
            Dimens.textSize15,
            FontWeight.w500),
        buttonText: APPStrings.textContinue.translate(),
      );
    }

    ///[mBody] is used to get Mobile view body
    Widget mBody() {
      return Container(
        padding: const EdgeInsets.all(Dimens.margin15),
        color: Theme.of(context).colorScheme.background,
        child: getJobImages(),
      );
    }

    return MultiValueListenableBuilder(
      valueListenables: [mLoading, selectedJobImagesImages],
      builder: (BuildContext context, List<dynamic> values, Widget? child) {
        return BlocListener<AddImageBloc, AddImageState>(
          listener: (context, state) {
            mLoading.value = state is AddImageLoading;
          },
          child: ModalProgressHUD(
            inAsyncCall: mLoading.value,
            child: Scaffold(
              appBar: getJobImagesAppbar(),
              bottomNavigationBar: Container(
                padding: const EdgeInsets.all(Dimens.margin15),
                height: Dimens.margin85,
                child: btnContinues(),
              ),
              body: mBody(),
            ),
          ),
        );
      },
    );
  }

  ///[selectPicture] it is used for image picker in mobile platform from gallery and camera
  Future<void> selectPicture() async {
    await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
          content: Text(
            APPStrings.textChooseImageSource.translate(),
            style: getTextStyleFontWeight(
                Theme.of(context).primaryTextTheme.labelMedium!,
                Dimens.textSize18,
                FontWeight.w600),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              child: Text(APPStrings.textCamera.translate()),
              onPressed: () => Navigator.pop(context, ImageSource.camera),
            ),
            TextButton(
              child: Text(APPStrings.textGallery.translate()),
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ]),
    ).then((ImageSource? source) async {
      if (source != null) {
        await ImagePicker().pickImage(source: source).then((pickedFile) async {
          if (pickedFile != null) {
            if (getFileImageSize(await File(pickedFile.path).length()) < 5) {
              ImageCropper.platform
                  .cropImage(
                sourcePath: pickedFile.path,
                compressQuality: 50,
              )
                  .then((croppedImage) async {
                if (croppedImage != null) {
                  setState(() {
                    selectedJobImagesImages.value.add(File(croppedImage.path));
                  });
                }
              });
            } else {
              ToastController.showToast(
                  ValidationString.validationImageSize.translate(),
                  getNavigatorKeyContext(),
                  false);
            }
          }
        });
      }
    });
  }

  /// [validateImages] This function is use for validate data
  void validateImages(BuildContext context) {
    if (selectedJobImagesImages.value.isEmpty) {
      if ((widget.mJobData.invoice ?? []).isEmpty ||
          !(widget.mJobData.invoice
                  ?.every((element) => element.status == 'Paid') ??
              false)) {
        Navigator.pushNamed(context, AppRoutes.routesCollectPayment,
                arguments: widget.mJobData)
            .then((value) {
          widget.mJobData = value as JobData;
        });
      } else {
        Navigator.pushNamed(context, AppRoutes.routesCloseJob,
            arguments: widget.mJobData);
      }
    } else {
      BlocProvider.of<AddImageBloc>(context).add(AddImage(
          url: AppUrls.apiAddImage,
          body: {ApiParams.paramJobId: widget.mJobData.jobId},
          mFileList: selectedJobImagesImages.value,
          mJobData: widget.mJobData));
    }
    /*if (selectedJobImagesImages.value.isEmpty) {
      ToastController.showToast(
          ValidationString.validationSelect.translate(), context, false);
    } else {
      Navigator.pushNamed(context, AppRoutes.routesCollectPayment);
    }*/
  }
}

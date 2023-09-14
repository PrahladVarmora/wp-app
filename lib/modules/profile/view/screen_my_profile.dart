import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/masters/model/model_sources.dart';
import 'package:we_pro/modules/profile/bloc/get_profile/get_profile_bloc.dart';
import 'package:we_pro/modules/profile/bloc/update_profile/update_profile_bloc.dart';
import 'package:we_pro/modules/profile/model/model_get_profile.dart';

import '../../masters/sources/bloc/assigned_sources_providers/sources_bloc.dart';

class ScreenMyProfile extends StatefulWidget {
  const ScreenMyProfile({Key? key}) : super(key: key);

  @override
  State<ScreenMyProfile> createState() => _ScreenMyProfileState();
}

class _ScreenMyProfileState extends State<ScreenMyProfile> {
  ValueNotifier<bool> mLoading = ValueNotifier(false);
  List<String> mDays = [
    APPStrings.textMonday,
    APPStrings.textTuesday,
    APPStrings.textWednesday,
    APPStrings.textThursday,
    APPStrings.textFriday,
    APPStrings.textSaturday,
    APPStrings.textSunday,
  ];
  ValueNotifier<List<AvailabilityHours>> mModelBusinessHours =
      ValueNotifier([]);

  File? selectedProfilePic;

  List<String> mSkillsList = [
    'Self-Discipline',
    'Good Communicator',
    'Problem-Solver',
    'Attention to Detail'
  ];

  /// get profile data
  ModelGetProfile? modelGetProfile;

  @override
  void initState() {
    modelGetProfile = getProfileData();
    List<AvailabilityHours> mList = [];
    mList.addAll(modelGetProfile?.profile?.availabilityHours ?? []);
    for (int i = 0; i < mList.length; i++) {
      mList[i].dayName = mDays[i].translate();
    }

    mModelBusinessHours.value =
        mList.where((element) => element.isOff == false).toList();
    super.initState();
  }

  ///[profilePictureUpdateEvent] this method is used to connect to profile picture update
  void profilePictureUpdateEvent() async {
    BlocProvider.of<UpdateProfileBloc>(context).add(PictureUpdateProfile(
        url: AppUrls.apiPictureUpdateProfile, imageFile: selectedProfilePic));
  }

  ///[getProfileEvent] this method is used to connect to get profile api
  getProfileEvent() async {
    BlocProvider.of<GetProfileBloc>(context)
        .add(GetProfileUser(url: AppUrls.apiGetProfileApi));
  }

  @override
  Widget build(BuildContext context) {
    // addingMobileUiStyles(context);

    ///[getMyProfileAppbar] is used to get Appbar for different views i.e. Mobile and Web
    BaseAppBar getMyProfileAppbar() {
      return BaseAppBar(
        appBar: AppBar(),
        title: APPStrings.textMyProfile.translate(),
        mLeftImage: APPImages.icBlackArrow,
        backButtonColor: AppColors.colorBlack,
        textStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.labelSmall!,
            Dimens.textSize15,
            FontWeight.w500),
        backgroundColor: Theme.of(context).colorScheme.background,
        mLeftAction: () {
          NavigatorKey.navigatorKey.currentState!.pop();
        },
      );
    }

    /// [addProfilePicture()]  is used to display add profile picture text and select image button
    Widget addProfilePicture() {
      return InkWell(
        onTap: () {
          selectPicture(context);
        },
        child: Stack(
          children: [
            Container(
              height: Dimens.margin80,
              width: Dimens.margin80,
              padding: selectedProfilePic == null
                  ? const EdgeInsets.symmetric(
                      horizontal: Dimens.margin0,
                      vertical: Dimens.margin0,
                    )
                  : EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(
                  Dimens.margin100,
                ),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: selectedProfilePic == null
                  ? CircleImageViewerNetwork(
                      url: modelGetProfile!.profile!.picture,
                      mHeight: Dimens.margin80,
                    )
                  : Image.file(
                      selectedProfilePic!,
                      fit: BoxFit.fill,
                    ),
            ),
            Positioned(
              bottom: Dimens.margin0,
              right: Dimens.margin0,
              child: Container(
                height: Dimens.margin35,
                width: Dimens.margin35,
                padding: const EdgeInsets.all(Dimens.margin5),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.background),
                    borderRadius: BorderRadius.circular(Dimens.margin100)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: SvgPicture.asset(
                  APPImages.icCamera,
                  width: Dimens.margin18,
                  height: Dimens.margin15,
                ),
              ),
            ),
          ],
        ),
      );
    }

    ///[editImage] this widget use for edit image
    Widget editImage() {
      return InkWell(
        onTap: () {
          NavigatorKey.navigatorKey.currentState!
              .pushNamed(AppRoutes.routesEditProfile);
        },
        child: SvgPicture.asset(
          APPImages.icEdit,
          height: Dimens.margin20,
          width: Dimens.margin20,
        ),
      );
    }

    ///[personalDetail] this widget use for personal detail for name, email, data of birth etc
    Widget personalDetail() {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(Dimens.margin20),
        decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.all(Radius.circular(Dimens.margin30)),
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: Theme.of(context).colorScheme.surface),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [addProfilePicture(), editImage()],
            ),
            const SizedBox(height: Dimens.margin10),
            Text(
              '${modelGetProfile!.profile!.firstname}'
              '${modelGetProfile!.profile!.lastname}',
              style: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.displayMedium!,
                  Dimens.textSize24,
                  FontWeight.w600),
            ),
            const SizedBox(height: Dimens.margin15),
            Row(
              children: [
                SvgPicture.asset(
                  APPImages.icEmail,
                  height: Dimens.margin20,
                  width: Dimens.margin20,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.background,
                      BlendMode.srcIn),
                ),
                const SizedBox(width: Dimens.margin15),
                Text(
                  modelGetProfile!.profile!.email ?? '',
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.displayMedium!,
                      Dimens.textSize15,
                      FontWeight.w400),
                ),
              ],
            ),
            const SizedBox(height: Dimens.margin23),
            Row(
              children: [
                SvgPicture.asset(
                  APPImages.icTelephone,
                  height: Dimens.margin20,
                  width: Dimens.margin20,
                ),
                const SizedBox(width: Dimens.margin15),
                Text(
                  modelGetProfile!.profile!.phoneNumber ?? '',
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.displayMedium!,
                      Dimens.textSize15,
                      FontWeight.w400),
                ),
              ],
            ),
            const SizedBox(height: Dimens.margin23),
            Row(
              children: [
                SvgPicture.asset(
                  APPImages.icBirthdate,
                  height: Dimens.margin20,
                  width: Dimens.margin20,
                ),
                const SizedBox(width: Dimens.margin15),
                Text(
                  modelGetProfile?.profile?.dob ?? "-",
                  style: getTextStyleFontWeight(
                      Theme.of(context).primaryTextTheme.displayMedium!,
                      Dimens.textSize15,
                      FontWeight.w400),
                ),
              ],
            ),
            const SizedBox(height: Dimens.margin23),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  APPImages.icLocationPin,
                  height: Dimens.margin20,
                  width: Dimens.margin20,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.background,
                      BlendMode.srcIn),
                ),
                const SizedBox(width: Dimens.margin15),
                Expanded(
                  child: Text(
                    modelGetProfile?.profile?.address ?? "-",
                    style: getTextStyleFontWeight(
                        Theme.of(context).primaryTextTheme.displayMedium!,
                        Dimens.textSize15,
                        FontWeight.w400),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    /* ///[bankDetail] this widget use for bank Detail for name,bank name, account number,address etc
    Widget bankDetail() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            APPStrings.textBankDetails.translate(),
            style: getTextStyleFontWeight(
                Theme.of(context).primaryTextTheme.labelSmall!,
                Dimens.textSize15,
                FontWeight.w600),
          ),
          const SizedBox(height: Dimens.margin10),
          Text(
            'John Doe',
            style: getTextStyleFontWeight(
                Theme.of(context).primaryTextTheme.labelSmall!,
                Dimens.textSize15,
                FontWeight.w400),
          ),
          const SizedBox(height: Dimens.margin10),
          Text(
            'Bank of America',
            style: getTextStyleFontWeight(
                Theme.of(context).primaryTextTheme.labelSmall!,
                Dimens.textSize15,
                FontWeight.w400),
          ),
          const SizedBox(height: Dimens.margin10),
          Text(
            '00000123456789',
            style: getTextStyleFontWeight(
                Theme.of(context).primaryTextTheme.labelSmall!,
                Dimens.textSize15,
                FontWeight.w400),
          ),
          const SizedBox(height: Dimens.margin10),
          Text(
            '44653 Felicity Viaduct, Apt. 587, 70311, Gleichnershire,Colorado, United States',
            style: getTextStyleFontWeight(
                Theme.of(context).primaryTextTheme.labelSmall!,
                Dimens.textSize15,
                FontWeight.w400),
          ),
        ],
      );
    }*/

    ///[drivingLicence] this widget use for driving Licence for front image and back image for licence
    Widget drivingLicence() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            APPStrings.textDrivingLicense.translate(),
            style: getTextStyleFontWeight(
                Theme.of(context).primaryTextTheme.labelMedium!,
                Dimens.textSize15,
                FontWeight.w600),
          ),
          const SizedBox(height: Dimens.margin10),
          Row(
            children: [
              (modelGetProfile!.profile!.imgDLF ?? '').isNotEmpty
                  ? SizedBox(
                      height: Dimens.margin64,
                      width: Dimens.margin100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimens.margin10),
                        child: ImageViewerNetwork(
                            mFit: BoxFit.fill,
                            url: modelGetProfile!.profile!.imgDLF!.toString()),
                      ))
                  : const SizedBox(),
              const SizedBox(width: Dimens.margin10),
              (modelGetProfile!.profile!.imgDLB ?? '').isNotEmpty
                  ? SizedBox(
                      height: Dimens.margin64,
                      width: Dimens.margin100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimens.margin10),
                        child: ImageViewerNetwork(
                            mFit: BoxFit.fill,
                            url: modelGetProfile!.profile!.imgDLB!.toString()),
                      ))
                  : const SizedBox(),
            ],
          )
        ],
      );
    }

    ///[professionalDetail] this widget use for professional Detail for source provider, Pay Type, Pay Free, availability etc
    Widget professionalDetail() {
      return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(Dimens.margin20),
          decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.all(Radius.circular(Dimens.margin30)),
            color: Theme.of(context).colorScheme.background,
            border: Border.all(
                color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      APPStrings.textProfessionalDetails.translate(),
                      style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.labelMedium!,
                          Dimens.textSize15,
                          FontWeight.w600),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      NavigatorKey.navigatorKey.currentState!
                          .pushNamed(AppRoutes.routesEditProfessionalDetail);
                    },
                    child: SvgPicture.asset(
                      APPImages.icEdit,
                      height: Dimens.margin20,
                      width: Dimens.margin20,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.onInverseSurface,
                          BlendMode.srcIn),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimens.margin20),

              /// Source Provider
              Text(
                APPStrings.textSourceProvider.translate(),
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize12,
                    FontWeight.w400),
              ),

              const SizedBox(height: Dimens.margin6),
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        BlocProvider.of<SourcesProvidersBloc>(context)
                            .sources
                            .toSet()
                            .map((e) => e.title)
                            .toList()
                            .join(', '),
                        style: getTextStyleFontWeight(
                            Theme.of(context).primaryTextTheme.labelSmall!,
                            Dimens.textSize15,
                            FontWeight.w400),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        var list =
                            BlocProvider.of<SourcesProvidersBloc>(context)
                                .sources;
                        showListDialog(list);
                      },
                      child: const Text("More",
                          style: TextStyle(color: AppColors.colorBlack)),
                    )
                  ]),
              const SizedBox(height: Dimens.margin20),

              /*  /// Pay Type
              Text(
                APPStrings.textPayType.translate(),
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize12,
                    FontWeight.w400),
              ),
              const SizedBox(height: Dimens.margin6),
              Text(
                'Fixed Fee',
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize15,
                    FontWeight.w400),
              ),
              const SizedBox(height: Dimens.margin20),

              /// Pay Fee
              Text(
                APPStrings.textPayFee.translate(),
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize12,
                    FontWeight.w400),
              ),
              const SizedBox(height: Dimens.margin6),
              Text(
                setCurrency('100'),
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize15,
                    FontWeight.w400),
              ),
              const SizedBox(height: Dimens.margin20),*/

              /// Availability
              Text(
                APPStrings.textAvailability.translate(),
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize12,
                    FontWeight.w400),
              ),
              const SizedBox(height: Dimens.margin6),
              Text(
                '${modelGetProfile!.profile?.userAvail}',
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize15,
                    FontWeight.w400),
              ),
              const SizedBox(height: Dimens.margin6),
              ...List.generate(
                mModelBusinessHours.value.length,
                (index) => Column(
                  children: [
                    Text(
                      '${formatTime12H(convertStringToTimeOfDay(mModelBusinessHours.value[index].open ?? ''))} - ${formatTime12H(convertStringToTimeOfDay(mModelBusinessHours.value[index].close ?? ''))} | ${mModelBusinessHours.value[index].dayName}',
                      style: getTextStyleFontWeight(
                          Theme.of(context).primaryTextTheme.labelSmall!,
                          Dimens.textSize15,
                          FontWeight.w400),
                    ),
                    const SizedBox(height: Dimens.margin6)
                  ],
                ),
              ),
              /*Text(
                '9:00 AM - 5:00 PM | Monday',
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize15,
                    FontWeight.w400),
              ),
              const SizedBox(height: Dimens.margin6),
              Text(
                '9:00 AM - 5:00 PM | Tuesday',
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize15,
                    FontWeight.w400),
              ),
              const SizedBox(height: Dimens.margin6),
              Text(
                '9:00 AM - 5:00 PM | Saturday',
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize15,
                    FontWeight.w400),
              ),*/
              const SizedBox(height: Dimens.margin20),

              /// Skills
              /*    Text(
                APPStrings.textSkills.translate(),
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize12,
                    FontWeight.w400),
              ),
              const SizedBox(height: Dimens.margin6),
              Wrap(
                spacing: Dimens.margin10,
                runSpacing: Dimens.margin10,

                ///   direction: Axis.horizontal,
                children: mSkillsList
                    .map((data) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                padding: const EdgeInsets.all(Dimens.margin3),

                                ///alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceVariant,
                                  border: Border.all(
                                      width: Dimens.margin05,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceVariant),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(Dimens.margin25)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: Dimens.margin15),
                                      child: Text(data,
                                          style: getTextStyleFontWeight(
                                              Theme.of(context)
                                                  .primaryTextTheme
                                                  .labelSmall!,
                                              Dimens.margin12,
                                              FontWeight.w400)),
                                    ),
                                    */
              /*const SizedBox(width: Dimens.margin8),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          right: Dimens.margin10),
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {});
                                          },
                                          child: const Icon(Icons.close,
                                              color: AppColors.color707070,
                                              size: Dimens.margin18)),
                                    ),*/ /*
                                    // const SizedBox(width: Dimens.margin3),
                                  ],
                                )),
                          ],
                        ))
                    .toList(),
              ),
              const SizedBox(height: Dimens.margin30),
              bankDetail(),
              const SizedBox(height: Dimens.margin30),*/
              if ((modelGetProfile!.profile!.imgDLB ?? '').isNotEmpty &&
                  (modelGetProfile!.profile!.imgDLF ?? '').isNotEmpty)
                drivingLicence(),
            ],
          ));
    }

    ///[mobileSignUpForm] this method is used for mobile signUpn screen
    Widget mobileSignUpForm() {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: Dimens.margin30,
                  ),
                  personalDetail(),
                  const SizedBox(
                    height: Dimens.margin20,
                  ),
                  professionalDetail(),
                  const SizedBox(height: Dimens.margin30),
                ],
              ),
            ),
          ),
        ],
      );
    }

    ///[mBody] is used to get Mobile view body
    Widget mBody() {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: Dimens.margin16),
        color: Theme.of(context).colorScheme.background,
        child: mobileSignUpForm(),
      );
    }

    return MultiValueListenableBuilder(
      valueListenables: [
        mLoading,
        mModelBusinessHours,
      ],
      builder: (BuildContext context, List<dynamic> values, Widget? child) {
        return BlocListener<UpdateProfileBloc, UpdateProfileState>(
          listener: (context, state) {
            mLoading.value = state is UpdateProfileLoading;
            if (state is UpdateProfilePictureResponse) {
              getProfileEvent();
            }
            if (state is UpdateProfileFailure) {
              ToastController.showToast(state.mError, context, false);
            }
          },
          child: BlocListener<GetProfileBloc, GetProfileState>(
            listener: (context, state) {
              mLoading.value = state is GetProfileLoading;
              if (state is GetProfileResponse) {
                modelGetProfile = getProfileData();
              }
            },
            child: ModalProgressHUD(
              inAsyncCall: mLoading.value,
              progressIndicator: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
              child: Scaffold(
                appBar: getMyProfileAppbar(),
                backgroundColor: Theme.of(context).primaryColor,
                body: mBody(),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> selectPicture(BuildContext context) async {
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
        await ImagePicker().pickImage(source: source).then((pickedFile) {
          if (pickedFile != null) {
            ImageCropper.platform.cropImage(
              sourcePath: pickedFile.path,
              compressQuality: 50,
              aspectRatioPresets: [CropAspectRatioPreset.square],
            ).then((croppedImage) {
              if (croppedImage != null) {
                selectedProfilePic = File(croppedImage.path);

                if (selectedProfilePic != null) {
                  profilePictureUpdateEvent();
                }
              }
            });
          }
        });
      }
    });
  }

  void showListDialog(List<ModelSources> list) {
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.background,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: double.maxFinite,
              child: Container(
                // width:  MediaQuery.of(context).size.width,
                // height: Dimens.margin190,
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.margin20, vertical: Dimens.margin20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(Dimens.margin10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                      child: Text(
                        APPStrings.textSourceProvider.translate(),
                        style: getTextStyleFontWeight(AppFont.regularColorBlack,
                            Dimens.margin20, FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.margin15,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: Scrollbar(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: list.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text("- ${list[index].title!}",
                                  style: getTextStyleFontWeight(
                                      AppFont.regularColorBlack,
                                      Dimens.margin15,
                                      FontWeight.w400));
                            }),
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.margin15,
                    ),
                    CustomButton(
                        onPress: () {
                          Navigator.pop(context);
                        },
                        backgroundColor: Theme.of(context).primaryColor,
                        buttonText: APPStrings.textClose.translate(),
                        style: getTextStyleFontWeight(
                            Theme.of(context).primaryTextTheme.displayMedium!,
                            Dimens.textSize15,
                            FontWeight.w500),
                        borderRadius: Dimens.margin15),
                  ],
                ),
              ),
            ),
          );
        });
  }

  /// A method that is used to set the status bar color and icon brightness.
/* void addingMobileUiStyles(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: (Theme.of(context).brightness == Brightness.dark)
            ? Colors.transparent
            : Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));
  }*/
}

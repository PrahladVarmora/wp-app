// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:http/http.dart' as http;
import 'package:readmore/readmore.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/bloc/job_detail_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/update_job_bloc.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';

import '../../dashboard/model/model_geo_data.dart';

/// This class is a stateful widget that job detail a screen
class ScreenJobHistoryDetail extends StatefulWidget {
  final int status;
  final String jobId;

  const ScreenJobHistoryDetail(
      {Key? key, required this.status, required this.jobId})
      : super(key: key);

  @override
  State<ScreenJobHistoryDetail> createState() => _ScreenJobHistoryDetailState();
}

class _ScreenJobHistoryDetailState extends State<ScreenJobHistoryDetail> {
  ValueNotifier<bool> mLoading = ValueNotifier(false);

  ///[mStatus] 1 = before accept, 2 = Accepted(In Progress), 3 = completed
  ValueNotifier<int> mStatus = ValueNotifier(0);
  ValueNotifier<JobData> mJobData = ValueNotifier(JobData());
  ValueNotifier<String> mAddress = ValueNotifier('');
  ValueNotifier<String> mJobType = ValueNotifier('');

  /// map controller
  Completer<GoogleMapController> googleMapController = Completer();

  CameraPosition kGooglePlex = CameraPosition(
    target: MyAppState.mCurrentPosition.value,
    zoom: 12,
  );

  /// init state is starting point
  @override
  void initState() {
    ///mStatus.value = widget.status;
    /// job detail event called
    jobDetailEvent();
    super.initState();
  }

  List<Marker> markers = <Marker>[];
  BitmapDescriptor onlyPin = BitmapDescriptor.defaultMarker;

  /// It sets the markers on the map.
  Future<void> setMarkersOnMap(JobData item) async {
    try {
      var marker = const Marker(markerId: MarkerId(''));
      await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(
          size: Size(40, 50),
        ),
        Platform.isIOS
            ? APPImages.icMapMarkerOnlyIOS
            : APPImages.icMapMarkerOnlyAndroid,
      ).then((d) {
        setState(() {
          onlyPin = d;
        });
      });
      if ((item.latitude ?? '').replaceAll('-', '').trim().isNotEmpty &&
          (item.longitude ?? '').replaceAll('-', '').trim().isNotEmpty) {
        marker = Marker(
          icon: onlyPin,
          markerId: MarkerId(item.placeId.toString()),
          position: LatLng(
              double.parse(item.latitude!), double.parse(item.longitude!)),
        );
        kGooglePlex = CameraPosition(
          target: LatLng(
              double.parse(item.latitude!), double.parse(item.longitude!)),
          zoom: 12,
        );

        markers.add(marker);
        setState(() {});
      } else {
        var response = await http.get(Uri.parse(
            'https://maps.googleapis.com/maps/api/geocode/json?place_id=${item.placeId}&key=${AppConfig.googleMapKey}'));
        printWrapped('response--googleapis---$response');
        if (response.statusCode == 200) {
          GeoDataModel mGeoDataModel =
              GeoDataModel.fromJson(jsonDecode(response.body));
          if (mGeoDataModel.results != null &&
              mGeoDataModel.results!.isNotEmpty) {
            LocationData mLocationData =
                mGeoDataModel.results![0].geometry!.location!;
            item.latitude = mLocationData.lat.toString();
            item.longitude = mLocationData.lng.toString();
            marker = Marker(
              icon: onlyPin,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.routesJobDetail,
                    arguments: {
                      AppConfig.jobStatus: statusJobCollectPaymentSendInvoice,
                      AppConfig.jobId: item.jobId.toString()
                    });
              },
              markerId: MarkerId(item.jobId.toString()),
              position: LatLng(mLocationData.lat!, mLocationData.lng!),
            );
            setState(() {
              markers.add(marker);
            });
          }
        }
      }

      if (markers.isNotEmpty) {
        _moveTo(
            markers.first.position.latitude, markers.first.position.longitude);
      }
    } catch (e) {
      printWrapped('error---$e');

      ///Todo Error Manage
    }
  }

  ///[_moveTo] this method use to _move To
  _moveTo(double latitude, double longitude) async {
    final GoogleMapController controller = await googleMapController.future;
    if (Platform.isAndroid) {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 16,
          ),
        ),
      );
    } else {
      await controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 16,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ///[moreButton] is widget is use popup menu
    /*Widget moreButton() {
      return PopupMenuButton(
        elevation: 2,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.margin10),
        ),
        position: PopupMenuPosition.under,
        color: Theme.of(context).colorScheme.background,
        iconSize: 0,
        tooltip: '',
        child: Container(
          alignment: Alignment.topRight,
          decoration: BoxDecoration(
            color: AppColors.colorPrimary,
            borderRadius: BorderRadius.circular(Dimens.margin10),
          ),
          child: Container(
              margin: const EdgeInsets.only(
                  right: Dimens.margin15, top: Dimens.margin10),
              child: SvgPicture.asset(APPImages.icVerticalMenu)),
        ),
        onSelected: (mSelect) {
          switch (mSelect) {
            case 1:
              Navigator.pushNamed(context, AppRoutes.routesSendJobUpdates);
              break;
            case 2:
              break;

            default:
              Navigator.pop(context);
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            padding: const EdgeInsets.only(
                left: Dimens.margin20,
                top: Dimens.margin10,
                bottom: Dimens.margin10),
            height: Dimens.margin30,
            value: 1,
            child: Text(
              APPStrings.textSendJobUpdates.translate(),
              style: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.labelSmall!,
                  Dimens.textSize15,
                  FontWeight.w400),
            ),
          ),
          PopupMenuItem(
            padding: const EdgeInsets.only(
                left: Dimens.margin20,
                top: Dimens.margin10,
                bottom: Dimens.margin10),
            height: Dimens.margin30,
            value: 2,
            child: Text(
              APPStrings.textChatWithAdmin.translate(),
              style: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.labelSmall!,
                  Dimens.textSize15,
                  FontWeight.w400),
            ),
          )
        ],
      );
    }*/

    ///[getJobDetailAppbar] is used to get Appbar for different views i.e. Mobile and Web
    BaseAppBar getJobDetailAppbar() {
      return BaseAppBar(
        appBar: AppBar(
          toolbarHeight: Dimens.margin70,
          elevation: Dimens.margin0,
        ),
        title: APPStrings.textJobDetails.translate(),
        mLeftImage: APPImages.icArrowBack,
        textStyle: getTextStyleFontWeight(
            Theme.of(context).primaryTextTheme.titleLarge!,
            Dimens.textSize18,
            FontWeight.w600),
        mLeftAction: () {
          // if (mStatus.value == statusJobMarkAsDone) {
          //   Navigator.pushNamedAndRemoveUntil(
          //       context, AppRoutes.routesDashboard, (route) => false);
          // } else {
          Navigator.pop(context);
          // }
        },
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.routesMessageDetails,
                  arguments: {
                    'jobId': mJobData.value.jobId,
                    'clientName': mJobData.value.company,
                    'company': mJobData.value.company,
                    'chat_type': 'Company',
                    'compId': mJobData.value.compId,
                    'company': mJobData.value.company,
                    'copyData': getCopyData(),
                  }).then((value) {
                jobDetailEvent();
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
                Navigator.pushNamed(context, AppRoutes.routesMessageDetails,
                    arguments: {
                      'jobId': mJobData.value.jobId,
                      'clientName': mJobData.value.clientName,
                      'company': mJobData.value.company,
                      'chat_type': 'Client',
                      'compId': mJobData.value.compId,
                      'company': mJobData.value.company,
                      'copyData': "",
                    });
              },
              padding: const EdgeInsets.only(right: Dimens.margin15),
              icon: SvgPicture.asset(APPImages.icUserMessages,
                  colorFilter: const ColorFilter.mode(
                      AppColors.colorF0A04B, BlendMode.srcIn)))
        ],
      );
    }

    Widget jobAmount() {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Amount: ',
              style: getTextStyleFontWeight(
                  Theme.of(context).textTheme.displaySmall!,
                  Dimens.textSize15,
                  FontWeight.w600),
            ),
            TextSpan(
                text: mJobData.value.invoice?.first.totalAmount ?? '',
                style: getTextStyleFontWeight(
                    Theme.of(context).textTheme.displaySmall!,
                    Dimens.textSize15,
                    FontWeight.w400))
          ],
        ),
      );
    }

    ///[rowStatusArea] is used to get row status area
    Widget rowStatusArea(JobData jobData) {
      String? text = "";
      if ((jobData.jobSubTypesData ?? []).isNotEmpty) {
        jobData.jobSubTypesData?.forEach((element) {
          if (text!.isEmpty) {
            text = " - ${element.typeName!}";
          } else {
            text = "${text!} - ${element.typeName!}";
          }
        });
      }
      return Container(
        padding: const EdgeInsets.only(
            left: Dimens.margin15,
            right: Dimens.margin15,
            bottom: Dimens.margin15),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            border: Border.all(color: Theme.of(context).primaryColor)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'Job ${jobData.jobId.toString()}',
                        style: getTextStyleFontWeight(
                            Theme.of(context).textTheme.displaySmall!,
                            Dimens.textSize15,
                            FontWeight.w400),
                      ),
                      const SizedBox(width: Dimens.margin10),
                      Container(
                        width: Dimens.margin5,
                        height: Dimens.margin5,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(Dimens.margin25),
                          border: Border.all(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant),
                        ),
                      ),
                      const SizedBox(width: Dimens.margin10),
                      Expanded(
                        child: Text(
                          jobData.sourceTitle.toString(),
                          style: getTextStyleFontWeight(
                              Theme.of(context).textTheme.displaySmall!,
                              Dimens.textSize15,
                              FontWeight.w400),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomButton(
                  buttonText: mJobData.value.status.toString(),
                  style: getTextStyleFontWeight(
                          Theme.of(context).textTheme.bodyMedium!,
                          Dimens.textSize12,
                          FontWeight.w600)
                      .copyWith(
                          color: getColorStatusJobType(
                              mJobData.value.status ?? '')),
                  backgroundColor: getBackgroundColorStatusJobType(
                      mJobData.value.status ?? ''),
                  borderColor: getBackgroundColorStatusJobType(
                      mJobData.value.status ?? ''),
                  borderRadius: Dimens.margin13,
                  height: Dimens.margin26,
                ),
              ],
            ),
            const SizedBox(
              height: Dimens.margin10,
            ),
            const SizedBox(
              height: Dimens.margin10,
            ),
            Text(
              jobData.jobCategory.toString(),
              style: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.titleLarge!,
                  Dimens.textSize24,
                  FontWeight.w600),
            ),
            const SizedBox(
              height: Dimens.margin10,
            ),
            if ((mJobData.value.invoice ?? []).isNotEmpty) ...[
              jobAmount(),
              const SizedBox(height: Dimens.margin8),
            ],
            Row(
              children: [
                Text(
                  jobData.jobType.toString(),
                  style: getTextStyleFontWeight(
                      Theme.of(context).textTheme.displaySmall!,
                      Dimens.textSize15,
                      FontWeight.w400),
                ),
                if ((jobData.jobSubTypesData ?? []).isNotEmpty)
                  ...List.generate(
                    jobData.jobSubTypesData!.length,
                    (index) => Text(
                      ' - ${jobData.jobSubTypesData?[index].typeName}',
                      style: getTextStyleFontWeight(
                          Theme.of(context).textTheme.displaySmall!,
                          Dimens.textSize15,
                          FontWeight.w400),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      //   ),
                      // ),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: Dimens.margin10,
            ),
            Text(
              jobData.dated.toString(),
              style: getTextStyleFontWeight(
                  Theme.of(context).primaryTextTheme.displayMedium!,
                  Dimens.textSize15,
                  FontWeight.w400),
            )
          ],
        ),
      );
    }

    /// This widget used to show Map with Origin and Destination mark
    Widget mapView() {
      CameraPosition kGooglePlex = CameraPosition(
        target: markers.isNotEmpty
            ? markers.first.position
            : MyAppState.mCurrentPosition.value,
        zoom: 12,
      );
      Set<Circle> circles = {
        Circle(
          circleId: const CircleId("1"),
          center:
              LatLng(kGooglePlex.target.latitude, kGooglePlex.target.longitude),
          radius: 1500,
          fillColor: Colors.blue.shade100.withOpacity(0.5),
          strokeColor: Colors.blue.shade100.withOpacity(0.1),
        )
      };

      return GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: kGooglePlex,
        myLocationEnabled: true,
        compassEnabled: true,
        circles: circles,
        onMapCreated: (GoogleMapController controller) async {
          if (!googleMapController.isCompleted) {
            googleMapController.complete(controller);
          }
        },
        markers: Set<Marker>.of(markers),
      );
    }

    ///[rowLocationDetail] is used to get row location direction and mapview
    Widget rowLocationDetail(JobData jobData) {
      return Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(Dimens.margin15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SvgPicture.asset(
                                height: Dimens.margin20,
                                width: Dimens.margin17,
                                APPImages.icLocationPin),
                            const SizedBox(
                              width: Dimens.margin10,
                            ),
                            Text(
                              APPStrings.textLocationDetails.translate(),
                              style: getTextStyleFontWeight(
                                  Theme.of(context)
                                      .primaryTextTheme
                                      .labelMedium!,
                                  Dimens.textSize15,
                                  FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: Dimens.margin20,
                      ),
                      // CustomChildButton(
                      //   height: Dimens.margin40,
                      //   width: 170,
                      //   backgroundColor: Theme.of(context).primaryColor,
                      //   borderColor: Theme.of(context).primaryColor,
                      //   borderRadius: Dimens.margin30,
                      //   onPress: () {
                      //     clickMap(kGooglePlex.target);
                      //   },
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       SvgPicture.asset(
                      //           height: Dimens.margin20,
                      //           width: Dimens.margin20,
                      //           APPImages.icDirection),
                      //       const SizedBox(
                      //         width: Dimens.margin10,
                      //       ),
                      //       Text(
                      //         APPStrings.textGetDirections.translate(),
                      //         style: getTextStyleFontWeight(
                      //             Theme.of(context)
                      //                 .primaryTextTheme
                      //                 .displayLarge!,
                      //             Dimens.textSize15,
                      //             FontWeight.w500),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      /* InkWell(
                        onTap: () {
                          clickMap(const LatLng(
                              39.774632744213704, -101.8047208106536));
                        },
                        child: Container(
                            height: Dimens.margin40,
                            width: Dimens.margin170,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius:
                                  BorderRadius.circular(Dimens.margin25),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                      height: Dimens.margin20,
                                      width: Dimens.margin20,
                                      APPImages.icDirection),
                                  const SizedBox(
                                    width: Dimens.margin10,
                                  ),
                                  Text(
                                    APPStrings.textGetDirections.translate(),
                                    style: getTextStyleFontWeight(
                                        Theme.of(context)
                                            .primaryTextTheme
                                            .displayLarge!,
                                        Dimens.textSize15,
                                        FontWeight.w500),
                                  ),
                                ],
                              ),
                            )),
                      ),*/
                    ],
                  ),
                  const SizedBox(height: Dimens.margin10),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (mStatus.value ==
                                statusJobCollectPaymentSendInvoice ||
                            mStatus.value == statusJobMarkAsDone)
                          Expanded(
                            child: Text(
                              '${jobData.location.toString()}, \n${jobData.city.toString()},${jobData.zip.toString()}, \n${jobData.country.toString()}',
                              style: getTextStyleFontWeight(
                                  Theme.of(context)
                                      .primaryTextTheme
                                      .labelSmall!,
                                  Dimens.textSize12,
                                  FontWeight.w400),
                            ),
                          ),
                        const SizedBox(width: Dimens.margin10),
                        // Container(
                        //   margin: const EdgeInsets.only(right: Dimens.margin30),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: [
                        //       SvgPicture.asset(
                        //           height: Dimens.margin24,
                        //           width: Dimens.margin21,
                        //           APPImages.icEta),
                        //       const SizedBox(
                        //         width: Dimens.margin10,
                        //       ),
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Text(
                        //             APPStrings.textEtaWithColon.translate(),
                        //             style: getTextStyleFontWeight(
                        //                 Theme.of(context)
                        //                     .primaryTextTheme
                        //                     .labelSmall!,
                        //                 Dimens.textSize12,
                        //                 FontWeight.w400),
                        //           ),
                        //           Text(
                        //             '${jobData.duration ?? 'NA'} | ${jobData.distance ?? 'NA'} ',
                        //             style: getTextStyleFontWeight(
                        //                 Theme.of(context)
                        //                     .primaryTextTheme
                        //                     .labelMedium!,
                        //                 Dimens.textSize12,
                        //                 FontWeight.w600),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimens.margin20),
            if (mJobData.value.status == statusDone)
              SizedBox(height: Dimens.margin352, child: mapView())
            else
              Expanded(child: mapView())
          ],
        ),
      );
    }

    ///[btnSendInvoice] is used for send invoice for job on this screen
    Widget btnSendInvoice() {
      return Expanded(
        child: CustomButton(
          height: Dimens.margin50,
          backgroundColor: Theme.of(context).primaryColor,
          borderColor: Theme.of(context).primaryColor,
          borderRadius: Dimens.margin25,
          onPress: () {
            if ((mJobData.value.invoice ?? []).isEmpty) {
              Navigator.pushNamed(context, AppRoutes.routesAddInvoice,
                      arguments: widget.jobId)
                  .then((value) {
                jobDetailEvent();
              });
            } else {
              Navigator.pushNamed(context, AppRoutes.routesInvoiceList,
                      arguments: mJobData.value)
                  .then((value) {
                jobDetailEvent();
              });
            }
          },
          style: getTextStyleFontWeight(
              Theme.of(context).primaryTextTheme.displayMedium!,
              Dimens.textSize15,
              FontWeight.w500),
          buttonText: (mJobData.value.invoice ?? []).isNotEmpty
              ? APPStrings.textViewInvoice.translate()
              : APPStrings.textAddInvoice.translate(),
        ),
      );
    }

    ///[jobDescription] is used for job description part
    Widget jobDescription(JobData jobData) {
      return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(Dimens.margin15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Dimens.margin15),
            if (jobData.clientName != null)
              Text(
                jobData.clientName.toString(),
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelMedium!,
                    Dimens.textSize18,
                    FontWeight.w600),
              ),
            const SizedBox(height: Dimens.margin10),
            if (jobData.companyName != null)
              Text(
                jobData.companyName.toString(),
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize15,
                    FontWeight.w400),
              ),
            const SizedBox(height: Dimens.margin10),
            if (jobData.email != null)
              Row(
                children: [
                  SvgPicture.asset(
                      height: Dimens.margin20,
                      width: Dimens.margin14,
                      APPImages.icEmail),
                  const SizedBox(
                    width: Dimens.margin10,
                  ),
                  Text(
                    jobData.email.toString(),
                    style: getTextStyleFontWeight(
                        Theme.of(context).primaryTextTheme.labelSmall!,
                        Dimens.textSize15,
                        FontWeight.w400),
                  ),
                ],
              ),
            const SizedBox(height: Dimens.margin20),
            // if (mStatus.value == 1 || mStatus.value == 2)
            //   Row(
            //     children: [
            //       btnCallCustomer(jobData),
            //       const SizedBox(width: Dimens.margin10),
            //       btnMessageCustomer(),
            //     ],
            //   ),
            // const SizedBox(height: Dimens.margin15),
            // if (mStatus.value == 1 || mStatus.value == 2) btnSendDispatcher(),
            if (mStatus.value == 1 || mStatus.value == 2)
              const SizedBox(height: Dimens.margin20),
            if ((jobData.description ?? '').isNotEmpty) ...[
              Text(
                APPStrings.textJobDescription.translate(),
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelMedium!,
                    Dimens.textSize15,
                    FontWeight.w700),
              ),
              const SizedBox(height: Dimens.margin10),
              ReadMoreText(
                jobData.description ?? '',
                trimLines: 4,
                trimMode: TrimMode.Line,
                trimCollapsedText: APPStrings.textReadMore.translate(),
                trimExpandedText: APPStrings.textShowLess.translate(),
                textAlign: TextAlign.start,
                style: getTextStyleFontWeight(
                    Theme.of(context).primaryTextTheme.labelSmall!,
                    Dimens.textSize12,
                    FontWeight.w400),
              ),
            ],
            const SizedBox(height: Dimens.margin20),
            //TODO: Hidden
            Visibility(
              visible: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          InterpolateString.interpolate(
                              APPStrings.textFrom.translate(), [':']),
                          style: getTextStyleFontWeight(
                              Theme.of(context).primaryTextTheme.labelSmall!,
                              Dimens.textSize15,
                              FontWeight.w400),
                        ),
                        Text(
                          jobData.updatedAt.toString(),
                          style: getTextStyleFontWeight(
                              Theme.of(context).primaryTextTheme.labelMedium!,
                              Dimens.textSize15,
                              FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          InterpolateString.interpolate(
                              APPStrings.textTo.translate(), [':']),
                          style: getTextStyleFontWeight(
                              Theme.of(context).primaryTextTheme.labelSmall!,
                              Dimens.textSize15,
                              FontWeight.w400),
                        ),
                        Text(
                          jobData.updatedAt.toString(),
                          style: getTextStyleFontWeight(
                              Theme.of(context).primaryTextTheme.labelMedium!,
                              Dimens.textSize15,
                              FontWeight.w700),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }

    /// [statusWiseButton] this widget use for status wise show in button
    Widget statusWiseButton() {
      return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: Dimens.margin16),
        child: Column(
          children: [
            // if (mStatus.value == 1)
            //   Row(
            //     children: [
            //       btnReject(),
            //       const SizedBox(width: Dimens.margin10),
            //       btnAccept()
            //     ],
            //   ),
            if (mJobData.value.invoice != null &&
                mJobData.value.invoice!.isNotEmpty)
              Row(
                children: [
                  btnSendInvoice(),
                  // if ((mJobData.value.invoice ?? []).isNotEmpty) ...[
                  //   const SizedBox(width: Dimens.margin10),
                  //   btnCollectPayment()
                  // ]
                ],
              ),
            // if (mStatus.value == 3)
            //   Row(
            //     children: [
            //       btnMarkAsDone(),
            //     ],
            //   ),
          ],
        ),
      );
    }

    /// It returns a widget.
    Widget getJobDetail() {
      printWrapped("widget.status -- ${widget.status}");
      if (mJobData.value.status != statusDone) {
        return BlocBuilder<JobDetailBloc, JobDetailState>(
          builder: (context, state) {
            if (state is JobDetailLoading) {
              return Container(
                height: MediaQuery.of(context).size.height / 1.3,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                ),
              );
            }
            if (state is JobDetailResponse) {
              mLoading.value = false;
              return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    rowStatusArea(state.mModelJobDetail.jobData![0]),
                    mStatus.value == statusJobCollectPaymentSendInvoice ||
                            mStatus.value == statusJobMarkAsDone
                        ? jobDescription(state.mModelJobDetail.jobData![0])
                        : const SizedBox(),
                    Expanded(
                        child: rowLocationDetail(
                            state.mModelJobDetail.jobData![0]))
                  ],
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        );
      } else {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: BlocBuilder<JobDetailBloc, JobDetailState>(
            builder: (context, state) {
              if (state is JobDetailLoading) {
                return Container(
                  height: MediaQuery.of(context).size.height / 1.3,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Center(
                    child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor),
                  ),
                );
              }
              if (state is JobDetailResponse) {
                mLoading.value = false;
                return Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      rowStatusArea(state.mModelJobDetail.jobData![0]),
                      mStatus.value == statusJobCollectPaymentSendInvoice ||
                              mStatus.value == statusJobMarkAsDone
                          ? jobDescription(state.mModelJobDetail.jobData![0])
                          : const SizedBox(),
                      rowLocationDetail(state.mModelJobDetail.jobData![0])
                    ],
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        );
      }
    }

    ///[mBody] is used to get Mobile view body
    Widget mBody() {
      return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: Dimens.margin0)),
        child: getJobDetail(),
      );
    }

    return MultiValueListenableBuilder(
      valueListenables: [
        mLoading,
        mStatus,
        mJobData,
      ],
      builder: (BuildContext context, List<dynamic> values, Widget? child) {
        return BlocListener<JobDetailBloc, JobDetailState>(
          listener: (context, state) {
            if (state is JobDetailResponse) {
              if (state.mModelJobDetail.jobData != null) {
                mStatus.value =
                    getJobStatus(state.mModelJobDetail.jobData![0].status!);
                mJobData.value = state.mModelJobDetail.jobData![0];
                mAddress.value = '';
                if (mJobData.value.location != null) {
                  mAddress.value += '${mJobData.value.location},';
                }
                if (mJobData.value.city != null) {
                  mAddress.value += '\n${mJobData.value.city},';
                }
                if (mJobData.value.country != null) {
                  mAddress.value += '\n${mJobData.value.country},';
                }
                if (mJobData.value.zip != null) {
                  mAddress.value += '\n${mJobData.value.zip},';
                }
                mJobType.value = '';
                mJobType.value += mJobData.value.jobType ?? '';
                mJobData.value.jobSubTypesData?.map((e) => mJobType.value +=
                    e.typeName != null ? ' - ${e.typeName}' : '');
                // kGooglePlex = CameraPosition(
                //   target: LatLng(double.parse(mJobData.value.latitude ?? '0'),
                //       double.parse(mJobData.value.longitude ?? '0')),
                //   zoom: 12,
                // );
                setMarkersOnMap(mJobData.value);
              }
            }
          },
          child: BlocListener<UpdateJobBloc, UpdateJobState>(
            listener: (context, state) {
              mLoading.value = state is UpdateJobLoading;
              if (state is UpdateJobAcceptResponse) {
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.routesAcceptJobSuccessfully,
                    (route) => route.settings.name == AppRoutes.routesDashboard,
                    arguments: widget.jobId);
              }
            },
            child: ModalProgressHUD(
              inAsyncCall: mLoading.value,
              progressIndicator: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
              child: Scaffold(
                backgroundColor: Theme.of(context).primaryColor,
                appBar: getJobDetailAppbar(),
                bottomNavigationBar: mLoading.value
                    ? null
                    : mJobData.value.invoice != null &&
                            mJobData.value.invoice!.isNotEmpty
                        ? Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            padding: const EdgeInsets.all(Dimens.margin16),
                            height: Dimens.margin85,
                            child: statusWiseButton(),
                          )
                        : const SizedBox.shrink(),
                body: mBody(),
              ),
            ),
          ),
        );
      },
    );
  }

  ///[updateAcceptJob] this method is used to connect to accept job
  void updateAcceptJob() async {
    Map<String, dynamic> mBody = {
      ApiParams.paramJobId: widget.jobId,
      ApiParams.paramJobUpdateStatus: AppConfig.jobStatusConfirmed
    };
    BlocProvider.of<UpdateJobBloc>(context).add(UpdateJobAccept(
      body: mBody,
      url: AppUrls.apiUpdateJob,
    ));
  }

  ///[jobDetailEvent] this method is used to connect to job detail
  void jobDetailEvent() async {
    Map<String, dynamic> mBody = {
      ApiParams.paramJobId: widget.jobId,
      ApiParams.paramLatitude:
          MyAppState.mCurrentPosition.value.latitude.toString(),
      ApiParams.paramLongitude:
          MyAppState.mCurrentPosition.value.longitude.toString()
    };
    BlocProvider.of<JobDetailBloc>(context).add(JobDetail(
      body: mBody,
      url: AppUrls.apiJobs,
    ));
  }

  String getCopyData() {
    String mCopy = '';
    mCopy += 'Job Id: ${mJobData.value.jobId ?? '- -'}';

    mCopy += 'Job Type: ${mJobType.value}';
    mCopy += '\nAddress: ${mAddress.value.replaceAll('\n', ' ')}';
    mCopy += '\nDescription: ${mJobData.value.description ?? '- -'}';
    mCopy += '\nPhone Number: ${mJobData.value.phoneNumber ?? '- -'}';
    mCopy += '\nSource: ${mJobData.value.sourceTitle ?? '- -'}';
    mCopy += '\nName: ${mJobData.value.clientName ?? '- -'}';
    return mCopy;
  }
}

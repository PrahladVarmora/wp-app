// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:math';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/model/model_geo_data.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';
import 'package:we_pro/modules/optimize_route/bloc/google_optimize_route/google_optimize_route_bloc.dart';
import 'package:we_pro/modules/optimize_route/bloc/optimize_route/optimize_route_bloc.dart';

import '../../core/utils/api_import.dart';

/// This class is a stateful widget that displays a map of the jobs in the database
class ScreenPreviewMap extends StatefulWidget {
  final List<JobData> mJobData;

  const ScreenPreviewMap({Key? key, required this.mJobData}) : super(key: key);

  @override
  State<ScreenPreviewMap> createState() => _ScreenPreviewMapState();
}

class _ScreenPreviewMapState extends State<ScreenPreviewMap>
    with SingleTickerProviderStateMixin {
  ValueNotifier<bool> mLoading = ValueNotifier(false);
  ValueNotifier<List<JobData>> mJobData = ValueNotifier([]);
  ValueNotifier<List<JobData>> mFinalJobData = ValueNotifier([]);
  ValueNotifier<List<JobData>> mJobDataByDirection = ValueNotifier([]);
  ValueNotifier<List<JobData>> mTempJobData = ValueNotifier([]);
  ValueNotifier<int> tabPosition = ValueNotifier(0);
  late TabController _tabController;
  List<JobData> tmpList = [];
  Completer<GoogleMapController> googleMapController = Completer();
  List<Marker> markers = <Marker>[];
  final Set<Polyline> _polyline = {};
  BitmapDescriptor onlyPin = BitmapDescriptor.defaultMarker;
  List<BitmapDescriptor> customIcon = [];
  int idMarkerSelected = -1;

  ///static const LatLng center = LatLng(-33.86711, 151.1947171);

  @override
  void initState() {
    for (JobData job in widget.mJobData) {
      job.isRemove = false;
      mFinalJobData.value.add(job);
      mJobData.value.add(job);
      mTempJobData.value.add(job);
      printWrapped(job.schedule!);
    }

    /* if (mJobData.value.isEmpty) {
      var jobList = getMyJobList();
      for (JobData job in jobList) {
        job.isRemove = false;
        mFinalJobData.value.add(job);
        mJobData.value.add(job);
        mTempJobData.value.add(job);
        printWrapped(job.schedule!);
      }
    }*/
    setMarkersOnMap();
    _tabController = TabController(length: 3, vsync: this);

    getDirectionCalculationFilter();

    setState(() {
      if (markers.isNotEmpty) {
        _moveTo(
            markers.first.position.latitude, markers.first.position.longitude);
      }
    });
    super.initState();
  }

  /// It sets the markers on the map.
  Future<void> setMarkersOnMap() async {
    try {
      int count = mJobData.value.length >= 50 ? 50 : mJobData.value.length;
      for (int i = 0; i < count; i++) {
        await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(
            size: Size(40, 50),
          ),
          Platform.isIOS
              ? mJobData.value[i].isRemove == false
                  ? InterpolateString.interpolate(
                      APPImages.icMapMarkerOrangeIos, ['${i + 1}'])
                  : InterpolateString.interpolate(
                      APPImages.icMapMarkerIos, ['${i + 1}'])
              : mJobData.value[i].isRemove == false
                  ? InterpolateString.interpolate(
                      APPImages.icMapMarkerOrangeAndroid, ['${i + 1}'])
                  : InterpolateString.interpolate(
                      APPImages.icMapMarkerAndroid, ['${i + 1}']),
        ).then((d) {
          setState(() {
            customIcon.add(d);
          });
        });
      }
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

      //TODO: Change while API integration
      int iJobData = 0;
      for (JobData item in mJobData.value) {
        String mJobType = '';
        mJobType += item.jobType ?? '';
        item.jobSubTypesData?.map(
            (e) => mJobType += e.typeName != null ? ' - ${e.typeName}' : '');
        // JobData item = mJobData.value[i];
        var marker = const Marker(markerId: MarkerId(''));
        if ((item.latitude ?? '').replaceAll('-', '').trim().isNotEmpty &&
            (item.longitude ?? '').replaceAll('-', '').trim().isNotEmpty) {
          marker = Marker(
            icon: iJobData > 50 ? onlyPin : customIcon[iJobData],
            /*onTap: () {
              Navigator.pushNamed(context, AppRoutes.routesJobDetail,
                  arguments: {
                    AppConfig.jobStatus: statusJobCollectPaymentSendInvoice,
                    AppConfig.jobId: item.jobId.toString()
                  });
            },*/
            onTap: () {
              printWrapped("job Id :- ${item.jobId.toString()}");

              idMarkerSelected = mJobData.value.indexOf(item);
              printWrapped("job Id :- $idMarkerSelected");
              if (mTempJobData.value.contains(item)) {
                mTempJobData.value.remove(item);
                mJobData.value[mJobData.value.indexOf(item)].isRemove = true;
                var last = mJobData.value.removeAt(idMarkerSelected);
                mJobData.value.add(last);
                // var mark = markers.removeAt(mJobData.value.indexOf(item));
                // markers.add(mark);
              } else {
                mTempJobData.value.add(item);

                mJobData.value[mJobData.value.indexOf(item)].isRemove = false;
                var data =
                    mJobData.value.removeAt(mJobData.value.indexOf(item));
                mJobData.value.insert(mTempJobData.value.length - 1, data);
              }
              if (tabPosition.value == 0) {
                getDirectionCalculationFilter();
              } else if (tabPosition.value == 1) {
                shortListFilter();
              } else if (tabPosition.value == 2) {
                mTempJobData.notifyListeners();
                mJobData.notifyListeners();
                setState(() {
                  markers = [];

                  setMarkersOnMap();
                });
              }
            },
            infoWindow: InfoWindow(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.routesJobDetail,
                      arguments: {
                        AppConfig.jobStatus: statusJobCollectPaymentSendInvoice,
                        AppConfig.jobId: item.jobId.toString()
                      });
                },
                title: "${item.jobId}: ${item.jobCategory}",
                snippet: mJobType),
            markerId: MarkerId(item.jobId.toString()),
            position: LatLng(
                double.parse(item.latitude!), double.parse(item.longitude!)),
          );
          setState(() {
            markers.add(marker);
          });
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
                  icon: iJobData > 50 ? onlyPin : customIcon[iJobData],
                  infoWindow: InfoWindow(
                      onTap: () {
                        printWrapped("job Id :- ${item.jobId.toString()}");

                        Navigator.pushNamed(context, AppRoutes.routesJobDetail,
                            arguments: {
                              AppConfig.jobStatus:
                                  statusJobCollectPaymentSendInvoice,
                              AppConfig.jobId: item.jobId.toString()
                            });
                      },
                      title: "${item.jobId}: ${item.jobCategory}",
                      snippet: mJobType),
                  markerId: MarkerId(item.jobId.toString()),
                  position: LatLng(mLocationData.lat!, mLocationData.lng!),
                  onTap: () {
                    printWrapped("job Id :- ${item.jobId.toString()}");
                    idMarkerSelected = mJobData.value.indexOf(item);
                    if (mTempJobData.value.contains(item)) {
                      mTempJobData.value.remove(item);
                      mJobData.value[mJobData.value.indexOf(item)].isRemove =
                          true;
                    } else {
                      mTempJobData.value.add(item);

                      mJobData.value[mJobData.value.indexOf(item)].isRemove =
                          false;
                    }
                    mTempJobData.notifyListeners();
                    mJobData.notifyListeners();
                    setState(() {
                      markers = [];

                      setMarkersOnMap();
                    });
                    // BitmapDescriptor.fromAssetImage(
                    //   const ImageConfiguration(
                    //     size: Size(40, 50),
                    //   ),
                    //   Platform.isIOS
                    //       ? mJobData.value[mJobData.value.indexOf(item)]
                    //                   .isRemove ==
                    //               false
                    //           ? InterpolateString.interpolate(
                    //               APPImages.icMapMarkerOrangeIos,
                    //               ['${mJobData.value.indexOf(item) + 1}'])
                    //           : InterpolateString.interpolate(
                    //               APPImages.icMapMarkerIos,
                    //               ['${mJobData.value.indexOf(item) + 1}'])
                    //       : mJobData.value[mJobData.value.indexOf(item)]
                    //                   .isRemove ==
                    //               false
                    //           ? InterpolateString.interpolate(
                    //               APPImages.icMapMarkerOrangeAndroid,
                    //               ['${mJobData.value.indexOf(item) + 1}'])
                    //           : InterpolateString.interpolate(
                    //               APPImages.icMapMarkerAndroid,
                    //               ['${mJobData.value.indexOf(item) + 1}']),
                    // ).then((d) {
                    //   setState(() {
                    //     markers[mJobData.value.indexOf(item)] =
                    //         markers[mJobData.value.indexOf(item)]
                    //             .copyWith(iconParam: d);
                    //     markers.toSet();
                    //   });
                    // });
                  });
              setState(() {
                markers.add(marker);
              });
            }
          }
        }
        iJobData++;
      }

      setState(() {
        if (markers.isNotEmpty) {
          _moveTo(markers.first.position.latitude,
              markers.first.position.longitude);
        }
      });
    } catch (e) {
      ///Todo Error Manage
    }

    for (var element in mJobData.value) {
      BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(
          size: Size(40, 50),
        ),
        Platform.isIOS
            ? mJobData.value[mJobData.value.indexOf(element)].isRemove == false
                ? InterpolateString.interpolate(APPImages.icMapMarkerOrangeIos,
                    ['${mJobData.value.indexOf(element) + 1}'])
                : InterpolateString.interpolate(APPImages.icMapMarkerIos,
                    ['${mJobData.value.indexOf(element) + 1}'])
            : mJobData.value[mJobData.value.indexOf(element)].isRemove == false
                ? InterpolateString.interpolate(
                    APPImages.icMapMarkerOrangeAndroid,
                    ['${mJobData.value.indexOf(element) + 1}'])
                : InterpolateString.interpolate(APPImages.icMapMarkerAndroid,
                    ['${mJobData.value.indexOf(element) + 1}']),
      ).then((d) {
        setState(() {
          markers[mJobData.value.indexOf(element)] =
              markers[mJobData.value.indexOf(element)].copyWith(iconParam: d);
          markers.toSet();
        });
      });
    }
  }

  void setPolyline(List<PointLatLng> result) {
    _polyline.add(Polyline(
        polylineId: const PolylineId('value'),
        width: 3,
        color: Theme.of(getNavigatorKeyContext()).colorScheme.primary,
        points: result.map((e) => LatLng(e.latitude, e.longitude)).toList()));
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// This widget used to show Map with Origin and Destination mark
    _tabController.addListener(() {
      tabPosition.value = _tabController.index;
    });

    Widget customTabView() {
      return Container(
        margin:
            const EdgeInsets.only(bottom: Dimens.margin10, top: Dimens.margin7),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // give the tab bar a height [can change hheight to preferred height]
            Container(
              height: Dimens.margin50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(
                  Dimens.margin10,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                // give the indicator a decoration (color and border radius)
                indicator: BoxDecoration(
                  borderRadius: tabPosition.value == 0
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(Dimens.margin10),
                          bottomLeft: Radius.circular(Dimens.margin10),
                        )
                      : tabPosition.value == 1
                          ? BorderRadius.circular(
                              0.0,
                            )
                          : const BorderRadius.only(
                              topRight: Radius.circular(Dimens.margin10),
                              bottomRight: Radius.circular(Dimens.margin10),
                            ),
                  color: Colors.black,
                ),
                onTap: (i) {
                  printWrapped("Tab Index: $i");
                  if (i == 1) {
                    shortListFilter();
                  } else if (i == 0) {
                    getDirectionCalculationFilter();
                  }
                },
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelPadding: const EdgeInsets.all(0),
                indicatorPadding: const EdgeInsets.all(0),
                tabs: [
                  // first tab [you can add an icon using the icon property]
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.grey,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    child: const Tab(
                      child: Text("By\nDistance", textAlign: TextAlign.center),
                    ),
                  ),

                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.grey,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    child: const Tab(
                      child: Text("By\nPriority", textAlign: TextAlign.center),
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.all(0),
                    width: double.infinity,
                    child: const Tab(
                      child: Text("By\nSelection", textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            ),
            // tab bar view here
          ],
        ),
      );
    }

    Widget horizontalLocationList() {
      return SizedBox(
        height: Dimens.margin58,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ReorderableListView.builder(
                primary: false,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: mTempJobData.value.length,
                proxyDecorator: (child, index, anim) {
                  return Material(
                    color: Colors.transparent,
                    child: AnimatedContainer(
                      duration: Duration(seconds: anim.value.toInt()),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: Theme.of(context).highlightColor,
                          borderRadius: BorderRadius.circular(Dimens.margin25)),
                      child: Container(
                        margin: EdgeInsets.only(
                            top: Dimens.margin10,
                            bottom: Dimens.margin10,
                            left:
                                index == 0 ? Dimens.margin20 : Dimens.margin10,
                            right: index == mTempJobData.value.length - 1
                                ? Dimens.margin20
                                : Dimens.margin10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimens.margin8),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.colorF0A04B,
                            ),
                            color: AppColors.colorF0A04B,
                            borderRadius: const BorderRadius.all(
                                Radius.circular(Dimens.margin30))),
                        child: InkWell(
                          onTap: () async {
                            final GoogleMapController controller =
                                await googleMapController.future;
                            controller.showMarkerInfoWindow(MarkerId(
                                mTempJobData.value[index].jobId.toString()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(left: Dimens.margin8),
                                // decoration: BoxDecoration(
                                //     border: Border.all(
                                //       color: AppColors.colorBlack,
                                //     ),
                                //     color: AppColors.colorBlack,
                                //     borderRadius: const BorderRadius.only(
                                //         bottomLeft: Radius.circular(Dimens.margin30),
                                //         topLeft: Radius.circular(Dimens.margin30))),
                                padding: const EdgeInsets.all(Dimens.margin8),
                                child: Text(
                                  "${index + 1}.",
                                  style: const TextStyle(
                                    color: AppColors.colorBlack,
                                    fontSize: Dimens.textSize17,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  final GoogleMapController controller =
                                      await googleMapController.future;
                                  controller.showMarkerInfoWindow(MarkerId(
                                      mTempJobData.value[index].jobId
                                          .toString()));
                                },
                                child: Text(
                                  " ${mTempJobData.value[index].jobId!}: ${mTempJobData.value[index].jobType!}",
                                  style: const TextStyle(
                                      color: AppColors.colorWhite),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  mJobData
                                      .value[mJobData.value
                                          .indexOf(mTempJobData.value[index])]
                                      .isRemove = true;

                                  await BitmapDescriptor.fromAssetImage(
                                    const ImageConfiguration(
                                      size: Size(40, 50),
                                    ),
                                    Platform.isIOS
                                        ? mJobData.value[mJobData.value.indexOf(mTempJobData.value[index])].isRemove ==
                                                false
                                            ? InterpolateString.interpolate(
                                                APPImages.icMapMarkerOrangeIos,
                                                [
                                                    '${mJobData.value.indexOf(mTempJobData.value[index]) + 1}'
                                                  ])
                                            : InterpolateString.interpolate(
                                                APPImages.icMapMarkerIos, [
                                                '${mJobData.value.indexOf(mTempJobData.value[index]) + 1}'
                                              ])
                                        : mJobData.value[mJobData.value.indexOf(mTempJobData.value[index])].isRemove ==
                                                false
                                            ? InterpolateString.interpolate(
                                                APPImages
                                                    .icMapMarkerOrangeAndroid,
                                                [
                                                    '${mJobData.value.indexOf(mTempJobData.value[index]) + 1}'
                                                  ])
                                            : InterpolateString.interpolate(
                                                APPImages.icMapMarkerAndroid, [
                                                '${mJobData.value.indexOf(mTempJobData.value[index]) + 1}'
                                              ]),
                                  ).then((d) {
                                    setState(() {
                                      idMarkerSelected = mJobData.value
                                          .indexOf(mTempJobData.value[index]);
                                      //  markers[mJobData.value.indexOf(mTempJobData.value[index])];
                                      printWrapped(
                                          "marker Index -${mJobData.value.indexOf(mTempJobData.value[index])}");
                                      markers[mJobData.value.indexOf(
                                          mTempJobData.value[index])] = markers[
                                              mJobData.value.indexOf(
                                                  mTempJobData.value[index])]
                                          .copyWith(iconParam: d);
                                      markers.toSet();
                                    });
                                  });
                                  mTempJobData.value.removeAt(index);
                                  mTempJobData.notifyListeners();
                                  idMarkerSelected = -1;
                                },
                                child: Container(
                                    // decoration: BoxDecoration(
                                    //     border: Border.all(
                                    //       color: AppColors.colorBlack,
                                    //     ),
                                    //     color: AppColors.colorBlack,
                                    //     borderRadius: const BorderRadius.all(
                                    //         Radius.circular(Dimens.margin30))),
                                    // margin: EdgeInsets.only(
                                    //     top: Dimens.margin10,
                                    //     bottom: Dimens.margin10,
                                    //     left: index == 0
                                    //         ? Dimens.margin20
                                    //         : Dimens.margin10,
                                    //     right:
                                    //         index == mTempJobData.value.length - 1
                                    //             ? Dimens.margin20
                                    //             : Dimens.margin10),
                                    // padding: const EdgeInsets.all(Dimens.margin5),
                                    // child: SvgPicture.asset(
                                    //   APPImages.icClose,
                                    //   colorFilter: const ColorFilter.mode(
                                    //       AppColors.colorWhite, BlendMode.srcIn),
                                    //   width: Dimens.margin10,
                                    // ),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(
                        top: Dimens.margin10,
                        bottom: Dimens.margin10,
                        left: index == 0 ? Dimens.margin20 : Dimens.margin5,
                        right: index == mTempJobData.value.length - 1
                            ? Dimens.margin20
                            : Dimens.margin5),
                    key: ValueKey(mTempJobData.value[index].jobId.toString()),
                    padding: const EdgeInsets.only(right: Dimens.margin8),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.colorF0A04B,
                        ),
                        color: AppColors.colorF0A04B,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(Dimens.margin30))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: Dimens.margin8),
                          // decoration: BoxDecoration(
                          //     border: Border.all(
                          //       color: AppColors.colorBlack,
                          //     ),
                          //     color: AppColors.colorBlack,
                          //     borderRadius: const BorderRadius.only(
                          //         bottomLeft: Radius.circular(Dimens.margin30),
                          //         topLeft: Radius.circular(Dimens.margin30))),
                          padding: const EdgeInsets.all(Dimens.margin8),
                          child: Text(
                            "${index + 1}.",
                            style: const TextStyle(
                              color: AppColors.colorBlack,
                              fontSize: Dimens.textSize17,
                            ),
                          ),
                        ),
                        Text(
                          "${mTempJobData.value[index].jobId!}: ${mTempJobData.value[index].jobType!}",
                          style: const TextStyle(color: AppColors.colorWhite),
                        ),
                        InkWell(
                          onTap: () async {
                            mJobData
                                .value[mJobData.value
                                    .indexOf(mTempJobData.value[index])]
                                .isRemove = true;

                            idMarkerSelected = -1;
                            var first = mJobData.value.removeAt(mJobData.value
                                .indexOf(mTempJobData.value[index]));
                            mJobData.value.add(first);
                            mTempJobData.value.removeAt(index);
                            mTempJobData.notifyListeners();
                            mJobData.notifyListeners();
                            setState(() {
                              markers = [];
                              setMarkersOnMap();
                            });

                            // await BitmapDescriptor.fromAssetImage(
                            //   const ImageConfiguration(
                            //     size: Size(40, 50),
                            //   ),
                            //   Platform.isIOS
                            //       ? mJobData.value[mJobData.value.indexOf(mTempJobData.value[index])].isRemove ==
                            //               false
                            //           ? InterpolateString.interpolate(
                            //               APPImages.icMapMarkerOrangeIos, [
                            //               '${mJobData.value.indexOf(mTempJobData.value[index]) + 1}'
                            //             ])
                            //           : InterpolateString.interpolate(
                            //               APPImages.icMapMarkerIos, [
                            //               '${mJobData.value.indexOf(mTempJobData.value[index]) + 1}'
                            //             ])
                            //       : mJobData
                            //                   .value[mJobData.value.indexOf(
                            //                       mTempJobData.value[index])]
                            //                   .isRemove ==
                            //               false
                            //           ? InterpolateString.interpolate(
                            //               APPImages.icMapMarkerOrangeAndroid, [
                            //               '${mJobData.value.indexOf(mTempJobData.value[index]) + 1}'
                            //             ])
                            //           : InterpolateString.interpolate(
                            //               APPImages.icMapMarkerAndroid, [
                            //               '${mJobData.value.indexOf(mTempJobData.value[index]) + 1}'
                            //             ]),
                            // ).then((d) {
                            //   setState(() {
                            //     idMarkerSelected = mJobData.value
                            //         .indexOf(mTempJobData.value[index]);
                            //     //  markers[mJobData.value.indexOf(mTempJobData.value[index])];
                            //     printWrapped(
                            //         "marker Index -${mJobData.value.indexOf(mTempJobData.value[index])}");
                            //     markers[mJobData.value
                            //             .indexOf(mTempJobData.value[index])] =
                            //         markers[mJobData.value
                            //                 .indexOf(mTempJobData.value[index])]
                            //             .copyWith(iconParam: d);
                            //     markers.toSet();
                            //   });
                            // });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.colorBlack,
                                ),
                                color: AppColors.colorBlack,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(Dimens.margin30))),
                            margin: const EdgeInsets.only(left: Dimens.margin5),
                            padding: const EdgeInsets.all(Dimens.margin5),
                            child: SvgPicture.asset(
                              APPImages.icClose,
                              colorFilter: const ColorFilter.mode(
                                  AppColors.colorWhite, BlendMode.srcIn),
                              width: Dimens.margin10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                buildDefaultDragHandles:
                    (tabPosition.value == 0 || tabPosition.value == 1)
                        ? false
                        : true,
                onReorder: (int oldIndex, int newIndex) {
                  JobData mTmp = mTempJobData.value.removeAt(oldIndex);
                  printWrapped("oldIndex : $oldIndex");
                  printWrapped("newIndex : $newIndex");
                  if (newIndex > mTempJobData.value.length) {
                    mTempJobData.value.add(mTmp);
                    var data =
                        mJobData.value.removeAt(mJobData.value.indexOf(mTmp));
                    mJobData.value.insert(newIndex - 1, data);
                  } else {
                    if (newIndex > oldIndex) {
                      mTempJobData.value.insert(newIndex - 1, mTmp);
                      var data =
                          mJobData.value.removeAt(mJobData.value.indexOf(mTmp));
                      mJobData.value.insert(newIndex - 1, data);
                    } else if (newIndex < oldIndex) {
                      mTempJobData.value.insert(newIndex, mTmp);
                      var data =
                          mJobData.value.removeAt(mJobData.value.indexOf(mTmp));
                      mJobData.value.insert(newIndex, data);
                    }
                  }
                  mTempJobData.notifyListeners();
                  mJobData.notifyListeners();

                  setState(() {
                    markers = [];

                    setMarkersOnMap();
                  });
                },
              ),
            ),
          ],
        ),
      );
    }

    Widget mapView() {
      CameraPosition kGooglePlex = CameraPosition(
        target: markers.isNotEmpty
            ? markers.first.position
            : MyAppState.mCurrentPosition.value,
        zoom: 0,
      );

      return Column(
        children: [
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: kGooglePlex,
              myLocationEnabled: true,
              compassEnabled: true,

              // circles: circles,
              onMapCreated: (GoogleMapController controller) async {
                if (!googleMapController.isCompleted) {
                  googleMapController.complete(controller);
                }
              },
              onTap: (position) {
                // printWrapped("position ::= $position");
                // if (idMarkerSelected > -1) {
                //   setState(() {
                //     BitmapDescriptor.fromAssetImage(
                //       const ImageConfiguration(
                //         size: Size(40, 50),
                //       ),
                //       Platform.isIOS
                //           ? mJobData.value[idMarkerSelected].isRemove == false
                //               ? InterpolateString.interpolate(
                //                   APPImages.icMapMarkerOrangeIos,
                //                   ['${idMarkerSelected + 1}'])
                //               : InterpolateString.interpolate(
                //                   APPImages.icMapMarkerIos,
                //                   ['${idMarkerSelected + 1}'])
                //           : mJobData.value[idMarkerSelected].isRemove == false
                //               ? InterpolateString.interpolate(
                //                   APPImages.icMapMarkerOrangeAndroid,
                //                   ['${idMarkerSelected + 1}'])
                //               : InterpolateString.interpolate(
                //                   APPImages.icMapMarkerAndroid,
                //                   ['${idMarkerSelected + 1}']),
                //     ).then((d) {
                //       setState(() {
                //         markers[idMarkerSelected] =
                //             markers[idMarkerSelected].copyWith(iconParam: d);
                //         var first = mJobData.value.removeAt(idMarkerSelected);
                //         mJobData.value.add(first);
                //         mJobData.notifyListeners();
                //         setMarkersOnMap();
                //         // markers.toSet();
                //       });
                //     });
                //   });
                // }
              },
              markers: Set<Marker>.of(markers),
              polylines: _polyline,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: Dimens.margin5,
              ),
              horizontalLocationList(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: Dimens.margin15),
                child: customTabView(),
              ),
              const SizedBox(
                height: Dimens.margin10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: Dimens.margin15),
                child: CustomButton(
                    onPress: () {
                      if (mTempJobData.value.isNotEmpty) {
                        mLoading.value = true;
                        mLoading.notifyListeners();
                        switch (tabPosition.value) {
                          case 0:
                            {
                              mLoading.value = true;
                              mLoading.notifyListeners();
                              getDirectionCalculation();
                              break;
                            }
                          case 1:
                            {
                              shortList();

                              break;
                            }
                          case 2:
                            {
                              mLoading.value = false;
                              mLoading.notifyListeners();
                              Navigator.pushNamed(getNavigatorKeyContext(),
                                  AppRoutes.routesJobsMapView,
                                  arguments: mTempJobData.value);

                              break;
                            }
                        }
                      } else {
                        ToastController.showToast(
                            ValidationString.validationSelectionOnMap
                                .translate(),
                            NavigatorKey.navigatorKey.currentContext!,
                            false);
                      }
                    },
                    height: Dimens.margin50,
                    backgroundColor: Theme.of(context).primaryColor,
                    buttonText: APPStrings.textPreview.translate(),
                    style: getTextStyleFontWeight(AppFont.mediumColorWhite,
                        Dimens.margin15, FontWeight.w400),
                    borderRadius: Dimens.margin15_5),
              ),
              const SizedBox(
                height: Dimens.margin10,
              ),
            ],
          ),
        ],
      );
    }

    return MultiValueListenableBuilder(
        valueListenables: [mLoading, mJobData, tabPosition, mTempJobData],
        builder: (context, values, child) {
          return MultiBlocListener(
            listeners: [
              BlocListener<GoogleOptimizeRouteBloc, GoogleOptimizeRouteState>(
                listener: (context, state) {
                  mLoading.value = state is GoogleOptimizeRouteLoading;
                  if (state is GoogleOptimizeRouteResponse) {
                    if ((state.mModelGoogleOptimizeRoute.routes ?? [])
                        .isNotEmpty) {
                      List<JobData> tmp = [];
                      tmp.addAll(mJobData.value);
                      mJobData.value = state.mModelGoogleOptimizeRoute
                              .routes![0].optimizedIntermediateWaypointIndex
                              ?.map((e) => tmpList[e])
                              .toList() ??
                          [];
                      mJobData.value.addAll(tmp.where((element) =>
                          (element.distance ?? '')
                              .toString()
                              .trim()
                              .replaceAll('-', '')
                              .isEmpty));
                      mJobData.notifyListeners();

                      markers.clear();
                      PolylinePoints polylinePoints = PolylinePoints();
                      List<PointLatLng> result = polylinePoints.decodePolyline(
                          state.mModelGoogleOptimizeRoute.routes![0].polyline
                                  ?.encodedPolyline ??
                              '');
                      setPolyline(result);
                      setMarkersOnMap();

                      BlocProvider.of<OptimizeRouteBloc>(context).add(
                          SaveOptimizedRoute(
                              url: AppUrls.apiOptimizeRoute,
                              body: {
                            ApiParams.paramJobIds: mJobData.value
                                .map((e) => e.jobId ?? '')
                                .toList()
                                .join(',')
                          }));
                    }
                  }
                },
              ),
              BlocListener<OptimizeRouteBloc, OptimizeRouteState>(
                listener: (context, state) {
                  mLoading.value = state is OptimizeRouteLoading;
                },
              ),
            ],
            child: ModalProgressHUD(
              inAsyncCall: mLoading.value,
              child: Scaffold(
                appBar: BaseAppBar(
                  backgroundColor: AppColors.colorPrimary,
                  mLeftImage: APPImages.icArrowBack,
                  title: APPStrings.textJobsLocations.translate(),
                  appBar: AppBar(),
                  mLeftAction: () {
                    Navigator.pop(context);
                  },
                ),
                body: SafeArea(
                  child: mapView(),
                ),
              ),
            ),
          );
        });
  }

  ///[_moveTo] this method use to _move To
  _moveTo(double latitude, double longitude) async {
    final GoogleMapController controller = await googleMapController.future;
    if (Platform.isAndroid) {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 3,
          ),
        ),
      );
    } else {
      await controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 0,
          ),
        ),
      );
    }
  }

  Future<void> getDirectionCalculation() async {
    List<JobData> jobList = [];
    var index = <int>[];
    var permission = await Geolocator.checkPermission();
    if (await Geolocator.isLocationServiceEnabled() &&
        (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always)) {
      for (JobData job in mTempJobData.value) {
        double dist = 0.0;
        int indexLength = index.length;

        if (jobList.isEmpty) {
          var currentPosition = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best);
          for (var i = 0; i < mTempJobData.value.length; i++) {
            double distance = distanceCalculator(
                currentPosition.latitude,
                currentPosition.longitude,
                double.parse(mTempJobData.value[i].latitude ?? ''),
                double.parse(mTempJobData.value[i].longitude ?? ''));
            printWrapped("empty distance $distance");
            if (dist == 0.0) {
              dist = distance;
            }
            if (distance <= dist) {
              dist = distance;
              if (index.isEmpty) {
                index.add(i);
              } else {
                index[0] = i;
              }

              printWrapped("empty ${index.toString()}");
            }
          }
          jobList.add(mTempJobData.value[index[0]]);
        } else {
          var tempList = <DistanceWithIndex>[];
          printWrapped("not empty ${index.toString()}");
          for (var i = 0; i < mTempJobData.value.length; i++) {
            if (!index.contains(i)) {
              printWrapped(index.toString());

              double distance = distanceCalculator(
                  double.parse(
                      mTempJobData.value[index[indexLength - 1]].latitude ??
                          ''),
                  double.parse(
                      mTempJobData.value[index[indexLength - 1]].longitude ??
                          ''),
                  double.parse(mTempJobData.value[i].latitude ?? ''),
                  double.parse(mTempJobData.value[i].longitude ?? ''));

              printWrapped(
                  "current latLong ${mTempJobData.value[i].latitude} ${mTempJobData.value[i].latitude}  lastLatLong ${mTempJobData.value[index[indexLength - 1]].latitude} ${mTempJobData.value[index[indexLength - 1]].latitude}");
              printWrapped("current index $i Dostance $distance");
              tempList.add(DistanceWithIndex(index: i, distance: distance));
            }
          }

          if (tempList.isNotEmpty) {
            try {
              tempList.removeWhere((element) => element.distance == 0.0);
              var min = tempList.reduce(
                  (curr, next) => curr.distance < next.distance ? curr : next);

              index.add(min.index);
              jobList.add(mTempJobData.value[min.index]);
              printWrapped("index ${index.toString()}");
              printWrapped("tempList ${jsonEncode(tempList).toString()}");

              printWrapped("min ${min.toString()}");
            } catch (e) {
              printWrapped(e.toString());
            }
          }
        }
      }

      printWrapped("jobList lenth :- ${jobList.length}");
      mLoading.value = false;
      mLoading.notifyListeners();
      Navigator.pushNamed(getNavigatorKeyContext(), AppRoutes.routesJobsMapView,
          arguments: jobList);
    } else {
      mLoading.value = false;
      mLoading.notifyListeners();
      ToastController.showToast(APPStrings.textAllowLocation.translate(),
          getNavigatorKeyContext(), false);
    }
  }

  void shortList() {
    var list = <JobData>[];
    list.addAll(mTempJobData.value);
    list.sort((a, b) {
      var adate = getDateForFormatDateString(
          a.schedule!.isEmpty ? a.updatedAt.toString() : a.schedule.toString(),
          AppConfig.dateFormatYYYYMMDDHHMMA); //before -> var adate = a.expiry;
      var bdate = getDateForFormatDateString(
          b.schedule!.isEmpty ? b.updatedAt.toString() : b.schedule.toString(),
          AppConfig.dateFormatYYYYMMDDHHMMA);
      printWrapped("Date :- ${a.schedule} - ${b.schedule}");
      return adate.millisecondsSinceEpoch
          .compareTo(bdate.millisecondsSinceEpoch);
    });
    printWrapped("list :- $list");
    mLoading.value = false;
    mLoading.notifyListeners();
    Navigator.pushNamed(getNavigatorKeyContext(), AppRoutes.routesJobsMapView,
        arguments: list);
  }

  void shortListFilter() {
    var list = <JobData>[];
    list.addAll(mTempJobData.value);
    list.sort((a, b) {
      var adate = getDateForFormatDateString(
          a.schedule!.isEmpty ? a.updatedAt.toString() : a.schedule.toString(),
          AppConfig.dateFormatYYYYMMDDHHMMA); //before -> var adate = a.expiry;
      var bdate = getDateForFormatDateString(
          b.schedule!.isEmpty ? b.updatedAt.toString() : b.schedule.toString(),
          AppConfig.dateFormatYYYYMMDDHHMMA);
      printWrapped("Date :- ${a.schedule} - ${b.schedule}");
      return adate.millisecondsSinceEpoch
          .compareTo(bdate.millisecondsSinceEpoch);
    });

    var allList = <JobData>[];
    allList.addAll(mJobData.value);
    allList.sort((a, b) {
      var adate = getDateForFormatDateString(
          a.schedule!.isEmpty ? a.updatedAt.toString() : a.schedule.toString(),
          AppConfig.dateFormatYYYYMMDDHHMMA); //before -> var adate = a.expiry;
      var bdate = getDateForFormatDateString(
          b.schedule!.isEmpty ? b.updatedAt.toString() : b.schedule.toString(),
          AppConfig.dateFormatYYYYMMDDHHMMA);
      printWrapped("Date :- ${a.schedule} - ${b.schedule}");
      return adate.millisecondsSinceEpoch
          .compareTo(bdate.millisecondsSinceEpoch);
    });
    mJobData.value.clear();
    mJobData.value.addAll(list);
    mTempJobData.value.clear();
    mTempJobData.value.addAll(list);

    for (var element in allList) {
      if (!mJobData.value.contains(element)) {
        mJobData.value.add(element);
      }
    }
    mJobData.notifyListeners();
    mTempJobData.notifyListeners();
    setState(() {
      markers.clear();
      setMarkersOnMap();
    });
  }

  Future<void> getDirectionCalculationFilter() async {
    List<JobData> jobList = [];
    var index = <int>[];
    var permission = await Geolocator.checkPermission();
    if (await Geolocator.isLocationServiceEnabled() &&
        (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always)) {
      for (JobData job in mTempJobData.value) {
        double dist = 0.0;
        int indexLength = index.length;

        if (jobList.isEmpty) {
          var currentPosition = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best);
          for (var i = 0; i < mTempJobData.value.length; i++) {
            double distance = distanceCalculator(
                currentPosition.latitude,
                currentPosition.longitude,
                double.parse(mTempJobData.value[i].latitude!),
                double.parse(mTempJobData.value[i].longitude!));
            printWrapped("empty distance $distance");
            if (dist == 0.0) {
              dist = distance;
            }
            if (distance <= dist) {
              dist = distance;
              if (index.isEmpty) {
                index.add(i);
              } else {
                index[0] = i;
              }

              printWrapped("empty ${index.toString()}");
            }
          }
          jobList.add(mTempJobData.value[index[0]]);
        } else {
          var tempList = <DistanceWithIndex>[];
          printWrapped("not empty ${index.toString()}");
          for (var i = 0; i < mTempJobData.value.length; i++) {
            if (!index.contains(i)) {
              printWrapped(index.toString());

              double distance = distanceCalculator(
                  double.parse(
                      mTempJobData.value[index[indexLength - 1]].latitude!),
                  double.parse(
                      mTempJobData.value[index[indexLength - 1]].longitude!),
                  double.parse(mTempJobData.value[i].latitude!),
                  double.parse(mTempJobData.value[i].longitude!));

              printWrapped(
                  "current latLong ${mTempJobData.value[i].latitude} ${mTempJobData.value[i].latitude}  lastLatLong ${mTempJobData.value[index[indexLength - 1]].latitude} ${mTempJobData.value[index[indexLength - 1]].latitude}");
              printWrapped("current index $i Dostance $distance");
              tempList.add(DistanceWithIndex(index: i, distance: distance));
            }
          }

          if (tempList.isNotEmpty) {
            try {
              tempList.removeWhere((element) => element.distance == 0.0);
              var min = tempList.reduce(
                  (curr, next) => curr.distance < next.distance ? curr : next);

              index.add(min.index);
              jobList.add(mTempJobData.value[min.index]);
              printWrapped("index ${index.toString()}");
              printWrapped("tempList ${jsonEncode(tempList).toString()}");

              printWrapped("min ${min.toString()}");
            } catch (e) {
              printWrapped(e.toString());
            }
          }
        }
      }
      mJobData.value.clear();
      mTempJobData.value.clear();
      mJobData.value.addAll(jobList);
      mTempJobData.value.addAll(jobList);

      if (mJobData.value.length != mFinalJobData.value.length) {
        for (var element in mFinalJobData.value) {
          if (!mJobData.value.contains(element)) {
            mJobData.value.add(element);
          }
        }
      }
      mTempJobData.notifyListeners();
      mJobData.notifyListeners();

      setState(() {
        markers.clear();
        setMarkersOnMap();
      });
    } else {
      mLoading.value = false;
      mLoading.notifyListeners();
      ToastController.showToast(APPStrings.textAllowLocation.translate(),
          getNavigatorKeyContext(), false);
    }
  }
}

double distanceCalculator(double lat1, double lon1, double lat2, double lon2) {
  const r = 6372.8; // Earth radius in kilometers

  final dLat = _toRadians(lat2 - lat1);
  final dLon = _toRadians(lon2 - lon1);
  final lat1Radians = _toRadians(lat1);
  final lat2Radians = _toRadians(lat2);

  final a =
      _haversin(dLat) + cos(lat1Radians) * cos(lat2Radians) * _haversin(dLon);
  final c = 2 * asin(sqrt(a));

  return r * c;
}

double _toRadians(double degrees) => degrees * pi / 180;

num _haversin(double radians) => pow(sin(radians / 2), 2);

class Result {
  Result(this.name, this.score, this.date);

  String name;
  int score;
  DateTime date;

  @override
  String toString() => '$name  $score  $date';
}

class DistanceWithIndex {
  int index;
  double distance;

  DistanceWithIndex({required this.index, required this.distance});

  DistanceWithIndex.fromJson(Map<String, dynamic> json)
      : index = json['index'],
        distance = json['distance'];

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'distance': distance,
    };
  }
}

// Create a list to put the results in

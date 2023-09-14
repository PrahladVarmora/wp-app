// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/model/model_geo_data.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';
import 'package:we_pro/modules/dashboard/model/model_way_point.dart';
import 'package:we_pro/modules/optimize_route/bloc/optimize_route/optimize_route_bloc.dart';

import '../../core/utils/api_import.dart';

/// This class is a stateful widget that displays a map of the jobs in the database
class ScreenJobsMapView extends StatefulWidget {
  final List<JobData> mJobData;

  const ScreenJobsMapView({Key? key, required this.mJobData}) : super(key: key);

  @override
  State<ScreenJobsMapView> createState() => _ScreenJobsMapViewState();
}

class _ScreenJobsMapViewState extends State<ScreenJobsMapView> {
  ValueNotifier<bool> mLoading = ValueNotifier(false);
  ValueNotifier<List<JobData>> mJobData = ValueNotifier([]);
  List<JobData> tmpList = [];
  Completer<GoogleMapController> googleMapController = Completer();
  List<Marker> markers = <Marker>[];
  final Set<Polyline> _polyline = {};
  BitmapDescriptor onlyPin = BitmapDescriptor.defaultMarker;
  List<BitmapDescriptor> customIcon = [];

  ///static const LatLng center = LatLng(-33.86711, 151.1947171);

  @override
  void initState() {
    initData();
    super.initState();
    /*for (var element in widget.mJobData) {
      printWrapped("jobId from preview ${element.jobId}");
    }*/
  }

  void initData() async {
    if (mJobData.value.isNotEmpty) {
      mJobData.value.clear();
    }
    mJobData.value.addAll(widget.mJobData);

    printWrapped('viewJobList---${mJobData.value.length}');

    await setMarkersOnMap();

    addPolyline();
  }

  void addPolyline() {
    var latLong = <LatLng>[];
    for (var element in mJobData.value) {
      latLong.add(LatLng(double.parse(element.latitude ?? ''),
          double.parse(element.longitude ?? '')));
    }
    _polyline.add(Polyline(
      polylineId: const PolylineId("demo"),
      visible: true,
      points: latLong,
      color: Colors.black,
      width: 5,
    ));
    setState(() {});
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
              ? InterpolateString.interpolate(
                  APPImages.icMapMarkerIos, ['${i + 1}'])
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
            position: LatLng(double.parse(item.latitude ?? ''),
                double.parse(item.longitude ?? '')),
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
                  mGeoDataModel.results?[0].geometry?.location ??
                      LocationData();
              item.latitude = mLocationData.lat.toString();
              item.longitude = mLocationData.lng.toString();
              marker = Marker(
                icon: iJobData > 50 ? onlyPin : customIcon[iJobData],
                infoWindow: InfoWindow(
                    onTap: () {
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
                position:
                    LatLng(mLocationData.lat ?? 0.0, mLocationData.lng ?? 0.0),
              );
              setState(() {
                markers.add(marker);
              });
            }
          }
        }
        iJobData++;
        /*var response = await http.get(Uri.parse(
            'https://maps.googleapis.com/maps/api/geocode/json?place_id=${item.placeId}&key=${AppConfig.googleMapKey}'));
        if (response.statusCode == 200) {
          GeoDataModel mGeoDataModel =
              GeoDataModel.fromJson(jsonDecode(response.body));
          if (mGeoDataModel.results != null &&
              mGeoDataModel.results!.isNotEmpty) {
            LocationData mLocationData =
                mGeoDataModel.results![0].geometry!.location!;
            marker = Marker(
              icon: mJobData.value.length >= 50 ? onlyPin : customIcon[i],
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
            markers.add(marker);
          }
        }*/
      }

      setState(() {
        if (markers.isNotEmpty) {
          _moveTo(markers.first.position.latitude,
              markers.first.position.longitude);

          ///_adjustCameraToBounds();
        }
      });
    } catch (e) {
      ///Todo Error Manage
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
    /// mJobData.value.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// This widget used to show Map with Origin and Destination mark
    Widget mapView() {
      CameraPosition kGooglePlex = CameraPosition(
        target: markers.isNotEmpty
            ? markers.first.position
            : MyAppState.mCurrentPosition.value,
        zoom: 0,
      );
      /*Set<Circle> circles = {
        Circle(
          circleId: const CircleId("1"),
          center:
              LatLng(kGooglePlex.target.latitude, kGooglePlex.target.longitude),
          radius: 1500,
          fillColor: Colors.blue.shade100.withOpacity(0.5),
          strokeColor: Colors.blue.shade100.withOpacity(0.1),
        )
      };*/

      return Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: kGooglePlex,
            myLocationEnabled: true,
            compassEnabled: true,
            // circles: circles,
            onMapCreated: (GoogleMapController controller) async {
              if (!googleMapController.isCompleted) {
                googleMapController.complete(controller);
              }

              ///_adjustCameraToBounds();
            },
            markers: Set<Marker>.of(markers),
            polylines: _polyline,
          ),
          // PointerInterceptor(
          //
          //   child: Container(
          //     margin: const EdgeInsets.all(Dimens.margin16),
          //     color: AppColors.colorPrimary,
          //     child: Container(
          //       padding: const EdgeInsets.all(Dimens.margin16),
          //       child: InkWell(
          //         onTap: () {
          //
          //         },
          //         child: const Text('Optimise Route'),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      );
    }

    return MultiValueListenableBuilder(
        valueListenables: [
          mLoading,
          mJobData,
        ],
        builder: (context, values, child) {
          return MultiBlocListener(
            listeners: [
              // BlocListener<GoogleOptimizeRouteBloc, GoogleOptimizeRouteState>(
              //   listener: (context, state) {
              //     mLoading.value = state is GoogleOptimizeRouteLoading;
              //     if (state is GoogleOptimizeRouteResponse) {
              //       if ((state.mModelGoogleOptimizeRoute.routes ?? [])
              //           .isNotEmpty) {
              //         List<JobData> tmp = [];
              //         tmp.addAll(mJobData.value);
              //         mJobData.value = state.mModelGoogleOptimizeRoute
              //                 .routes![0].optimizedIntermediateWaypointIndex
              //                 ?.map((e) => tmpList[e])
              //                 .toList() ??
              //             [];
              //         mJobData.value.addAll(tmp.where((element) =>
              //             (element.distance ?? '')
              //                 .toString()
              //                 .trim()
              //                 .replaceAll('-', '')
              //                 .isEmpty));
              //         mJobData.notifyListeners();
              //
              //         markers.clear();
              //         PolylinePoints polylinePoints = PolylinePoints();
              //         List<PointLatLng> result = polylinePoints.decodePolyline(
              //             state.mModelGoogleOptimizeRoute.routes![0].polyline
              //                     ?.encodedPolyline ??
              //                 '');
              //         setPolyline(result);
              //         setMarkersOnMap();
              //
              //         BlocProvider.of<OptimizeRouteBloc>(context).add(
              //             SaveOptimizedRoute(
              //                 url: AppUrls.apiOptimizeRoute,
              //                 body: {
              //               ApiParams.paramJobIds: mJobData.value
              //                   .map((e) => e.jobId ?? '')
              //                   .toList()
              //                   .join(',')
              //             }));
              //       }
              //     }
              //   },
              // ),
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
                  title: APPStrings.textRoutePreview.translate(),
                  appBar: AppBar(),
                  mLeftAction: () {
                    Navigator.pop(context);
                  },
                ),
                body: SafeArea(
                  child: mapView(),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: const BorderSide(color: Colors.black)))),
                  onPressed: () async {
                    if (Platform.isIOS) {
                      LocationPermission permission;
                      permission = await Geolocator.requestPermission();
                      Position currentPosition =
                          await Geolocator.getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.high);
                      if (permission == LocationPermission.always ||
                          permission == LocationPermission.whileInUse) {
                        var waypoints = <ModelWayPoint>[];
                        for (var element in mJobData.value) {
                          if (element != mJobData.value.last) {
                            // waypoints.add(ModelWayPoint(location:"${element.latitude!},${element.longitude!}",stopover: true));
                            waypoints.add(ModelWayPoint(
                                location: element.address!,
                                placeId: element.placeId!,
                                stopover: true));
                          }
                        }

                        clickMapMultipleLocation(
                            "${currentPosition.latitude}, ${currentPosition.longitude}",
                            "${mJobData.value.last.latitude}, ${mJobData.value.last.longitude}",
                            waypoints,
                            "",
                            mJobData.value.last.placeId!);
                      } else {
                        ToastController.showToast(
                            APPStrings.textAllowLocation.translate(),
                            getNavigatorKeyContext(),
                            false);
                      }
                    } else {
                      var permission = await Geolocator.checkPermission();
                      if (await Geolocator.isLocationServiceEnabled() &&
                          (permission == LocationPermission.whileInUse ||
                              permission == LocationPermission.always)) {
                        var currentPosition = await determinePosition();
                        var waypoints = <ModelWayPoint>[];
                        for (var element in mJobData.value) {
                          if (element != mJobData.value.last) {
                            // waypoints.add(ModelWayPoint(location:"${element.latitude!},${element.longitude!}",stopover: true));
                            waypoints.add(ModelWayPoint(
                                location: element.address!,
                                placeId: element.placeId!,
                                stopover: true));
                          }
                        }

                        clickMapMultipleLocation(
                            "${currentPosition!.latitude}, ${currentPosition.longitude}",
                            "${mJobData.value.last.latitude}, ${mJobData.value.last.longitude}",
                            waypoints,
                            "",
                            mJobData.value.last.placeId!);
                      } else {
                        ToastController.showToast(
                            APPStrings.textAllowLocation.translate(),
                            getNavigatorKeyContext(),
                            false);
                      }
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimens.margin20, vertical: Dimens.margin10),
                    child: Text(
                      "Route",
                      style: TextStyle(
                          color: Colors.white, fontSize: Dimens.textSize18),
                    ),
                  ),
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
            zoom: 0,
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

  /// [_adjustCameraToBounds] this function used to adjust map camera bounds
  void _adjustCameraToBounds() async {
    final GoogleMapController controller = await googleMapController.future;
    double minLat = -double.infinity;
    double maxLat = -double.infinity;
    double minLng = -double.infinity;
    double maxLng = -double.infinity;
    for (Marker marker in markers) {
      double lat = marker.position.latitude;
      double lng = marker.position.longitude;
      if (lat < minLat) minLat = lat;
      if (lat > maxLat) maxLat = lat;
      if (lng < minLng) minLng = lng;
      if (lng > maxLng) maxLng = lng;
    }
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
    controller.animateCamera(cameraUpdate);
  }
}

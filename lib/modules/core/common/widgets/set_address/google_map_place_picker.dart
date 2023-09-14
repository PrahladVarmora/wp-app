import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:we_pro/modules/core/common/widgets/animated_pin.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/pick_result.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/place_picker.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/place_provider.dart';

import '../../../utils/core_import.dart';

typedef SelectedPlaceWidgetBuilder = Widget Function(
  BuildContext context,
  PickResult? selectedPlace,
  SearchingState state,
  bool isSearchBarFocused,
);

typedef PinBuilder = Widget Function(
  BuildContext context,
  PinState state,
);

///[GoogleMapPlacePicker] this class use to Google Map Place Picker
class GoogleMapPlacePicker extends StatelessWidget {
  const GoogleMapPlacePicker({
    Key? key,
    required this.initialTarget,
    required this.appBarKey,
    this.selectedPlaceWidgetBuilder,
    this.pinBuilder,
    this.onSearchFailed,
    this.onMoveStart,
    this.onMapCreated,
    this.debounceMilliseconds,
    this.enableMapTypeButton,
    this.enableMyLocationButton,
    this.onToggleMapType,
    this.onMyLocation,
    this.onPlacePicked,
    this.usePinPointingSearch,
    this.usePlaceDetailSearch,
    this.selectInitialPosition,
    this.language,
    this.forceSearchOnZoomChanged,
    this.hidePlaceDetailsWhenDraggingPin,
  }) : super(key: key);

  final LatLng initialTarget;
  final GlobalKey appBarKey;

  final SelectedPlaceWidgetBuilder? selectedPlaceWidgetBuilder;
  final PinBuilder? pinBuilder;

  final ValueChanged<String>? onSearchFailed;
  final VoidCallback? onMoveStart;
  final MapCreatedCallback? onMapCreated;
  final VoidCallback? onToggleMapType;
  final VoidCallback? onMyLocation;
  final ValueChanged<PickResult>? onPlacePicked;

  final int? debounceMilliseconds;
  final bool? enableMapTypeButton;
  final bool? enableMyLocationButton;

  final bool? usePinPointingSearch;
  final bool? usePlaceDetailSearch;

  final bool? selectInitialPosition;

  final String? language;

  final bool? forceSearchOnZoomChanged;
  final bool? hidePlaceDetailsWhenDraggingPin;

  ///[_searchByCameraLocation] this method use to _search By Camera Location
  void _searchByCameraLocation(PlaceProvider provider) async {
    // We don't want to search location again if camera location is changed by zooming in/out.
    bool hasZoomChanged = provider.cameraPosition != null &&
        provider.prevCameraPosition != null &&
        provider.cameraPosition!.zoom != provider.prevCameraPosition!.zoom;
    if (forceSearchOnZoomChanged == false && hasZoomChanged) {
      provider.placeSearchingState = SearchingState.ddle;
      return;
    }
    provider.placeSearchingState = SearchingState.searching;
    final GeocodingResponse response =
        await provider.geocoding.searchByLocation(
      Location(
          lat: provider.cameraPosition!.target.latitude,
          lng: provider.cameraPosition!.target.longitude),
      language: language,
    );

    if (response.errorMessage?.isNotEmpty == true ||
        response.status == 'REQUEST_DENIED') {
      if (onSearchFailed != null) {
        onSearchFailed!(response.status);
      }
      provider.placeSearchingState = SearchingState.ddle;
      return;
    }
    if (usePlaceDetailSearch!) {
      final PlacesDetailsResponse detailResponse =
          await provider.places.getDetailsByPlaceId(
        response.results[0].placeId,
        language: language,
      );
      if (detailResponse.errorMessage?.isNotEmpty == true ||
          detailResponse.status == 'REQUEST_DENIED') {
        if (onSearchFailed != null) {
          onSearchFailed!(detailResponse.status);
        }
        provider.placeSearchingState = SearchingState.ddle;
        return;
      }
      provider.selectedPlace =
          PickResult.fromPlaceDetailResult(detailResponse.result);
    } else {
      provider.selectedPlace =
          PickResult.fromGeocodingResult(response.results[0]);
    }
    provider.placeSearchingState = SearchingState.ddle;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildGoogleMap(context),
        _buildPin(),
        _buildMapIcons(context),
      ],
    );
  }

  ///[_buildGoogleMap] this method use to _build Google Map
  Widget _buildGoogleMap(BuildContext context) {
    return Selector<PlaceProvider, MapType>(
        selector: (_, provider) => provider.mapType,
        builder: (_, data, __) {
          PlaceProvider provider = PlaceProvider.of(context, listen: false);
          CameraPosition initialCameraPosition =
              CameraPosition(target: initialTarget, zoom: 15);
          return GoogleMap(
            myLocationButtonEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            initialCameraPosition: initialCameraPosition,
            mapType: MapType.normal,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              provider.mapController = controller;
              provider.setCameraPosition(null);
              provider.pinState = PinState.idle;

              // When select initialPosition set to true.
              if (selectInitialPosition!) {
                provider.setCameraPosition(initialCameraPosition);
                _searchByCameraLocation(provider);
              }
            },
            onCameraIdle: () {
              if (provider.isAutoCompleteSearching) {
                provider.isAutoCompleteSearching = false;
                provider.pinState = PinState.idle;
                return;
              }

              // Perform search only if the setting is to true.
              if (usePinPointingSearch!) {
                // Search current camera location only if camera has moved (dragged) before.
                if (provider.pinState == PinState.dragging) {
                  // Cancel previous timer.
                  if (provider.debounceTimer?.isActive ?? false) {
                    provider.debounceTimer!.cancel();
                  }
                  provider.debounceTimer =
                      Timer(Duration(milliseconds: debounceMilliseconds!), () {
                    _searchByCameraLocation(provider);
                  });
                }
              }
              provider.pinState = PinState.idle;
            },
            onCameraMoveStarted: () {
              provider.setPrevCameraPosition(provider.cameraPosition);
              // Cancel any other timer.
              provider.debounceTimer?.cancel();
              // Update state, dismiss keyboard and clear text.
              provider.pinState = PinState.dragging;
              // Begins the search state if the hide details is enabled
              if (hidePlaceDetailsWhenDraggingPin!) {
                provider.placeSearchingState = SearchingState.searching;
              }
              onMoveStart!();
            },
            onCameraMove: (CameraPosition position) {
              provider.setCameraPosition(position);
            },
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            }..add(Factory<EagerGestureRecognizer>(
                () => EagerGestureRecognizer())),
          );
        });
  }

  ///[_buildPin] this method use to _build Pin
  Widget _buildPin() {
    return Center(
      child: Selector<PlaceProvider, PinState>(
        selector: (_, provider) => provider.pinState,
        builder: (context, state, __) {
          if (pinBuilder == null) {
            return _defaultPinBuilder(context, state);
          } else {
            return Builder(
                builder: (builderContext) =>
                    pinBuilder!(builderContext, state));
          }
        },
      ),
    );
  }

  ///[_defaultPinBuilder] this method use to _default Pin Builder
  Widget _defaultPinBuilder(BuildContext context, PinState state) {
    if (state == PinState.preparing) {
      return Container();
    } else if (state == PinState.idle) {
      return Stack(
        children: <Widget>[
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.place, size: 40, color: AppColors.colorPrimary),
                SizedBox(height: 42),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedPin(
                    child: Icon(Icons.place,
                        size: 60, color: AppColors.colorPrimary)),
                SizedBox(height: 42),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    }
  }

  ///[_buildMapIcons] this method use to _build Map Icons
  Widget _buildMapIcons(BuildContext context) {
    final RenderBox appBarRenderBox =
        appBarKey.currentContext!.findRenderObject() as RenderBox;

    return Positioned(
      bottom: appBarRenderBox.size.height + 15,
      right: 15,
      child: Column(
        children: <Widget>[
          enableMyLocationButton!
              ? SizedBox(
                  width: 35,
                  height: 35,
                  child: RawMaterialButton(
                    shape: const CircleBorder(),
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black54
                        : Colors.white,
                    elevation: 8.0,
                    onPressed: onMyLocation,
                    child: const Icon(Icons.my_location),
                  ),
                )
              : Container(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

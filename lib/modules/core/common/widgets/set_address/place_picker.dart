import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/autocomplete_search.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/autocomplete_search_controller.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/google_map_place_picker.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/model_picked_location.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/pick_result.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/place_provider.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/set_address_bloc.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/uuid.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';

enum PinState { preparing, idle, dragging }

enum SearchingState { ddle, searching }

///[PlacePicker] this class use to Place Picker Mobile
class PlacePicker extends StatefulWidget {
  const PlacePicker({
    Key? key,
    required this.isSearch,
    required this.apiKey,
    required this.onPickedLocation,
    required this.onPickedLocationResult,
    required this.mModelPickedLocation,
    this.onPlacePicked,
    required this.initialPosition,
    this.useCurrentLocation = true,
    this.desiredLocationAccuracy = LocationAccuracy.high,
    this.onMapCreated,
    this.hintText,
    this.searchingText,
    this.onAutoCompleteFailed,
    this.onGeocodingSearchFailed,
    this.proxyBaseUrl,
    this.httpClient,
    this.selectedPlaceWidgetBuilder,
    this.pinBuilder,
    this.autoCompleteDebounceInMilliseconds = 500,
    this.cameraMoveDebounceInMilliseconds = 750,
    this.initialMapType = MapType.none,
    this.enableMapTypeButton = true,
    this.enableMyLocationButton = true,
    this.myLocationButtonCooldown = 10,
    this.usePinPointingSearch = true,
    this.usePlaceDetailSearch = false,
    this.autocompleteOffset,
    this.autocompleteRadius,
    this.autocompleteLanguage,
    this.autocompleteComponents,
    this.autocompleteTypes,
    this.strictbounds,
    this.region,
    this.selectInitialPosition = false,
    this.resizeToAvoidBottomInset = false,
    this.initialSearchString,
    this.searchForInitialValue = false,
    this.forceAndroidLocationManager = false,
    this.forceSearchOnZoomChanged = false,
    this.automaticallyImplyAppBarLeading = true,
    this.autocompleteOnTrailingWhitespace = false,
    this.hidePlaceDetailsWhenDraggingPin = true,
  }) : super(key: key);

  final bool isSearch;
  final String apiKey;
  final ModelPickedLocation mModelPickedLocation;
  final LatLng initialPosition;
  final bool? useCurrentLocation;
  final LocationAccuracy desiredLocationAccuracy;
  final MapCreatedCallback? onMapCreated;

  final String? hintText;
  final String? searchingText;

  // final double searchBarHeight;
  // final EdgeInsetsGeometry contentPadding;

  final ValueChanged<String>? onAutoCompleteFailed;
  final ValueChanged<String>? onGeocodingSearchFailed;
  final int autoCompleteDebounceInMilliseconds;
  final int cameraMoveDebounceInMilliseconds;

  final MapType initialMapType;
  final bool enableMapTypeButton;
  final bool enableMyLocationButton;
  final int myLocationButtonCooldown;

  final bool usePinPointingSearch;
  final bool usePlaceDetailSearch;

  final num? autocompleteOffset;
  final num? autocompleteRadius;
  final String? autocompleteLanguage;
  final List<String>? autocompleteTypes;
  final List<Component>? autocompleteComponents;
  final bool? strictbounds;
  final String? region;

  final bool resizeToAvoidBottomInset;
  final bool selectInitialPosition;
  final ValueChanged<PickResult>? onPlacePicked;
  final SelectedPlaceWidgetBuilder? selectedPlaceWidgetBuilder;
  final PinBuilder? pinBuilder;

  final String? proxyBaseUrl;
  final BaseClient? httpClient;
  final String? initialSearchString;
  final bool searchForInitialValue;
  final bool forceAndroidLocationManager;
  final bool forceSearchOnZoomChanged;
  final bool automaticallyImplyAppBarLeading;
  final bool autocompleteOnTrailingWhitespace;
  final bool hidePlaceDetailsWhenDraggingPin;
  final Function(ModelPickedLocation)? onPickedLocation;
  final Function(PickResult)? onPickedLocationResult;

  @override
  PlacePickerState createState() => PlacePickerState();
}

class PlacePickerState extends State<PlacePicker> {
  // Address_Appear Click menu
  GlobalKey appBarKey = GlobalKey();
  Future<PlaceProvider>? _futureProvider;
  PlaceProvider? provider;
  SearchBarController searchBarController = SearchBarController();

  TextEditingController addressInformationController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController placeIdController = TextEditingController();

  final FocusNode addressInformationFocus = FocusNode();
  final FocusNode areaFocus = FocusNode();
  final FocusNode cityFocus = FocusNode();
  final FocusNode stateFocus = FocusNode();

  PickResult? mPickResultAddrees;
  SharedPreferences? prefs;
  bool isDisplayAddressWhenInEditModeFirstTime = false;
  LocationPermission? permission;

  ///[setUpDummyData] this method use to setUp Dummy Data
  void setUpDummyData() async {
    prefs = await SharedPreferences.getInstance();
    if (widget.mModelPickedLocation.longitude != null) {
      addressInformationController.text =
          widget.mModelPickedLocation.addressLine.toString();
      areaController.text = widget.mModelPickedLocation.addressArea.toString();
      cityController.text = widget.mModelPickedLocation.addressCity.toString();
      stateController.text =
          widget.mModelPickedLocation.addressState.toString();

      Timer(const Duration(milliseconds: 500), () async {
        _moveTo(widget.mModelPickedLocation.latitude!,
            widget.mModelPickedLocation.longitude!);
      });

      setState(() {});
    }
  }

  ///[getPermission] this method use to get Permission
  void getPermission() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    } else if (permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
  }

  @override
  void initState() {
    super.initState();
    getPermission();
    _futureProvider = _initPlaceProvider();
    setUpDummyData();
  }

  @override
  void dispose() {
    searchBarController.dispose();
    super.dispose();
  }

  ///[_initPlaceProvider] this method use to _init Place Provider
  Future<PlaceProvider> _initPlaceProvider() async {
    final headers = await const GoogleApiHeaders().getHeaders();
    final provider = PlaceProvider(
      widget.apiKey,
      widget.proxyBaseUrl,
      widget.httpClient,
      headers,
    );
    provider.sessionToken = Uuid().generateV4();
    provider.desiredAccuracy = widget.desiredLocationAccuracy;
    provider.setMapType(widget.initialMapType);
    return provider;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            WillPopScope(
              onWillPop: () {
                searchBarController.clearOverlay();
                return Future.value(true);
              },
              child: FutureBuilder<PlaceProvider>(
                future: _futureProvider,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    provider = snapshot.data;
                    return MultiProvider(
                      providers: [
                        ChangeNotifierProvider<PlaceProvider>.value(
                            value: provider!),
                      ],
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: Scaffold(
                          key: ValueKey<int>(provider.hashCode),
                          resizeToAvoidBottomInset:
                              widget.resizeToAvoidBottomInset,
                          //extendBodyBehindAppBar: true,
                          appBar: AppBar(
                            key: appBarKey,
                            automaticallyImplyLeading: false,
                            iconTheme: Theme.of(context).iconTheme,
                            elevation: 0,
                            backgroundColor: Colors.white,
                            titleSpacing: 0.0,
                            title: _buildSearchBar(context),
                          ),
                          //  body: _buildMapWithLocation(),
                          body: layoutSetAddress(),
                          bottomNavigationBar: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimens.margin16),
                            child: addressData(),
                          ),
                        ),
                      ),
                    );
                  }

                  final children = <Widget>[];
                  if (snapshot.hasError) {
                    children.addAll([
                      const Icon(
                        Icons.error_outline,
                        // color: Theme.of(context).errorColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Error: ${snapshot.error}'),
                      )
                    ]);
                  } else {
                    children.add(const CircularProgressIndicator());
                  }

                  return Scaffold(
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: children,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }

  /// This text Widget in this page all text UI interface
  Widget text(String text, TextAlign textAlign, TextStyle style) {
    return Text(
      text,
      textAlign: textAlign,
      style: style,
    );
  }

  /// This Done Button Widget in this page all text UI interface
  Widget textDone() {
    return CustomButton(
      buttonText: APPStrings.textDone.translate(),
      height: Responsive.isMobile(context) ? Dimens.margin56 : Dimens.margin40,
      width: Responsive.isMobile(context) ? double.infinity : Dimens.margin98,
      backgroundColor: Theme.of(context).primaryColor,
      borderColor: Theme.of(context).primaryColor,
      borderRadius: Dimens.margin7,
      onPress: () {
        if (provider!.placeSearchingState != SearchingState.searching) {
          ModelPickedLocation mModelPickedLocation = ModelPickedLocation();
          bool isLocationPick = false;
          if (provider!.selectedPlace != null &&
              provider!.selectedPlace!.geometry != null &&
              provider!.selectedPlace!.geometry!.location.lat
                  .toString()
                  .isNotEmpty &&
              provider!.selectedPlace!.geometry!.location.lng
                  .toString()
                  .isNotEmpty) {
            mModelPickedLocation.latitude =
                provider!.selectedPlace!.geometry!.location.lat;
            mModelPickedLocation.longitude =
                provider!.selectedPlace!.geometry!.location.lng;
            isLocationPick = true;
          }
          String addressInformation = addressInformationController.text;
          String area = areaController.text;
          String city = cityController.text;
          String state = stateController.text;

          String country = countryController.text;
          String zip = zipController.text;
          if (isLocationPick == false) {
            ToastController.showToast('Please Select Location', context, false);
          } else {
            mModelPickedLocation.addressLine = addressInformation;
            mModelPickedLocation.addressArea = area;
            mModelPickedLocation.addressCity = city;
            mModelPickedLocation.addressState = state;

            mModelPickedLocation.addressCountry = country;
            mModelPickedLocation.addressZip = zip;
            mModelPickedLocation.placeId = placeIdController.text;
            widget.onPickedLocation!(mModelPickedLocation);
            if (provider!.selectedPlace != null) {
              widget.onPickedLocationResult!(provider!.selectedPlace!);
            }
          }
        }
      },
      style: getTextStyleFontWeight(
          AppFont.mediumColorWhite, Dimens.margin15, FontWeight.w400),
    );
  }

  /// This Address Line Widget in this page all text UI interface
  Widget textAddressLine() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            text('APPStrings.textAddressLine', TextAlign.left,
                AppFont.color727272Regular),
            text('APPStrings.textStar', TextAlign.left,
                AppFont.colorPrimarySemiBold),
          ],
        ),
        const SizedBox(
          height: Dimens.margin4,
        ),
        SizedBox(
          height: Dimens.margin40,
          width: double.infinity,
          child: BaseTextFormField(
            inputFormatters: const [],
            controller: addressInformationController,
            focusNode: addressInformationFocus,
            nextFocusNode: areaFocus,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            maxLength: 50,
            hintText: 'APPStrings.textEnterBlockNumberStreet',
            labelStyle: AppFont.colorPrimarySemiBold,
            hintStyle: AppFont.colorPrimarySemiBold,
          ),
        ),
      ],
    );
  }

  /// This Address Line Widget in this page all text UI interface
  Widget textAreaLandmark() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            text('APPStrings.textAreaLandmark', TextAlign.left,
                AppFont.colorPrimarySemiBold),
            text('APPStrings.textStar', TextAlign.left,
                AppFont.colorPrimarySemiBold),
          ],
        ),
        const SizedBox(
          height: Dimens.margin4,
        ),
        SizedBox(
          height: Dimens.margin40,
          width: double.infinity,
          child: BaseTextFormField(
            inputFormatters: const [],
            controller: areaController,
            focusNode: areaFocus,
            nextFocusNode: cityFocus,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            maxLength: 50,
            hintText: 'APPStrings.textEnterAreaLandmark',
            labelStyle: AppFont.colorPrimarySemiBold,
            hintStyle: AppFont.colorPrimarySemiBold,
          ),
        ),
      ],
    );
  }

  /// This City Line Widget in this page all text UI interface
  Widget textCity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            text(APPStrings.textCity, TextAlign.left,
                AppFont.colorPrimarySemiBold),
            text('APPStrings.textStar', TextAlign.left,
                AppFont.colorPrimarySemiBold),
          ],
        ),
        const SizedBox(
          height: Dimens.margin4,
        ),
        SizedBox(
          height: Dimens.margin40,
          width: double.infinity,
          child: BaseTextFormField(
            inputFormatters: const [],
            controller: cityController,
            focusNode: cityFocus,
            nextFocusNode: stateFocus,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            maxLength: 50,
            hintText: APPStrings.textEnterCity,
            labelStyle: AppFont.colorPrimarySemiBold,
            hintStyle: AppFont.colorPrimarySemiBold,
          ),
        ),
      ],
    );
  }

  /// This State Line Widget in this page all text UI interface
  Widget textState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            text(APPStrings.textState, TextAlign.left,
                AppFont.colorPrimarySemiBold),
            text('APPStrings.textStar', TextAlign.left,
                AppFont.colorPrimarySemiBold),
          ],
        ),
        const SizedBox(
          height: Dimens.margin4,
        ),
        SizedBox(
          height: Dimens.margin40,
          width: double.infinity,
          child: BaseTextFormField(
            inputFormatters: const [],
            controller: stateController,
            focusNode: stateFocus,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            maxLength: 50,
            hintText: APPStrings.textEnterState,
            labelStyle: AppFont.colorPrimarySemiBold,
            hintStyle: AppFont.colorPrimarySemiBold,
          ),
        ),
      ],
    );
  }

  ///[_buildSearchBar] this method use to _build Search Bar
  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(
          width: Dimens.margin10,
        ),
        widget.automaticallyImplyAppBarLeading
            ? SvgPicture.asset(
                APPImages.icSearch,
                width: Dimens.margin20,
                height: Dimens.margin20,
              )
            : const SizedBox(width: 15),
        const SizedBox(
          width: Dimens.margin10,
        ),
        Expanded(
          child: AutoCompleteSearch(
              appBarKey: appBarKey,
              searchBarController: searchBarController,
              sessionToken: provider!.sessionToken,
              hintText: 'Search Location',
              searchingText: widget.searchingText,
              debounceMilliseconds: widget.autoCompleteDebounceInMilliseconds,
              onPicked: (prediction) {
                _pickPrediction(prediction);
              },
              onSearchFailed: (status) {
                if (widget.onAutoCompleteFailed != null) {
                  widget.onAutoCompleteFailed!(status);
                }
              },
              autocompleteOffset: widget.autocompleteOffset,
              autocompleteRadius: widget.autocompleteRadius,
              autocompleteLanguage: widget.autocompleteLanguage,
              autocompleteComponents: widget.autocompleteComponents,
              autocompleteTypes: widget.autocompleteTypes,
              strictbounds: widget.strictbounds,
              region: widget.region,
              initialSearchString: widget.initialSearchString,
              searchForInitialValue: widget.searchForInitialValue,
              autocompleteOnTrailingWhitespace:
                  widget.autocompleteOnTrailingWhitespace),
        ),
        const SizedBox(width: 5),
      ],
    );
  }

  ///[_pickPrediction] this method use to _pick Prediction
  void _pickPrediction(Prediction prediction) async {
    provider!.placeSearchingState = SearchingState.searching;
    final PlacesDetailsResponse response =
        await provider!.places.getDetailsByPlaceId(
      prediction.placeId!,
      sessionToken: provider!.sessionToken,
      language: widget.autocompleteLanguage,
    );

    if (response.errorMessage?.isNotEmpty == true ||
        response.status == 'REQUEST_DENIED') {
      if (widget.onAutoCompleteFailed != null) {
        widget.onAutoCompleteFailed!(response.status);
      }
      return;
    }
    provider!.selectedPlace = PickResult.fromPlaceDetailResult(response.result);
    // Prevents searching again by camera movement.
    provider!.isAutoCompleteSearching = true;
    await _moveTo(provider!.selectedPlace!.geometry!.location.lat,
        provider!.selectedPlace!.geometry!.location.lng);
    provider!.placeSearchingState = SearchingState.ddle;
  }

  ///[_moveTo] this method use to _move To
  _moveTo(double latitude, double longitude) async {
    GoogleMapController? controller = provider!.mapController;
    if (controller == null) return;

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

  ///[_moveToCurrentPosition] this method use to _move To Current Position
  _moveToCurrentPosition() async {
    if (provider!.currentPosition != null) {
      await _moveTo(provider!.currentPosition!.latitude,
          provider!.currentPosition!.longitude);
    }
  }

  ///[_buildMapWithLocation] this method use to _build Map With Location
  Widget _buildMapWithLocation() {
    if (widget.useCurrentLocation!) {
      return FutureBuilder(
          future: provider!
              .updateCurrentLocation(widget.forceAndroidLocationManager),
          builder: (context, snap) {
            if (Platform.isAndroid && provider!.currentPosition == null) {
              return Responsive.isMobile(context)
                  ? const Center(
                      child: Padding(
                      padding: EdgeInsets.only(top: Dimens.margin50),
                      child: CircularProgressIndicator(
                          color: AppColors.colorPrimary),
                    ))
                  : const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.colorPrimary),
                    );
            } else if (provider!.currentPosition == null) {
              return _buildMap(Platform.isIOS
                  ? const LatLng(41.40338, 2.17403)
                  : widget.initialPosition);
            } else {
              return _buildMap(LatLng(provider!.currentPosition!.latitude,
                  provider!.currentPosition!.longitude));
            }
          });
    } else {
      return FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 1)),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _buildMap(widget.initialPosition);
          }
        },
      );
    }
  }

  ///[_buildMap] this method use to _build Map
  Widget _buildMap(LatLng initialTarget) {
    return SizedBox(
      height: widget.isSearch
          ? MediaQuery.of(context).size.height - 250
          : MediaQuery.of(context).size.height / 2 - 120,
      child: GoogleMapPlacePicker(
        initialTarget: initialTarget,
        appBarKey: appBarKey,
        selectedPlaceWidgetBuilder: widget.selectedPlaceWidgetBuilder,
        pinBuilder: widget.pinBuilder,
        onSearchFailed: widget.onGeocodingSearchFailed,
        debounceMilliseconds: widget.cameraMoveDebounceInMilliseconds,
        enableMapTypeButton: widget.enableMapTypeButton,
        enableMyLocationButton: widget.enableMyLocationButton,
        usePinPointingSearch: widget.usePinPointingSearch,
        usePlaceDetailSearch: widget.usePlaceDetailSearch,
        onMapCreated: widget.onMapCreated,
        selectInitialPosition: widget.selectInitialPosition,
        language: widget.autocompleteLanguage,
        forceSearchOnZoomChanged: widget.forceSearchOnZoomChanged,
        hidePlaceDetailsWhenDraggingPin: widget.hidePlaceDetailsWhenDraggingPin,
        onToggleMapType: () {
          FocusScope.of(context).requestFocus(FocusNode());

          provider!.switchMapType();
        },
        onMyLocation: () async {
          // Prevent to click many times in short period.
          if (provider!.isOnUpdateLocationCooldown == false) {
            provider!.isOnUpdateLocationCooldown = true;
            Timer(Duration(seconds: widget.myLocationButtonCooldown), () {
              provider!.isOnUpdateLocationCooldown = false;
            });
            await provider!
                .updateCurrentLocation(widget.forceAndroidLocationManager);
            await _moveToCurrentPosition();
          }
        },
        onMoveStart: () {
          searchBarController.reset();
          FocusScope.of(context).requestFocus(FocusNode());
        },
        onPlacePicked: widget.onPlacePicked,
      ),
    );
  }

  bool isAddressManually = true;

  ///[layoutSetAddress] this method use to layout Set Address
  Widget layoutSetAddress() {
    return Stack(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: widget.isSearch
                    ? MediaQuery.of(context).size.height - 200
                    : MediaQuery.of(context).size.height / 2 - 120,
                child: _buildMapWithLocation(),
              ),
              /*Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: Dimens.margin16),
                child: addressData(),
              ),*/
            ],
          ),
        ),
      ],
    );
  }

  ///[addressData] this method use to address Data
  Widget addressData() {
    return BlocListener<SetAddressBloc, SetAddressState>(
      listener: (context, state) {
        if (state is SetAddressResponse) {
          setState(() {
            if (state.address.length < 50) {
              addressInformationController.text = state.address;
            } else {
              addressInformationController.text =
                  state.address.toString().substring(0, 50);
            }
            cityController.text = state.city;
            stateController.text = state.state;

            countryController.text = state.country;

            zipController.text = state.pinCode;
            placeIdController.text = state.placeId;
          });
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.isSearch
              ? const SizedBox()
              : const SizedBox(height: Dimens.margin16),
          Visibility(
            visible: widget.isSearch == false,
            child: textAddressLine(),
          ),
          const SizedBox(
            height: Dimens.margin16,
          ),
          widget.isSearch ? const SizedBox() : textAreaLandmark(),
          widget.isSearch
              ? const SizedBox()
              : const SizedBox(
                  height: Dimens.margin16,
                ),
          widget.isSearch ? const SizedBox() : textCity(),
          widget.isSearch
              ? const SizedBox()
              : const SizedBox(
                  height: Dimens.margin16,
                ),
          widget.isSearch ? const SizedBox() : textState(),
          widget.isSearch
              ? const SizedBox()
              : const SizedBox(
                  height: Dimens.margin16,
                ),
          Visibility(visible: Responsive.isMobile(context), child: textDone()),
          const SizedBox(
            height: Dimens.margin16,
          ),
          _buildAddress()
        ],
      ),
    );
  }

  ///[_buildAddress] this method use to _build Address
  Widget _buildAddress() {
    return Selector<PlaceProvider,
        Tuple4<PickResult?, SearchingState, bool, PinState>>(
      selector: (_, provider) => Tuple4(
          provider.selectedPlace,
          provider.placeSearchingState,
          provider.isSearchBarFocused,
          provider.pinState),
      builder: (context, data, __) {
        if ((data.item1 == null && data.item2 == SearchingState.ddle) ||
            data.item3 == true ||
            data.item4 == PinState.dragging &&
                widget.hidePlaceDetailsWhenDraggingPin) {
          return Container();
        } else {
          if (widget.selectedPlaceWidgetBuilder == null) {
            PickResult? mPickResult = data.item1;
            if (data.item2 != SearchingState.searching) {
              String city = '', state = '', country = '', pinCode = '';
              for (int i = 0; i < mPickResult!.addressComponents!.length; i++) {
                var addressComponents = mPickResult.addressComponents![i];
                if (addressComponents.types[0] == 'locality') {
                  city = addressComponents.longName;
                }
                if (city.isEmpty &&
                    addressComponents.types[0] ==
                        'administrative_area_level_2') {
                  city = addressComponents.longName;
                }
                if (addressComponents.types[0] ==
                    'administrative_area_level_1') {
                  state = addressComponents.longName;
                }
                if (addressComponents.types[0] == 'country') {
                  country = addressComponents.longName;
                }
                if (addressComponents.types[0] == 'postal_code') {
                  pinCode = addressComponents.longName;
                }
              }
              BlocProvider.of<SetAddressBloc>(context).add(SetAddressUser(
                  address: mPickResult.formattedAddress!.toString(),
                  city: city,
                  state: state,
                  country: country,
                  pinCode: pinCode,
                  placeId: provider?.selectedPlace?.placeId ?? ''));
            }
            return const SizedBox();
          } else {
            return Builder(
                builder: (builderContext) => widget.selectedPlaceWidgetBuilder!(
                    builderContext, data.item1, data.item2, data.item3));
          }
        }
      },
    );
  }
}

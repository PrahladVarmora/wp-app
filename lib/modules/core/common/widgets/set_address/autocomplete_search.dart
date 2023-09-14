import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/autocomplete_search_controller.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/place_picker.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/place_provider.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/prediction_tile.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/rounded_frame.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/search_provider.dart';

///[AutoCompleteSearch] this class class to Auto Complete Search
class AutoCompleteSearch extends StatefulWidget {
  const AutoCompleteSearch(
      {Key? key,
      required this.sessionToken,
      required this.onPicked,
      required this.appBarKey,
      this.hintText,
      this.searchingText,
      this.height = 60,
      this.contentPadding = EdgeInsets.zero,
      this.debounceMilliseconds,
      this.onSearchFailed,
      required this.searchBarController,
      this.autocompleteOffset,
      this.autocompleteRadius,
      this.autocompleteLanguage,
      this.autocompleteComponents,
      this.autocompleteTypes,
      this.strictbounds,
      this.region,
      this.initialSearchString,
      this.searchForInitialValue,
      this.autocompleteOnTrailingWhitespace})
      : super(key: key);

  final String? sessionToken;
  final String? hintText;
  final String? searchingText;
  final double height;
  final EdgeInsetsGeometry contentPadding;
  final int? debounceMilliseconds;
  final ValueChanged<Prediction> onPicked;
  final ValueChanged<String>? onSearchFailed;
  final SearchBarController searchBarController;
  final num? autocompleteOffset;
  final num? autocompleteRadius;
  final String? autocompleteLanguage;
  final List<String>? autocompleteTypes;
  final List<Component>? autocompleteComponents;
  final bool? strictbounds;
  final String? region;
  final GlobalKey appBarKey;
  final String? initialSearchString;
  final bool? searchForInitialValue;
  final bool? autocompleteOnTrailingWhitespace;

  @override
  AutoCompleteSearchState createState() => AutoCompleteSearchState();
}

class AutoCompleteSearchState extends State<AutoCompleteSearch> {
  TextEditingController controller = TextEditingController();
  FocusNode focus = FocusNode();
  OverlayEntry? overlayEntry;
  SearchProvider provider = SearchProvider();

  @override
  void initState() {
    super.initState();
    if (widget.initialSearchString != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.text = widget.initialSearchString!;
        if (widget.searchForInitialValue!) {
          _onSearchInputChange();
        }
      });
    }
    controller.addListener(_onSearchInputChange);
    focus.addListener(_onFocusChanged);

    widget.searchBarController.attach(this);
  }

  @override
  void dispose() {
    controller.removeListener(_onSearchInputChange);
    controller.dispose();

    focus.removeListener(_onFocusChanged);
    focus.dispose();
    _clearOverlay();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: RoundedFrame(
        height: widget.height,
        padding: const EdgeInsets.only(right: 10),
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black54
            : Colors.white,
        child: Row(
          children: <Widget>[
            const SizedBox(width: 10),
            const SizedBox(width: 10),
            Expanded(child: _buildSearchTextField()),
            _buildTextClearIcon(),
          ],
        ),
      ),
    );
  }

  ///[_buildSearchTextField] this method class to _build SearchTextField
  Widget _buildSearchTextField() {
    return TextField(
      controller: controller,
      onSubmitted: (val) {
        if (val.isEmpty) {}
      },
      focusNode: focus,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: InputBorder.none,
        isDense: true,
        contentPadding: widget.contentPadding,
      ),
    );
  }

  ///[_buildTextClearIcon] this method class to _build TextClearIcon
  Widget _buildTextClearIcon() {
    return Selector<SearchProvider, String>(
        selector: (_, provider) => provider.searchTerm,
        builder: (_, data, __) {
          if (data.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                child: Icon(
                  Icons.clear,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                onTap: () {
                  clearText();
                },
              ),
            );
          } else {
            return const SizedBox(width: 10);
          }
        });
  }

  ///[_onSearchInputChange] this method class to _onSearchInputChange
  _onSearchInputChange() {
    if (!mounted) return;
    this.provider.searchTerm = controller.text;

    PlaceProvider provider = PlaceProvider.of(context, listen: false);

    if (controller.text.isEmpty) {
      provider.debounceTimer?.cancel();
      _searchPlace(controller.text);
      return;
    }

    if (controller.text.trim() == this.provider.prevSearchTerm.trim()) {
      provider.debounceTimer?.cancel();
      return;
    }

    if (!widget.autocompleteOnTrailingWhitespace! &&
        controller.text.substring(controller.text.length - 1) == ' ') {
      provider.debounceTimer?.cancel();
      return;
    }

    if (provider.debounceTimer?.isActive ?? false) {
      provider.debounceTimer!.cancel();
    }

    provider.debounceTimer =
        Timer(Duration(milliseconds: widget.debounceMilliseconds!), () {
      _searchPlace(controller.text.trim());
    });
  }

  ///[_onFocusChanged] this method class to _onFocusChanged
  _onFocusChanged() {
    PlaceProvider provider = PlaceProvider.of(context, listen: false);
    provider.isSearchBarFocused = focus.hasFocus;
    provider.debounceTimer?.cancel();
    provider.placeSearchingState = SearchingState.ddle;
  }

  ///[_searchPlace] this method class to _searchPlace
  _searchPlace(String searchTerm) {
    provider.prevSearchTerm = searchTerm;

    _clearOverlay();

    if (searchTerm.isEmpty) return;

    _displayOverlay(_buildSearchingOverlay());

    _performAutoCompleteSearch(searchTerm);
  }

  ///[_clearOverlay] this method class to _clear Overlay
  _clearOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }

  ///[_displayOverlay] this method class to _display Overlay
  _displayOverlay(Widget overlayChild) {
    _clearOverlay();

    final RenderBox? appBarRenderBox =
        widget.appBarKey.currentContext!.findRenderObject() as RenderBox?;
    final screenWidth = MediaQuery.of(context).size.width;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: appBarRenderBox!.size.height + 55,
        left: screenWidth * 0.025,
        right: screenWidth * 0.025,
        child: Material(
          elevation: 4.0,
          child: overlayChild,
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  ///[_buildSearchingOverlay] this method class to _build SearchingOverlay
  Widget _buildSearchingOverlay() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Text(
              widget.searchingText ?? 'Searching...',
              style: const TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  ///[_buildPredictionOverlay] this method class to _build PredictionOverlay
  Widget _buildPredictionOverlay(List<Prediction> predictions) {
    return ListBody(
      children: predictions
          .map(
            (p) => PredictionTile(
              prediction: p,
              onTap: (selectedPrediction) {
                resetSearchBar();
                widget.onPicked(selectedPrediction);
              },
            ),
          )
          .toList(),
    );
  }

  ///[_performAutoCompleteSearch] this method class to _perform AutoCompleteSearch
  _performAutoCompleteSearch(String searchTerm) async {
    PlaceProvider provider = PlaceProvider.of(context, listen: false);

    if (searchTerm.isNotEmpty) {
      final PlacesAutocompleteResponse response =
          await provider.places.autocomplete(
        searchTerm,
        sessionToken: widget.sessionToken,
        location: provider.currentPosition == null
            ? null
            : Location(
                lat: provider.currentPosition!.latitude,
                lng: provider.currentPosition!.longitude),
        offset: widget.autocompleteOffset,
        radius: widget.autocompleteRadius,
        language: widget.autocompleteLanguage,
        types: widget.autocompleteTypes ?? const [],
        components: widget.autocompleteComponents ?? const [],
        strictbounds: widget.strictbounds ?? false,
        region: widget.region,
      );

      if (response.errorMessage?.isNotEmpty == true ||
          response.status == 'REQUEST_DENIED') {
        if (widget.onSearchFailed != null) {
          widget.onSearchFailed!(response.status);
        }
        return;
      }

      _displayOverlay(_buildPredictionOverlay(response.predictions));
    }
  }

  ///[clearText] this method class to clear Text
  clearText() {
    provider.searchTerm = '';
    controller.clear();
  }

  ///[resetSearchBar] this method class to reset SearchBar
  resetSearchBar() {
    clearText();
    focus.unfocus();
  }

  ///[clearOverlay] this method class to clear Overlay
  clearOverlay() {
    _clearOverlay();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/autocomplete_search.dart';

/// [SearchBarController] This class is used to SearchBarController
class SearchBarController extends ChangeNotifier {
  late AutoCompleteSearchState _autoCompleteSearch;

  attach(AutoCompleteSearchState searchWidget) {
    _autoCompleteSearch = searchWidget;
  }

  /// Just clears text.
  clear() {
    _autoCompleteSearch.clearText();
  }

  /// Clear and remove focus (Dismiss keyboard)
  reset() {
    _autoCompleteSearch.resetSearchBar();
  }

  clearOverlay() {
    _autoCompleteSearch.clearOverlay();
  }
}

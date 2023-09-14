import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// [SearchProvider] This class is used to Search Provider
class SearchProvider extends ChangeNotifier {
  static SearchProvider of(BuildContext context, {bool listen = true}) =>
      Provider.of<SearchProvider>(context, listen: listen);

  String prevSearchTerm = '';
  String _searchTerm = '';

  String get searchTerm => _searchTerm;

  set searchTerm(String newValue) {
    _searchTerm = newValue;
    notifyListeners();
  }
}

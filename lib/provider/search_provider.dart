import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchProvider extends ChangeNotifier {
   String _searchQuery = '';

  String get searchQuery => _searchQuery;

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}

final searchProvider = ChangeNotifierProvider((ref) {
  return SearchProvider();
});

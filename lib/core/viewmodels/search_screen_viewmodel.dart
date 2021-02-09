import 'package:flutter/material.dart';
import 'package:podcast_app/core/models/SearchResult.dart';
import 'package:podcast_app/core/networking/api_provider.dart';

class SearchViewModel extends ChangeNotifier {
  SearchResult result;

  getSearchResults({@required String query}) {
    ApiProvider().getSearchResults(query: query).then((value) {
      result = value;
      notifyListeners();
    });
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:podcast_app/core/models/GenresList.dart';
import 'package:podcast_app/core/models/PodcastEpisodes.dart';
import 'package:podcast_app/core/models/PodcastsFromGenre.dart';
import 'package:podcast_app/core/models/SearchResult.dart';

class ApiProvider{

  static const String baseURL = "https://listen-api.listennotes.com/api/v2";
  Map<String, String> headers = {
      'X-ListenAPI-Key': 'ccdd42c671f44176995ed8b9e83332de'
  };
Future<GenresList> getGenres({bool showTopLevelGenresOnly=true})async{
    final http.Response response = await http.get(baseURL+"/genres?top_level_only=1",headers: headers);
    log("Fetch Genre Response Code is:- ${response.statusCode}");
    if(response.statusCode == 200){
      return GenresList.fromJson(jsonDecode(response.body));
    }
    else log(response.body);
    return GenresList();
}

Future<GenresList> getGenresFromLocalStorage({@required BuildContext context})async{
  var genres = await DefaultAssetBundle.of(context).loadString('assets/json/genresList.json');
  return GenresList.fromJson(jsonDecode(genres));
}

Future<PodcastsFromGenre> getPodcastsFromGenreLocalStorage({@required BuildContext context})async{
  var genres = await DefaultAssetBundle.of(context).loadString('assets/json/podcastsFromGenre.json');
  return PodcastsFromGenre.fromJson(jsonDecode(genres));
}

  Future<PodcastEpisodes> getPodcastsEpisodesLocalStorage({@required BuildContext context})async{
    var genres = await DefaultAssetBundle.of(context).loadString('assets/json/episodes.json');
    return PodcastEpisodes.fromJson(jsonDecode(genres));
  }


  Future<SearchResult> getSearchResults({@required String query})async{
    final http.Response response = await http.get(baseURL+"/search?q=${query??""}&type=podcast}",headers:headers);

    if(response.statusCode==200){
      return SearchResult.fromJson(jsonDecode(response.body));
    }
    else log(response.body);
    return SearchResult();
  }


Future<PodcastsFromGenre> getPodcastsFromGenre({int genreID})async{
  final http.Response response = await http.get(baseURL+"/best_podcasts?genre_id=$genreID&safe_mode=0",headers: headers);
  log("Fetch Podcasts from Genre Response Code is:- ${response.statusCode}");
  if(response.statusCode == 200){
    print("getting response");
    return PodcastsFromGenre.fromJson(jsonDecode(response.body));
  }
  else
  return PodcastsFromGenre();
}

}
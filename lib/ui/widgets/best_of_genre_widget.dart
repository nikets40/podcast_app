import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:podcast_app/core/models/GenresList.dart';
import 'package:podcast_app/core/models/PodcastsFromGenre.dart';
import 'package:podcast_app/core/networking/api_provider.dart';
import 'package:podcast_app/ui/screens/podcasts_episodes_listing.dart';

class BestOfGenresListing extends StatelessWidget {
  final Genres genre;

  BestOfGenresListing({this.genre});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            genre.name,
            textScaleFactor: 2,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 240,
            child: FutureBuilder<PodcastsFromGenre>(
                // future: ApiProvider().getPodcastsFromGenre(genreID: genre.id),
                future: ApiProvider().getPodcastsFromGenreLocalStorage(context: context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    PodcastsFromGenre podcasts = snapshot.data;
                    podcasts.podcasts.shuffle();
                    return ListView.separated(
                        separatorBuilder: (ctx, idx) => SizedBox(
                              width: 20,
                            ),
                        itemCount: podcasts?.podcasts?.length ?? 0,
                        shrinkWrap: true,
                        cacheExtent: 2000,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) {
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>PodcastsEpisodesListing(podcastData: podcasts.podcasts[index],)));
                              },
                              child: SizedBox(
                                width: 140,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top:20.0),
                                      child: Container(
                                        height: 140,
                                        width: 140,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                                fit: BoxFit.contain,
                                                image: CachedNetworkImageProvider(
                                                    podcasts
                                                        .podcasts[index].image))),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text(
                                      podcasts.podcasts[index].title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textScaleFactor: 1.3,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      _parseHtmlString(
                                          podcasts.podcasts[index].description),
                                      textScaleFactor: 0.8,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }
                  return Container();
                }),
          )
        ],
      ),
    );
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }
}

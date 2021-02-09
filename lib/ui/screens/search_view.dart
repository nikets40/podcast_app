import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcast_app/core/models/PodcastsFromGenre.dart';
import 'package:podcast_app/core/models/SearchResult.dart';
import 'package:podcast_app/core/viewmodels/search_screen_viewmodel.dart';
import 'package:podcast_app/ui/screens/podcasts_episodes_listing.dart';
import 'package:podcast_app/ui/widgets/bottom_mini_player.dart';
import 'package:provider/provider.dart';

class SearchScreenView extends StatefulWidget {
  @override
  _SearchScreenViewState createState() => _SearchScreenViewState();
}

class _SearchScreenViewState extends State<SearchScreenView> {
  TextEditingController searchTextController = new TextEditingController();
  SearchViewModel searchViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchViewModel = new SearchViewModel();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchViewModel.dispose();
    searchTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: searchViewModel,
        child: Consumer<SearchViewModel>(
          builder: (context, model, child) {
            return Scaffold(
              backgroundColor: Color(0xff121212),
              bottomNavigationBar: BottomMiniPLayer(),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: TextField(
                  autofocus: true,
                  onChanged: (val) {
                    if (val.length <=1)
                      setState(() {
                        model.result = new SearchResult();
                      });
                    else
                      model.getSearchResults(query: val);
                  },
                  controller: searchTextController,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration.collapsed(hintText: "Search"),
                ),
                actions: [
                  Visibility(
                      visible: searchTextController.text.length > 0,
                      child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              searchTextController.clear();
                              model.result = new SearchResult();
                            });
                          }))
                ],
              ),
              body: Container(
                child: (model.result != null &&
                        (model?.result?.results?.length ?? 0) > 0)
                    ? ListView.separated(
                        padding: EdgeInsets.only(top: 10),
                        separatorBuilder: (ctx, idx) => Divider(),
                        itemCount: model.result.count,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              var podcastData = new Podcasts();
                              podcastData.title = model.result.results[index].titleOriginal;
                              podcastData.description = model.result.results[index].descriptionOriginal;
                              podcastData.image = model.result.results[index].image;
                              podcastData.publisher = model.result.results[index].publisherOriginal;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => PodcastsEpisodesListing(
                                           podcastData:  podcastData,
                                          )));
                            },
                            leading: Hero(
                              tag: model?.result?.results[index]?.id ??
                                  UniqueKey().toString(),
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: CachedNetworkImageProvider(
                                            model.result.results[index].image)),
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                            title:
                                Text(model.result.results[index].titleOriginal),
                            subtitle: Text(
                              model.result.results[index].descriptionOriginal,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        })
                    : Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, left: 10, right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   "Recent Searches",
                            //   textScaleFactor: 1.6,
                            //   style: TextStyle(
                            //       fontWeight: FontWeight.w600),
                            // ),
                            Expanded(
                                child: Center(
                                    child: Padding(
                              padding: const EdgeInsets.only(bottom: 35.0),
                              child: Text(
                                "Nothing to show here...",
                                textScaleFactor: 1.3,
                              ),
                            )))
                          ],
                        ),
                      ),
              ),
            );
          },
        ));
  }
}

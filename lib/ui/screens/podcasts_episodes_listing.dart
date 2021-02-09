import 'dart:developer';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcast_app/core/models/PodcastEpisodes.dart';
import 'package:podcast_app/core/models/PodcastsFromGenre.dart';
import 'package:podcast_app/core/networking/api_provider.dart';
import 'package:podcast_app/core/services/audio_streaming_service.dart';
import 'package:podcast_app/core/services/pick_accent_color_service.dart';
import 'package:podcast_app/core/services/utils.dart';
import 'package:podcast_app/ui/screens/episode_details.dart';
import 'package:podcast_app/ui/widgets/bottom_mini_player.dart';

Future<void> _entrypoint() async =>
    await AudioServiceBackground.run(() => AudioPlayerTask());

class PodcastsEpisodesListing extends StatefulWidget {
  final Podcasts podcastData;

  PodcastsEpisodesListing({@required this.podcastData});

  @override
  _PodcastsEpisodesListingState createState() =>
      _PodcastsEpisodesListingState();
}

class _PodcastsEpisodesListingState extends State<PodcastsEpisodesListing> {
  Color accentColor = Colors.black;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setBackground();
  }

  void setBackground() async {
    PickAccentColor.instance
        .getAccentColor(CachedNetworkImageProvider(widget.podcastData.image))
        .then((color) {
      setState(() {
        accentColor = color;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
          gradient: new LinearGradient(
        colors: [
          accentColor,
          Color(0xff020202),
        ],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(0.0, 1.0),
        stops: [0.0, 1.0],
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: BottomMiniPLayer(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            widget?.podcastData?.title ?? "Podcast",
          ),
          centerTitle: true,
          titleSpacing: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                                image: widget.podcastData.image != null
                                    ? DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            widget.podcastData.image))
                                    : null,
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.red),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.podcastData.title,
                                  textScaleFactor: 1.6,
                                  maxLines: 5,
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  widget.podcastData.publisher,
                                  textScaleFactor: 1.2,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(Utils.instance.parsedHtml(
                          htmlString: widget.podcastData.description)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Text(
                  "Episodes",
                  textScaleFactor: 1.6,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 15,
                ),
                StreamBuilder<MediaItem>(
                  stream: AudioService.currentMediaItemStream,
                  builder: (context, snapshot) {
                    MediaItem mediaItem = snapshot.data;
                    return FutureBuilder<PodcastEpisodes>(
                        future: ApiProvider()
                            .getPodcastsEpisodesLocalStorage(context: context),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var episodes = snapshot.data.episodes;
                            return ListView.separated(
                                separatorBuilder: (_, __) => Divider(),
                                itemCount: episodes.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (ctx, index) {
                                  return InkWell(
                                    onLongPress: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>EpisodeDetails(episodeData: episodes[index],)));
                                    },
                                    onTap: () async {
                                      log(episodes[index].audio);
                                      log(episodes[index].title);
                                      log(snapshot.data.publisher);
                                      log(episodes[index].thumbnail);
                                      if (Platform.isIOS && AudioService.running)
                                        await AudioService.stop();
                                      else if (Platform.isAndroid)
                                        await AudioService.stop();
                                      await AudioService.start(
                                        backgroundTaskEntrypoint: _entrypoint,
                                        androidNotificationChannelName:
                                            'Audio Service Demo',
                                        androidNotificationColor: 0xff121212,
                                        // androidNotificationColor: 0xff000080,
                                        androidNotificationIcon:
                                            'mipmap/ic_launcher',
                                        androidEnableQueue: true,
                                        // androidNotificationOngoing: true,
                                        // fastForwardInterval:
                                        //     Duration(seconds: 10),
                                        params: {
                                          'url': episodes[index].audio,
                                          'title': episodes[index].title,
                                          'album': snapshot.data.publisher,
                                          'artUri': episodes[index].thumbnail,
                                          'duration':
                                              episodes[index].audioLengthSec,
                                          'id':episodes[index].id
                                        },
                                      );
                                    },
                                    child: Card(
                                      elevation: 10,
                                      color: Color(0xff535353).withOpacity(0.5),
                                      margin: null,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 7),
                                        child: Column(
                                          children: [
                                            ListTile(
                                              contentPadding: EdgeInsets.all(0),
                                              leading: AspectRatio(
                                                aspectRatio: 1,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.redAccent,
                                                      image: DecorationImage(
                                                          image:
                                                              CachedNetworkImageProvider(
                                                                  episodes[index]
                                                                      .image),
                                                          fit: BoxFit.cover),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                ),
                                              ),
                                              title: Text(
                                                episodes[index].title,
                                                maxLines:
                                                    2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: ((mediaItem?.id??"")==episodes[index].audio)?Colors.greenAccent:Colors.white,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              subtitle:
                                                  Text(widget.podcastData.title),
                                            ),
                                            Text(
                                              Utils.instance.parsedHtml(
                                                  htmlString:
                                                      episodes[index].description),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  TextStyle(color: Colors.white70),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Text(Utils.instance
                                                      .formattedReleasedDate(
                                                          milliseconds:
                                                              episodes[index]
                                                                  .pubDateMs) +
                                                  "  |  ${Utils.instance.formattedTime(episodes[index].audioLengthSec)}   "),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          }
                          return CircularProgressIndicator();
                        });
                  }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

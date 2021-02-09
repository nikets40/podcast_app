import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcast_app/core/models/PodcastEpisodes.dart';
import 'package:podcast_app/core/services/pick_accent_color_service.dart';
import 'package:podcast_app/core/services/utils.dart';
import 'package:podcast_app/ui/widgets/bottom_mini_player.dart';

class EpisodeDetails extends StatefulWidget {
  final EpisodeData episodeData;

  EpisodeDetails({@required this.episodeData});

  @override
  _EpisodeDetailsState createState() => _EpisodeDetailsState();
}

class _EpisodeDetailsState extends State<EpisodeDetails> {
  var accentColor = Colors.black;

  void setBackground() async {
    PickAccentColor.instance
        .getAccentColor(CachedNetworkImageProvider(widget.episodeData.image))
        .then((color) {
      setState(() {
        accentColor = color;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setBackground();
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
        end: const FractionalOffset(0.0, 1),
        stops: [0.0, 1.0],
      )),
      child: Scaffold(
        bottomNavigationBar: BottomMiniPLayer(),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            widget.episodeData.thumbnail))),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.episodeData.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),

              SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(Utils.instance.formattedReleasedDate(milliseconds: widget.episodeData.pubDateMs)),
                  Text(" | "),
                  Text(Utils.instance.formattedTime(widget.episodeData.audioLengthSec)),
                  SizedBox(width: 20,),
                  Container(
                    width: 100,
                    height: 4,
                    color: Colors.white10,
                    child: Padding(
                      padding: EdgeInsets.only(right:40.0),
                      child: Container(width: 40,height: 4,color: accentColor,),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  TextButton(
                    // color: Color(0xff00BD44),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 7,horizontal: 40),
                        child: Text("PLAY",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16,color: accentColor),),
                      )),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(Utils.instance
                  .parsedHtml(htmlString: widget.episodeData.description),style: TextStyle(fontSize: 14,color: Colors.white.withOpacity(0.9)),),
            ],
          ),
        ),
      ),
    );
  }
}

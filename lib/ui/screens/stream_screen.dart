import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';
import 'package:podcast_app/core/services/pick_accent_color_service.dart';

class StreamScreen extends StatefulWidget {
  @override
  _StreamScreenState createState() => _StreamScreenState();
}

class _StreamScreenState extends State<StreamScreen> {
  Color accentColor = Colors.black;
  var maxTime;
  int currentTime=00;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setBackground();
    maxTime = AudioService.currentMediaItem.duration.inSeconds;
  }

  void setBackground() async {
    PickAccentColor.instance
        .getAccentColor(
            CachedNetworkImageProvider(AudioService.currentMediaItem.artUri))
        .then((color) {
      setState(() {
        accentColor = color;
      });
    });
  }

  seekPlayer({@required int seconds}) async {

   await AudioService.positionStream.last.then((value) =>
        AudioService.seekTo(Duration(seconds: value.inSeconds + seconds)));
    if(!AudioService.playbackState.playing){
      setState(() {
        currentTime = currentTime+seconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            accentColor,
            Colors.black,
          ],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
          stops: [0.0, 1],
        )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Column(
              children: [
                Text(
                  "Playing From Publisher".toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                ),
                Text(AudioService.currentMediaItem.album ?? "",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
              ],
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: CachedNetworkImageProvider(
                                  AudioService.currentMediaItem.artUri))),
                    ),
                  ),
                ),

                Spacer(),

                SizedBox(
                  height: kToolbarHeight / 1.5,
                  child: Marquee(
                    text: AudioService.currentMediaItem.title,
                    fadingEdgeEndFraction: 0.5,
                    fadingEdgeStartFraction: 0.2,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                    scrollAxis: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    blankSpace: 20.0,
                    velocity: 100.0,
                    pauseAfterRound: Duration(seconds: 5),
                    startPadding: 10.0,
                    accelerationDuration: Duration(seconds: 1),
                    accelerationCurve: Curves.linear,
                    decelerationDuration: Duration(milliseconds: 500),
                    decelerationCurve: Curves.easeOut,
                  ),
                ),

                // Marquee(text: widget.data.title),
                Text(
                  AudioService?.currentMediaItem?.album ?? "",
                  textScaleFactor: 1.3,
                  style: TextStyle(color: Colors.white54),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: StreamBuilder<Duration>(
                      stream: AudioService.positionStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          currentTime = snapshot.data.inSeconds;
                          String currentPositionTime =
                              "${(currentTime/60).floor().remainder(60).toString().padLeft(2,'0')}:${(currentTime.remainder(60)).toString().padLeft(2,'0')}";
                          String maxPositionTime =
                              "${Duration(seconds: maxTime).inMinutes.remainder(60).toString().padLeft(2,'0')}:${(Duration(seconds: maxTime).inSeconds.remainder(60)).toString().padLeft(2,'0')}";

                          // print(currentPositionTime);
                          return Row(
                            children: [
                              Text(currentPositionTime),
                              Expanded(
                                child: Slider(
                                    activeColor: accentColor,
                                    inactiveColor: Colors.white12,
                                    min: 0,
                                    max: maxTime.toDouble(),
                                    value: snapshot.data.inSeconds.toDouble(),
                                    onChanged: (val) {
                                      AudioService.seekTo(
                                          Duration(seconds: val.toInt()));
                                    }),
                              ),
                              Text("$maxPositionTime")
                            ],
                          );
                        }
                        return Slider(
                          activeColor: accentColor,
                          inactiveColor: Colors.white12,
                          min: 0,
                          max: 100,
                          value: 0,
                          onChanged: null,
                        );
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                StreamBuilder<PlaybackState>(
                    stream: AudioService.playbackStateStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var playbackState = snapshot.data;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Icon(
                            //   Icons.chevron_left,
                            //   size: 70,
                            // ),
                            InkWell(
                                borderRadius: BorderRadius.circular(100),
                                onTap: () {
                                  seekPlayer(seconds: -10);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    'assets/svg/replay_10.svg',
                                    color: Colors.white,
                                    height: 50,
                                  ),
                                )),
                            if (!playbackState.playing)
                              GestureDetector(
                                onTap: () async {
                                  AudioService.play();
                                },
                                child: Icon(
                                  Icons.play_circle_fill,
                                  size: 100,
                                ),
                              ),
                            if (playbackState.playing)
                              GestureDetector(
                                onTap: () async {
                                  AudioService.pause();
                                },
                                child: Icon(
                                  Icons.pause_circle_filled,
                                  size: 100,
                                ),
                              ),
                            InkWell(
                                borderRadius: BorderRadius.circular(100),
                                onTap: () {
                                  seekPlayer(seconds: 10);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    'assets/svg/forward_10.svg',
                                    color: Colors.white,
                                    height: 50,
                                  ),
                                )),
                            // Icon(
                            //   Icons.chevron_right,
                            //   size: 70,
                            // ),
                          ],
                        );
                      } else
                        return Container();
                    }),
                Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:podcast_app/ui/screens/stream_screen.dart';

class BottomMiniPLayer extends StatefulWidget {
  @override
  _BottomMiniPLayerState createState() => _BottomMiniPLayerState();
}

class _BottomMiniPLayerState extends State<BottomMiniPLayer>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem>(
        stream: AudioService.currentMediaItemStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            MediaItem mediaItem = snapshot.data;
            return SafeArea(
              child: Container(
                height: kToolbarHeight * 1.5,
                color: Colors.black.withOpacity(0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    StreamBuilder<Duration>(
                        stream: AudioService.positionStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData){
                            return Container(
                              width: 0,
                              height: 0,
                            );
                          }
                          var data = snapshot.data;
                          var currentTimeSeconds = data.inSeconds;
                          var totalDuration = mediaItem.duration.inSeconds;
                          return Container(
                            height: 5,
                            color: Colors.white,
                            width: currentTimeSeconds/totalDuration*
                                MediaQuery.of(context).size.width,
                          );
                        }),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>StreamScreen()));
                        },
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: snapshot.data.artUri,
                            ),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: kToolbarHeight * 0.5,
                                    child: Marquee(
                                      text: snapshot.data.title,
                                      fadingEdgeEndFraction: 0.2,
                                      showFadingOnlyWhenScrolling: false,
                                      numberOfRounds: 2,
                                      startAfter: Duration(seconds: 2),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: kToolbarHeight * 0.3),
                                    )),
                                Text(
                                  snapshot.data.album,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.9)),
                                )
                              ],
                            )),
                            StreamBuilder<PlaybackState>(
                                stream: AudioService.playbackStateStream,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData|| snapshot.data.processingState==AudioProcessingState.connecting)
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal:8.0),
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                      ),
                                    );

                                  if (snapshot.data.playing) {
                                    _controller.reverse();
                                  } else
                                    _controller.forward();
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal:8.0),
                                    child: IconButton(
                                        icon: AnimatedIcon(
                                          icon: AnimatedIcons.pause_play,
                                          progress: _controller,
                                          color: Colors.white,
                                        ),
                                        iconSize: kToolbarHeight * 1,
                                        onPressed: () {
                                          if (snapshot.data.playing) {
                                            _controller.forward();
                                            AudioService.pause();
                                          } else {
                                            _controller.reverse();
                                            AudioService.play();
                                          }
                                        }),
                                  );
                                }),
                            InkWell(
                                onTap: AudioService.stop,
                                child: Icon(Icons.stop,size: kToolbarHeight,))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else
            return Container(
              height: 0,
            );
        });
  }
}

import 'dart:async';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';


class AudioPlayerTask extends BackgroundAudioTask {
  final _player = AudioPlayer(); // e.g. just_audio
  Completer _completer = Completer();

  onPlay() => _player.play();
  onPause() => _player.pause();
  onSeekTo(Duration duration) => _player.seek(duration);
  onSetSpeed(double speed) => _player.setSpeed(speed);

  onStart(Map<String, dynamic> params) async {
    final mediaItem = MediaItem(
        id: params['url'],
        album: params['album'],
        title: params['title'],
        artUri: params['artUri'],
        duration: Duration(seconds: params['duration'])
    );

    // Tell the UI and media notification what we're playing.
    AudioServiceBackground.setMediaItem(mediaItem);
    // Listen to state changes on the player...
    _player.playbackEventStream.listen((event) {
      AudioServiceBackground.setState(
        playing: _player.playing,
        position: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
      );
    });
    _player.positionStream.listen((event) {
      AudioServiceBackground.setState(
        playing: _player.playing,
        position: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
      );
    });

    _player.playerStateStream.listen((playerState) {
      // ... and forward them to all audio_service clients.
      AudioServiceBackground.setState(
        playing: playerState.playing,
        // Every state from the audio player gets mapped onto an audio_service state.
        processingState: {
          ProcessingState.idle: AudioProcessingState.none,
          ProcessingState.loading: AudioProcessingState.connecting,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[playerState.processingState],
        // Tell clients what buttons/controls should be enabled in the
        // current state.
        controls: [
          MediaControl.rewind,
          playerState.playing ? MediaControl.pause : MediaControl.play,
          MediaControl.stop,
          MediaControl.fastForward,
        ],
        systemActions: [
          MediaAction.seekTo,
          MediaAction.playPause,
        ],
        androidCompactActions: [0, 1, 3],
        updateTime: DateTime.now(),
        position: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
      );
    });
    // Play when ready.
    _player.play();
    // Start loading something (will play when ready).
    await _player.setUrl(mediaItem.id);

    _completer.complete();
  }

  Duration getPosition(){
   return _player.position;
  }

  onStop() async {
    log("onStop method called");
    // Stop and dispose of the player.
    await _player.dispose();
    log("player disposed");
    // Shut down the background task.
    await super.onStop();
    log("onStop method completed");
  }

  @override
  Future<void> onTaskRemoved() {
    // TODO: implement onTaskRemoved
    onStop();
    return super.onTaskRemoved();
  }

}





import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import '../../audioPlayerPage.dart';
import '../../class/book.dart';
import '../../main.dart';

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.audio',
      androidNotificationChannelName: 'Audio Service Demo',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(
      children: []);

  MyAudioHandler() {
    _loadEmptyPlaylist();
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
    _listenForSequenceStateChanges();
  }

  Future<void> _loadEmptyPlaylist() async {
    try {
      await _player.setAudioSource(_playlist);
    } catch (e) {
      print("Error: $e");
    }
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        repeatMode: const {
          LoopMode.off: AudioServiceRepeatMode.none,
          LoopMode.one: AudioServiceRepeatMode.one,
          LoopMode.all: AudioServiceRepeatMode.all,
        }[_player.loopMode]!,
        shuffleMode: (_player.shuffleModeEnabled)
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }

  void _listenForDurationChanges() {
    _player.durationStream.listen((duration) {
      var index = _player.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices!.indexOf(index);
      }
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    });
  }

  void _listenForCurrentSongIndexChanges() {
    _player.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices!.indexOf(index);
      }
      mediaItem.add(playlist[index]);
    });
  }

  void _listenForSequenceStateChanges() {
    _player.sequenceStateStream.listen((SequenceState? sequenceState) {
      final sequence = sequenceState?.effectiveSequence;
      if (sequence == null || sequence.isEmpty) return;
      final items = sequence.map((source) => source.tag as MediaItem);
      queue.add(items.toList());
    });
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    // manage Just Audio
    final audioSource = mediaItems.map(_createAudioSource);
    _playlist.addAll(audioSource.toList());

    // notify system
    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {

    final MediaItem media = MediaItem(
      id: mediaItem.id,
      title: mediaItem.title,
      artUri: mediaItem.artUri,
      album: mediaItem.album,
      extras: mediaItem.extras,
    );

    // manage Just Audio
    UriAudioSource audioSource;
    if(mediaItem.playable == false) {
      audioSource = _createAudioSource(media);
      _playlist.clear();
      _loadEmptyPlaylist();
      _playlist.add(audioSource);

    }else{
      _playlist.clear();
      _player.setAudioSource(AudioSource.uri(Uri.parse(mediaItem.extras!['url'] as String),tag: media),preload: true,);

    }


    // notify system
    final newQueue = queue.value..add(media);
    queue.add(newQueue);
  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) {

    return AudioSource.uri(
      Uri.parse(mediaItem.extras!['url'] as String),
      tag: mediaItem,
    );


  }


  @override
  Future<void> removeQueueItemAt(int index) async {
    // manage Just Audio
    _playlist.removeAt(index);

    // notify system
    final newQueue = queue.value..removeAt(index);
    queue.add(newQueue);
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    if (_player.shuffleModeEnabled) {
      index = _player.shuffleIndices![index];
    }
    _player.seek(Duration.zero, index: index);
  }

  @override
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);


  @override
  Future<void> skipToNext() async {
    if(pageManager.progressNotifier.value.current >  Duration(seconds: pageManager.progressNotifier.value.total.inSeconds - AudioPlayerPage.seekValue.inSeconds)){

      _player.seek( Duration(seconds: pageManager.progressNotifier.value.total.inSeconds));
    }else{
      _player.seek( Duration(seconds: (pageManager.progressNotifier.value.current.inSeconds +AudioPlayerPage.seekValue.inSeconds)));
    }
  }

  @override
  Future<void> skipToPrevious() async {
    if(pageManager.progressNotifier.value.current < AudioPlayerPage.seekValue){
      _player.seek( const Duration(seconds: 0));
    }else{
      _player.seek(Duration(seconds: pageManager.progressNotifier.value.current.inSeconds -AudioPlayerPage.seekValue.inSeconds));
    }
  }




  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'dispose') {
      await _player.dispose();
      super.stop();
    }
  }
  

  Future<void> setUrl(String url) async {
    _player.setUrl(url);
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }
}

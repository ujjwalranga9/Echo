import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';

import '../audioPlayerPage.dart';
import '../class/book.dart';
import '../main.dart';
import '../services/download.dart';
import 'notifier/play_button_notifier.dart';
import 'notifier/progress_notifier.dart';


class PageManager {
  final currentSongTitleNotifier = ValueNotifier<String>('');
  final playlistNotifier = ValueNotifier<List<String>>([]);
  final progressNotifier = ProgressNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);

  late AudioPlayer _audioPlayer;
  late ConcatenatingAudioSource _playlist;
  late Book book;

  PageManager(this.book) {
    init();
  }
  void setSpeed(double speed){
    _audioPlayer.setSpeed(speed);

  }
  void init() async {
    _audioPlayer = AudioPlayer();
    _setInitialPlaylist();
    _listenForChangesInPlayerState();
    _listenForChangesInPlayerPosition();
    _listenForChangesInBufferedPosition();
    _listenForChangesInTotalDuration();
  }

  void _setInitialPlaylist() async {

    _playlist = ConcatenatingAudioSource(
        children: book.audio.map((e) {
          return AudioSource.uri(Uri.parse(e),
              tag: MediaItem(
            // Specify a unique ID for each media item:
            id: book.id,
            // Metadata to display in the notification:
            album: book.getAuthor(),
            title: book.getBookName(),
            artUri: Uri.parse(book.getImage()),
          ));
        }).toList());

    await _audioPlayer.setAudioSource(_playlist);

  }


  Future<void> setUrl(String url) async {

      await _audioPlayer.setUrl(url);


  }
  void _listenForChangesInPlayerState() {
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });
  }

  void _listenForChangesInPlayerPosition() {
    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenForChangesInBufferedPosition(){
    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenForChangesInTotalDuration() {
    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void setBook(Book book) async {
   this.book = book;
   _setInitialPlaylist();
  }
   Future<String> duration() async {

    return _audioPlayer.duration.toString();
  }

  void play() async {

     _audioPlayer.play();
  }

  void pause() {

    _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void dispose() {
    _audioPlayer.dispose();
  }


  void onPreviousSongButtonPressed() {
    _audioPlayer.seekToPrevious();
  }

  void onNextSongButtonPressed() {
    _audioPlayer.seekToNext();
  }

  void setAsset(String s) {
    final dir = externalDirectory;
    final filePath = '${dir.path}/$s.mp3';
    print(filePath);
    _audioPlayer.setFilePath(filePath);
  }
}

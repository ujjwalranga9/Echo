import 'package:audio_service/audio_service.dart';
import 'package:echo/player/audioService/playlist_repository.dart';
import 'package:hive/hive.dart';
import '../../class/book.dart';
import '../page_manager.dart';
import 'audio_handler.dart';

import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // services
  getIt.registerSingleton<AudioHandler>(await initAudioService());
  getIt.registerLazySingleton<PlaylistRepository>(() => DemoPlaylist());
  var box = Hive.box<Book>('play');
  // page state
  getIt.registerLazySingleton<PageManager>(() => PageManager(box.getAt(0)!));
}

import 'package:just_audio/just_audio.dart';

final AudioPlayer globalPlayer = AudioPlayer();

Future<void> initGlobalPlayer() async {
  await globalPlayer.setLoopMode(LoopMode.off);

}
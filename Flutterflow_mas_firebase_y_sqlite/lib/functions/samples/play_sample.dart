// functions/samples/play_sample.dart
import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import '../../controladores/mongo_connection.dart';
import '../../pages/provider/globar_player.dart';

Timer? _echoTimer;

Future<File> _getTempAudioFile(Uint8List bytes) async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/temp_sample.mp3');
  await file.writeAsBytes(bytes, flush: true);
  return file;
}

Future<void> playSample(
    DatabaseService dbService,
    dynamic sampleId,
    ) async {
  try {
    print('Intentando reproducir sample ID: $sampleId (tipo: ${sampleId.runtimeType})');

    final collection = await dbService.collection('samples');

    final doc = await collection.findOne(
      where.eq('id', sampleId),
    );

    if (doc == null) {
      print('Sample no encontrado: $sampleId');
      return;
    }

    final binary = doc['sample'];
    if (binary == null || binary is! BsonBinary) {
      print('Campo "sample" no encontrado o no es BsonBinary');
      return;
    }

    final audioBytes = binary.byteList;

    if (globalPlayer.playing) {
      await globalPlayer.pause();
    }

    final file = await _getTempAudioFile(audioBytes);
    await globalPlayer.setFilePath(file.path);
    await globalPlayer.play();

    print('Reproducción iniciada OK para ID: $sampleId');
  } catch (e, stack) {
    print('Error grave al reproducir sample $sampleId: $e');
    print('Stack trace: $stack');
  }
}

Future<void> setPlaybackSpeed(double speed) async {
  try {
    await globalPlayer.setSpeed(speed);
    print('Velocidad cambiada a $speed');
  } catch (e) {
    print('Error al cambiar velocidad: $e');
  }
}

Future<void> enableEcho() async {
  try {
    _echoTimer?.cancel();

    _echoTimer = Timer.periodic(
      const Duration(milliseconds: 450), // retardo del eco
          (timer) async {
        if (!globalPlayer.playing) return;

        final pos = globalPlayer.position;
        final vol = globalPlayer.volume;

        // baja un poco el volumen del "eco"
        await globalPlayer.setVolume((vol * 0.85).clamp(0.0, 1.0));
        await globalPlayer.seek(pos);
      },
    );

    print('Eco activado');
  } catch (e) {
    print('Error al activar eco: $e');
  }
}

Future<void> disableEcho() async {
  try {
    _echoTimer?.cancel();
    _echoTimer = null;
    await globalPlayer.setVolume(1.0);
    print('Eco desactivado');
  } catch (e) {
    print('Error al desactivar eco: $e');
  }
}
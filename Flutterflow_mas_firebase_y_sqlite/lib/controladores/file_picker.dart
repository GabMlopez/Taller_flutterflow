import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

Future<Uint8List?> seleccionarMusica() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.audio,
    withData: true,
  );

  if (result != null && result.files.single.bytes != null) {
    return result.files.single.bytes!;
  }

  return null;
}
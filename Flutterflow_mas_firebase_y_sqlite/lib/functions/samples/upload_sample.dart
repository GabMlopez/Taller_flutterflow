  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:mongo_dart/mongo_dart.dart';
  import 'package:provider/provider.dart';
  import 'dart:typed_data';
  import '../../controladores/file_picker.dart';
  import '../../controladores/mongo_connection.dart';
  import '../../pages/provider/user_provider.dart';

  Future<void> uploadSample(BuildContext context) async {
    final Uint8List? audioBytes = await seleccionarMusica();
    if (audioBytes == null) return;

    final user = context.read<UserProvider>().user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario no autenticado')),
      );
      return;
    }

    String? sampleName;
    await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Nombre del sample'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Ej: Guitar Riff 2025',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                sampleName = controller.text.trim();
                if (sampleName == null || sampleName!.isEmpty) {
                  sampleName = 'Sample sin nombre';
                }
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (sampleName == null) return;

    final dbService = context.read<DatabaseService>();
    final collection = await dbService.collection('samples');

    await collection.insert({
      'id': DateTime.now().millisecondsSinceEpoch,
      'nombre': sampleName,
      'sample': BsonBinary.from(audioBytes),
      'favorito': false,
      'id_usuario': user.id,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sample "$sampleName" subido exitosamente')),
    );
  }


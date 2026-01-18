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

      // 1. Validar tamaño (Límite práctico para evitar crashes de RAM)
      final double sizeInMb = audioBytes.lengthInBytes / (1024 * 1024);
      if (sizeInMb > 14) { // Dejamos margen por debajo de los 16MB de Mongo
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Archivo demasiado grande para la base de datos (Máx 14MB)')),
          );
        }
        return;
      }

      final user = context.read<UserProvider>().user;
      if (user == null) return;

      final String? nombreFinal = await showDialog<String>(
        context: context,
        builder: (context) {
          final controller = TextEditingController();
          return AlertDialog(
            title: const Text('Nombre del sample'),
            content: TextField(controller: controller, autofocus: true),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
              TextButton(
                onPressed: () => Navigator.pop(context, controller.text.trim()),
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      );

      if (nombreFinal == null || nombreFinal.isEmpty) return;

      print(">>> INICIANDO SUBIDA A COLECCIÓN 'samples' <<<");

      try {
        final dbService = context.read<DatabaseService>();
        // Usamos el método collection que ya tienes en tu DatabaseService
        final collection = await dbService.collection('samples');

        final docParaInsertar = {
          'id': DateTime.now().millisecondsSinceEpoch,
          'nombre': nombreFinal,
          'sample': BsonBinary.from(audioBytes), // Aquí es donde ocurre el pico de RAM
          'favorito': false,
          'id_usuario': user.id,
        };

        // Usamos WriteConcern.ACKNOWLEDGED para asegurarnos que Mongo responda
        final result = await collection.insertOne(docParaInsertar, writeConcern: WriteConcern.ACKNOWLEDGED);

        if (result.isSuccess) {
          print(">>> ¡GUARDADO EN MONGODB EXITOSAMENTE! <<<");
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Sample "$nombreFinal" subido correctamente')),
            );
          }
        } else {
          print(">>> ERROR DE MONGO: ${result.errmsg} <<<");
        }
      } catch (e) {
        print(">>> EXCEPCIÓN DURANTE LA SUBIDA: $e <<<");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error crítico al subir a la base de datos')),
          );
        }
      }
    }
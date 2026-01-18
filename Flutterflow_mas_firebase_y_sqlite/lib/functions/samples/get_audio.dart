import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:provider/provider.dart';
import '../../controladores/mongo_connection.dart';
import '../../pages/provider/user_provider.dart';
import '../sqlite/local_controller.dart';

Future<List<Map<String, dynamic>>> getSamplesFromMongo(BuildContext context) async {
  final user = context.read<UserProvider>().user;
  if (user == null) return [];

  final dbService = context.read<DatabaseService>();
  final collection = await dbService.collection('samples');

  final selector = where.eq('id_usuario', user.id).excludeFields(['sample']);
  final lista = await collection.find(selector).toList();

  return lista;
}

Future<List<Map<String, dynamic>>> getSamples(BuildContext context) async {
  final user = context.read<UserProvider>().user;
  if (user == null) return [];

  print(">>> Intentando cargar de MongoDB para usuario: ${user.id}");

  try {
    final dbService = context.read<DatabaseService>();
    final db = await dbService.db;

    if (!db.isConnected) {
      await db.open();
    }

    final collection = db.collection('samples');

    final selector = where.eq('id_usuario', user.id).excludeFields(['sample']);
    final mongoData = await collection.find(selector).toList().timeout(const Duration(seconds: 10));

    print(">>> MongoDB respondió con ${mongoData.length} samples");

    if (mongoData.isNotEmpty) {
      await updateLocalCache(mongoData.take(10).toList());
      return mongoData;
    } else {
      print(">>> MongoDB conectado pero la colección está vacía para este usuario.");
    }
  } catch (e) {
    print(">>> Falló MongoDB: $e");
  }

  print(">>> Cargando desde SQLite por falla o falta de datos en Mongo...");
  return await getLocalSamples(user.id);
}

Future<void> _syncLocalCache(List<Map<String, dynamic>> samples) async {
}

Future<List<Map<String, dynamic>>> _getSamplesFromSQLite() async {
  return [];
}

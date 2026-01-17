import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controladores/mongo_connection.dart';
import '../../pages/provider/user_provider.dart';

Future<List<Map<String, dynamic>>> getSamples(BuildContext context) async {
  final user = context.read<UserProvider>().user;
  if (user == null) return [];

  final dbService = context.read<DatabaseService>();
  final collection = await dbService.collection('samples');

  final cursor = collection.find({'id_usuario': user.id});
  cursor.project({'sample': 0});
  
  return await cursor.toList();
}

extension on Stream<Map<String, dynamic>> {
  void project(Map<String, int> map) {}
}


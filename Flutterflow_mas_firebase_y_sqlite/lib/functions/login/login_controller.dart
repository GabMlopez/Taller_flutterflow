import 'package:flutterflow_taller/pages/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:provider/provider.dart';

import '../../controladores/mongo_connection.dart';
import '../../Data/entities/usuario.dart';

Future<bool> loginUser(
    BuildContext context, {
      required String usuario,
      required String contrasenia,
    }) async {
  final trimmedUser = usuario.trim();
  final trimmedPass = contrasenia.trim();

  print('→ Buscando exactamente:');
  print('   usuario   : "$trimmedUser" (longitud: ${trimmedUser.length})');
  print('   contrasenia: "$trimmedPass" (longitud: ${trimmedPass.length})');

  try {
    final dbService = context.read<DatabaseService>();
    final users = await dbService.collection('usuarios');

    final result = await users.findOne(
      where
          .eq('usuario', trimmedUser)
          .eq('contrasenia', trimmedPass),
    );

    print('Resultado crudo de findOne: $result');

    if (result == null) {
      print('→ Usuario NO encontrado');

      // Debug extra para saber qué pasa realmente
      final count = await users.count();
      print('Total docs en la colección "usuarios": $count');

      final primerDoc = await users.findOne(); // sin filtro
      print('Primer documento cualquiera (si existe): $primerDoc');

      return false;
    }

    final user = UserModel.fromMap(result);
    print('→ Usuario encontrado OK: ${user.usuario}');

    context.read<UserProvider>().setUser(user);
    return true;
  } catch (e, stack) {
    print('ERROR en loginUser: $e');
    print('Stack trace: $stack');
    return false;
  }
}
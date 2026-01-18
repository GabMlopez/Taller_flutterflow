import 'package:flutterflow_taller/Data/dataServices/user_service.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../../controladores/mongo_connection.dart';

Future<int> getNextUserId(Db db) async {
  final result = await db.collection('counters').findAndModify(
    query: {'id': 1},
    update: {
      r'$inc': {'user_counter': 1}
    },
    upsert: true,
    returnNew: true,
  );

  if (result == null || result['user_counter'] == null) {
    throw Exception('No se pudo generar el ID de usuario');
  }

  return result['user_counter'] as int;
}

class UserRegisterService {

  static const String collectionName = 'usuarios';

  static Future<bool> registerUser({
    required String username,
    required String password,
  }) async {
    try {
      UserService chatUserService=UserService();
      final dbService = await DatabaseService.instance;
      final collection = await dbService.collection(collectionName);

      final exists = await collection.findOne(where.eq('usuario', username));
      if (exists != null) {
        return false;
      }
      final userId = await getNextUserId(await dbService.db);

      final result = await collection.insertOne({
        'id': userId,
        'usuario': username,
        'contrasenia': password,
      });

      await chatUserService.addUser(username, password);


      return result.isSuccess;
    } catch (e) {
      print('Error al registrar usuario: $e');
      return false;
    }

  }


}


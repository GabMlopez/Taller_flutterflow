import 'package:mongo_dart/mongo_dart.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static Db? _db;

  static const String _mongoUrl =
      'mongodb+srv://new_admin:97X7to0HB77p9fA4@cluster0.0byxby9.mongodb.net/Music_db?retryWrites=true&w=majority&appName=Taller_moviles';
  DatabaseService._();

  static Future<DatabaseService> get instance async {
    if (_instance == null) {
      _instance = DatabaseService._();
      await _initDb();
    }

    return _instance!;
  }

  static Future<void> _initDb() async {
    if (_db == null || !_db!.isConnected) {
      try {
        _db = await Db.create(_mongoUrl);
        await _db!.open();
        print('→ MongoDB conectado OK!');
        print('  Base de datos actual: ${_db!.databaseName}');
        print('  URI usada: $_mongoUrl');
      } catch (e) {
        print('→ ERROR AL CONECTAR A MONGO: $e');
        rethrow;
      }
    }
  }

  Future<Db> get db async {
    if (_db == null || !_db!.isConnected) {
      await _initDb();
    }
    return _db!;
  }

  // Obtener una colección
  Future<DbCollection> collection(String name) async {
    final database = await db;
    return database.collection(name);
  }

  static Future<void> close() async {
    if (_db != null && _db!.isConnected) {
      await _db!.close();
      _db = null;
      _instance = null;
    }
  }

  Future<void> dropDatabase() async {
    final database = await db;
    await database.drop();
  }

}
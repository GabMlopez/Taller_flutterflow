import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDbHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  static Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'samples_cache.db');

    return await openDatabase(
      path,
      version: 2, // Incrementamos la versión para forzar la actualización
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          // Si la tabla no existía, la creamos
          await _createTables(db);
        }
      },
    );
  }

  static Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS samples(
        id INTEGER PRIMARY KEY,
        nombre TEXT,
        favorito INTEGER,
        id_usuario TEXT
      )
    ''');
    print("Tabla 'samples' verificada/creada en SQLite.");
  }
}

Future<void> updateLocalCache(List<Map<String, dynamic>> samples) async {
  try {
    final db = await LocalDbHelper.database;

    await db.transaction((txn) async {
      // Borrar lo anterior
      await txn.delete('samples');

      for (var sample in samples) {
        await txn.insert('samples', {
          'id': sample['id'],
          'nombre': sample['nombre'],
          'favorito': (sample['favorito'] == true) ? 1 : 0,
          'id_usuario': sample['id_usuario'].toString(), // Convertimos a String por seguridad
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
    print("SQLite: 10 samples sincronizados.");
  } catch (e) {
    print("Error al actualizar caché local: $e");
  }
}

Future<List<Map<String, dynamic>>> getLocalSamples(dynamic userId) async {
  final db = await LocalDbHelper.database;

  // Consultamos los samples guardados
  final List<Map<String, dynamic>> maps = await db.query(
    'samples',
    where: 'id_usuario = ?',
    whereArgs: [userId],
    limit: 10,
  );

  // Convertimos el 1/0 de favorito de vuelta a booleano para que tu UI no falle
  return List.generate(maps.length, (i) {
    return {
      'id': maps[i]['id'],
      'nombre': maps[i]['nombre'],
      'favorito': maps[i]['favorito'] == 1,
      'id_usuario': maps[i]['id_usuario'],
    };
  });
}
import 'dart:async';
import 'dart:io';

import 'package:playerbloc/models/audio_item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi/windows/sqflite_ffi_setup.dart';

class DatabaseHelper {
  //inicializar bd
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> getDatabase() async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initDB("playpoor.db");
      return _database!;
    }
  }

  Future<Database?> initDB(String filePath) async {
    String dbPath, path;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      dbPath = await databaseFactoryFfi.getDatabasesPath();
      path = join(dbPath, filePath);

      return await databaseFactoryFfi.openDatabase(
        path,
        options: OpenDatabaseOptions(version: 1, onCreate: onCreate),
      );
    }
    if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) {
      dbPath = await getDatabasesPath();
      path = join(dbPath, filePath);

      // Imprime la ruta para verificar
      print("---------Ruta de la base de datos: $path");

      return await openDatabase(path, version: 1, onCreate: onCreate);
    }
  }

  FutureOr<void> onCreate(Database db, int version) async {
    return await db.execute("""
    CREATE TABLE IF NOT EXISTS audioitem(
    id integer primary key not null unique,
    assetPath varchar(100) not null,
    title varchar(100) not null,
    artist varchar(100) not null,
    imagePath varchar(100) not null
    );
    """);
  }

  Future<AudioItem> create(AudioItem audioItem) async {
    final db = await instance.getDatabase();
    int newId = await db.insert("audioitem", audioItem.toMap());
    return AudioItem(
      id: newId,
      assetPath: audioItem.assetPath,
      title: audioItem.title,
      artist: audioItem.artist,
      imagePath: audioItem.imagePath,
    );
  }

  Future<List<AudioItem>> readAll() async {
    final db = await instance.getDatabase();
    final data = await db.query("audioitem");
    return data.map((map) => AudioItem.fromMap(map)).toList(); //Lamda
  }

  Future<void> loadAudioList(List<AudioItem> audioList) async {
    final db = await instance.getDatabase();

    for (final audioItem in audioList) {
      // Verifica si ya existe por assetPath o título
      final existing = await db.query(
        "audioitem",
        where: "assetPath = ? AND title = ?",
        whereArgs: [audioItem.assetPath, audioItem.title],
      );

      if (existing.isEmpty) {
        await create(audioItem);
        print("Insertada: ${audioItem.title}");
      } else {
        print("Ya existe: ${audioItem.title}");
      }
    }
  }

  void close() async {
    final db = await instance.getDatabase();
    db.close();
  }
}

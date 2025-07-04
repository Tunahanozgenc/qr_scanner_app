import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('qr_scanner_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE qr_codes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertQRCode(String code) async {
    final db = await instance.database;
    return await db.insert('qr_codes', {'code': code});
  }

  Future<List<Map<String, dynamic>>> getAllQRCodes() async {
    final db = await instance.database;
    return await db.query('qr_codes', orderBy: 'id DESC');
  }

  Future<int> deleteQRCode(int id) async {
    final db = await instance.database;
    return await db.delete('qr_codes', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    await db.close();
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../core/models/qr_code_model.dart';

class QRDatabase {
  static final QRDatabase instance = QRDatabase._init();
  static Database? _database;

  QRDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('qr_codes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE qr_codes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      code TEXT NOT NULL UNIQUE
    )
    ''');
  }

  Future<int> insertCode(String code) async {
    final db = await instance.database;
    return await db.insert(
      'qr_codes',
      {'code': code},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<QRCode>> getAllCodes() async {
    final db = await instance.database;
    final result = await db.query('qr_codes', orderBy: 'id DESC');
    return result.map((json) => QRCode.fromMap(json)).toList();
  }

  Future<int> deleteCode(int id) async {
    final db = await instance.database;
    return await db.delete('qr_codes', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

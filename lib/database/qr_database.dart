import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../core/models/qr_code_model.dart';

// QR kodlarını veritabanında yönetmek için
class QRDatabase {
  // Sınıfın tek örneği
  static final QRDatabase instance = QRDatabase._init();

  // SQLite veritabanı nesnesi
  static Database? _database;

  // Private olarak oluşturuldu dışarıdan ekleme yapılamaz !
  QRDatabase._init();

  // Veritabanı nesnesini sağlayan getter
  Future<Database> get database async {
    // Veritabanı zaten açıksa onu döndür
    if (_database != null) return _database!;

    // Veritabanı yoksa oluştur ve döndür
    _database = await _initDB('qr_codes.db');
    return _database!;
  }

  // Veritabanını oluşturur/açar
  Future<Database> _initDB(String filePath) async {
    // Veritabanı dosyasının konumunu al
    final dbPath = await getDatabasesPath();
    // Dosya yolunu birleştir
    final path = join(dbPath, filePath);

    // Veritabanını aç (eğer yoksa onCreate ile tabloyu oluşturur)
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Veritabanı ilk kez oluşturulurken tabloyu tanımlar
  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE qr_codes (
      id INTEGER PRIMARY KEY AUTOINCREMENT, -- Otomatik artan birincil anahtar
      code TEXT NOT NULL UNIQUE             -- QR kodu metni, tekrarına izin verilmez
    )
    ''');
  }

  // Verilen QR kodunu veritabanına ekler
  Future<int> insertCode(String code) async {
    final db = await instance.database;

    // Aynı QR kodu daha önce eklenmişse eklemez (ignore ile çakışmayı yoksayar)
    return await db.insert(
      'qr_codes',
      {'code': code},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // Tüm QR kodlarını veritabanından çeker, model listesine dönüştürür
  Future<List<QRCode>> getAllCodes() async {
    final db = await instance.database;

    // 'qr_codes' tablosundaki tüm verileri id'ye göre tersten sırala
    final result = await db.query('qr_codes', orderBy: 'id DESC');

    // Her satırı QRCode modeline dönüştür
    return result.map((json) => QRCode.fromMap(json)).toList();
  }

  // Belirtilen ID'ye sahip QR kodunu siler
  Future<int> deleteCode(int id) async {
    final db = await instance.database;

    return await db.delete('qr_codes', where: 'id = ?', whereArgs: [id]);
  }

  // Veritabanı bağlantısını kapatır
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

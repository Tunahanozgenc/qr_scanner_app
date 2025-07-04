import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Veritabanı işlemlerini yöneten yardımcı sınıf
class DatabaseHelper {
  // Sınıfın tek örneği (singleton pattern)
  static final DatabaseHelper instance = DatabaseHelper._init();

  // Veritabanı nesnesi
  static Database? _database;

  //private oluşturuldu!
  DatabaseHelper._init();

  // Veritabanına erişim için getter
  Future<Database> get database async {
    // Eğer veritabanı zaten açıksa döndür
    if (_database != null) return _database!;

    // Değilse başlat
    _database = await _initDB('qr_scanner_app.db');
    return _database!;
  }

  // Veritabanını başlatır ve açar
  Future<Database> _initDB(String filePath) async {
    // Uygulamanın veritabanı klasörünün yolunu al
    final dbPath = await getDatabasesPath();
    // Tam veritabanı yolunu oluştur
    final path = join(dbPath, filePath);

    // Veritabanını aç ve eğer yoksa oluştur
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB, // İlk oluşturulurken tabloyu oluşturacak
    );
  }

  // Veritabanı ilk oluşturulduğunda çağrılır — tabloyu burada tanımlarız
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE qr_codes (
        id INTEGER PRIMARY KEY AUTOINCREMENT, -- Otomatik artan birincil anahtar
        code TEXT NOT NULL                    -- QR kodunun metinsel içeriği
      )
    ''');
  }

  // QR kodunu veritabanına ekler
  Future<int> insertQRCode(String code) async {
    final db = await instance.database;
    // 'qr_codes' tablosuna veri ekle ve string biçimde
    return await db.insert('qr_codes', {'code': code});
  }

  // Tüm QR kodlarını getirir (id'ye göre azalan sırada)
  Future<List<Map<String, dynamic>>> getAllQRCodes() async {
    final db = await instance.database;
    return await db.query('qr_codes', orderBy: 'id DESC');
  }

  // Belirli bir QR kodunu id'ye göre siler
  Future<int> deleteQRCode(int id) async {
    final db = await instance.database;
    return await db.delete('qr_codes', where: 'id = ?', whereArgs: [id]);
  }

  // Veritabanını kapatır
  Future close() async {
    final db = await instance.database;
    await db.close();
  }
}

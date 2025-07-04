// QR kod bilgilerini temsil eden model sınıfı
class QRCode {
  // QR kod nesnesinin ID'si (veritabanında birincil anahtar olabilir)
  final int? id;

  final String code;

  // QRCode nesnesi oluşturucu (id opsiyonel, code zorunlu)
  QRCode({this.id, required this.code});

  // QRCode nesnesini Map'e çevirir (veritabanı işlemleri için kullanılır)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
    };
  }

  // Map'ten QRCode nesnesi oluşturur (veritabanından veri çekerken kullanılır)
  factory QRCode.fromMap(Map<String, dynamic> map) {
    return QRCode(
      id: map['id'],
      code: map['code'],
    );
  }
}

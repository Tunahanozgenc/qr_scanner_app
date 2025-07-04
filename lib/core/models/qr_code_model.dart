class QRCode {
  final int? id;
  final String code;

  QRCode({this.id, required this.code});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
    };
  }

  factory QRCode.fromMap(Map<String, dynamic> map) {
    return QRCode(
      id: map['id'],
      code: map['code'],
    );
  }
}

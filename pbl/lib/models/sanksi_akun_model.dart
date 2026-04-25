class SanksiAkunModel {
  final String id;
  final String peninjaauanId;
  final String userId;
  final String jenis; // peringatan, suspensi, banned
  final String alasan;
  final DateTime tglSanksi;

  SanksiAkunModel({
    required this.id,
    required this.peninjaauanId,
    required this.userId,
    required this.jenis,
    required this.alasan,
    required this.tglSanksi,
  });

  factory SanksiAkunModel.fromMap(Map<String, dynamic> map) {
    return SanksiAkunModel(
      id: map['sanksi_id'],
      peninjaauanId: map['peninjauan_id'],
      userId: map['user_id'],
      jenis: map['jenis'] ?? 'peringatan',
      alasan: map['alasan'] ?? '',
      tglSanksi: DateTime.parse(map['tgl_sanksi']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sanksi_id': id,
      'peninjauan_id': peninjaauanId,
      'user_id': userId,
      'jenis': jenis,
      'alasan': alasan,
      'tgl_sanksi': tglSanksi.toIso8601String(),
    };
  }
}

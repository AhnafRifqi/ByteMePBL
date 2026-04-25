class PeninjaauanModel {
  final String id;
  final String userId;
  final String produkId;
  final String? catatan;
  final String status; // proses, selesai, ditolak

  PeninjaauanModel({
    required this.id,
    required this.userId,
    required this.produkId,
    this.catatan,
    required this.status,
  });

  factory PeninjaauanModel.fromMap(Map<String, dynamic> map) {
    return PeninjaauanModel(
      id: map['peninjauan_id'],
      userId: map['user_id'],
      produkId: map['produk_id'],
      catatan: map['catatan'],
      status: map['status'] ?? 'proses',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'peninjauan_id': id,
      'user_id': userId,
      'produk_id': produkId,
      'catatan': catatan,
      'status': status,
    };
  }
}

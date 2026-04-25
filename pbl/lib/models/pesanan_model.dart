class PesananModel {
  final String id;
  final String userId;
  final DateTime tglPesanan;
  final double totalHarga;
  final String status; // menunggu, diproses, dikirim, selesai, dibatalkan

  PesananModel({
    required this.id,
    required this.userId,
    required this.tglPesanan,
    required this.totalHarga,
    required this.status,
  });

  factory PesananModel.fromMap(Map<String, dynamic> map) {
    return PesananModel(
      id: map['pesanan_id'],
      userId: map['user_id'],
      tglPesanan: DateTime.parse(map['tgl_pesanan']),
      totalHarga: (map['total_harga'] as num).toDouble(),
      status: map['status'] ?? 'menunggu',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pesanan_id': id,
      'user_id': userId,
      'tgl_pesanan': tglPesanan.toIso8601String(),
      'total_harga': totalHarga,
      'status': status,
    };
  }
}

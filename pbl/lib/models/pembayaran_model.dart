class PembayaranModel {
  final String id;
  final String pesananId;
  final String metode; // transfer, cod, ewallet, kartu_kredit
  final String status; // menunggu, berhasil, gagal, dikembalikan
  final DateTime? tglBayar;

  PembayaranModel({
    required this.id,
    required this.pesananId,
    required this.metode,
    required this.status,
    this.tglBayar,
  });

  factory PembayaranModel.fromMap(Map<String, dynamic> map) {
    return PembayaranModel(
      id: map['pembayaran_id'],
      pesananId: map['pesanan_id'],
      metode: map['metode'] ?? 'transfer',
      status: map['status'] ?? 'menunggu',
      tglBayar: map['tgl_bayar'] != null
          ? DateTime.parse(map['tgl_bayar'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pembayaran_id': id,
      'pesanan_id': pesananId,
      'metode': metode,
      'status': status,
      'tgl_bayar': tglBayar?.toIso8601String(),
    };
  }
}

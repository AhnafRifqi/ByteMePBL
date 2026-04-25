class DetailPesananModel {
  final String id;
  final String pesananId;
  final String produkId;
  final int jumlah;
  final double hargaSatuan;
  final double subtotal;

  DetailPesananModel({
    required this.id,
    required this.pesananId,
    required this.produkId,
    required this.jumlah,
    required this.hargaSatuan,
    required this.subtotal,
  });

  factory DetailPesananModel.fromMap(Map<String, dynamic> map) {
    return DetailPesananModel(
      id: map['detail_pesanan_id'],
      pesananId: map['pesanan_id'],
      produkId: map['produk_id'],
      jumlah: map['jumlah'] ?? 1,
      hargaSatuan: (map['harga_satuan'] as num).toDouble(),
      subtotal: (map['subtotal'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'detail_pesanan_id': id,
      'pesanan_id': pesananId,
      'produk_id': produkId,
      'jumlah': jumlah,
      'harga_satuan': hargaSatuan,
      'subtotal': subtotal,
    };
  }
}

class DetailKeranjangModel {
  final String id;
  final String keranjangId;
  final String produkId;
  final int jumlah;
  final double hargaSatuan;
  final double subtotal;

  DetailKeranjangModel({
    required this.id,
    required this.keranjangId,
    required this.produkId,
    required this.jumlah,
    required this.hargaSatuan,
    required this.subtotal,
  });

  factory DetailKeranjangModel.fromMap(Map<String, dynamic> map) {
    return DetailKeranjangModel(
      id: map['detail_keranjang_id'],
      keranjangId: map['keranjang_id'],
      produkId: map['produk_id'],
      jumlah: map['jumlah'] ?? 1,
      hargaSatuan: (map['harga_satuan'] as num).toDouble(),
      subtotal: (map['subtotal'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'detail_keranjang_id': id,
      'keranjang_id': keranjangId,
      'produk_id': produkId,
      'jumlah': jumlah,
      'harga_satuan': hargaSatuan,
      'subtotal': subtotal,
    };
  }
}

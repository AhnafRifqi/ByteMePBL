class ProductModel {
  final String id;
  final String name;
  final double price;
  final String? description;
  final String? filePath;
  final String sellerId;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.filePath,
    required this.sellerId,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['produk_id'],
      name: map['nama_produk'],
      price: (map['harga'] as num).toDouble(),
      description: map['deskripsi'],
      filePath: map['file_path'],
      sellerId: map['user_id'],
    );
  }
}
class KeranjangModel {
  final String id;
  final String userId;
  final int totalItem;
  final DateTime createdAt;

  KeranjangModel({
    required this.id,
    required this.userId,
    required this.totalItem,
    required this.createdAt,
  });

  factory KeranjangModel.fromMap(Map<String, dynamic> map) {
    return KeranjangModel(
      id: map['keranjang_id'],
      userId: map['user_id'],
      totalItem: map['total_item'] ?? 0,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'keranjang_id': id,
      'user_id': userId,
      'total_item': totalItem,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

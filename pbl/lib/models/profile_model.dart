class ProfileModel {
  final String id;
  final String username;
  final String email;
  final String role;
  final DateTime createdAt;

  ProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'],
      username: map['username'],
      email: map['email'] ?? '',
      role: map['role'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  String get roleLabel {
    switch (role) {
      case 'pembeli':
        return 'Pembeli';
      case 'penjual':
        return 'Penjual';
      case 'admin':
        return 'Admin';
      default:
        return role;
    }
  }
}

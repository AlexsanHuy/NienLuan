class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final String userId;
  final String uid;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.userId,
    required this.uid,
  });

  factory UserModel.fromRecord(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'] ?? '',
      name: data['name'] ?? 'Chưa có tên',
      email: data['email'] ?? 'Chưa có email',
      phone: data['phone'] ?? 'Chưa có số điện thoại',
      avatar: data['avatar'] ?? '',
      userId: data['userId'] ?? '',
      uid: data['uid']?.toString() ?? '0',
    );
  }
}

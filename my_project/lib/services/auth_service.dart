import '../pages/route.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import '../services/database_service.dart';
import '../services/ip_server.dart';
import '../services/format.dart';

class AuthService {
  final pb = PocketBase(IpServer.ip);

  Future<void> register(
    String email,
    String password,
    String name,
    String phone,
    String confirmPassword,
  ) async {
    if (email.isEmpty ||
        password.isEmpty ||
        name.isEmpty ||
        phone.isEmpty ||
        confirmPassword.isEmpty) {
      Format.editToast('Vui lòng điền đầy đủ thông tin');
      return;
    }
    if (password != confirmPassword) {
      Format.editToast('Mật khẩu không khớp');
      return;
    }
    try {
      final body = <String, dynamic>{
        "password": password,
        "passwordConfirm": confirmPassword,
        "email": email,
        "name": name,
        "phone": phone,
        "avatar": '',
      };
      await pb.collection('users').create(body: body);
      Format.editToast('Đăng ký thành công');
    } catch (e) {
      Format.editToast('Đăng ký thất bại');
    }
  }

  Future<void> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    if (email.isEmpty || password.isEmpty) {
      Format.editToast('Vui lòng điền đầy đủ thông tin');
      return;
    }
    try {
      await pb.collection('users').authWithPassword(email, password);
      await pb.collection('currentUser').create(body: {
        'userId': pb.authStore.record!.id,
        'name': pb.authStore.record!.data['name'],
        'email': pb.authStore.record!.data['email'],
        'phone': pb.authStore.record!.data['phone'],
        'avatar': pb.authStore.record!.data['avatar'],
        'uid': '0',
      });
      Format.editToast('Đăng nhập thành công');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Navigate()));
    } catch (e) {
      Format.editToast('Tài khoản hoặc mật khẩu không chính xác');
    }
  }

  Future<void> logout() async {
    pb.authStore.clear();
    DatabaseService().deleteAllRecords('currentUser');
    DatabaseService().deleteAllRecords('cart');
  }
}

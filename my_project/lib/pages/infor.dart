import 'package:flutter/material.dart';
import '../components/footer.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import '../pages/route.dart';

class InforPage extends StatefulWidget {
  const InforPage({Key? key}) : super(key: key);

  @override
  State<InforPage> createState() => _InforPageState();
}

class _InforPageState extends State<InforPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  UserModel? user;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    UserModel? currentUser = await DatabaseService().getCurrentUser();
    setState(() {
      user = currentUser;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              const PopupMenuItem(child: Text('Báo lỗi')),
              const PopupMenuItem(child: Text('Khác')),
            ],
          )
        ],
        title: const Text(
          'Tài khoản',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Hiển thị khi đang tải dữ liệu
          : user == null
              ? const Center(child: Text('Không có dữ liệu người dùng'))
              : SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                        backgroundImage: user!.avatar.isNotEmpty
                            ? NetworkImage(user!.avatar)
                            : null,
                        child: user!.avatar.isEmpty
                            ? const Icon(Icons.person,
                                size: 50, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user!.name,
                        style: const TextStyle(
                          fontSize: 24.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(user!.phone),
                      _buildUserInfoTile(Icons.person, 'Họ tên:', user!.name),
                      _divider(),
                      _buildUserInfoTile(Icons.email, 'Email:', user!.email),
                      _divider(),
                      _buildUserInfoTile(
                          Icons.phone, 'Số điện thoại:', user!.phone),
                      _divider(),
                      _buildUserInfoTile(
                          Icons.star, 'Cấp độ khách hàng:', 'Cấp độ 1'),
                      const ProfileFooter(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildUserInfoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      trailing: title == 'Họ tên:'
          ? IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    title: const Text(
                      'Chỉnh sửa thông tin',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: user?.name ?? 'Nhập tên',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: phoneController,
                              decoration: InputDecoration(
                                hintText: user?.phone ?? 'Nhập số điện thoại',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Hủy'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            DatabaseService().updateUser(
                              user!.userId,
                              user!.id,
                              nameController.text,
                              phoneController.text,
                            );
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Navigate()));
                          },
                          child: const Text('Lưu'),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.edit, color: Colors.black),
            )
          : null,
    );
  }

  Widget _divider() {
    return Divider(color: Colors.grey.withOpacity(0.5), thickness: 1);
  }
}

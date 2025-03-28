import 'package:flutter/material.dart';
import 'login.dart';
import 'infor.dart';
import 'setting.dart';
import 'changepass.dart';
import '../components/footer.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? user;
  bool isLoading = true;
  TextEditingController feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUserName();
  }

  Future<void> getCurrentUserName() async {
    UserModel? currentUser = await DatabaseService().getCurrentUser();

    if (!mounted) return;
    setState(() {
      user = currentUser;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        leading: Icon(Icons.sort_rounded, color: Colors.white),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              PopupMenuItem(child: Text('Báo lỗi')),
              PopupMenuItem(child: Text('Khác')),
            ],
          )
        ],
        title: Text('Tài khoản',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Colors.blue, Colors.purple]),
                ),
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    user?.name ?? 'Chưa có tên',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(user?.phone ?? 'Chưa có số điện thoại'),
                  SizedBox(height: 30),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.blue, Colors.lightBlue]),
                    ),
                    alignment: Alignment.center,
                    child: Text('Các chức năng chính',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InforPage()),
                      );

                      if (result == true && mounted) {
                        setState(() {
                          isLoading = true;
                        });
                        await getCurrentUserName();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Changed background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corner
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10), // padding
                      shadowColor: Colors.grey.withOpacity(0.5), // shadow
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit_note_outlined, color: Colors.black),
                        Text(' Xem thông tin',
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingPage(
                                  name: user!.name, phone: user!.phone)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Changed background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corner
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10), // padding
                      shadowColor: Colors.grey.withOpacity(0.5), // shadow
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.settings_outlined, color: Colors.black),
                        Text(' Cài đặt', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePassPage(
                                  id: user!.userId,
                                  name: user!.name,
                                  phone: user!.phone)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Changed background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corner
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10), // padding
                      shadowColor: Colors.grey.withOpacity(0.5), // shadow
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline, color: Colors.black),
                        Text(' Đổi mật khẩu',
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: Center(
                              child: Text('Đóng góp ý kiến',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black))),
                          content: TextField(
                            controller: feedbackController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: 'Góp ý của bạn',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('Hủy',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                DatabaseService().sendFeedback(
                                    user!.userId, feedbackController.text);
                                feedbackController.clear();
                                Navigator.pop(context);
                              },
                              child: Text('Gửi',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Changed background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corner
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10), // padding
                      shadowColor: Colors.grey.withOpacity(0.5), // shadow
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.feedback_outlined, color: Colors.black),
                        Text(' Đóng góp ý kiến',
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {
                      AuthService().logout();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Changed background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corner
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10), // padding
                      shadowColor: Colors.grey.withOpacity(0.5), // shadow
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_outlined, color: Colors.black),
                        Text(' Đăng xuất',
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  ProfileFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

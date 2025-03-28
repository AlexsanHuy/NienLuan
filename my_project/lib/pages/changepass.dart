import 'package:flutter/material.dart';
import '../components/footer.dart';
import '../services/database_service.dart';

class ChangePassPage extends StatefulWidget {
  final String name;
  final String phone;
  final String id;
  const ChangePassPage(
      {Key? key, required this.name, required this.phone, required this.id})
      : super(key: key);

  @override
  State<ChangePassPage> createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> {
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isReNewPasswordVisible = false;
  TextEditingController _oldPassController = TextEditingController();
  TextEditingController _newPassController = TextEditingController();
  TextEditingController _reNewPassController = TextEditingController();

  @override
  void dispose() {
    _oldPassController.dispose();
    _newPassController.dispose();
    _reNewPassController.dispose();
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
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
                    widget.name,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(widget.phone),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Đổi mật khẩu',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _oldPassController,
                          decoration: InputDecoration(
                            labelText: 'Mật khẩu cũ',
                            border: OutlineInputBorder(),
                            prefixIcon:
                                Icon(Icons.lock_outline, color: Colors.grey),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isOldPasswordVisible =
                                      !_isOldPasswordVisible;
                                });
                              },
                              icon: Icon(
                                  _isOldPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey),
                            ),
                          ),
                          obscureText: !_isOldPasswordVisible,
                        ),
                        SizedBox(height: 15),
                        TextField(
                          controller: _newPassController,
                          decoration: InputDecoration(
                            labelText: 'Mật khẩu mới',
                            border: OutlineInputBorder(),
                            prefixIcon:
                                Icon(Icons.lock_outline, color: Colors.grey),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isNewPasswordVisible =
                                      !_isNewPasswordVisible;
                                });
                              },
                              icon: Icon(
                                  _isNewPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey),
                            ),
                          ),
                          obscureText: !_isNewPasswordVisible,
                        ),
                        SizedBox(height: 15),
                        TextField(
                          controller: _reNewPassController,
                          decoration: InputDecoration(
                            labelText: 'Nhập lại mật khẩu mới',
                            border: OutlineInputBorder(),
                            prefixIcon:
                                Icon(Icons.lock_outline, color: Colors.grey),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isReNewPasswordVisible =
                                      !_isReNewPasswordVisible;
                                });
                              },
                              icon: Icon(
                                  _isReNewPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey),
                            ),
                          ),
                          obscureText: !_isReNewPasswordVisible,
                        ),
                        SizedBox(height: 25),
                        ElevatedButton(
                          onPressed: () {
                            DatabaseService().changePass(
                                widget.id,
                                _oldPassController.text,
                                _newPassController.text,
                                _reNewPassController.text);
                          },
                          child: Text(
                            'Đổi mật khẩu',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 60, vertical: 5),
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
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

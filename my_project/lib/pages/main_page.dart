import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'login.dart';
import 'route.dart';
import '../services/ip_server.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final PocketBase pb = PocketBase(IpServer.ip);

  UserModel? user;
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    UserModel? currentUser = await DatabaseService().getCurrentUser();
    setState(() {
      user = currentUser;
      if (user != null) {
        isLogin = true;
      } else {
        isLogin = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLogin ? const Navigate() : const LoginPage();
  }
}

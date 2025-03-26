import 'package:flutter/material.dart';
import '../components/footer.dart';

class SettingPage extends StatefulWidget {
  final String name;
  final String phone;
  const SettingPage({Key? key, required this.name, required this.phone})
      : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isNotificationEnabled = true;
  bool isNightModeEnabled = true;
  bool isAutoUpdateEnabled = true;

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
                  SizedBox(height: 20),
                  ListTile(
                    title: Text('Thông báo',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    trailing: IconButton(
                      icon: Icon(
                        isNotificationEnabled
                            ? Icons.notifications
                            : Icons.notifications_off,
                        color:
                            isNotificationEnabled ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isNotificationEnabled = !isNotificationEnabled;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Chế độ ban đêm',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: IconButton(
                      icon: Icon(
                        isNightModeEnabled ? Icons.nights_stay : Icons.wb_sunny,
                        color: isNightModeEnabled ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isNightModeEnabled = !isNightModeEnabled;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Tự động cập nhật',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: IconButton(
                      icon: Icon(
                        isAutoUpdateEnabled
                            ? Icons.update
                            : Icons.update_disabled,
                        color: isAutoUpdateEnabled ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isAutoUpdateEnabled = !isAutoUpdateEnabled;
                        });
                      },
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

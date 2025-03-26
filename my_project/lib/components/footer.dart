import 'package:flutter/material.dart';

class ProfileFooter extends StatelessWidget {
  const ProfileFooter({super.key});

  void _showContactDialog(BuildContext context, String title, IconData icon,
      Color color, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Column(
          children: [
            Icon(icon, size: 50, color: color),
            SizedBox(height: 10),
            Text(title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(content,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black87)),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Đóng',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 10,
                      endIndent: 10)),
              Text('Liên hệ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(
                  child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 10,
                      endIndent: 10)),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildContactButton(
                  context,
                  Icons.facebook_outlined,
                  Colors.blue[300]!,
                  'Facebook',
                  'https://facebook.com/TanHwiFood'),
              _buildContactButton(context, Icons.mail_outlined,
                  Colors.red[300]!, 'Email', 'TanHwiFood@gmail.com'),
              _buildContactButton(context, Icons.phone_android_outlined,
                  Colors.green[300]!, 'Điện thoại', '0909090909'),
              _buildContactButton(context, Icons.location_on_outlined,
                  Colors.grey, 'Địa chỉ', '123 Đường ABC, TP. XYZ'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton(BuildContext context, IconData icon, Color color,
      String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        onPressed: () =>
            _showContactDialog(context, title, icon, color, content),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.all(10),
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}

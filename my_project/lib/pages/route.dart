import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'chat.dart';
import 'cart.dart';
import 'order_list.dart';
import 'profile.dart';

class Navigate extends StatefulWidget {
  const Navigate({this.initialIndex = 0, super.key});

  final int initialIndex;

  @override
  State<Navigate> createState() => _NavigateState();
}

int selectedIndex = 0;

class _NavigateState extends State<Navigate> {
  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: selectedIndex == 0
          ? HomePage()
          : selectedIndex == 1
              ? ChatPage()
              : selectedIndex == 2
                  ? CartPage()
                  : selectedIndex == 3
                      ? OrderPage()
                      : selectedIndex == 4
                          ? ProfilePage()
                          : HomePage(),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blue,
        color: Colors.white,
        height: 80,
        items: [
          CurvedNavigationBarItem(
            child: Icon(Icons.home_outlined),
            label: 'Trang chủ',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.chat_bubble_outline),
            label: 'Tin nhắn',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.shopping_cart_outlined),
            label: 'Giỏ hàng',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.shopping_bag_outlined),
            label: 'Đơn hàng',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.person_outline),
            label: 'Tài khoản',
          ),
        ],
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}

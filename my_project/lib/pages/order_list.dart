import 'package:flutter/material.dart';
import 'package:my_project/pages/order_list_detail.dart';
import '../services/database_service.dart';
import '../services/format.dart';
import '../models/user_model.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<Map<String, dynamic>> orderList = [];
  List<Map<String, dynamic>> filteredOrderList = [];
  UserModel? user;

  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();
    getOrderList();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    UserModel? currentUser = await DatabaseService().getCurrentUser();
    setState(() {
      user = currentUser;
    });
    getOrderList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getOrderList() async {
    try {
      if (user == null) return;
      final orderList = await DatabaseService().getOrderList(user!.userId);
      setState(() {
        this.orderList = orderList;
        filteredOrderList = orderList;
      });
    } catch (e) {
      print("Lỗi lấy danh sách đơn hàng: $e");
    }
  }

  void filterOrders() {
    setState(() {
      if (fromDate == null && toDate == null) {
        filteredOrderList = orderList;
      } else {
        filteredOrderList = orderList.where((order) {
          DateTime orderDate = DateTime.parse(order['created']);

          if (fromDate != null && toDate == null) {
            return orderDate.isAfter(fromDate!.subtract(Duration(days: 1)));
          }

          if (fromDate == null && toDate != null) {
            return orderDate.isBefore(toDate!.add(Duration(days: 1)));
          }

          return orderDate.isAfter(fromDate!.subtract(Duration(days: 1))) &&
              orderDate.isBefore(toDate!.add(Duration(days: 1)));
        }).toList();
      }
    });
  }

  Future<void> selectDate(BuildContext context, bool isFromDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
      filterOrders();
    }
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
        title: Text('Đơn hàng',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: fromDate != null
                          ? Format.formatDate(fromDate.toString())
                          : '',
                    ),
                    decoration: InputDecoration(
                      labelText: 'Từ ngày',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => selectDate(context, true),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: toDate != null
                          ? Format.formatDate(toDate.toString())
                          : '',
                    ),
                    decoration: InputDecoration(
                      labelText: 'Đến ngày',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => selectDate(context, false),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: filteredOrderList.isEmpty
                  ? Center(
                      child: Text(
                        'Không có đơn hàng',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredOrderList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: _buildStatusIcon(
                                filteredOrderList[index]['status']),
                            title: Text(
                                'Ngày: ${Format.formatDate(filteredOrderList[index]['created'])}',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                'Thanh toán: ${Format.formatCurrency(filteredOrderList[index]['total'].toDouble())}',
                                style: TextStyle(color: Colors.grey)),
                            trailing: Icon(
                              Icons.arrow_forward_outlined,
                              color: Colors.blue,
                              size: 30,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderListDetail(
                                    orderId: filteredOrderList[index]['id'],
                                    total: filteredOrderList[index]['total']
                                        .toDouble(),
                                    address: filteredOrderList[index]
                                        ['address'],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(int status) {
    switch (status) {
      case 0:
        return _statusIcon(Colors.green, Icons.check_circle_outline);
      case 1:
        return _statusIcon(Colors.yellow[700]!, Icons.access_time_outlined);
      default:
        return _statusIcon(Colors.red, Icons.close);
    }
  }

  Widget _statusIcon(Color color, IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}

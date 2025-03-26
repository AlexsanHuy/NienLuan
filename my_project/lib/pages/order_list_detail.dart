import 'package:flutter/material.dart';
import '../components/product_ordered.dart';
import '../services/database_service.dart';
import '../services/format.dart';

class OrderListDetail extends StatefulWidget {
  final String orderId;
  final double total;
  final String address;
  const OrderListDetail(
      {super.key,
      required this.orderId,
      required this.total,
      required this.address});

  @override
  State<OrderListDetail> createState() => _OrderListDetailState();
}

class _OrderListDetailState extends State<OrderListDetail> {
  List<Map<String, dynamic>> order = [];
  @override
  void initState() {
    super.initState();
    getOrder();
  }

  Future<void> getOrder() async {
    try {
      final order = await DatabaseService().getOrderDetail(widget.orderId);
      setState(() {
        this.order = order;
      });
    } catch (e) {
      print("Lỗi lấy đơn hàng: $e");
    }
  }

  @override
  void dispose() {
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
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
        title: Text('Chi tiết đơn hàng',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
      body: Column(
        children: [
          Divider(
            color: Colors.green[300],
            indent: 100,
            endIndent: 100,
            thickness: 2,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: order.length,
              itemBuilder: (context, index) {
                return ProductOrdered(
                    name: order[index]['name'],
                    price: order[index]['price'].toDouble(),
                    image: order[index]['image'],
                    quantity: order[index]['quantity'],
                    pid: order[index]['pid']);
              },
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Địa chỉ: ',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    Text(widget.address,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tổng: ',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    Text(
                        Format.formatCurrency((widget.total * 0.95).toDouble()),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Phí vận chuyển: ',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    Text(
                        Format.formatCurrency(
                            (widget.total - widget.total * 0.95).toDouble()),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                  ],
                ),
                Divider(
                  color: Colors.green[300],
                  indent: 190,
                  thickness: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tổng cộng: ',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    Text(Format.formatCurrency(widget.total),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

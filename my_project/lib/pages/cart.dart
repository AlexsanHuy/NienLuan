import 'package:flutter/material.dart';
import '../components/product.dart';
import 'payment.dart';
import '../services/database_service.dart';
import '../services/format.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [];
  double totalPrice = 0;
  double shippingFee = 0;
  double totalAmount = 0;

  @override
  void initState() {
    super.initState();
    _loadCartData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadCartData() async {
    final data = await DatabaseService().getCartData();
    setState(() {
      cartItems = data;
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    totalPrice = cartItems.fold(0, (sum, item) {
      double price = item['sale']
          ? item['price'].toDouble() * (1 - item['discount'] / 100)
          : item['price'].toDouble();
      return sum + (price * item['quantity'].toDouble());
    });
    shippingFee = totalPrice * 0.05;
    totalAmount = totalPrice + shippingFee;
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
        leading: const Icon(Icons.sort_rounded, color: Colors.white),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => const [
              PopupMenuItem(child: Text('Báo lỗi')),
              PopupMenuItem(child: Text('Khác')),
            ],
          )
        ],
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Đã thêm vào giỏ hàng ',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
                Icon(Icons.check_circle_outline, color: Colors.green),
              ],
            ),
          ),
          Divider(
              color: Colors.green[300],
              indent: 100,
              endIndent: 100,
              thickness: 2),
          Expanded(
            child: cartItems.isEmpty
                ? const Center(child: Text('Không có sản phẩm nào'))
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return Product(
                        id: cartItems[index]['id'],
                        pid: cartItems[index]['pid'],
                        name: cartItems[index]['name'],
                        price: cartItems[index]['price'].toDouble(),
                        image: cartItems[index]['image'],
                        quantity: cartItems[index]['quantity'],
                        sale: cartItems[index]['sale'],
                        discount: cartItems[index]['discount'].toDouble(),
                        onQuantityChanged: (quantity) {
                          setState(() {
                            cartItems[index]['quantity'] = quantity;
                            _calculateTotal();
                          });
                          DatabaseService().updateCartItem(
                              cartItems[index]['id'] ?? '', quantity);
                        },
                        onDelete: () {
                          setState(() {
                            cartItems.removeAt(index);
                            _calculateTotal();
                          });
                        },
                      );
                    },
                  ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tổng: ',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    Text(Format.formatCurrency(totalPrice),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Phí vận chuyển: ',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    Text(Format.formatCurrency(shippingFee),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                  ],
                ),
                Divider(color: Colors.green[300], indent: 190, thickness: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tổng cộng: ',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    Text(Format.formatCurrency(totalAmount),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: cartItems.isNotEmpty
                        ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PaymentPage(totalAmount: totalAmount)))
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'Thanh toán',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

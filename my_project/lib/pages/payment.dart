import 'package:flutter/material.dart';
import '../services/format.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import 'success_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, required this.totalAmount});

  final double totalAmount;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isDirectPayment = true;
  final addressController = TextEditingController();
  UserModel? user;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    UserModel? currentUser = await DatabaseService().getCurrentUser();
    setState(() {
      user = currentUser;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'Thanh toán',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              const PopupMenuItem(child: Text('Báo lỗi')),
              const PopupMenuItem(child: Text('Khác')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConfirmationHeader(),
            const SizedBox(height: 20),
            _buildAddressField(),
            const SizedBox(height: 20),
            _buildAmountSection(),
            const SizedBox(height: 20),
            _buildPaymentOptions(),
            const SizedBox(height: 30),
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Xác nhận đơn hàng',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            SizedBox(width: 8),
            Icon(Icons.check_circle_outline, color: Colors.green),
          ],
        ),
        Divider(
          color: Colors.green[300],
          indent: 80,
          endIndent: 80,
          thickness: 2,
        ),
      ],
    );
  }

  Widget _buildAddressField() {
    return TextField(
      controller: addressController,
      decoration: InputDecoration(
        labelText: 'Nhập địa chỉ',
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        prefixIcon: const Icon(Icons.location_on, color: Colors.black),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildAmountSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'Số tiền phải thanh toán: ${Format.formatCurrency(widget.totalAmount)}',
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildPaymentOptions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.credit_card, color: Colors.blue),
            title: const Text('Thanh toán trực tiếp'),
            trailing: Radio(
              value: true,
              groupValue: isDirectPayment,
              onChanged: (value) => setState(() => isDirectPayment = true),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.payment, color: Colors.blue),
            title: const Text('Thanh toán online'),
            trailing: Radio(
              value: false,
              groupValue: isDirectPayment,
              onChanged: (value) => setState(() => isDirectPayment = false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (isDirectPayment) {
            DatabaseService().createOrderList(addressController.text, 'cod',
                widget.totalAmount, user!.userId);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SuccessPage()));
          } else {
            // DatabaseService.createOrderOnline();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Text(
          'Xác nhận',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}

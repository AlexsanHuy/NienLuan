import 'package:flutter/material.dart';
import '../services/ip_server.dart';
import 'package:intl/intl.dart';
import '../services/database_service.dart';

class Product extends StatefulWidget {
  final String id;
  final String pid;
  final String name;
  final double price;
  final String image;
  final int quantity;
  final bool sale;
  final double discount;
  final Function(int) onQuantityChanged;
  final VoidCallback onDelete;

  Product({
    required this.id,
    required this.pid,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
    required this.sale,
    required this.discount,
    required this.onQuantityChanged,
    required this.onDelete,
  });

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.quantity;
  }

  void increaseQuantity() {
    setState(() {
      quantity++;
    });
    widget.onQuantityChanged(quantity);
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
      widget.onQuantityChanged(quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    double discountedPrice =
        widget.sale ? widget.price * (1 - widget.discount / 100) : widget.price;

    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  '${IpServer.ip}/api/files/pbc_4092854851/${widget.pid}/${widget.image}',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: Colors.grey),
                ),
              ),
              if (widget.sale)
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '-${widget.discount.toInt()}%',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    if (widget.sale) ...[
                      Text(
                        NumberFormat.currency(locale: 'vi', symbol: '₫')
                            .format(widget.price),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        NumberFormat.currency(locale: 'vi', symbol: '₫')
                            .format(discountedPrice),
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ] else ...[
                      Text(
                        NumberFormat.currency(locale: 'vi', symbol: '₫')
                            .format(widget.price),
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
                Row(
                  children: [
                    Text('Số lượng:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon:
                          Icon(Icons.remove_circle_outline, color: Colors.blue),
                      onPressed: decreaseQuantity,
                    ),
                    Text(
                      '$quantity',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline, color: Colors.blue),
                      onPressed: increaseQuantity,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await DatabaseService().deleteCartItem(widget.id);
                widget.onDelete();
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../pages/food_detail.dart';
import '../services/ip_server.dart';
import '../services/format.dart';
import '../services/database_service.dart';

class ProductCardSale extends StatelessWidget {
  final String product;
  final String image;
  final double price;
  final String id;
  final double rating;
  final String description;
  final double? discount;

  ProductCardSale({
    super.key,
    required this.product,
    required this.image,
    required num price,
    required this.id,
    this.rating = 4.5,
    required this.description,
    this.discount,
  }) : price = price.toDouble();

  double get discountedPrice =>
      discount != null ? price * (1 - discount! / 100) : price;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.2 * 255).toInt()),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FoodDetail(
                  image: '${IpServer.ip}/api/files/pbc_4092854851/$id/$image',
                  product: product,
                  price: discountedPrice,
                  description: description,
                  pid: id,
                ),
              ));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Stack(
                children: [
                  Image.network(
                    '${IpServer.ip}/api/files/pbc_4092854851/$id/$image',
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                  if (discount != null && discount! > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '-${discount!.toInt()}%',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    if (discount != null && discount! > 0) ...[
                      Text(
                        Format.formatCurrency(price),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        Format.formatCurrency(discountedPrice),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ] else ...[
                      Text(
                        Format.formatCurrency(price),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                    Spacer(),
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: ElevatedButton(
                        onPressed: () {
                          DatabaseService().addToCart(id, 1);
                        },
                        child: Icon(Icons.shopping_cart_outlined,
                            size: 16, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[300],
                          padding: const EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Rate: ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    ...List.generate(5, (index) {
                      return Icon(
                        index < rating.floor()
                            ? Icons.star
                            : (index < rating
                                ? Icons.star_half
                                : Icons.star_border),
                        color: Colors.amber,
                        size: 18,
                      );
                    }),
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

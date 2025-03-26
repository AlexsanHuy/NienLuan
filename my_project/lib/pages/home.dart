import 'package:flutter/material.dart';
import '../components/category.dart';
import '../components/product_card.dart';
import '../components/productcard_sale.dart';
import '../services/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> productsFuture;
  late Future<List<Map<String, dynamic>>> categoriesFuture;
  List<Map<String, dynamic>> allProducts = [];
  List<Map<String, dynamic>> filteredProducts = [];
  String selectedCategory = "Tất cả";

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    productsFuture = DatabaseService().getAllProducts();
    categoriesFuture = DatabaseService().getAllCategories();

    productsFuture.then((products) {
      setState(() {
        allProducts = products;
        filteredProducts = products;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterProducts(String query) {
    setState(() {
      filteredProducts = allProducts
          .where((product) =>
              product['name'].toLowerCase().contains(query.toLowerCase()) &&
              (selectedCategory == "Tất cả" ||
                  product['category'] == selectedCategory))
          .toList();
    });
  }

  void filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
      filteredProducts = allProducts
          .where((product) =>
              category == "Tất cả" ||
              (product['category']['name']?.toString().toLowerCase() ?? '') ==
                  category.toLowerCase())
          .toList();
    });
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
        title: Text('TanHwi Food Xin chào!',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: searchController,
                  onChanged: filterProducts,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Tìm kiếm món ăn',
                    hintStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.black),
                            onPressed: () {
                              setState(() {
                                searchController.clear();
                                filterProducts('');
                              });
                            },
                          )
                        : null,
                  ),
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🍽️ TanHwi Food',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '✨ Uy tín tạo nên thương hiệu!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 15,
                  child: IconButton(
                    icon: Icon(Icons.favorite, color: Colors.white, size: 50),
                    onPressed: () {
                      // Thêm logic khi nhấn vào trái tim (nếu cần)
                    },
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey[300],
              thickness: 1,
            ),
            // Categories
            FutureBuilder<List<Map<String, dynamic>>>(
              future: categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Lỗi: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('Không có danh mục nào');
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Category(
                          category: 'Tất cả',
                          isSelected: selectedCategory == 'Tất cả',
                          onTap: () => filterByCategory('Tất cả'),
                        ),
                        ...snapshot.data!.map((category) {
                          return Category(
                            category: category['name'] ?? '',
                            isSelected: selectedCategory == category['name'],
                            onTap: () => filterByCategory(category['name']),
                          );
                        }).toList(),
                      ],
                    ),
                  );
                }
              },
            ),
            Divider(
              color: Colors.grey[300],
              thickness: 1,
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                  selectedCategory == 'Tất cả'
                      ? 'Phổ biến!'
                      : '${selectedCategory}!',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                var product = filteredProducts[index];
                return product['sale'] == true
                    ? ProductCardSale(
                        id: product['id'],
                        product: product['name'],
                        image: product['image'],
                        price: product['price'],
                        description: product['description'],
                        discount: product['sale_value'].toDouble(),
                      )
                    : ProductCard(
                        id: product['id'],
                        product: product['name'],
                        image: product['image'],
                        price: product['price'],
                        description: product['description'],
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

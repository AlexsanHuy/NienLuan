import 'package:pocketbase/pocketbase.dart';
import '../services/ip_server.dart';
import '../models/user_model.dart';
import '../services/format.dart';

class DatabaseService {
  final pb = PocketBase(IpServer.ip);

  Future<UserModel?> getCurrentUser() async {
    try {
      final record = await pb.collection('currentUser').getList(
            page: 1,
            perPage: 1,
            filter: 'uid = "0"',
          );

      if (record.items.isNotEmpty) {
        return UserModel.fromRecord(record.items.first.data);
      }
      return null;
    } catch (e) {
      print("Lỗi khi lấy người dùng hiện tại: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAllCategories() async {
    try {
      final records = await pb.collection('categories').getFullList();
      return records.map((record) => record.toJson()).toList();
    } catch (e) {
      print("Lỗi lấy danh sách: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      final records =
          await pb.collection('products').getFullList(expand: 'category');
      return records.map((record) {
        final product = record.toJson();
        final category = product['expand']?['category'] ?? {};
        return {
          ...product,
          'category': category,
        };
      }).toList();
    } catch (e) {
      print("Lỗi lấy danh sách sản phẩm: $e");
      return [];
    }
  }

  Future<void> addToCart(String pid, int quantity) async {
    try {
      await pb.collection('cart').create(body: {
        'pid': pid,
        'quantity': quantity,
      });
      Format.editToast('Đã thêm vào giỏ hàng');
    } catch (e) {
      print("Lỗi thêm vào giỏ hàng: $e");
    }
  }

  Future<void> deleteAllRecords(String collectionName) async {
    final records = await pb.collection(collectionName).getFullList();
    for (var record in records) {
      await pb.collection(collectionName).delete(record.id);
    }
  }

  Future<List<Map<String, dynamic>>> getCartData() async {
    try {
      final records = await pb.collection('cart').getFullList(expand: 'pid');

      return records.map((record) {
        final cartItem = record.data;
        final product = cartItem['expand']?['pid'] ?? {};
        return {
          'id': record.id,
          'pid': cartItem['pid'] ?? '',
          'name': product['name'] ?? 'Sản phẩm không tồn tại',
          'price': product['price'] ?? 0.0,
          'image': product['image'] ?? '',
          'quantity': cartItem['quantity'] ?? 1,
          'sale': product['sale'] ?? false,
          'discount': product['sale_value'] ?? 0.0,
        };
      }).toList();
    } catch (e) {
      print("Lỗi lấy danh sách giỏ hàng: $e");
      return [];
    }
  }

  Future<void> updateCartItem(String id, int quantity) async {
    await pb.collection('cart').update(id, body: {
      'quantity': quantity,
    });
  }

  Future<void> deleteCartItem(String id) async {
    await pb.collection('cart').delete(id);
    Format.editToast('Đã xóa sản phẩm khỏi giỏ hàng');
  }

  Future<void> createOrderList(
      String address, String paymethod, double totalPrice, String uid) async {
    try {
      final order = await pb.collection('order_list').create(body: {
        'address': address,
        'status': 1,
        'paymethod': paymethod,
        'total_price': totalPrice,
        'uid': uid,
        'total': totalPrice,
      });
      final cartItems = await getCartData();
      if (cartItems.isEmpty) {
        Format.editToast('Giỏ hàng trống, không thể tạo đơn hàng');
        return;
      }
      for (var item in cartItems) {
        await pb.collection('order_detail').create(body: {
          'oid': order.id,
          'pid': item['pid'],
          'quantity': item['quantity'],
        });
      }
      await deleteAllRecords('cart');
      Format.editToast('Thanh toán thành công');
    } catch (e) {
      Format.editToast('Lỗi khi tạo đơn hàng: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getOrderList(String uid) async {
    try {
      final records = await pb.collection('order_list').getFullList(
            filter: 'uid = "$uid"',
            expand: 'uid',
          );
      return records.map((record) => record.toJson()).toList();
    } catch (e) {
      print("Lỗi lấy danh sách đơn hàng: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getOrderDetail(String orderId) async {
    try {
      final records = await pb.collection('order_detail').getFullList(
            filter: 'oid = "$orderId"',
            expand: 'pid',
          );
      return records.map((record) {
        final cartItem = record.data;
        final product = cartItem['expand']?['pid'] ?? {};
        return {
          'id': record.id,
          'pid': cartItem['pid'] ?? '',
          'name': product['name'] ?? 'Sản phẩm không tồn tại',
          'price': product['price'] ?? 0.0,
          'image': product['image'] ?? '',
          'quantity': cartItem['quantity'] ?? 1,
        };
      }).toList();
    } catch (e) {
      print("Lỗi lấy danh sách chi tiết đơn hàng: $e");
      return [];
    }
  }

  Future<void> updateUser(
      String id, String uid, String name, String phone) async {
    if (name != '' && phone != '') {
      await pb.collection('users').update(id, body: {
        'name': name,
        'phone': phone,
      });
      await pb.collection('currentUser').update(uid, body: {
        'name': name,
        'phone': phone,
      });
      Format.editToast('Cập nhật thông tin thành công');
    } else {
      Format.editToast('Vui lòng nhập đầy đủ thông tin');
    }
  }

  Future<void> changePass(
      String id, String oldPass, String newPass, String reNewPass) async {
    try {
      if (newPass != reNewPass) {
        Format.editToast('Mật khẩu mới không khớp');
        return;
      }
      await pb.collection('users').update(id, body: {
        'oldPassword': oldPass,
        'password': newPass,
        'passwordConfirm': reNewPass,
      });

      Format.editToast('Đổi mật khẩu thành công');
    } catch (e) {
      if (e.toString().contains('oldPassword')) {
        Format.editToast('Mật khẩu cũ không chính xác');
      } else {
        Format.editToast('Lỗi khi đổi mật khẩu: $e');
      }
    }
  }

  Future<void> sendFeedback(String uid, String feedback) async {
    try {
      if (feedback == '') {
        Format.editToast('Vui lòng nhập ý kiến');
        return;
      }
      await pb.collection('feedbacks').create(body: {
        'feedback': feedback,
        'feedback_uid': uid,
      });
      Format.editToast('Đã gửi ý kiến');
    } catch (e) {
      Format.editToast('Lỗi khi gửi ý kiến: $e');
    }
  }
}

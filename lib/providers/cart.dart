import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/url.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final String imageUrl;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
    @required this.imageUrl,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  int choosenQuantiy = 1;

  Map<String, CartItem> get cartItems {
    return {..._items};
  }

  int get cartSize {
    return _items.length;
  }

  int setChoosenQuantity(int quantity) {
    return choosenQuantiy = quantity;
  }

  int get getChoosenQuantity {
    return choosenQuantiy;
  }

  double get cartTotalPrice {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  addToCart({int mealid, String quantity}) async {
    try {
      await http.post(Url.addtocart, body: {
        'mealid': mealid.toString(),
        'quantity': quantity,
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  deleteFromCart({int mealid, String quantity}) async {
    try {
      await http.post(Url.deletefromcart, body: {
        'mealid': mealid.toString(),
        'quantity': quantity,
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  addCartItem(
      {String productId,
      double price,
      String title,
      int quantity,
      String image}) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          price: existingCartItem.price,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + quantity,
          imageUrl: existingCartItem.imageUrl,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          price: price,
          title: title,
          quantity: quantity,
          imageUrl: image,
        ),
      );
    }
    notifyListeners();
  }

  removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  removeCartItem({
    String productId,
    double price,
    String title,
    int quantity,
    String image,
  }) {
    _items.update(
      productId,
      (existingCartItem) => CartItem(
        id: existingCartItem.id,
        price: existingCartItem.price,
        title: existingCartItem.title,
        quantity: existingCartItem.quantity - quantity,
        imageUrl: existingCartItem.imageUrl,
      ),
    );
    notifyListeners();
  }

  removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(productId, (existing) {
        return CartItem(
          id: existing.id,
          title: existing.title,
          quantity: existing.quantity - 1,
          price: existing.price,
          imageUrl: existing.imageUrl,
        );
      });
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  clearCart() {
    _items = {};
    notifyListeners();
  }
}

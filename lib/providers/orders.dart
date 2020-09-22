import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './cart.dart' show CartItem;
import '../models/url.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final String dateTime;
  final String available;
  final String orderID;
  final String deliveryMethod;
  final String paymentMethod;
  final String status;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
    this.available = 'No',
    @required this.orderID,
    @required this.deliveryMethod,
    @required this.paymentMethod,
    @required this.status,
  });
}

class Orders with ChangeNotifier {
  int cost;
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  int get delivery {
    return cost;
  }

  Future<void> fetchOrdersOnline(int userid) async {
    _orders = [];
    try {
      final List<OrderItem> loadedOrders = [];
      final response = await http.post(Url.yourOrders, body: {
        'userid': userid.toString(),
      });
      final extractedData = json.decode(response.body) as Map<dynamic, dynamic>;

      extractedData.forEach(
        (orderId, orderItems) {
          List<dynamic> ord = orderItems as List<dynamic>;
          ord.forEach(
            (element) {
              loadedOrders.add(
                OrderItem(
                  id: element['id'].toString(),
                  amount: double.parse(element['amount'].toString()),
                  dateTime: element['period'].toString(),
                  available: element['available'],
                  orderID: element['orderID'],
                  deliveryMethod: element['delivery_method'],
                  paymentMethod: element['payment_method'],
                  status: element['status'],
                  products: (json.decode(element['cartitems']) as List<dynamic>)
                      .map(
                        (value) => CartItem(
                          id: value['id'],
                          title: value['title'],
                          quantity: value['quantity'],
                          price: value['price'],
                          imageUrl: value['imageUrl'],
                        ),
                      )
                      .toList(),
                ),
              );
            },
          );
        },
      );
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(
    List<CartItem> cartProducts,
    double total,
    int userid,
    String delivery,
    String address,
    String payment,
  ) async {
    try {
      await http.post(Url.createOrders, body: {
        'userid': '$userid',
        'amount': '$total',
        'delivery_method': '$delivery',
        'payment_method': '$payment',
        'address': '$address',
        'cartitems': json.encode(
          cartProducts
              .map((cart) => {
                    'id': cart.id,
                    'title': cart.title,
                    'quantity': cart.quantity,
                    'price': cart.price,
                    'imageUrl': cart.imageUrl,
                  })
              .toList(),
        ),
        'period': '${DateTime.now()}',
      });
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  Future<void> deliveryCost() async {
    try {
      final response = await http.post(Url.deliveryCost);
      final amount = jsonDecode(response.body);
      cost = int.parse(amount['delivery_fee']);
    } catch (error) {
      throw error;
    }
  }

  Future<String> cancelOrder(int id, String orderID) async {
    try {
      var response = await http.post(Url.removeOrder, body: {'id': '$id'});
      var responseData = json.decode(response.body);

      if (responseData['message'] == 'true') removeFromOrderList(orderID);
      return responseData['message'];

    } catch (error) {
      throw error;
    }
  }

  void removeFromOrderList(String id) {
    _orders.removeWhere((element) => element.orderID == id);
  }
}

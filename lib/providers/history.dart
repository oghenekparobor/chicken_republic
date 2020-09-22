import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';
import '../models/url.dart';

class HistoryItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final String dateTime;

  HistoryItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class History with ChangeNotifier {
  List<HistoryItem> _transactions = [];

  History();

  List<HistoryItem> get transactions {
    return [..._transactions];
  }

  Future<void> fetchOrdersOnline(int userid) async {
    try {
      final List<HistoryItem> loadedTransaction = [];
      final response = await http.post(Url.yourHistory, body: {
        'userid': userid.toString(),
      });
      final extractedData = json.decode(response.body) as Map<dynamic, dynamic>;
      if (extractedData == null) {
        return;
      }

      extractedData.forEach((orderId, orderItems) {
        List<dynamic> ord = orderItems as List<dynamic>;
        ord.forEach((element) {
          loadedTransaction.add(HistoryItem(
            id: element['id'].toString(),
            amount: double.parse(element['amount'].toString()),
            dateTime: element['period'].toString(),
            products: (json.decode(element['cartitems']) as List<dynamic>)
                .map((value) => CartItem(
                      id: value['id'],
                      title: value['title'],
                      quantity: value['quantity'],
                      price: value['price'],
                      imageUrl: value['imageUrl'],
                    ))
                .toList(),
          ));
        });
      });
      _transactions = loadedTransaction.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> removeFromHistory(int id) async {
    try {
      await http.post('${Url.deleteHistory}', body: {
        'id': id.toString(),
      });
      _transactions.removeWhere((element) => element.id == id.toString());
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

}

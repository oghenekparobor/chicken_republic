import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../views/main_drawer.dart';
import '../providers/auth.dart';
import '../providers/orders.dart' show Orders;
import '../views/order_item.dart' as Or;
import '../views/bag.dart';

class OrdersScreen extends StatelessWidget {
  static const route = '/orders';
  const OrdersScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context).userId;
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [Bag()],
      ),
      drawer: const MainDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: const Text('My Orders',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
          ),
          Expanded(
            child: FutureBuilder(
              future: Provider.of<Orders>(context, listen: false)
                  .fetchOrdersOnline(int.parse(auth)),
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );
                } else {
                  if (dataSnapshot.data.toString().isEmpty) {
                    return Center(
                      child: Text('No transaction history'),
                    );
                  } else {
                    return Consumer<Orders>(
                      builder: (ctx, orders, child) => orders.orders.length < 1
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/order.png',
                                    // width: 150,
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'No orders yet',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'Please add an item to cart \nthen complete checkout process',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                Text(
                                  'swipe on an order to cancel',
                                  style: TextStyle(fontSize: 10),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemBuilder: (ctx, i) => Or.OrderItem(
                                      orderitem: orders.orders[i],
                                    ),
                                    itemCount: orders.orders.length,
                                  ),
                                ),
                              ],
                            ),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

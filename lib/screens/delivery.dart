import 'dart:convert';

import 'package:chicken_republic/providers/auth.dart';
import 'package:chicken_republic/providers/cart.dart';
import 'package:chicken_republic/providers/orders.dart';
import 'package:chicken_republic/screens/pay.dart';
import 'package:chicken_republic/screens/profile.dart';
import 'package:chicken_republic/views/bag.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

enum DeliveryMethod { pickup, home_delivery }

class Delivery extends StatefulWidget {
  static const route = '/delivery';
  Delivery({Key key}) : super(key: key);

  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  var _cost = 0;
  String _delivery = 'home_delivery';
  DeliveryMethod _deliveryMethod = DeliveryMethod.home_delivery;

  showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      backgroundColor: Colors.black45,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController address = new TextEditingController();
    int cost = Provider.of<Orders>(context, listen: true).delivery;
    _cost = cost;
    var authCart =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    final Cart cart = authCart['cart'];
    final Auth auth = authCart['auth'];
    var details = json.decode(auth.userDetail) as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
        actions: [Bag()],
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delivery Method',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                ),
                Text(
                  'Delivery time from 8am to 6pm',
                  style: TextStyle(fontSize: 11),
                )
              ],
            ),
          ),
          AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.easeIn,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Image.asset('assets/images/delivery.png'),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: ListTile(
              leading: Radio(
                  value: DeliveryMethod.home_delivery,
                  groupValue: _deliveryMethod,
                  onChanged: (DeliveryMethod value) {
                    setState(() {
                      _deliveryMethod = value;
                      _cost = cost;
                      _delivery = 'home_delivery';
                    });
                  }),
              title: Consumer<Orders>(
                builder: (ctx, orders, _) =>
                    Text('Door delivery (fee: #${orders.cost})'),
              ),
              subtitle: TextField(
                enabled: _deliveryMethod == DeliveryMethod.home_delivery
                    ? true
                    : false,
                autofocus: true,
                controller: address,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Please enter your delivery address.',
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: ListTile(
              leading: Radio(
                  value: DeliveryMethod.pickup,
                  groupValue: _deliveryMethod,
                  onChanged: (DeliveryMethod value) {
                    setState(() {
                      _deliveryMethod = value;
                      _cost = 0;
                      _delivery = 'pickup';
                    });
                  }),
              title: Text('Pickup from'),
              subtitle: Text('Chicken republic, Delta mall'),
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: RaisedButton.icon(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                if (address.text.isEmpty && _delivery == 'home_delivery') {
                  showToast('Please enter a drop location');
                } else if (details['mobile'].toString().isEmpty ||
                    details['username'].toString().isEmpty &&
                        _delivery == 'home_delivery') {
                  showToast(
                      'Please complete your profile detail before checking out.');
                  Navigator.of(context).pushNamed(Profile.route);
                } else if (details['mobile'].toString().isEmpty ||
                    details['username'].toString().isEmpty) {
                  showToast(
                      'Please complete your profile detail before checking out.');
                  Navigator.of(context).pushNamed(Profile.route);
                } else {
                  Navigator.of(context).pushNamed(
                    Pay.route,
                    arguments: {
                      'cart': cart,
                      'auth': auth,
                      'amount':
                          ((cart.cartTotalPrice.round() * 100) + (_cost * 100)),
                      'delivery_method': _delivery,
                      'address': address.text,
                    },
                  );
                }
              },
              icon: const Icon(Icons.credit_card, color: Colors.white),
              label: const Text(
                'Proceed to Pay',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 10)
        ],
      ),
    );
  }
}

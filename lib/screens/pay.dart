import 'package:chicken_republic/providers/auth.dart';
import 'package:chicken_republic/providers/cart.dart';
import 'package:chicken_republic/providers/orders.dart';
import 'package:chicken_republic/screens/home_overview.dart';
import 'package:chicken_republic/screens/orders_screen.dart';
import 'package:chicken_republic/views/bag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:provider/provider.dart';

enum PaymentMethod { card, cash }

class Pay extends StatefulWidget {
  static const route = '/payment';
  const Pay({Key key}) : super(key: key);

  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {
  var _publicKey = 'pk_live_2f6a28cf8e27012e5353c6bb9186d7f20a6f01ea';
  var _subAccount = 'ACCT_fcbkutqabzvjrkw';
  var _payment = 'card';
  PaymentMethod _payementMethod = PaymentMethod.card;

  finaliseOrders(
    Cart cart,
    Auth auth,
    String delivery,
    String address,
    String payment,
  ) async {
    await Provider.of<Orders>(context, listen: false).addOrder(
        cart.cartItems.values.toList(),
        cart.cartTotalPrice,
        int.parse(auth.userId),
        delivery,
        address,
        payment);
    cart.clearCart();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(HomeOverview.route, (route) => false);
    showToast('Your order has been placed successful');
  }

  showToast(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Text('Your orders has been placed successfully!'),
        ),
        actions: [
          RaisedButton(
            padding: const EdgeInsets.all(14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: Text('Continue shopping'),
          ),
          FlatButton(
            onPressed: () async {
              Navigator.of(context).pushReplacementNamed(OrdersScreen.route);
            },
            child: Text('View Orders'),
          ),
          SizedBox(width: 10)
        ],
      ),
    );
  }

  @override
  void initState() {
    PaystackPlugin.initialize(publicKey: _publicKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authCart =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    final Cart cart = authCart['cart'];
    final Auth auth = authCart['auth'];
    final int amount = authCart['amount'] as int;
    final String deliveryMethod = authCart['delivery_method'] as String;
    final String address = authCart['address'] as String;

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
            child: Text(
              'Payment Method',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
          ),
          AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.easeIn,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Image.asset('assets/images/payment.png'),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: ListTile(
              leading: Radio(
                  value: PaymentMethod.card,
                  groupValue: _payementMethod,
                  onChanged: (PaymentMethod value) {
                    setState(() {
                      _payementMethod = value;
                      _payment = 'card';
                    });
                  }),
              title: Text('Pay using card'),
              subtitle: FittedBox(
                child: Container(
                  margin: EdgeInsets.all(15),
                  height: 40,
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/mastercard.png',
                        height: 40,
                      ),
                      SizedBox(width: 10),
                      Image.asset(
                        'assets/images/visa.png',
                        height: 20,
                      ),
                      SizedBox(width: 10),
                      Image.asset(
                        'assets/images/verve.png',
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: ListTile(
              leading: Radio(
                  value: PaymentMethod.cash,
                  groupValue: _payementMethod,
                  onChanged: (PaymentMethod value) {
                    setState(() {
                      _payementMethod = value;
                      _payment = 'cash';
                    });
                  }),
              title: deliveryMethod == 'home_delivery'
                  ? Text('Make payment on delivery')
                  : Text('Make payment on pickup'),
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
                if (_payment == 'card') {
                  Charge charge = Charge()
                    ..amount = amount
                    ..reference = 'CDM_${DateTime.now()}'
                    ..subAccount = _subAccount
                    ..email = auth.email;
                  CheckoutResponse response = await PaystackPlugin.checkout(
                    context,
                    charge: charge,
                    logo: Image.asset('assets/images/logo.png', width: 50),
                    method: CheckoutMethod.card,
                  );
                  if (response.verify)
                    finaliseOrders(
                      cart,
                      auth,
                      deliveryMethod,
                      address,
                      _payment,
                    );
                } else {
                  finaliseOrders(
                    cart,
                    auth,
                    deliveryMethod,
                    address,
                    _payment,
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

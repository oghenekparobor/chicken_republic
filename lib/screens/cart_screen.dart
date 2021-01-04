import 'package:chicken_republic/auth/sign_in.dart';
import 'package:chicken_republic/providers/orders.dart';
import 'package:chicken_republic/screens/delivery.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../views/cart_item.dart';
import '../providers/cart.dart' show Cart;
import '../providers/auth.dart';

class CartScreen extends StatelessWidget {
  static const route = '/cart';
  const CartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<Orders>(context, listen: false).deliveryCost();
    final cart = Provider.of<Cart>(context);
    final auth = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: const Text(
                'My Cart',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (ctx, constraint) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        Text(
                          'swipe on an item to delete',
                          style: TextStyle(fontSize: 10),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (ctx, i) {
                              return CartItem(
                                cartId: cart.cartItems.values.toList()[i].id,
                                image:
                                    cart.cartItems.values.toList()[i].imageUrl,
                                mealid: cart.cartItems.keys.toList()[i],
                                price: cart.cartItems.values.toList()[i].price,
                                quantity:
                                    cart.cartItems.values.toList()[i].quantity,
                                title: cart.cartItems.values.toList()[i].title,
                              );
                            },
                            itemCount: cart.cartItems.length,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          // height: constraint.maxHeight / 4.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Divider(thickness: .5),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Subtotal ${cart.cartSize} items',
                                        style: TextStyle(fontSize: 9),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Image.asset(
                                        'assets/images/naira.png',
                                        width: 9,
                                        height: 9,
                                      ),
                                      Text(
                                        '${(cart.cartTotalPrice * 0.925).toStringAsFixed(2)}',
                                        style: TextStyle(fontSize: 9),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'VAT 7.5%',
                                        style: TextStyle(fontSize: 9),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Image.asset(
                                        'assets/images/naira.png',
                                        width: 9,
                                        height: 9,
                                      ),
                                      Text(
                                        '${(cart.cartTotalPrice * 0.075).toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 9,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Total',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Image.asset(
                                        'assets/images/naira.png',
                                        width: 14,
                                        height: 14,
                                      ),
                                      Text(
                                        '${(cart.cartTotalPrice).toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              FlatButtonWidget(cart: cart),
                              OrderButton(cart: cart, auth: auth),
                              SizedBox(height: 10)
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FlatButtonWidget extends StatelessWidget {
  const FlatButtonWidget({@required this.cart});

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      textColor: Theme.of(context).primaryColor,
      onPressed: cart.cartSize < 1 ? null : () {},
      child: const Text(
        'Apply Coupon',
        style: TextStyle(fontSize: 12),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({@required this.cart, @required this.auth});

  final Cart cart;
  final Auth auth;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  void showCustomDialog({
    Cart cart,
    Auth auth,
  }) {
    showDialog(
      context: context,
      builder: (context)=> Center(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * .4,
          margin: EdgeInsets.symmetric(horizontal: 50),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Material(
                    color: Color.fromRGBO(237, 237, 237, 1),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 30,
                      ),
                      child: FittedBox(
                        child: Text(
                          'Please note',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOCATION',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          'This app is meant for users within Warri only',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: FittedBox(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: RaisedButton(
                        elevation: 0,
                        color: Theme.of(context).primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        onPressed: () => Navigator.of(context).pushNamed(
                          Delivery.route,
                          arguments: {'cart': cart, 'auth': auth},
                        ),
                        child: FittedBox(
                          child: Text(
                            'Proceed',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Text('Proceed', style: TextStyle(color: Colors.white)),
      color: Theme.of(context).primaryColor,
      onPressed: widget.cart.cartSize < 1
          ? null
          : widget.auth.isAuth
              ? () {
                  showCustomDialog(auth: widget.auth, cart: widget.cart);
                }
              : () async {
                  Navigator.of(context).pushNamed(SignIn.route);
                  showToast('You need to sign in to proceed to checkout');
                },
    );
  }
}

showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    gravity: ToastGravity.CENTER,
    textColor: Colors.white,
    backgroundColor: Colors.black,
    toastLength: Toast.LENGTH_LONG,
  );
}

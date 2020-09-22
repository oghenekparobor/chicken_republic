import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../views/badge.dart';
import '../screens/cart_screen.dart';

class Bag extends StatelessWidget {
  const Bag({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (ctx, cart, child) => Badge(
        child: child,
        value: cart.cartSize.toString(),
        color: Theme.of(context).primaryColor,
      ),
      child: IconButton(
        icon: const Icon(Icons.shopping_basket),
        onPressed: () => Navigator.of(context).pushNamed(CartScreen.route),
      ),
    );
  }
}

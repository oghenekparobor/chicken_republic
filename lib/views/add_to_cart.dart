import 'package:chicken_republic/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../views/quantity_counter_vertical.dart';
import '../providers/cart.dart';
import '../views/my_flutter_app_icons.dart';
import '../providers/meals.dart';

class AddToCart extends StatefulWidget {
  final int mealid;
  final String title;
  final double price;
  final String image;
  final Color color;
  final BuildContext cxt;

  const AddToCart({
    this.color,
    this.cxt,
    this.mealid,
    this.title,
    this.price,
    this.image,
  });

  @override
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  int quan = 1;
  var init = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<Meals>(context, listen: false).setQuantity(widget.mealid);
      Provider.of<Cart>(context, listen: false).setChoosenQuantity(1);
    });
  }

  @override
  void didChangeDependencies() {
    setState(() {
      quan = Provider.of<Meals>(context, listen: true).getQuantity;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return Center(
      child: Container(
        width: 180,
        height: 260,
        child: Card(
          color: widget.color,
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop())
                ]),
                Expanded(
                    child: QuantityCounterVertical(
                  id: widget.mealid,
                  quan: quan,
                )),
                Container(
                  width: double.infinity,
                  child: RaisedButton.icon(
                    onPressed: quan < 3
                        ? null
                        : () async {
                            await cart.addToCart(
                                mealid: widget.mealid,
                                quantity: cart.choosenQuantiy.toString());
                            cart.addCartItem(
                              price: widget.price,
                              productId: widget.mealid.toString(),
                              quantity: cart.choosenQuantiy,
                              title: widget.title,
                              image: widget.image,
                            );
                            Navigator.of(context).pop();
                            Scaffold.of(widget.cxt).hideCurrentSnackBar();
                            Scaffold.of(widget.cxt).showSnackBar(SnackBar(
                              content: const Text('Added to Cart'),
                              action: SnackBarAction(
                                label: 'Proceed to checkout',
                                onPressed: () {
                                  Navigator.of(widget.cxt)
                                      .pushNamed(CartScreen.route);
                                },
                              ),
                              duration: Duration(seconds: 1),
                            ));
                          },
                    label: const Text('Bag It',
                        style: TextStyle(color: Colors.white)),
                    icon: Icon(MyFlutterApp.emo_happy, color: Colors.white),
                    padding: const EdgeInsets.all(12),
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

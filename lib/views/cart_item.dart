import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatefulWidget {
  final String cartId;
  final int quantity;
  final double price;
  final String mealid;
  final String title;
  final String image;

  const CartItem(
      {this.cartId,
      this.mealid,
      this.price,
      this.quantity,
      this.title,
      this.image});

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  int _current;

  @override
  Widget build(BuildContext context) {
    _current = widget.quantity;

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            Provider.of<Cart>(context, listen: false).removeItem(widget.mealid);
            Provider.of<Cart>(context, listen: false).deleteFromCart(
              mealid: int.parse(widget.mealid),
              quantity: '${widget.quantity}',
            );
          },
        )
      ],
      child: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 1),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(widget.image),
                  maxRadius: 30,
                ),
                title: Text(widget.title),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/naira.png',
                            width: 14,
                            height: 14,
                          ),
                          Text('${widget.price}'),
                        ],
                      ),
                    ),
                    Container(
                      child: Container(
                        height: 25,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).primaryColor,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.remove,
                                  size: 10,
                                  color: Colors.white,
                                ),
                                onPressed: _current < 2
                                    ? null
                                    : () {
                                        setState(() {
                                          _current -= 1;
                                          Provider.of<Cart>(context,
                                                  listen: false)
                                              .removeCartItem(
                                            image: widget.image,
                                            price: widget.price,
                                            productId: widget.mealid,
                                            quantity: 1,
                                          );
                                        });
                                      },
                              ),
                            ),
                            Text(
                              '$_current',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).primaryColor,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.add,
                                  size: 10,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _current += 1;

                                    Provider.of<Cart>(context, listen: false)
                                        .addCartItem(
                                      image: widget.image,
                                      price: widget.price,
                                      productId: widget.mealid,
                                      quantity: 1,
                                    );
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

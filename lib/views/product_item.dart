import 'package:chicken_republic/screens/cart_screen.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail.dart';
import '../views/add_to_cart.dart';
import '../models/meal.dart';
import '../providers/meals.dart';

class ProductItem extends StatefulWidget {
  static const route = '/product-item';
  ProductItem({this.meal});
  final Meal meal;

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  var isLoading = false;

  @override
  void initState() {
    _controller = AnimationController(
        duration: Duration(milliseconds: 500), vsync: this, value: .6);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceIn);

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void gotoCart() {
      Navigator.of(context).pushNamed(ProductDetail.route, arguments: {
        'id': '${widget.meal.id}',
        'title': widget.meal.title,
        'description': widget.meal.description,
        'price': '${widget.meal.price}',
        'imageUrl': widget.meal.picture1,
        'imageUrl2': widget.meal.picture2,
        'imageUrl3': widget.meal.picture3,
        'imageUrl4': widget.meal.picture4,
        'slashed_price': widget.meal.slashedprice,
        'color': Colors.white,
      }).then((value) {
        if (value != null) {
          // ignore: deprecated_member_use
          Scaffold.of(context).hideCurrentSnackBar();
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: const Text('Added to Cart'),
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'Proceed to Checkout',
                onPressed: () =>
                    Navigator.of(context).pushNamed(CartScreen.route),
              ),
            ),
          );
          Provider.of<Meals>(context, listen: false).resetFav();
        }
      });
    }

    return ScaleTransition(
      scale: _animation,
      alignment: Alignment.center,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: LayoutBuilder(
                builder: (cxt, constraint) => Stack(
                  children: [
                    GestureDetector(
                      onTap: gotoCart,
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Hero(
                          tag: widget.meal.id.toString(),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            child: FancyShimmerImage(
                              imageUrl: widget.meal.picture1,
                              boxFit: BoxFit.cover,
                              height: constraint.maxHeight,
                              width: constraint.maxWidth,
                              shimmerBackColor: Colors.grey,
                              shimmerBaseColor: Colors.grey.shade100,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AddToCart(
                                mealid: widget.meal.id,
                                color: Colors.white,
                                cxt: context,
                                image: widget.meal.picture1,
                                price: widget.meal.price,
                                title: widget.meal.title,
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(color: Colors.grey.shade400)
                                ]),
                            child: const Icon(
                              Icons.add,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(left: 8, right: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Text(
                        widget.meal.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/naira.png',
                                width: 14,
                                height: 14,
                              ),
                              Text(
                                '${widget.meal.price}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                          FlatButton(
                            onPressed: gotoCart,
                            child: Text(
                              'View detail',
                              style: TextStyle(
                                  fontSize: 10, color: Colors.redAccent),
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

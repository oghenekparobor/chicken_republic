import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../views/quantity_counter_horizontal.dart';
import '../providers/meals.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';
import '../views/my_flutter_app_icons.dart';
import '../views/bag.dart';

class ProductDetail extends StatefulWidget {
  static const route = '/product-detail';
  const ProductDetail({Key key}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int _current = 0;
  // int quan = 1;
  var iOS = Platform.isIOS;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i));
    }
    return result;
  }

  @override
  void didChangeDependencies() {
    Provider.of<Meals>(context, listen: true).getQuantity;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> details =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    String authId = Provider.of<Auth>(context, listen: false).userId;
    Provider.of<Meals>(context, listen: false)
        .showFav(int.parse(details['id']), authId);
    List<String> images = [
      if (details['imageUrl'].toString().endsWith('png') ||
          details['imageUrl'].toString().endsWith('jpg') ||
          details['imageUrl'].toString().endsWith('jpeg'))
        details['imageUrl'].toString(),
      if (details['imageUrl2'].toString().endsWith('png') ||
          details['imageUrl2'].toString().endsWith('jpg') ||
          details['imageUrl2'].toString().endsWith('jpeg'))
        details['imageUrl2'].toString(),
      if (details['imageUrl3'].toString().endsWith('png') ||
          details['imageUrl3'].toString().endsWith('jpg') ||
          details['imageUrl3'].toString().endsWith('jpeg'))
        details['imageUrl3'].toString(),
      if (details['imageUrl4'].toString().endsWith('png') ||
          details['imageUrl4'].toString().endsWith('jpg') ||
          details['imageUrl4'].toString().endsWith('jpeg'))
        details['imageUrl4'].toString(),
    ];

    double sp = double.parse(details['slashed_price']);
    double p = double.parse(details['price']);
    double yousave = ((sp - p) / sp) * 100;

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
        backgroundColor:
            details['color'] == null ? Colors.white38 : details['color'],
        actions: [Bag()],
      ),
      body: Consumer<Meals>(
        builder: (ctx, meals, child) => LayoutBuilder(
          builder: (ctx, constraint) {
            return Stack(
              children: [
                Container(
                  height: constraint.maxHeight,
                  width: constraint.maxWidth,
                  color: details['color'] == null
                      ? Colors.white38
                      : details['color'],
                ),
                Container(
                  height: height - height / 2,
                  width: width,
                  alignment: Alignment.center,
                  child: Hero(
                    tag: details['id'],
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: CarouselSlider.builder(
                        itemBuilder: (ctx, i) => FadeInImage(
                          placeholder:
                              const AssetImage('assets/images/placeholder.png'),
                          fadeInCurve: Curves.easeIn,
                          fit: BoxFit.cover,
                          fadeOutCurve: Curves.easeOut,
                          image: NetworkImage(images[i]),
                        ),
                        itemCount: images.length,
                        options: CarouselOptions(
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }),
                      ),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    // top: height - height / 3 - 130,
                    // right: width / 2.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: map<Widget>(images, (index) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin:
                              EdgeInsets.symmetric(vertical: 12, horizontal: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == index
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).primaryColorLight,
                          ),
                        );
                      }),
                    )),
                Positioned(
                  top: height - height / 3 - 100,
                  child: Container(
                    padding: EdgeInsets.all(18),
                    height: height / 3 + 25,
                    width: width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              offset: Offset(8, 9),
                              blurRadius: 11,
                              spreadRadius: 1)
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          details['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            details['description'],
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                QuantityCounterHorizontal(
                                  id: int.parse(details['id'].toString()),
                                  quan: meals.getQuantity,
                                ),
                                Row(
                                  children: [
                                    if (yousave > 0)
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/naira.png',
                                            width: 12,
                                            height: 12,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            '${details['slashed_price']}',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                        ],
                                      ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/naira.png',
                                          width: 21,
                                          height: 21,
                                        ),
                                        Text(
                                          '${details['price']}',
                                          style: TextStyle(
                                              fontSize: 21,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (yousave > 0)
                                  Text(
                                    'You save: ${yousave.toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 9,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Container(
                          height: 50,
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 1),
                                    borderRadius: BorderRadius.circular(12)),
                                child: IconButton(
                                  icon: Icon(
                                      meals.favStatus
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Theme.of(context).primaryColor),
                                  onPressed: () {
                                    Provider.of<Meals>(context, listen: false)
                                        .addFav(
                                            int.parse(details['id']), authId);
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Consumer<Cart>(
                                  builder: (ctx, cart, child) =>
                                      RaisedButton.icon(
                                    onPressed: meals.getQuantity < 3
                                        ? null
                                        : () async {
                                            await cart.addToCart(
                                                mealid:
                                                    int.parse(details['id']),
                                                quantity: cart.choosenQuantiy
                                                    .toString());
                                            cart.addCartItem(
                                              price: double.parse(
                                                  details['price']),
                                              productId: details['id'],
                                              quantity: cart.choosenQuantiy,
                                              title: details['title'],
                                              image: details['imageUrl'],
                                            );

                                            Navigator.of(context)
                                                .pop('added to cart');
                                          },
                                    label: FittedBox(
                                      child: const Text(
                                        'Bag It',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    icon: const Icon(MyFlutterApp.emo_happy,
                                        color: Colors.white),
                                    padding: const EdgeInsets.all(18),
                                    color: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

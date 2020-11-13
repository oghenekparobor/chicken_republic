import 'dart:math';

import 'package:chicken_republic/providers/orders.dart';
import 'package:chicken_republic/screens/orders_screen.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_clipboard_manager/flutter_clipboard_manager.dart';

import '../providers/orders.dart' as i;
import '../views/my_flutter_app_icons.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({this.orderitem});

  final i.OrderItem orderitem;

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  showOrderQr(BuildContext ctx, String orderid) {
    showDialog(context: ctx, child: QRImage(orderid: orderid));
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Orders>(context, listen: false).deliveryCost();
    var d = DateTime.parse(widget.orderitem.dateTime);
    var fd = DateFormat.yMMMMEEEEd().format(d);

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Cancel order',
          color: Colors.red,
          icon: Icons.cancel_rounded,
          onTap: () {
            try {
              Provider.of<Orders>(context, listen: false)
                  .cancelOrder(
                int.parse(widget.orderitem.id),
                widget.orderitem.orderID,
              )
                  .then((value) {
                if (value == 'true') {
                  showToast('Your order has been cancelled');
                  Navigator.of(context)
                      .pushReplacementNamed(OrdersScreen.route);
                } else {
                  showToast('Your order cannot be cancelled');
                }
              });
            } catch (error) {}
          },
        )
      ],
      child: Container(
        child: Column(
          children: [
            ListTile(
                leading: widget.orderitem.available == 'Yes'
                    ? const Icon(MyFlutterApp.emo_thumbsup)
                    : const Icon(MyFlutterApp.hourglass),
                title: Text('$fd'),
                subtitle: Column(
                  children: [
                    Row(
                      children: [
                        Text('Sum total of: '),
                        Image.asset(
                          'assets/images/naira.png',
                          width: 12,
                          height: 12,
                        ),
                        Text(
                          '${widget.orderitem.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (widget.orderitem.deliveryMethod == 'home_delivery')
                      Row(
                        children: [
                          Text('Delivery fee: '),
                          Image.asset(
                            'assets/images/naira.png',
                            width: 12,
                            height: 12,
                          ),
                          Consumer<Orders>(
                            builder: (context, orders, _) => Text(
                              '${orders.cost}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                trailing: FittedBox(
                  child: Column(
                    children: [
                      FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onPressed: () =>
                              showOrderQr(context, widget.orderitem.orderID),
                          child: const Text(
                            'VIEW ORDER ID',
                            style: TextStyle(fontSize: 10),
                          )),
                      IconButton(
                        icon: Icon(
                          _expanded ? Icons.expand_less : Icons.expand_more,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _expanded = !_expanded;
                          });
                        },
                      ),
                    ],
                  ),
                )),
            AnimatedContainer(
              duration: const Duration(milliseconds: 700),
              margin: const EdgeInsets.all(8),
              height: _expanded
                  ? min(widget.orderitem.products.length * 30.0 + 120, 320)
                  : 0,
              width: double.infinity,
              child: ListView.builder(
                itemBuilder: (ctx, i) => ListTile(
                  leading: Container(
                    width: 90,
                    height: 90,
                    child: FadeInImage(
                      placeholder: AssetImage('assets/images/placeholder.png'),
                      fadeInCurve: Curves.easeIn,
                      fit: BoxFit.cover,
                      fadeOutCurve: Curves.easeOut,
                      image:
                          NetworkImage(widget.orderitem.products[i].imageUrl),
                    ),
                  ),
                  title: Text('${widget.orderitem.products[i].title}'),
                  subtitle: Row(
                    children: [
                      Image.asset(
                        'assets/images/naira.png',
                        width: 12,
                        height: 12,
                      ),
                      Text(
                        '${widget.orderitem.products[i].price}',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  trailing: Text('x ${widget.orderitem.products[i].quantity}'),
                ),
                itemCount: widget.orderitem.products.length,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
              ),
            ),
            if (_expanded)
              Center(
                child: widget.orderitem.available == 'No' &&
                        widget.orderitem.status == 'processing'
                    ? Text('Your order is being processed')
                    : widget.orderitem.status == 'processing' &&
                            widget.orderitem.deliveryMethod == 'pickup'
                        ? Text(
                            'Your order is ready for pickup',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          )
                        : widget.orderitem.status == 'processed' &&
                                widget.orderitem.deliveryMethod ==
                                    'home_delivery'
                            ? Text(
                                'Your order is on the way',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                            : Text(
                                'Your order is on the way',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
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

class QRImage extends StatelessWidget {
  const QRImage({this.orderid});
  final String orderid;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 170,
        height: MediaQuery.of(context).size.height * .3,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(3, 5),
            spreadRadius: 1,
            blurRadius: 15,
          )
        ]),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              QrImage(
                data: orderid,
                version: QrVersions.auto,
                size: 170,
                gapless: false,
              ),
              FittedBox(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1)),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.all(5),
                        child: Text(
                          orderid,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.content_copy),
                        onPressed: () => FlutterClipboard.copy(orderid).then(
                          (value) => Fluttertoast.showToast(
                            msg: 'Copied to clipboad',
                            gravity: ToastGravity.BOTTOM,
                            textColor: Colors.white,
                            backgroundColor: Colors.black45,
                            toastLength: Toast.LENGTH_SHORT,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
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

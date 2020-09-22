import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/meals.dart';
import '../providers/cart.dart';

class QuantityCounterVertical extends StatefulWidget {
  final int id;
  final int quan;
  QuantityCounterVertical({this.id, this.quan});

  @override
  _QuantityCounterVerticalState createState() =>
      _QuantityCounterVerticalState();
}

class _QuantityCounterVerticalState extends State<QuantityCounterVertical> {
  var _quantity = 1;
  var init = true;

  @override
  void didChangeDependencies() {
    if (init) {
      Provider.of<Meals>(context).setQuantity(widget.id);
    }
    init = false;
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    // final int quan = Provider.of<Meals>(context, listen: false).getQuantity;
    return 
    // widget.quan < 3
    //     ? Center(
    //         child: Container(
    //           margin: EdgeInsets.only(left: 4),
    //           child: Text(
    //             'Out of Stock',
    //             style: TextStyle(
    //               fontWeight: FontWeight.bold,
    //               color: Theme.of(context).errorColor,
    //             ),
    //           ),
    //         ),
    //       )
    //     : 
        Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    //get total product count and disable button accordingly
                    onPressed: _quantity >= widget.quan
                        ? null
                        : () {
                            setState(() {
                              _quantity += 1;
                              Provider.of<Cart>(context, listen: false)
                                  .setChoosenQuantity(_quantity);
                            });
                          },
                    color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text('$_quantity',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor)),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: _quantity == 1
                      ? null
                      : () {
                          setState(() {
                            _quantity -= 1;
                            Provider.of<Cart>(context, listen: false)
                                .setChoosenQuantity(_quantity);
                          });
                        },
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          );
  }
}

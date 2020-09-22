import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/meals.dart';
import '../providers/cart.dart';

class QuantityCounterHorizontal extends StatefulWidget {
  QuantityCounterHorizontal({this.id, this.quan});
  final int id;
  final int quan;

  @override
  _QuantityCounterHorizontalState createState() =>
      _QuantityCounterHorizontalState();
}

class _QuantityCounterHorizontalState extends State<QuantityCounterHorizontal> {
  var _quantity = 1;
  var init = true;

  @override
  void didChangeDependencies() {
    if (init) {
      Provider.of<Meals>(context, listen: false).setQuantity(widget.id);
    }
    init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final int quan = Provider.of<Meals>(context, listen: false).getQuantity;

    return
        // widget.quan < 3
        //     ? Container(
        //         margin: EdgeInsets.only(left: 4),
        //         child: Text(
        //           'Out of Stock',
        //           style: TextStyle(
        //             fontWeight: FontWeight.bold,
        //             color: Theme.of(context).errorColor,
        //           ),
        //         ),
        //       )
        //     :
        Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
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
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          '$_quantity',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 8,
        ),
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
        ),
      ],
    );
  }
}

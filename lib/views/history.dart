import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/history.dart' as Hist;

class History extends StatefulWidget {
  History({this.history});
  final Hist.HistoryItem history;

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    var fd =
        DateFormat.yMMMEd().format(DateTime.parse(widget.history.dateTime));

    return Dismissible(
      key: ValueKey(widget.history.id),
      background: Container(
        color: Theme.of(context).errorColor,
        margin: EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            const Text(
              'REMOVE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 22,
            ),
            const Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(
              width: 18,
            ),
          ],
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (dir) async {
        await Provider.of<Hist.History>(context, listen: false)
            .removeFromHistory(int.parse(widget.history.id));
      },
      child: Container(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.history),
              title: Text('$fd'),
              subtitle: Text(
                'Sum total of: ₦${widget.history.amount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 12),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 700),
              margin: const EdgeInsets.all(8),
              height: _expanded
                  ? min(widget.history.products.length * 30.0 + 120, 320)
                  : 0,
              width: double.infinity,
              child: ListView.builder(
                itemBuilder: (ctx, i) => ListTile(
                  leading: Container(
                    width: 90,
                    height: 90,
                    child: FadeInImage(
                            placeholder: const AssetImage(
                                'assets/images/placeholder.png'),
                            fadeInCurve: Curves.easeIn,
                            fit: BoxFit.cover,
                            fadeOutCurve: Curves.easeOut,
                            image: NetworkImage(widget.history.products[i].imageUrl),
                          ),
                  ),
                  title: Text('${widget.history.products[i].title}'),
                  subtitle: Text('₦${widget.history.products[i].price}'),
                  trailing: Text('x ${widget.history.products[i].quantity}'),
                ),
                itemCount: widget.history.products.length,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

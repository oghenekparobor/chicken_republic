
import 'package:chicken_republic/screens/search_screen.dart';
import 'package:chicken_republic/views/bag.dart';
import 'package:flutter/material.dart';

class Searching extends StatelessWidget {
  static const route = '/searching';
  const Searching({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    runSearch(dynamic value) {
      Navigator.of(context).pushNamed(Search.route, arguments: value);
    }
    return Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [Bag()],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: TextField(
                autofocus: true,
                enabled: true,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  labelText: 'Search here',
                ),
                onSubmitted: (value) => runSearch(value),
              ),
            ),
          ],
        ));
  }
}


import 'package:chicken_republic/views/bag.dart';
import 'package:chicken_republic/views/products_grid.dart';
import 'package:flutter/material.dart';

class CategoryView extends StatelessWidget {
  static const route = '/category_view';
  const CategoryView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var category = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [Bag()],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text(
                '$category',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: ProductsGrid(category),
              ),
            )
          ],
        ),
      ),
    );
  }
}

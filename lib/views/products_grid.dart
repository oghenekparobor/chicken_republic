import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../views/product_item.dart';
import '../providers/meals.dart';
import '../models/meal.dart';

class ProductsGrid extends StatefulWidget {
  final String category;
  ProductsGrid([this.category]);

  @override
  _ProductsGridState createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  var _isInit = true;
  List<Meal> meals;

  @override
  void initState() {
    super.initState();
  }

  Future<void> initMeals() async {
    try {
      if (widget.category == null) {
        await Provider.of<Meals>(context, listen: false)
            .loadAllMealsFromMemory();
      } else {
        Provider.of<Meals>(context).loadCategorizedMeals(widget.category);
      }
    } catch (error) {
      print('$error');
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      initMeals();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.category == null) {
      meals = Provider.of<Meals>(context, listen: true).meals;
    } else {
      meals = Provider.of<Meals>(context).cmeals;
    }

    return Container(
      color: Color.fromRGBO(245, 245, 245, 1),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .6,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: meals[i],
          child: ProductItem(meal: meals[i]),
        ),
        itemCount: meals.length,
      ),
    );
  }
}

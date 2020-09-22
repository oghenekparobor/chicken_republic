import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../views/main_drawer.dart';
import '../views/product_item.dart';
import '../providers/meals.dart';
import '../providers/auth.dart';
import '../views/bag.dart';

class FavoriteScreen extends StatelessWidget {
  static const route = '/favorites';
  const FavoriteScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context, listen: false).userId;

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [Bag()],
      ),
      drawer: const MainDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: const Text('My Favorites',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
          ),
          Expanded(
            child: FutureBuilder(
                future: Provider.of<Meals>(context, listen: false)
                    .getAllFav(int.parse(auth)),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    );
                  } else {
                    if (snapshot.data.toString().isEmpty) {
                      return Center(child: Text('No favorites'));
                    } else {
                      return Consumer<Meals>(
                        builder: (ctx, meals, child) =>
                            meals.favMeals.length < 1
                                ? Center(
                                    child: Text('No favorites'),
                                  )
                                : GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: isLandscape ? 4 : 2,
                                      childAspectRatio: .6,
                                    ),
                                    itemBuilder: (ctx, i) => ProductItem(
                                      meal: meals.favMeals[i],
                                    ),
                                    itemCount: meals.favMeals.length,
                                  ),
                      );
                    }
                  }
                }),
          ),
        ],
      ),
    );
  }
}

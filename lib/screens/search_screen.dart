import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../views/bag.dart';
import '../views/product_item.dart';
import '../providers/meals.dart';

class Search extends StatefulWidget {
  static const route = '/search';
  const Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this, value: .1);
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCirc);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var search = ModalRoute.of(context).settings.arguments as dynamic;

    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
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
            child: const Text('My Search',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
          ),
          Expanded(
            child: FutureBuilder(
              future:
                  Provider.of<Meals>(context, listen: false).searchMeal(search),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );
                } else {
                  if (snapshot.error != null) {
                    return Center(child: Text('No meal found'));
                  } else {
                    return ScaleTransition(
                      scale: _animation,
                      alignment: Alignment.center,
                      child: MySearchGirdView(isLandscape: isLandscape),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MySearchGirdView extends StatelessWidget {
  const MySearchGirdView({@required this.isLandscape});

  final bool isLandscape;

  @override
  Widget build(BuildContext context) {
    return Consumer<Meals>(
      builder: (ctx, meals, child) => meals.searchedMeals.length < 1
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/search.png',
                    // width: 150,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Meal not found',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Try searching for a different meal.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isLandscape ? 4 : 2,
                childAspectRatio: .6,
              ),
              itemBuilder: (ctx, i) => ProductItem(
                meal: meals.searchedMeals[i],
              ),
              itemCount: meals.searchedMeals.length,
            ),
    );
  }
}

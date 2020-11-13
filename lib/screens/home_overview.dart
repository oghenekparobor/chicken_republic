import 'package:chicken_republic/providers/cart.dart';
import 'package:chicken_republic/screens/category_view.dart';
import 'package:chicken_republic/screens/searching.dart';
import 'package:chicken_republic/views/badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../views/main_drawer.dart';
import '../views/products_grid.dart';
import '../providers/categories.dart';
import 'cart_screen.dart';

// GlobalKey<ScaffoldState> _drawerState = GlobalKey();

class HomeOverview extends StatefulWidget {
  static const route = '/home-overview';
  const HomeOverview({Key key}) : super(key: key);

  @override
  _HomeOverviewState createState() => _HomeOverviewState();
}

class _HomeOverviewState extends State<HomeOverview> {
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) =>
        Provider.of<Categories>(context, listen: false).getCategories());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      body: ShowCaseWidget(
        builder: Builder(
          builder: (ctx) =>
              MyNestedScrollView(scrollController: _scrollController),
        ),
      ),
      drawer: const MainDrawer(),
    );
  }
}

class MyNestedScrollView extends StatefulWidget {
  const MyNestedScrollView({
    Key key,
    @required ScrollController scrollController,
  })  : _scrollController = scrollController,
        super(key: key);

  final ScrollController _scrollController;

  @override
  _MyNestedScrollViewState createState() => _MyNestedScrollViewState();
}

class KeysToBeInherited extends InheritedWidget {
  final GlobalKey menuKey;
  final GlobalKey cartKey;
  final GlobalKey categoryKey;
  final GlobalKey searchKey;

  KeysToBeInherited({
    this.menuKey,
    this.cartKey,
    this.categoryKey,
    this.searchKey,
    Widget child,
  }) : super(child: child);

  static KeysToBeInherited of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType(
        aspect: KeysToBeInherited);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class _MyNestedScrollViewState extends State<MyNestedScrollView> {
  GlobalKey _menuKey = GlobalKey();
  GlobalKey _cartKey = GlobalKey();
  GlobalKey _searchKey = GlobalKey();
  GlobalKey _categoryKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    SharedPreferences preferences;

    displayShowCase() async {
      preferences = await SharedPreferences.getInstance();
      bool showCaseVisibilityStatus = preferences.getBool('displayShowcase');

      if (showCaseVisibilityStatus == null) {
        return 'true';
      }
      return 'false';
    }

    displayShowCase().then((value) {
      if (value == 'true') {
        ShowCaseWidget.of(context).startShowCase([
          // _menuKey,
          _cartKey,
          _searchKey,
          _categoryKey,
        ]);
        preferences.setBool('displayShowcase', false);
      }
    });

    return KeysToBeInherited(
      cartKey: _cartKey,
      menuKey: _menuKey,
      categoryKey: _categoryKey,
      searchKey: _searchKey,
      child: NestedScrollView(
        controller: widget._scrollController,
        headerSliverBuilder: (ctx, innerBoxScrolled) {
          return <Widget>[
            MyAppBar(
              controller: widget._scrollController,
              innerBox: innerBoxScrolled,
            ),
          ];
        },
        body: FutureBuilder(
          future:
              Provider.of<Categories>(context, listen: false).getCategories(),
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
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Please check your network connection'),
                      FlatButton(
                        onPressed: () => Navigator.of(context)
                            .pushReplacementNamed(HomeOverview.route),
                        child: Text(
                          'Try again',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else if (snapshot.data.toString().isEmpty) {
                return Text('No products available');
              } else {
                // return MyTabView();
                return Container(
                  child: ProductsGrid(),
                );
              }
            }
          },
        ),
      ),
    );
  }
}

class MyAppBar extends StatefulWidget {
  MyAppBar({this.innerBox, this.controller});

  final bool innerBox;
  final ScrollController controller;

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  bool showSearchBar = true;
  bool isScrollingDown = false;
  bool _show = true;
  double searchBarHeight = 52;

  @override
  void initState() {
    super.initState();
    myScroll();
  }

  @override
  void dispose() {
    widget.controller.removeListener(() {});
    super.dispose();
  }

  void showSearchBarApp() {
    setState(() {
      _show = true;
    });
  }

  void hideSearchBar() {
    setState(() {
      _show = false;
    });
  }

  void myScroll() async {
    widget.controller.addListener(() {
      if (widget.controller.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          showSearchBar = false;
          hideSearchBar();
        }
      }
      if (widget.controller.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          showSearchBar = true;
          showSearchBarApp();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(''),
      backgroundColor: Colors.white,
      iconTheme: Theme.of(context).iconTheme,
      pinned: true,
      floating: true,
      forceElevated: widget.innerBox,
      actions: [
        Consumer<Cart>(
          builder: (ctx, cart, child) => Showcase(
            key: KeysToBeInherited.of(context).cartKey,
            title: 'Cart',
            description: 'Click to go cart & also proceed to checkout',
            child: Badge(
              child: child,
              value: cart.cartSize.toString(),
              color: Theme.of(context).primaryColor,
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.shopping_basket),
            onPressed: () => Navigator.of(context).pushNamed(CartScreen.route),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: _show ? Size.fromHeight(110) : Size.fromHeight(50),
        child: Column(
          children: [
            AnimatedContainer(
              duration: Duration.zero,
              curve: Curves.bounceInOut,
              height: _show ? 52 : 0,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(Searching.route),
                child: Showcase(
                  key: KeysToBeInherited.of(context).searchKey,
                  title: 'Search Bar',
                  description: 'Click to search for particular food item',
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    height: 52,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Search Here',
                          style: TextStyle(color: Colors.grey),
                        ),
                        _show ? Icon(Icons.search) : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Showcase(
              key: KeysToBeInherited.of(context).categoryKey,
              title: 'Categories',
              description: 'Click to view all meals in a category',
              child: Container(
                width: double.infinity,
                height: 50,
                child: Consumer<Categories>(
                  builder: (ctx, categories, child) => ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushNamedAndRemoveUntil('/', (route) => false),
                        child: Container(
                          margin: EdgeInsets.only(left: 15, right: 5),
                          height: 52,
                          alignment: Alignment.center,
                          child: Text(
                            'All Meals',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.black, width: 2),
                            ),
                          ),
                        ),
                      ),
                      for (int i = 0; i < categories.items.length; i++)
                        CustomTabs(category: categories.items[i].category)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomTabs extends StatelessWidget {
  const CustomTabs({this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(CategoryView.route, arguments: category),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        padding: EdgeInsets.symmetric(horizontal: 5),
        height: 52,
        alignment: Alignment.center,
        child: Text(
          '$category',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}

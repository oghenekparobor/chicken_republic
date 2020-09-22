import 'package:chicken_republic/auth/sign_in.dart';
import 'package:chicken_republic/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/orders_screen.dart';
import '../screens/transaction_history.dart';
import '../screens/favorite_screen.dart';
import '../screens/profile.dart';
import '../screens/home_overview.dart';
import '../providers/auth.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key key}) : super(key: key);

  void launchSoftkodes() async {
    const url = 'https://soft-kode.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Cannot launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
        child: Drawer(
          elevation: 5,
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 60,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    children: [
                      // SizedBox(height: 80),
                      const Divider(),
                      ListTile(
                        onTap: () => Navigator.of(context)
                            .pushReplacementNamed(HomeOverview.route),
                        leading: Icon(
                          Icons.dashboard,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          'Menu',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        onTap: auth.isAuth
                            ? () => Navigator.of(context)
                                .pushReplacementNamed(OrdersScreen.route)
                            : () {
                                Navigator.of(context)
                                    .pushNamed(SignIn.route)
                                    .then((value) {
                                  if (value != null)
                                    Navigator.of(context).pushReplacementNamed(
                                      OrdersScreen.route,
                                    );
                                });
                                showToast(
                                    'You need to sign in to view your orders');
                              },
                        leading: const Icon(Icons.payment),
                        title: const Text('My Orders'),
                      ),
                      ListTile(
                        onTap: auth.isAuth
                            ? () => Navigator.of(context)
                                .pushReplacementNamed(TransactionHistory.route)
                            : () {
                                Navigator.of(context)
                                    .pushNamed(SignIn.route)
                                    .then((value) {
                                  if (value != null)
                                    Navigator.of(context).pushReplacementNamed(
                                      TransactionHistory.route,
                                    );
                                });
                                showToast(
                                    'You need to sign in to view your transaction history');
                              },
                        leading: const Icon(Icons.history),
                        title: const Text('Transaction History'),
                      ),
                      ListTile(
                        onTap: auth.isAuth
                            ? () => Navigator.of(context)
                                .pushReplacementNamed(FavoriteScreen.route)
                            : () {
                                Navigator.of(context)
                                    .pushNamed(SignIn.route)
                                    .then((value) {
                                  if (value != null)
                                    Navigator.of(context).pushReplacementNamed(
                                      FavoriteScreen.route,
                                    );
                                });
                                showToast(
                                    'You need to sign in to view your favorites');
                              },
                        leading: const Icon(Icons.fastfood),
                        title: const Text('Favorites'),
                      ),
                      ListTile(
                        onTap: auth.isAuth
                            ? () => Navigator.of(context)
                                .pushReplacementNamed(Profile.route)
                            : () {
                                Navigator.of(context)
                                    .pushNamed(SignIn.route)
                                    .then((value) {
                                  if (value != null)
                                    Navigator.of(context).pushReplacementNamed(
                                      Profile.route,
                                    );
                                });
                                showToast(
                                    'You need to sign in to view your profile');
                              },
                        leading: const Icon(Icons.person_outline),
                        title: const Text('Profile'),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed(Settings.route);
                        },
                        leading: const Icon(Icons.headset_mic),
                        title: const Text('Help Desk'),
                      ),
                      if (!auth.isAuth)
                        ListTile(
                          onTap: () => Navigator.of(context).pushNamed(SignIn.route),
                          leading: const Icon(Icons.arrow_forward),
                          title: const Text('Login/Register'),
                        ),
                      if (auth.isAuth)
                        ListTile(
                          onTap: () async {
                            await auth.logout();
                            Navigator.of(context).pop();
                            Navigator.of(context)
                                .pushNamedAndRemoveUntil('/', (route) => false);
                            showToast('Logged out');
                          },
                          leading: const Icon(Icons.power_settings_new),
                          title: const Text('Logout'),
                        ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => launchSoftkodes(),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        Text(
                          'developed by Softkodes',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black38),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
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

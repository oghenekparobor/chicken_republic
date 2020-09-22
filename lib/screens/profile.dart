import 'dart:convert';

import 'package:chicken_republic/screens/cart_screen.dart';
import 'package:chicken_republic/screens/home_overview.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../views/main_drawer.dart';
import '../views/bag.dart';
import '../providers/auth.dart';
import '../screens/profile_edit.dart';

class Profile extends StatelessWidget {
  static const route = '/profile';
  Profile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);
    // var conv = md5.convert(utf8.encode(auth.userId));
    var details = json.decode(auth.userDetail) as Map<String, dynamic>;
    var _year = DateFormat.y().format(DateTime.now());

    Future<void> _show(ctx) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
          title: Text('Profile update'),
          content: Text('Your profile has been updated successfully.'),
          actions: [
            FittedBox(
              child: Row(
                children: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          HomeOverview.route, (route) => false);
                      // Navigator.of(ctx).pop();
                    },
                    child: Text('Continue shopping'),
                  ),
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      // Navigator.of(ctx).pop();
                      Navigator.of(ctx).pushNamed(CartScreen.route);
                    },
                    child: Text('Proceed to checkout'),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }

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
            child: const Text('My Profile',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 12),
                      CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              const AssetImage('assets/images/profiling.png'),
                          maxRadius: 60),
                      const SizedBox(height: 8),
                      Text(
                        details['username'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${auth.email}',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(250, 250, 250, 1),
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(22),
                                topRight: Radius.circular(22),
                              ),
                            ),
                            child: const Icon(
                              Icons.phone_android,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 18),
                          const Expanded(flex: 2, child: Text('Mobile Number')),
                          const Expanded(flex: 1, child: Text('-')),
                          Expanded(
                            flex: 2,
                            child: Container(
                                margin: EdgeInsets.only(right: 12),
                                child: Text(
                                  details['mobile'],
                                  maxLines: 1,
                                )),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(250, 250, 250, 1),
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(22),
                                topRight: Radius.circular(22),
                              ),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 18),
                          const Expanded(
                            flex: 2,
                            child: Text('Customer\'s ID '),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Text('-'),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: EdgeInsets.only(right: 12),
                              child: Text('CDM/$_year/${auth.userId}',
                                  maxLines: 1),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(250, 250, 250, 1),
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(22),
                                topRight: Radius.circular(22),
                              ),
                            ),
                            child: const Icon(
                              Icons.my_location,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 18),
                          const Expanded(flex: 2, child: Text('Address')),
                          const Expanded(flex: 1, child: Text('-')),
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: EdgeInsets.only(right: 12),
                              child: Text(details['address']),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: 150,
                    margin: const EdgeInsets.all(30),
                    child: RaisedButton(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(ProfileEdit.route, arguments: details)
                          .then((value) {
                        if (value == 'cart not empty') _show(context);
                      }),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('Edit'),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

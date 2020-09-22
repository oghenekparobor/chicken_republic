import 'dart:convert';

import 'package:chicken_republic/helpers/local_notification.dart';
import 'package:chicken_republic/screens/category_view.dart';
import 'package:chicken_republic/screens/delivery.dart';
import 'package:chicken_republic/screens/pay.dart';
import 'package:chicken_republic/screens/searching.dart';
import 'package:chicken_republic/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './screens/verify_auth.dart';
import './auth/sign_in.dart';
import './auth/sign_up.dart';
import './screens/home_overview.dart';
import './screens/product_detail.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/transaction_history.dart';
import './screens/favorite_screen.dart';
import './screens/profile.dart';
import './providers/categories.dart';
import './providers/meals.dart';
import './providers/cart.dart';
import './providers/auth.dart';
import './providers/orders.dart';
import './providers/history.dart' as his;
import './screens/search_screen.dart';
import './screens/profile_edit.dart';
import './models/url.dart';
import './auth/forget.dart';

final notifications = FlutterLocalNotificationsPlugin();

void backgroundFetchHeadlessTask(String taskId) async {
  notify();
  BackgroundFetch.finish(taskId);
}

notify() async {
  final prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey('userData')) {
    return false;
  }
  final userData =
      json.decode(prefs.getString('userData')) as Map<String, Object>;
  try {
    final response = await http.post(Url.available, body: {
      'userid': userData['userId'],
    });
    final responseData = json.decode(response.body);

    if (responseData['status']) {
      showOngoingNotification(
        notifications,
        title: 'Order ready',
        body:
            'Your order is now available for pickup, please endeavor to come pick it up. \n Thank you!',
      );
    } else {
      return;
    }
  } catch (error) {
    throw error;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
  // runApp(MyApp());
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.NONE), (String taskId) async {
      notify();
      BackgroundFetch.finish(taskId);
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();

    final settingsAndroid = AndroidInitializationSettings('appicon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async => notifications.cancel(0);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Categories()),
        ChangeNotifierProvider.value(value: Meals()),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProvider.value(value: Orders()),
        ChangeNotifierProvider.value(value: his.History()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
          title: 'Chicken Republic Food App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.red,
            primaryColor: Colors.red,
            accentColor: Colors.amber,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            canvasColor: Colors.white,
            fontFamily: 'Poppins',
          ),
          home: auth.isAuth
              ? HomeOverview()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (ctx, authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : HomeOverview(),
                ),
          routes: {
            SignIn.route: (ctx) => SignIn(),
            SignUp.route: (ctx) => SignUp(),
            HomeOverview.route: (ctx) => HomeOverview(),
            ProductDetail.route: (ctx) => ProductDetail(),
            CartScreen.route: (ctx) => CartScreen(),
            OrdersScreen.route: (ctx) => OrdersScreen(),
            TransactionHistory.route: (ctx) => TransactionHistory(),
            FavoriteScreen.route: (ctx) => FavoriteScreen(),
            Profile.route: (ctx) => Profile(),
            Search.route: (ctx) => Search(),
            ProfileEdit.route: (ctx) => ProfileEdit(),
            ForgetPassword.route: (ctx) => ForgetPassword(),
            Searching.route: (ctx) => Searching(),
            Settings.route: (ctx) => Settings(),
            Delivery.route: (ctx) => Delivery(),
            CategoryView.route: (ctx) => CategoryView(),
            Pay.route: (ctx) => Pay()
          },
        ),
      ),
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import './sign_in.dart';
import './sign_up.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  showError(error, BuildContext ctx) async {
    switch (error) {
      case 'INVALID_CREDENTIALS':
        await showToast('Invalid login credentials. Please try again');
        Navigator.of(context).pushNamed(SignIn.route);
        break;
      case 'FIELDS_MISSING':
        showToast('Email or password fields are empty.');
        break;
      case 'INVALID_REQUEST':
        showToast('Invalid request');
        break;
      case 'ERROR_FETCHING_DATA':
        showToast(
            'User registration was successful but error fetching your data \n please reload.');
        break;
      case 'REGISTRATION_FAILED':
        showToast('Failed to register user, please try again');
        break;
      case 'CREDENTIAL_EXISTS':
        await showToast('User with that email already exist. Please login');
        Navigator.of(context).pushNamed(SignIn.route);
        break;
      case 'FORGOT_PASSWORD_SUCCESS':
        showToast('Password recovery mail has been sent.');
        break;
      case 'NO_USER_FOUND':
        showToast('No user with that email found.');
        break;
      // case 'UNVERIFIED_ACCOUNT':
      //   showToast(
      //       'Your email has not been verified yet, please visit your email');
      //   break;
      case 'REGISTRATION_SUCCESS':
        showToast('Your account has been created successfully');
        break;
      case 'Success':
        showToast('Welcome!');
        break;
      default:
        break;
    }
  }

  showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      backgroundColor: Colors.black45,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Hero(
                    tag: 'chicken_republic',
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 80,
                    ),
                  ),
                  Text(
                    'Delta Mall',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.red),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
          ),
          Align(
            alignment: Alignment.center,
            child: Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/images/illustration2.png',
              ),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 22, right: 22, bottom: 42, top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      // const Text(
                      //   'Sign in to your account or create \na new one to start shopping!',
                      //   textAlign: TextAlign.center,
                      // ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RaisedButton(
                      elevation: 0,
                      padding: const EdgeInsets.all(14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      color: Theme.of(context).primaryColor,
                      child: const Text(
                        'Create an account',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () => Navigator.of(context)
                          .pushNamed(SignUp.route)
                          .then((value) => showError(value, context)),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    OutlineButton(
                      highlightElevation: 5,
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      borderSide: const BorderSide(color: Colors.red),
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () => Navigator.of(context)
                          .pushNamed(SignIn.route)
                          .then((value) => showError(value, context)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 150,
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: .5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../helpers/http_exception.dart';

class ForgetPassword extends StatefulWidget {
  static const route = '/forget';
  ForgetPassword({Key key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  Map<String, String> _authData = {
    'email': '',
  };

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() => _isLoading = true);
    try {
      await Provider.of<Auth>(context, listen: false)
          .forgotPassword(_authData['email']);
    } on HttpException catch (error) {
      home(error.toString());
    } catch (error) {
      home(error.toString());
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pushReplacementNamed('/');
    showToast('A password reset has been sent to your email.');
  }

  void home(String message) {
    Navigator.of(context).pop(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: ListView(
          children: [
            Container(
              child: const Text(
                'Forget \nPassword',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 34,
                ),
              ),
            ),
            SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Container(
                child: Column(
                  children: [
                    const SizedBox(height: 18),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (!value.contains('@') && !value.contains('.')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) => _submit(),
                      onSaved: (value) => _authData['email'] = value,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Container(
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Theme.of(context).primaryColor,
                onPressed: () => _submit(),
                child: _isLoading
                    ? CircularProgressIndicator(
                        strokeWidth: 1,
                        backgroundColor: Colors.white,
                      )
                    : Text(
                        'Recover password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),
          ],
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

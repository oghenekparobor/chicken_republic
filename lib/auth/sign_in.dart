import 'package:chicken_republic/auth/sign_up.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../helpers/http_exception.dart';
import '../providers/auth.dart';
import '../auth/forget.dart';

class SignIn extends StatefulWidget {
  static const route = '/sign-in';
  const SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() => _isLoading = true);
    try {
      await Provider.of<Auth>(context, listen: false).signIn(
        _authData['email'],
        _authData['password'],
      );
      Navigator.of(context).pop('success');
      showToast('Welcome!');
    } on HttpException catch (error) {
      if (error.toString() == 'INVALID_CREDENTIALS') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text('Invalid credential, please try again'),
            actions: [
              FlatButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    _formKey.currentState.reset();
                  },
                  child: Text('Ok'))
            ],
          ),
        );
      } // else some other error occured
    } catch (error) {
      home(error.toString());
    }
    setState(() {
      _isLoading = false;
    });
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
      body: LayoutBuilder(
        builder: (ctx, constraint) => Container(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: ListView(
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Login to\naccount',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 34),
                      ),
                      SizedBox(height: constraint.maxHeight * 0.005),
                      Text('Login to enjoy a varieties for food')
                    ],
                  ),
                ),
                SizedBox(height: constraint.maxHeight * 0.05),
                Form(
                  key: _formKey,
                  child: Container(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (!value.contains('@') && !value.contains('.')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['email'] = value;
                          },
                        ),
                        SizedBox(height: constraint.maxHeight * 0.01),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Password'),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value.length < 6) {
                              return 'Password length must six characters above';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['password'] = value;
                          },
                          onFieldSubmitted: (w) {
                            _submit();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: constraint.maxHeight * 0.02),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FlatButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(ForgetPassword.route),
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(fontSize: 13, color: Colors.redAccent),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                SizedBox(height: constraint.maxHeight * 0.22),
                Container(
                  width: double.infinity,
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
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: constraint.maxHeight * 0.02),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(SignUp.route),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('New here? '),
                      Text(
                        'Sign-up',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: constraint.maxHeight * 0.05),
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
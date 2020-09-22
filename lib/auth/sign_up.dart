import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:password_strength/password_strength.dart';

import '../providers/auth.dart';
import '../helpers/http_exception.dart';

class SignUp extends StatefulWidget {
  static const route = '/sign-up';
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  final _passwordController = TextEditingController();
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
      await Provider.of<Auth>(context, listen: false).signUp(
        _authData['email'],
        _authData['password'],
      );
    } on HttpException catch (error) {
      if (error.toString() == 'CREDENTIAL_EXISTS') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(
                'User with that email already exist, please login instead'),
            actions: [
              FlatButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    // send to login page
                    _formKey.currentState.reset();
                  },
                  child: Text('Ok'))
            ],
          ),
        );
      } else if (error.toString() == 'REGISTRATION_SUCCESS') {
        Navigator.of(context).pushReplacementNamed('/');
      }
    } catch (error) {
      throw error;
    }
    setState(() => _isLoading = false);
  }

  @override
  dispose() {
    _passwordController.dispose();
    super.dispose();
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
            height: constraint.maxHeight,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: ListView(
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Create an\naccount',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 34,
                        ),
                      ),
                      SizedBox(height: constraint.maxHeight * 0.005),
                      Text(
                        'signup to enjoy a varieties for food',
                        textAlign: TextAlign.start,
                      ),
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
                          controller: _passwordController,
                          validator: (value) {
                            double strength = estimatePasswordStrength(value);
                            if (value.length < 6) {
                              return 'Password length must six characters above';
                            }
                            if (strength < 0.4) {
                              return 'This password is weak';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['password'] = value;
                          },
                        ),
                        SizedBox(height: constraint.maxHeight * 0.01),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Confirm password'),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: constraint.maxHeight * .2),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () => _submit(),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            strokeWidth: 1,
                            backgroundColor: Colors.white,
                          )
                        : Text(
                            'Sign-up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

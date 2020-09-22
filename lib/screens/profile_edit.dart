import 'package:chicken_republic/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../views/bag.dart';
import '../providers/auth.dart';
import '../helpers/http_exception.dart';

class ProfileEdit extends StatefulWidget {
  static const route = '/editprofile';
  ProfileEdit({Key key}) : super(key: key);

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  Map<String, dynamic> _details = {'mobile': '', 'address': '', 'name': ''};

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() => _isLoading = true);
    try {
      await Provider.of<Auth>(context, listen: false).updateUserDetails(
          _details['name'], _details['mobile'], _details['address']);
    } on HttpException catch (error) {
      print(error);
    } catch (error) {
      print(error);
    }
    setState(() => _isLoading = false);
    if (Provider.of<Cart>(context, listen: false).cartSize < 1) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop('cart not empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    var details =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [Bag()],
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: const Text(
              'Edit Profile',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
          ),
          SizedBox(height: 50),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      TextFormField(
                        initialValue: details['username'],
                        decoration: const InputDecoration(labelText: 'Name'),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Customer name cannot be empty';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _details['name'] = value;
                        },
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        initialValue: details['mobile'],
                        decoration: const InputDecoration(labelText: 'Mobile'),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Mobile number cannot be empty';
                          }
                          if (value.length < 11) {
                            return 'Mobile number is not complete';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _details['mobile'] = value;
                        },
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        initialValue: details['address'],
                        decoration: const InputDecoration(labelText: 'Address'),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Address is empty';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _details['address'] = value;
                        },
                      ),
                      const SizedBox(height: 38),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 50),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 100),
            child: Container(
              width: 150,
              child: RaisedButton(
                onPressed: () => _submit(),
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(
                        strokeWidth: 1,
                        backgroundColor: Theme.of(context).primaryColor,
                      )
                    : Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

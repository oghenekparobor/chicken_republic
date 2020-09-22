import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/http_exception.dart';
import '../models/url.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  String _email;
  String details;
  Timer _authTimer;
  DateTime _expiryDate;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  String get email {
    return _email;
  }

  Future<void> _authentication(
      String email, String password, String url) async {
    try {
      final response = await http.post(url, body: {
        'email': email,
        'password': password,
      });
      final responseData = json.decode(response.body);

      if (responseData['message'] != null) {
        throw HttpException(responseData['message']);
      }

      _token = responseData['token'];
      _expiryDate = DateTime.parse(responseData['expiry']);
      _userId = responseData['id'].toString();
      _email = responseData['email'].toString();

      getDetails(int.parse(_userId));

      // _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'expiryDate': _expiryDate.toIso8601String(),
        'userId': _userId,
        'email': _email,
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authentication(email, password, Url.signup);
  }

  Future<void> signIn(String email, String password) async {
    return _authentication(email, password, Url.login);
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final userData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(userData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = userData['token'];
    _userId = userData['userId'];
    _email = userData['email'];
    _expiryDate = expiryDate;
    getDetails(int.parse(_userId));
    notifyListeners();
    // _autoLogout();
    return true;
  }

  logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    _email = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    
    prefs.remove('userData');
    prefs.remove('meals');
    prefs.remove('category_meals');
  }

  // _autoLogout() {
  //   if (_authTimer != null) {
  //     _authTimer.cancel();
  //   }
  //   final timeToExpiration = _expiryDate.difference(DateTime.now()).inSeconds;
  //   _authTimer = Timer(Duration(seconds: timeToExpiration), logout);
  // }

  Future<void> getDetails(int userid) async {
    try {
      var response = await http.post(Url.userDetail, body: {
        'userid': userid.toString(),
      });
      final responseData = json.decode(response.body);
      if (responseData['message'] != null) {
        throw HttpException(responseData['message']);
      }

      final profileData = json.encode({
        'username': responseData['username'],
        'mobile': responseData['mobile'],
        'address': responseData['address'],
      });
      details = profileData;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateUserDetails(
      String username, String mobile, String address) async {
    try {
      var response = await http.post(Url.updateUserDetail, body: {
        'username': username,
        'mobile': mobile,
        'address': address,
        'userid': _userId.toString(),
      });
      final responseData = json.decode(response.body);
      getDetails(int.parse(_userId));
      if (responseData['message'] != null) {
        throw HttpException(responseData['message']);
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      var response = await http.post(Url.forget, body: {
        'email': email,
      });
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (responseData['message'] != null) {
        throw HttpException(responseData['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  String get userDetail {
    return details;
  }
}

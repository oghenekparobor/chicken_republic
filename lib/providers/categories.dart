import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/category.dart';
import '../models/url.dart';

class Categories with ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get items {
    return [..._categories];
  }

  Future<void> getCategories() async {
    try {
      final response = await http.post(Url.getCategory);
      final categoryData = json.decode(response.body) as Map<String, dynamic>;
      final List<Category> loadedCategory = [];
      categoryData.forEach((key, element) {
        final List<dynamic> ele = element as List<dynamic>;
        ele.forEach((element) {
          loadedCategory.add(
            Category(
              id: (element['id'].toString()),
              category: element['category'],
            ),
          );
        });
      });
      _categories = loadedCategory;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

import 'package:flutter/material.dart';

class Meal with ChangeNotifier {
  final int id;
  final String title;
  final String description;
  final double price;
  final String slashedprice;
  final String picture1;
  final String picture2;
  final String picture3;
  final String picture4;
  final String category;
  final Color color;

  Meal({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.slashedprice,
    @required this.picture1,
    this.picture2,
    this.picture3,
    this.picture4,
    @required this.category,
    this.color = Colors.white30,
  });

}


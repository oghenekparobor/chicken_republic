import 'package:flutter/material.dart';
import 'dart:async';

class Waiting extends StatefulWidget {
  Waiting({Key key}) : super(key: key);

  @override
  _WaitingState createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {
  var isLoading = false;
  Timer timer;

  @override
  void initState() {
    timer =Timer.periodic(Duration(milliseconds: 212), (Timer t) => _getTime());
    super.initState();
  }

  void _getTime() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Icon(
      isLoading ? Icons.hdr_strong : Icons.hdr_weak,
      color: Colors.green,
    );
  }
}

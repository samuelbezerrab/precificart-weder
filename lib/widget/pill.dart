import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:precific_arte/constants.dart';

class Pill extends StatelessWidget {
  final String title;

  const Pill({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(Constants.colorGray),
        border: Border.all(
          color: Color(Constants.colorGray),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(right: 2),
      child: Text(
        title,
        style: TextStyle(
          color: Color(Constants.colorPink),
        ),
      ),
    );
  }
}

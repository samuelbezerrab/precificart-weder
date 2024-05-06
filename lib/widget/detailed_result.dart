import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:precific_arte/constants.dart';

class DetailedResult extends StatelessWidget {
  final String title;
  final String price;

  const DetailedResult({
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(Constants.colorWhite),
            ),
          ),
          SizedBox(
            width: 50,
          ),
          Text(
            price,
            style: TextStyle(
              color: Color(Constants.colorWhite),
            ),
          ),
        ],
      ),
    );
  }
}

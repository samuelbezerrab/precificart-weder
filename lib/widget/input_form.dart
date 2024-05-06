import 'package:flutter/material.dart';

class InputForm extends StatelessWidget {
  final String hint;
  final String errMsg;
  final String? type;
  final double defaultWidth = 110;

  InputForm(
      {required final this.hint, required final this.errMsg, final this.type});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '${this.errMsg}';
        }
        // price = value;
        return null;
      },
      decoration: InputDecoration(hintText: '${this.hint}'),
    );
  }
}

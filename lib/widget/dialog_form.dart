import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DialogForm extends StatefulWidget {
  @override
  _DialogFormState createState() => _DialogFormState();
}

class _DialogFormState extends State<DialogForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _textEditingController =
        TextEditingController();

    return AlertDialog(
      content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _textEditingController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Senha inválida';
                  }
                },
                decoration: InputDecoration(hintText: "Nome descritivo"),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _textEditingController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Senha inválida';
                  }
                },
                decoration: InputDecoration(hintText: "Valor"),
              ),
            ],
          )),
      actions: <Widget>[
        TextButton(
          child: Text('Okay'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

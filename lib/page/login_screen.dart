import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:precific_arte/page/home_screen.dart';
import 'package:precific_arte/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 250,
                  // height: 400,
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(Constants.colorGreen),
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: 5, right: 5, top: 5),
                              child: TextFormField(
                                obscureText: true,
                                // style: TextStyle(color: Color(0xFF444444)),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Digite a senha',
                                  labelStyle: TextStyle(
                                    color: Color(Constants.colorGray),
                                  ),
                                  hintStyle: TextStyle(
                                    color: Color(Constants.colorGray),
                                  ),
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Senha inválida';
                                  } else if (value != 'Love.cursobe') {
                                    return 'Senha inválida';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(Constants.colorPink),
                              onPrimary: Color(Constants.colorGray),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                              fixedSize: Size(335, 60),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                              }
                            },
                            child: const Text('Entrar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

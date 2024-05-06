import 'package:flutter/material.dart';
import 'package:precific_arte/constants.dart';
import 'package:precific_arte/page/wizard/result.dart';
import 'package:precific_arte/repositories/shared_preferences.dart';

class InsertDesiredProfit extends StatefulWidget {
  @override
  _InsertDesiredProfitState createState() => _InsertDesiredProfitState();
}

class _InsertDesiredProfitState extends State<InsertDesiredProfit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var sharedPreferences = new MySharedPreferences();
  var desiredProfit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: true,
        title: Text(
          'Calcular preço de venda',
          style: TextStyle(color: Color(Constants.colorGray)),
        ),
        backgroundColor: Color(Constants.colorPink),
        foregroundColor: Color(Constants.colorGray),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color(Constants.colorGray),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Color(Constants.colorPink),
          ),
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(Constants.colorPinkDarker),
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 5),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Percentual de lucro desejado',
                                  labelStyle: TextStyle(
                                    color: Color(Constants.colorGray),
                                  ),
                                  hintStyle: TextStyle(
                                    color: Color(Constants.colorGray),
                                  ),
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Informe o percentual de lucro desejado';
                                  }
                                  desiredProfit = value;
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(Constants.colorWhite),
                            onPrimary: Color(Constants.colorGray),
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 20),
                            fixedSize: Size(335, 60),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              sharedPreferences.saveDouble(
                                'desiredProfit',
                                double.parse(desiredProfit),
                              );
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Result(),
                                ),
                              );
                            }
                          },
                          child: const Text('Salvar'),
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

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:precific_arte/model/variable_cost.dart';
import 'package:precific_arte/page/records/fixed_costs.dart';
import 'package:precific_arte/page/records/inputs.dart';
import 'package:precific_arte/page/records/packing.dart';
import 'package:precific_arte/page/records/salary.dart';
import 'package:precific_arte/page/wizard/select_inputs.dart';
import 'package:precific_arte/widget/custom_dialog.dart';
import 'package:precific_arte/constants.dart';

import 'records/variable_costs.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: new BoxDecoration(color: Color(Constants.colorPink)),
          padding: EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  'assets/images/logo.png',
                  width: 200,
                ),
                const SizedBox(height: 30),
                ButtonTheme(
                  minWidth: 800,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFFFFFFF),
                      onPrimary: Color(Constants.colorGray),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      fixedSize: Size(300, 70),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => InputScreen()));
                    },
                    child: const Text('Cadastrar materiais'),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFFFFFF),
                    onPrimary: Color(Constants.colorGray),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    fixedSize: Size(300, 70),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FixedCostsScreen()));
                  },
                  child: const Text('Cadastrar custos fixos'),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFFFFFF),
                    onPrimary: Color(Constants.colorGray),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    fixedSize: Size(300, 70),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PackingScreen()));
                  },
                  child: const Text('Custos com embalagens'),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFFFFFF),
                    onPrimary: Color(Constants.colorGray),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    fixedSize: Size(300, 70),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SalaryScreen()));
                  },
                  child: const Text('Cadastrar salário'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SelectInputsScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
              backgroundColor: Color(Constants.colorGreen),
              foregroundColor: Color(Constants.colorGray),
              tooltip: "Calcular Preço de Venda",
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Calcular',
              style: TextStyle(
                color: Color(Constants.colorGray),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Preço de Venda',
              style: TextStyle(
                color: Color(Constants.colorGray),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

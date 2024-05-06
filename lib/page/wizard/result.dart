import 'package:flutter/material.dart';
import 'package:precific_arte/constants.dart';
import 'package:precific_arte/model/fixed_cost.dart';
import 'package:precific_arte/model/salary.dart';
import 'package:precific_arte/page/home_screen.dart';
import 'package:precific_arte/repositories/database_handler.dart';
import 'package:precific_arte/repositories/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:precific_arte/widget/detailed_result.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class Result extends StatefulWidget {
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  var sharedPreferences = new MySharedPreferences();
  late DatabaseHandler handler;
  var sellingPrice;
  var myProfit;
  var showDetailedBox = false;
  var finalValue;

  var brCurrencyFormat =
      new NumberFormat.currency(locale: "pt_BR", symbol: "R\$");

  var brNumberFormat = new NumberFormat.compact(locale: "pt_BR");

  final List<Widget> _details = <Widget>[];
  final List<Widget> _detailsInputs = <Widget>[];
  final List<Widget> _detailsPacking = <Widget>[];

  Future<List<Widget>> detailedResultBox() async {
    double inputsTotal = 0.0;
    double packingTotal = 0.0;
    double inputsAndPackingTotal = 0.0;
    double desiredProfit = 0.0;
    double workedHours = 0.0;

    _details.clear();

    var keys = await sharedPreferences.getKeys();
    print(keys.toString());
    for (String key in keys) {
      var val = await sharedPreferences.getDouble(key);

      if (key.toLowerCase() == 'desiredprofit') {
        desiredProfit = val;
      } else if (key.toLowerCase() != 'desiredprofit' &&
          key.toLowerCase() != 'workedhours') {
        var type = key.substring(0, key.indexOf('_'));
        print("MYTYPE: " + type);

        if (type == 'input') {
          _detailsInputs.add(
            DetailedResult(
              title: key.substring(key.indexOf('_') + 1),
              price: brCurrencyFormat.format(val).toString(),
            ),
          );

          inputsTotal += val;

          print(key + val.toString());
          print('InputsTotal: ' + inputsTotal.toString());
        } else if (type == 'packing') {
          _detailsPacking.add(
            DetailedResult(
              title: key.substring(key.indexOf('_') + 1),
              price: brCurrencyFormat.format(val).toString(),
            ),
          );

          packingTotal += val;

          print(key + val.toString());
          print('PackingTotal: ' + packingTotal.toString());
        }
        inputsAndPackingTotal += val;

        // _details.add(
        //   DetailedResult(
        //       title: key,
        //       // price: val.toString(),
        //       price: brNumberFormat.format(val).toString()),
        // );
      } else if (key.toLowerCase() != 'workedhours') {
        _details.add(
          DetailedResult(
            title: 'Horas trabalhadas',
            price: brNumberFormat.format(val).toString(),
          ),
        );
      } else if (key.toLowerCase() == 'workedhours') {
        workedHours = val;
        // desiredProfit = val;
      }
    }

    double salarySalary = 0.0;
    double hourCost = 0.0;
    List<Salary> salaries = await handler.retrieveSalary();
    for (var item in salaries) {
      print(item.salary);
      hourCost = (item.salary / 220);
      salarySalary = (item.salary / 220) * workedHours;
      print(salarySalary);
    }

    // _details.add(
    //   DetailedResult(
    //     title: 'Materiais e embalagem',
    //     price: brCurrencyFormat.format(inputsAndVariables).toString(),
    //   ),
    // );

    _details.add(
      Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            'Materiais',
            style: TextStyle(
              color: Color(Constants.colorPink),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: _detailsInputs,
          ),
          DetailedResult(
            title: 'Total',
            price: brCurrencyFormat.format(inputsTotal).toString(),
          ),
        ],
      ),
    );

    _details.add(
      Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            'Embalagem',
            style: TextStyle(
              color: Color(Constants.colorPink),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: _detailsPacking,
          ),
          DetailedResult(
            title: 'Total',
            price: brCurrencyFormat.format(packingTotal).toString(),
          ),
        ],
      ),
    );

    _details.add(Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          'Custos Fixos',
          style: TextStyle(
            color: Color(Constants.colorPink),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    ));
    double fixedCostsCosts = 0.0;
    double fixedCostsTotal = 0.0;
    List<FixedCost> fixedCosts = await handler.retrieveFixedCost();
    for (var item in fixedCosts) {
      print(item.name + ' - ' + item.price.toString());
      fixedCostsCosts =
          fixedCostsCosts + (((item.price / 220) * workedHours) / 10);
      fixedCostsTotal = fixedCostsTotal + item.price;
      print(fixedCostsCosts);
      _details.add(
        DetailedResult(
          title: item.name + ' (s/ hora trabalhada)',
          price: brCurrencyFormat
              .format((((item.price / 220) * workedHours) / 10))
              .toString(),
        ),
      );
    }

    // _details.add(
    //   DetailedResult(
    //     title: 'Total',
    //     price: brCurrencyFormat.format(fixedCostsTotal).toString(),
    //   ),
    // );

    _details.add(
      DetailedResult(
        title: 'Total',
        price: brCurrencyFormat.format(fixedCostsCosts).toString(),
      ),
    );

    _details.add(SizedBox(
      height: 10,
    ));
    // _details.add(
    //   DetailedResult(
    //     title: 'Custos Fixos',
    //     price: brCurrencyFormat.format(fixedCostsCosts).toString(),
    //   ),
    // );

    _details.add(
      Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            'Custo da mão de obra',
            style: TextStyle(
              color: Color(Constants.colorPink),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );

    _details.add(
      DetailedResult(
        title: 'Custo da hora trabalhada',
        price: brCurrencyFormat.format(hourCost).toString(),
      ),
    );

    _details.add(
      DetailedResult(
        title: 'Horas trabalhadas',
        price: brNumberFormat.format(workedHours).toString(),
      ),
    );

    _details.add(
      DetailedResult(
        title: 'Total',
        price: brCurrencyFormat.format(workedHours * hourCost).toString(),
      ),
    );

    double allCosts = 0.0;
    allCosts = salarySalary + fixedCostsCosts + inputsAndPackingTotal;
    print('Values: ' +
        salarySalary.toString() +
        ' ' +
        fixedCostsCosts.toString() +
        ' ' +
        inputsAndPackingTotal.toString());
    print('Custo Parcial: ' + allCosts.toString());

    _details.add(
      SizedBox(
        height: 10,
      ),
    );

    _details.add(
      DetailedResult(
        title: 'Custo parcial',
        price: brCurrencyFormat.format(allCosts).toString(),
      ),
    );

    _details.add(
      SizedBox(
        height: 10,
      ),
    );

    _details.add(
      DetailedResult(
        title: 'Lucro (%)',
        price: brNumberFormat.format(desiredProfit).toString(),
      ),
    );

    double finalPrice = 0.0;
    finalPrice = (allCosts * (desiredProfit / 100)) + allCosts;
    print(finalPrice);

    double profit = 0.0;
    profit = finalPrice - allCosts;
    print(profit);

    _details.add(
      DetailedResult(
        title: 'Lucro (R\$)',
        price: brCurrencyFormat.format(profit).toString(),
      ),
    );

    sellingPrice = finalPrice;
    myProfit = profit;

    _details.add(
      DetailedResult(
        title: 'Preço de venda final',
        price: brCurrencyFormat.format(sellingPrice).toString(),
      ),
    );
    // print(fixedCosts);
    // return sellingPrice * myProfit;

    return _details;
  }

  Future<void> sendEmail(value) async {
    final Email email = Email(
      body:
          'O valor total será de ${brCurrencyFormat.format(sellingPrice).toString()}',
      subject: 'Valor do serviço',
      // recipients: ['example@example.com'],
      // cc: ['cc@example.com'],
      // bcc: ['bcc@example.com'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }

  Future<double> shared() async {
    double inputsTotal = 0.0;
    double packingTotal = 0.0;
    double inputsAndPackingTotal = 0.0;
    double desiredProfit = 0.0;
    double workedHours = 0.0;

    _details.clear();

    var keys = await sharedPreferences.getKeys();
    print(keys.toString());
    for (String key in keys) {
      var val = await sharedPreferences.getDouble(key);

      if (key.toLowerCase() == 'desiredprofit') {
        desiredProfit = val;
      } else if (key.toLowerCase() != 'desiredprofit' &&
          key.toLowerCase() != 'workedhours') {
        var type = key.substring(0, key.indexOf('_'));

        if (type == 'input') {
          inputsTotal += val;
        } else if (type == 'packing') {
          packingTotal += val;
        }
        inputsAndPackingTotal += val;
      } else if (key.toLowerCase() != 'workedhours') {
      } else if (key.toLowerCase() == 'workedhours') {
        workedHours = val;
      }
    }

    double salarySalary = 0.0;
    double hourCost = 0.0;
    List<Salary> salaries = await handler.retrieveSalary();
    for (var item in salaries) {
      hourCost = (item.salary / 220);
      salarySalary = (item.salary / 220) * workedHours;
    }

    double fixedCostsCosts = 0.0;
    List<FixedCost> fixedCosts = await handler.retrieveFixedCost();
    for (var item in fixedCosts) {
      fixedCostsCosts =
          fixedCostsCosts + (((item.price / 220) * workedHours) / 10);
    }

    double allCosts = 0.0;
    allCosts = salarySalary + fixedCostsCosts + inputsAndPackingTotal;

    double finalPrice = 0.0;
    finalPrice = (allCosts * (desiredProfit / 100)) + allCosts;

    double profit = 0.0;
    profit = finalPrice - allCosts;

    sellingPrice = finalPrice;
    myProfit = profit;

    return sellingPrice * myProfit;
    // double inputsAndVariables = 0.0;
    // double desiredProfit = 0.0;

    // var keys = await sharedPreferences.getKeys();
    // print(keys.toString());
    // for (String key in keys) {
    //   var val = await sharedPreferences.getDouble(key);
    //   if (key.toLowerCase() != 'desiredprofit' &&
    //       key.toLowerCase() != 'workedhours') {
    //     inputsAndVariables += val;
    //   } else {
    //     desiredProfit = val;
    //   }
    //   print(key + ' - ' + val.toString());
    // }

    // double fixedCostsCosts = 0.0;
    // List<FixedCost> fixedCosts = await handler.retrieveFixedCost();
    // for (var item in fixedCosts) {
    //   print(item.name + ' - ' + item.price.toString());
    //   fixedCostsCosts = fixedCostsCosts + (((item.price / 220) * 8) / 10);
    //   print(fixedCostsCosts);
    // }

    // double salarySalary = 0.0;
    // List<Salary> salaries = await handler.retrieveSalary();
    // for (var item in salaries) {
    //   print(item.salary);
    //   salarySalary = (item.salary / 220) * 8;
    //   print(salarySalary);
    // }

    // double allCosts = 0.0;
    // allCosts = salarySalary + fixedCostsCosts + inputsAndVariables;
    // print('Values: ' +
    //     salarySalary.toString() +
    //     ' ' +
    //     fixedCostsCosts.toString() +
    //     ' ' +
    //     inputsAndVariables.toString());
    // print('Custo Parcial: ' + allCosts.toString());

    // double finalPrice = 0.0;
    // finalPrice = (allCosts * (desiredProfit / 100)) + allCosts;
    // print(finalPrice);

    // double profit = 0.0;
    // profit = finalPrice - allCosts;
    // print(profit);

    // sellingPrice = finalPrice;
    // myProfit = profit;
    // // print(fixedCosts);
    // finalValue = sellingPrice * myProfit;
    // return finalValue;
  }

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
    this.handler.initializeDB();
  }

  getDataForCalc() async {
    var fixedCosts = await handler.retrieveFixedCost();
    print(fixedCosts);
  }

  void _changeVisibility(bool visibility) {
    setState(() {
      showDetailedBox = visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: true,
        title: Text(
          'Preço de venda',
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
        child: FractionallySizedBox(
          heightFactor: 0.99,
          child: Container(
            decoration: BoxDecoration(
              color: Color(Constants.colorPink),
            ),
            padding: EdgeInsets.all(16),
            child: Center(
              child: FutureBuilder(
                future: shared(),
                builder:
                    (BuildContext context, AsyncSnapshot<double> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return SnackBar(
                          content: Text('${snapshot.error}'),
                          backgroundColor: Colors.red,
                        );
                      } else if (snapshot.hasData) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Preço de venda final'),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '${brCurrencyFormat.format(sellingPrice)}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 42),
                              ),
                              Text(
                                  'Seu lucro será de ${brCurrencyFormat.format(myProfit)}'),
                              SizedBox(
                                height: 10,
                              ),
                              if (showDetailedBox)
                                (Container(
                                  decoration: BoxDecoration(
                                    color: Color(Constants.colorGray),
                                    border: Border.all(
                                      color: Color(Constants.colorGray),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.only(right: 2),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Preço de venda detalhado',
                                        style: TextStyle(
                                          color: Color(Constants.colorWhite),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      FutureBuilder<List<Widget>>(
                                          future: detailedResultBox(),
                                          builder: (context, snapshot) {
                                            return FractionallySizedBox(
                                              widthFactor: 0.95,
                                              child: Column(
                                                children: snapshot.data!,
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                )),
                              SizedBox(
                                height: 25,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color(Constants.colorWhite),
                                  onPrimary: Color(Constants.colorGray),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 20),
                                  fixedSize: Size(335, 60),
                                ),
                                onPressed: () => {myFunction()},
                                child: const Text('Concluído'),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextButton(
                                onPressed: () =>
                                    _changeVisibility(!showDetailedBox),
                                child: showDetailedBox
                                    ? Text('Esconder detalhado')
                                    : Text('Mostrar detalhado'),
                              ),
                              SizedBox(
                                height: 5,
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
                                  sendEmail(finalValue);
                                  // await FlutterEmailSender.send(email);
                                },
                                child:
                                    const Text('Enviar preço final por e-mail'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(
                            'Algo deu errado.',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        );
                      }
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void myFunction() {
    sharedPreferences.removeAll();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }
}

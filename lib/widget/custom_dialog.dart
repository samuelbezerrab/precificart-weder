import 'dart:ui';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:precific_arte/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:precific_arte/model/fixed_cost.dart';
import 'package:precific_arte/model/variable_cost.dart';
import 'package:precific_arte/model/input.dart';
import 'package:precific_arte/model/salary.dart';
import 'package:precific_arte/repositories/database_handler.dart';
import 'package:precific_arte/repositories/shared_preferences.dart';
import 'package:precific_arte/test.dart';
import 'package:extended_masked_text/extended_masked_text.dart';

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, form, btnCancel, btnSave;
  final String? itemId,
      itemName,
      itemUnityCost,
      itemQuantity,
      itemLength,
      itemWeight,
      itemWidth,
      itemHeight,
      itemVolume,
      itemSalary,
      itemMeasurementUnity;
  final bool? itemHasPacking;
  // final Map<String, String> inputs;

  const CustomDialogBox(
      {Key? key,
      required this.title,
      required this.descriptions,
      required this.form,
      // required this.inputs,
      required this.btnCancel,
      required this.btnSave,
      this.itemId,
      this.itemName,
      this.itemUnityCost,
      this.itemQuantity,
      this.itemLength,
      this.itemWeight,
      this.itemWidth,
      this.itemHeight,
      this.itemVolume,
      this.itemSalary,
      this.itemMeasurementUnity,
      this.itemHasPacking})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late DatabaseHandler handler;
  var sharedPreferences = new MySharedPreferences();
  var fixedCostName, fixedCostprice;
  var variableCostName, variableUnity, variableQuantity, variableCost;
  var salary;
  var inputId,
      inputName,
      inputUnity,
      inputQuantity,
      inputHeight,
      inputWidth,
      inputWeight,
      inputLength,
      inputVolume,
      inputCost;
  var selectInputId, selectInputName, selectInputQuantity;
  var selectVariableCostsId,
      selectVariableCostsName,
      selectVariableCostsQuantity;

  var editFixedCostsName, editFixedCostsUnityCost;
  var editVariableCostsName,
      editVariableCostsQuantity,
      editVariableCostsUnityCost;

  var brCurrencyFormat =
      new NumberFormat.currency(locale: "pt_BR", symbol: "R\$");

  var brNumberFormat = new NumberFormat.compact(locale: "pt_BR");

  // final _currencyController = MoneyMaskedTextController(leftSymbol: 'R\$');
  final _currencyController = MoneyMaskedTextController();

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
    selectInputName = widget.itemName;

    print("form " + widget.form);
  }

  Future<int> addFixedCost(name, price) async {
    // var nPrice = double.parse(price);
    var nPrice = Helper.getDoubleFromBRL(price);
    FixedCost fixedCost = FixedCost(name: name, price: nPrice);
    List<FixedCost> listOfFixedCosts = [fixedCost];
    return await this.handler.insertFixedCost(listOfFixedCosts);
  }

  Future<int> updateFixedCost(id, name, price) async {
    var nId = int.parse(id);
    // var nPrice = double.parse(price);
    var nPrice = Helper.getDoubleFromBRL(price);
    FixedCost fixedCost = FixedCost(id: nId, name: name, price: nPrice);
    print('updatefixedcost');
    var res = await this.handler.updateFixedCost(fixedCost);
    print(res);
    return res;
  }

  Future<int> addVariableCost(name, quantity, totalCost) async {
    var nQuantity = double.parse(quantity);
    // var nTotalCost = double.parse(totalCost);
    var nTotalCost = Helper.getDoubleFromBRL(totalCost);
    VariableCost variableCost =
        VariableCost(name: name, quantity: nQuantity, price: nTotalCost);
    List<VariableCost> listOfVariableCosts = [variableCost];
    return await this.handler.insertVariableCost(listOfVariableCosts);
  }

  Future<int> updateVariableCost(id, name, quantity, totalCost) async {
    var nId = int.parse(id);
    var nQuantity = double.parse(quantity);
    // var nTotalCost = double.parse(totalCost);
    var nTotalCost = Helper.getDoubleFromBRL(totalCost);
    VariableCost variableCost = VariableCost(
        id: nId, name: name, quantity: nQuantity, price: nTotalCost);
    print('updatevariablecost');
    var res = await this.handler.updateVariableCost(variableCost);
    print(res);
    return res;
  }

  Future<int> addInput(
    String name,
    totalCost,
    String type, {
    quantity = 0,
    height = 0.0,
    width = 0.0,
    weight = 0.0,
    length = 0.0,
    volume = 0.0,
    packing = 0,
  }) async {
    print(name);
    print(totalCost);
    print(type);
    print(height);
    print('myvolume');
    print(volume);

    Input input = Input(
      name: name,
      quantity: quantity,
      height: height,
      width: width,
      weight: weight,
      length: length,
      volume: volume,
      // totalCost: totalCost,
      totalCost: totalCost,
      type: type,
      packing: packing,
    );

    List<Input> listOfInputs = [input];
    return await this.handler.insertInput(listOfInputs);
  }

  Future<int> updateInput(
    int id,
    String name,
    totalCost,
    String type, {
    int quantity = 0,
    height = 0.0,
    width = 0.0,
    weight = 0.0,
    length = 0.0,
    volume = 0.0,
    packing = 0,
  }) async {
    // Input input = Input(
    //   id: int.parse(id),
    //   name: name,
    //   quantity: double.parse(quantity),
    //   totalCost: double.parse(totalCost),
    //   type: '',
    // );
    Input input = Input(
      id: id,
      name: name,
      quantity: quantity,
      height: height,
      width: width,
      weight: weight,
      length: length,
      volume: volume,
      // totalCost: totalCost,
      totalCost: totalCost,
      type: type,
      packing: packing,
    );

    return await this.handler.updateInput(input);
  }

  Future<int> addSalary(value) async {
    // var nValue = double.parse(value);
    var nValue = Helper.getDoubleFromBRL(value);
    Salary salary = Salary(salary: nValue);
    List<Salary> listOfSalaries = [salary];
    return await this.handler.insertSalary(listOfSalaries);
  }

  Future<int> updateSalary(id, value) async {
    var nId = int.parse(id);
    // var nValue = double.parse(value);
    var nValue = Helper.getDoubleFromBRL(value);

    Salary salary = Salary(id: nId, salary: nValue);

    return await this.handler.updateSalary(salary);
  }

  final List<Widget> _formItems = <Widget>[];
  String dropdownValue = 'Unidade';

  List<Widget> buildForm() {
    _formItems.add(SizedBox(
      height: 10,
    ));

    switch (this.widget.form) {
      case 'fixed_costs':
        _formItems.add(
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Insira um nome.';
              }
              fixedCostName = value;
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Nome do custo fixo',
              hintStyle: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        );
        _formItems.add(SizedBox(
          height: 10,
        ));
        _formItems.add(
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Insira um valor.';
              }
              fixedCostprice = value;
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Valor do custo fixo',
              hintStyle: TextStyle(
                fontSize: 12,
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              MoneyInputFormatter(
                leadingSymbol: 'R\$',
                thousandSeparator: ThousandSeparator.Period,
                useSymbolPadding: true,
              ),
            ],
          ),
        );
        break;
      case 'variable_costs':
        _formItems.add(
          FractionallySizedBox(
            widthFactor: 0.95,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insira um nome.';
                      }
                      variableCostName = value;
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Nome do material',
                      hintStyle: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        );
        _formItems.add(
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira a quantidade.';
                    }
                    variableQuantity = value;
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Quantidade',
                    hintStyle: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 2,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira o valor total.';
                    }
                    variableCost = value;
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Valor total',
                    hintStyle: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    MoneyInputFormatter(
                      leadingSymbol: 'R\$',
                      thousandSeparator: ThousandSeparator.Period,
                      useSymbolPadding: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
        break;
      case 'inputs':
        _formItems.add(
          FractionallySizedBox(
            widthFactor: 0.95,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insira um nome.';
                      }
                      inputName = value;
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Nome do material',
                      hintStyle: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    // initialValue: widget.itemName != null ? widget.itemName : '',
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        );
        _formItems.add(SizedBox(
          height: 10,
        ));
        _formItems.add(Row(
          children: [
            Expanded(
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira a quantidade comprada.';
                  }
                  inputQuantity = value;
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Quantidade (un)',
                  hintStyle: TextStyle(
                    fontSize: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MoneyInputFormatter(
                    thousandSeparator: ThousandSeparator.Period,
                    mantissaLength: 0,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o valor.';
                  }
                  inputCost = value;
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Valor total',
                  hintStyle: TextStyle(
                    fontSize: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MoneyInputFormatter(
                    leadingSymbol: 'R\$',
                    thousandSeparator: ThousandSeparator.Period,
                    useSymbolPadding: true,
                  ),
                ],

                // initialValue: widget.itemQuantity != null ? widget.itemQuantity : '',
              ),
            )
          ],
        ));
        break;
      case 'edit_inputs_unitary':
        _formItems.add(
          FractionallySizedBox(
            widthFactor: 0.95,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: widget.itemName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insira um nome.';
                      }
                      inputName = value;
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Nome do material',
                      hintStyle: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        );
        _formItems.add(SizedBox(
          height: 10,
        ));
        _formItems.add(Row(
          children: [
            Expanded(
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira a quantidade comprada.';
                  }
                  inputQuantity = value;
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Quantidade (un)',
                  hintStyle: TextStyle(
                    fontSize: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
                initialValue: widget.itemQuantity,
                // brNumberFormat.format(int.parse(widget.itemQuantity!)),
                // initialValue: widget.itemQuantity != null ? widget.itemQuantity : '',
                inputFormatters: [
                  MoneyInputFormatter(
                    thousandSeparator: ThousandSeparator.Period,
                    mantissaLength: 0,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: TextFormField(
                initialValue: brCurrencyFormat
                    .format(double.parse(widget.itemUnityCost!)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o valor.';
                  }
                  inputCost = value;
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Valor total',
                  hintStyle: TextStyle(
                    fontSize: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MoneyInputFormatter(
                    leadingSymbol: 'R\$',
                    thousandSeparator: ThousandSeparator.Period,
                    useSymbolPadding: true,
                  ),
                ],
                // initialValue: widget.itemQuantity != null ? widget.itemQuantity : '',
              ),
            )
          ],
        ));
        break;
      case 'inputs_weight':
        _formItems.add(
          FractionallySizedBox(
            widthFactor: 0.95,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insira um nome.';
                      }
                      inputName = value;
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Nome do material',
                      hintStyle: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        );
        _formItems.add(SizedBox(
          height: 10,
        ));
        _formItems.add(Row(
          children: [
            Expanded(
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o peso';
                  }
                  inputWeight = value;
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Peso (g)',
                  hintStyle: TextStyle(
                    fontSize: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MoneyInputFormatter(
                    thousandSeparator: ThousandSeparator.Period,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o valor.';
                  }
                  inputCost = value;
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Valor total',
                  hintStyle: TextStyle(
                    fontSize: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MoneyInputFormatter(
                    leadingSymbol: 'R\$',
                    thousandSeparator: ThousandSeparator.Period,
                    useSymbolPadding: true,
                  ),
                ],
              ),
            )
          ],
        ));
        break;
      case 'edit_inputs_weight':
        _formItems.add(
          FractionallySizedBox(
            widthFactor: 0.95,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: widget.itemName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insira um nome.';
                      }
                      inputName = value;
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Nome do material',
                      hintStyle: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        );
        _formItems.add(SizedBox(
          height: 10,
        ));
        _formItems.add(Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue:
                    brNumberFormat.format(double.parse(widget.itemWeight!)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o peso';
                  }
                  inputWeight = value;
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Peso (g)',
                  hintStyle: TextStyle(
                    fontSize: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MoneyInputFormatter(
                    thousandSeparator: ThousandSeparator.Period,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: TextFormField(
                initialValue: brCurrencyFormat
                    .format(double.parse(widget.itemUnityCost!)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o valor.';
                  }
                  inputCost = value;
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Valor total',
                  hintStyle: TextStyle(
                    fontSize: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MoneyInputFormatter(
                    leadingSymbol: 'R\$',
                    thousandSeparator: ThousandSeparator.Period,
                    useSymbolPadding: true,
                  ),
                ],
              ),
            )
          ],
        ));
        break;
      case 'inputs_volume':
        _formItems.add(
          FractionallySizedBox(
            widthFactor: 0.95,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insira um nome.';
                      }
                      inputName = value;
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Nome do material',
                      hintStyle: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        );
        _formItems.add(SizedBox(
          height: 10,
        ));
        _formItems.add(Row(
          children: [
            Expanded(
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o volume.';
                  }
                  inputVolume = value;
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Volume (ml)',
                  hintStyle: TextStyle(
                    fontSize: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MoneyInputFormatter(
                    thousandSeparator: ThousandSeparator.Period,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o valor.';
                  }
                  inputCost = value;
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Valor total',
                  hintStyle: TextStyle(
                    fontSize: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MoneyInputFormatter(
                    leadingSymbol: 'R\$',
                    thousandSeparator: ThousandSeparator.Period,
                    useSymbolPadding: true,
                  ),
                ],
              ),
            )
          ],
        ));
        break;
      case 'edit_inputs_volume':
        _formItems.add(
          FractionallySizedBox(
            widthFactor: 0.95,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: widget.itemName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insira um nome.';
                      }
                      inputName = value;
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Nome do material',
                      hintStyle: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        );
        _formItems.add(SizedBox(
          height: 10,
        ));
        _formItems.add(Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue:
                    brNumberFormat.format(double.parse(widget.itemVolume!)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o volume.';
                  }
                  inputVolume = value;
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Volume (ml)',
                  hintStyle: TextStyle(
                    fontSize: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MoneyInputFormatter(
                    thousandSeparator: ThousandSeparator.Period,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: TextFormField(
                initialValue: brCurrencyFormat
                    .format(double.parse(widget.itemUnityCost!)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o valor.';
                  }
                  inputCost = value;
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Valor total',
                  hintStyle: TextStyle(
                    fontSize: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MoneyInputFormatter(
                    leadingSymbol: 'R\$',
                    thousandSeparator: ThousandSeparator.Period,
                    useSymbolPadding: true,
                  ),
                ],
              ),
            )
          ],
        ));
        break;
      case 'inputs_length':
        _formItems.add(
          FractionallySizedBox(
            widthFactor: 0.95,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insira um nome.';
                      }
                      inputName = value;
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Nome do material',
                      hintStyle: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        );
        _formItems.add(SizedBox(
          height: 10,
        ));
        _formItems.add(Row(
          children: [
            Expanded(
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o comprimento';
                  }
                  inputLength = value;
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Comprimento (cm)',
                  hintStyle: TextStyle(
                    fontSize: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MoneyInputFormatter(
                    thousandSeparator: ThousandSeparator.Period,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o valor.';
                  }
                  inputCost = value;
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Valor total',
                  hintStyle: TextStyle(
                    fontSize: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MoneyInputFormatter(
                    leadingSymbol: 'R\$',
                    thousandSeparator: ThousandSeparator.Period,
                    useSymbolPadding: true,
                  ),
                ],
              ),
            )
          ],
        ));
        break;
      case 'edit_inputs_length':
        _formItems.add(
          FractionallySizedBox(
            widthFactor: 0.95,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: widget.itemName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insira um nome.';
                      }
                      inputName = value;
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Nome do material',
                      hintStyle: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        );
        _formItems.add(SizedBox(
          height: 10,
        ));
        _formItems.add(Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue:
                    brNumberFormat.format(double.parse(widget.itemLength!)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o comprimento';
                  }
                  inputLength = value;
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Comprimento (cm)',
                  hintStyle: TextStyle(
                    fontSize: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MoneyInputFormatter(
                    thousandSeparator: ThousandSeparator.Period,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: TextFormField(
                initialValue: brCurrencyFormat
                    .format(double.parse(widget.itemUnityCost!)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o valor.';
                  }
                  inputCost = value;
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Valor total',
                  hintStyle: TextStyle(
                    fontSize: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MoneyInputFormatter(
                    leadingSymbol: 'R\$',
                    thousandSeparator: ThousandSeparator.Period,
                    useSymbolPadding: true,
                  ),
                ],
              ),
            )
          ],
        ));
        break;
      case 'inputs_area':
        _formItems.add(
          FractionallySizedBox(
            widthFactor: 0.95,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insira um nome.';
                      }
                      inputName = value;
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Nome do material',
                      hintStyle: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    // initialValue: widget.itemName != null ? widget.itemName : '',
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        );
        _formItems.add(SizedBox(
          height: 10,
        ));
        _formItems.add(
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira o comprimento.';
                    }
                    inputWidth = value;
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Comprimento (cm)',
                    hintStyle: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  // initialValue: widget.itemQuantity != null ? widget.itemQuantity : '',
                  inputFormatters: [
                    MoneyInputFormatter(
                      thousandSeparator: ThousandSeparator.Period,
                      useSymbolPadding: true,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira a largura.';
                    }
                    inputHeight = value;
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Largura (cm)',
                    hintStyle: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  // initialValue: widget.itemQuantity != null ? widget.itemQuantity : '',
                  inputFormatters: [
                    MoneyInputFormatter(
                      thousandSeparator: ThousandSeparator.Period,
                      useSymbolPadding: true,
                    ),
                  ],
                ),
              )
            ],
          ),
        );
        _formItems.add(
          Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira o valor.';
                    }
                    inputCost = value;
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Valor total',
                    hintStyle: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    MoneyInputFormatter(
                      leadingSymbol: 'R\$',
                      thousandSeparator: ThousandSeparator.Period,
                      useSymbolPadding: true,
                    ),
                  ],
                  // initialValue: widget.itemQuantity != null ? widget.itemQuantity : '',
                ),
              )
            ],
          ),
        );
        break;
      case 'edit_inputs_area':
        _formItems.add(
          FractionallySizedBox(
            widthFactor: 0.95,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: widget.itemName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insira um nome.';
                      }
                      inputName = value;
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Nome do material',
                      hintStyle: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    // initialValue: widget.itemName != null ? widget.itemName : '',
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        );
        _formItems.add(SizedBox(
          height: 10,
        ));
        _formItems.add(
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue:
                      brNumberFormat.format(double.parse(widget.itemWidth!)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira o comprimento.';
                    }
                    inputWidth = value;
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Comprimento (cm)',
                    hintStyle: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  // initialValue: widget.itemQuantity != null ? widget.itemQuantity : '',
                  inputFormatters: [
                    MoneyInputFormatter(
                      thousandSeparator: ThousandSeparator.Period,
                      useSymbolPadding: true,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: TextFormField(
                  initialValue:
                      brNumberFormat.format(double.parse(widget.itemHeight!)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira a largura.';
                    }
                    inputHeight = value;
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Largura (cm)',
                    hintStyle: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  // initialValue: widget.itemQuantity != null ? widget.itemQuantity : '',
                  inputFormatters: [
                    MoneyInputFormatter(
                      thousandSeparator: ThousandSeparator.Period,
                      useSymbolPadding: true,
                    ),
                  ],
                ),
              )
            ],
          ),
        );
        _formItems.add(
          Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: TextFormField(
                  initialValue: brCurrencyFormat
                      .format(double.parse(widget.itemUnityCost!)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira o valor.';
                    }
                    inputCost = value;
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Valor total',
                    hintStyle: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    MoneyInputFormatter(
                      leadingSymbol: 'R\$',
                      thousandSeparator: ThousandSeparator.Period,
                      useSymbolPadding: true,
                    ),
                  ],
                  // initialValue: widget.itemQuantity != null ? widget.itemQuantity : '',
                ),
              )
            ],
          ),
        );
        break;
      case 'salary':
        _formItems.add(
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o salário desejado.';
              }

              print(Helper.getDoubleFromBRL(value));
              salary = value;
              print('salary value: ' + salary.toString());
              // salary = Helper.getDoubleFromBRL(value);
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Salário mensal desejado.',
              hintStyle: TextStyle(
                fontSize: 12,
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              MoneyInputFormatter(
                leadingSymbol: 'R\$',
                thousandSeparator: ThousandSeparator.Period,
              ),
            ],
            // controller: _currencyController,
          ),
        );
        break;

      case 'selectInputs':
        String measurementUnity = widget.itemMeasurementUnity!;
        print(widget.itemMeasurementUnity);

        _formItems.add(
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe a quantidade utilizada.';
              }
              selectInputQuantity = value;
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Quantidade utilizada em ' +
                  Helper.simplifiedMeasurementUnity(measurementUnity) +
                  '.',
              hintStyle: TextStyle(
                fontSize: 12,
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              MoneyInputFormatter(
                thousandSeparator: ThousandSeparator.Period,
              ),
            ],
          ),
        );
        break;
      case 'selectVariableCosts':
        _formItems.add(
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe a quantidade utilizada.';
              }
              selectInputQuantity = value;
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Quantidade utilizada.',
              hintStyle: TextStyle(
                fontSize: 12,
              ),
            ),
            keyboardType: TextInputType.number,
          ),
        );
        break;
      case 'editFixedCosts':
        _formItems.add(
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: widget.itemName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o nome do custo fixo.';
                    }
                    editFixedCostsName = value;
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Nome',
                    hintStyle: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: TextFormField(
                  initialValue: brCurrencyFormat
                      .format(double.parse(widget.itemUnityCost!)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o valor do custo fixo.';
                    }
                    editFixedCostsUnityCost = value;
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Valor',
                    hintStyle: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    MoneyInputFormatter(
                      leadingSymbol: 'R\$',
                      thousandSeparator: ThousandSeparator.Period,
                      useSymbolPadding: true,
                    ),
                  ],
                ),
              )
            ],
          ),
        );
        break;
      case 'editVariableCosts':
        _formItems.add(
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: widget.itemName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o nome do custo fixo.';
                    }
                    editVariableCostsName = value;
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Nome descritivo',
                    hintStyle: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: TextFormField(
                  initialValue: widget.itemQuantity,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a quantidade do custo variável.';
                    }
                    editVariableCostsQuantity = value;
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Quantidade',
                    hintStyle: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: TextFormField(
                  initialValue: brNumberFormat
                      .format(double.parse(widget.itemUnityCost!))
                      .toString(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o valor total do custo variável.';
                    }
                    editVariableCostsUnityCost = value;
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Valor total',
                    hintStyle: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    MoneyInputFormatter(
                      leadingSymbol: 'R\$',
                      thousandSeparator: ThousandSeparator.Period,
                      useSymbolPadding: true,
                    ),
                  ],
                ),
              )
            ],
          ),
        );
        break;
      case 'editSalary':
        _formItems.add(
          TextFormField(
            initialValue:
                brCurrencyFormat.format(double.parse(widget.itemSalary!)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o salário desejado.';
              }
              salary = value;

              return null;
            },
            decoration: InputDecoration(
              hintText: 'Salário mensal desejado.',
              hintStyle: TextStyle(
                fontSize: 12,
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              MoneyInputFormatter(
                leadingSymbol: 'R\$',
                thousandSeparator: ThousandSeparator.Period,
                useSymbolPadding: true,
              ),
            ],
            // controller: _currencyController,
          ),
        );
        break;
      default:
    }

    return _formItems;
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.999,
      child: Dialog(
        insetPadding: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.padding),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: contentBox(context),
      ),
    );
  }

  contentBox(context) {
    return AlertDialog(
      backgroundColor: Color(Constants.colorPink),
      insetPadding: EdgeInsets.all(2),
      content: FractionallySizedBox(
        widthFactor: 0.99,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.descriptions,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              FractionallySizedBox(
                widthFactor: 0.99,
                child: Column(
                  children: buildForm(),
                ),
              )
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            widget.btnCancel,
            style: TextStyle(
              color: Color(Constants.colorGray),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(Constants.colorGray),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              widget.btnSave,
              style: TextStyle(
                color: Color(Constants.colorPink),
              ),
            ),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              switch (this.widget.form) {
                case 'fixed_costs':
                  addFixedCost(fixedCostName, fixedCostprice);
                  Navigator.pop(context, true);
                  break;
                case 'variable_costs':
                  addVariableCost(
                      variableCostName, variableQuantity, variableCost);
                  Navigator.pop(context, true);
                  break;
                case 'inputs':
                  print('inputs_itemHasPacking' +
                      widget.itemHasPacking.toString());
                  widget.itemHasPacking != null && widget.itemHasPacking!
                      ? addInput(
                          inputName,
                          // double.parse(inputCost),
                          Helper.getDoubleFromBRL(inputCost),
                          'unitary',
                          // quantity: double.parse(inputQuantity),
                          quantity: Helper.getIntFromBRLNumber(inputQuantity),
                          packing: 1,
                        )
                      : addInput(
                          inputName,
                          // double.parse(inputCost),
                          Helper.getDoubleFromBRL(inputCost),
                          'unitary',
                          // quantity: double.parse(inputQuantity),
                          quantity: Helper.getIntFromBRLNumber(inputQuantity),
                          packing: 0,
                        );

                  Navigator.pop(context, true);
                  break;
                case 'inputs_length':
                  print('inputs_itemHasPacking' +
                      widget.itemHasPacking.toString());
                  widget.itemHasPacking != null && widget.itemHasPacking!
                      ? addInput(
                          inputName,
                          // double.parse(inputCost),
                          Helper.getDoubleFromBRL(inputCost),
                          'length',
                          length: Helper.getDoubleFromBRLNumber(inputLength),
                          packing: 1,
                        )
                      : addInput(
                          inputName,
                          // double.parse(inputCost),
                          Helper.getDoubleFromBRL(inputCost),
                          'length',
                          // length: double.parse(inputLength),
                          length: Helper.getDoubleFromBRLNumber(inputLength),
                          packing: 0,
                        );

                  Navigator.pop(context, true);
                  break;
                case 'inputs_area':
                  print('inputs_itemHasPacking' +
                      widget.itemHasPacking.toString());
                  widget.itemHasPacking != null && widget.itemHasPacking!
                      ? addInput(
                          inputName,
                          // double.parse(inputCost),
                          Helper.getDoubleFromBRL(inputCost),
                          'area',
                          height: Helper.getDoubleFromBRLNumber(inputHeight),
                          width: Helper.getDoubleFromBRLNumber(inputWidth),
                          packing: 1,
                        )
                      : addInput(
                          inputName,
                          // double.parse(inputCost),
                          Helper.getDoubleFromBRL(inputCost),
                          'area',
                          height: Helper.getDoubleFromBRLNumber(inputHeight),
                          width: Helper.getDoubleFromBRLNumber(inputWidth),
                          packing: 0,
                        );

                  Navigator.pop(context, true);
                  break;
                case 'inputs_weight':
                  print('inputs_itemHasPacking' +
                      widget.itemHasPacking.toString());
                  widget.itemHasPacking != null && widget.itemHasPacking!
                      ? addInput(
                          inputName,
                          // double.parse(inputCost),
                          Helper.getDoubleFromBRL(inputCost),
                          'weight',
                          // weight: double.parse(inputWeight),
                          weight: Helper.getDoubleFromBRLNumber(inputWeight),
                          packing: 1,
                        )
                      : addInput(
                          inputName,
                          // double.parse(inputCost),
                          Helper.getDoubleFromBRL(inputCost),
                          'weight',
                          // weight: double.parse(inputWeight),
                          weight: Helper.getDoubleFromBRLNumber(inputWeight),
                          packing: 0,
                        );

                  Navigator.pop(context, true);
                  break;
                case 'inputs_volume':
                  print('inputs_itemHasPacking' +
                      widget.itemHasPacking.toString());
                  widget.itemHasPacking != null && widget.itemHasPacking!
                      ? addInput(
                          inputName,
                          // double.parse(inputCost),
                          Helper.getDoubleFromBRL(inputCost),
                          'volume',
                          // volume: double.parse(inputVolume),
                          volume: Helper.getDoubleFromBRLNumber(inputVolume),
                          packing: 1,
                        )
                      : addInput(
                          inputName,
                          // double.parse(inputCost),
                          Helper.getDoubleFromBRL(inputCost),
                          'volume',
                          // volume: double.parse(inputVolume),
                          volume: Helper.getDoubleFromBRLNumber(inputVolume),
                          packing: 0,
                        );

                  Navigator.pop(context, true);
                  break;
                case 'edit_inputs_unitary':
                  print('inputId: ' + widget.itemId.toString());
                  print('inputCost: ' + inputCost);
                  print('quantity: ' + inputQuantity);
                  print('type: ' + widget.form.substring(12));
                  updateInput(
                    int.parse(widget.itemId.toString()),
                    inputName,
                    // double.parse(inputCost),
                    Helper.getDoubleFromBRL(inputCost),
                    widget.form.substring(12),
                    // quantity: double.parse(inputQuantity),
                    quantity: Helper.getIntFromBRLNumber(inputQuantity),
                    // packing: widget.itemHasPacking,
                    packing:
                        widget.itemHasPacking != null && widget.itemHasPacking!
                            ? 1
                            : 0,
                  );

                  Navigator.pop(context, true);
                  break;
                case 'edit_inputs_length':
                  print('inputId: ' + widget.itemId.toString());
                  print('inputCost: ' + inputCost);
                  print('length: ' + inputLength);
                  print('type: ' + widget.form.substring(12));
                  updateInput(
                    int.parse(widget.itemId.toString()),
                    inputName,
                    // double.parse(inputCost),
                    Helper.getDoubleFromBRL(inputCost),
                    widget.form.substring(12),
                    // length: double.parse(inputLength),
                    length: Helper.getDoubleFromBRLNumber(inputLength),
                    // packing: widget.itemHasPacking,
                    packing:
                        widget.itemHasPacking != null && widget.itemHasPacking!
                            ? 1
                            : 0,
                  );

                  Navigator.pop(context, true);
                  break;
                case 'edit_inputs_area':
                  print('inputId: ' + widget.itemId.toString());
                  print('inputCost: ' + inputCost);
                  print('height: ' + inputHeight);
                  print('width: ' + inputWidth);
                  print('type: ' + widget.form.substring(12));
                  print('packing: ' + widget.itemHasPacking.toString());
                  updateInput(
                    int.parse(widget.itemId.toString()),
                    inputName,
                    // double.parse(inputCost),
                    Helper.getDoubleFromBRL(inputCost),
                    widget.form.substring(12),
                    // height: double.parse(inputHeight),
                    // width: double.parse(inputWidth),
                    height: Helper.getDoubleFromBRLNumber(inputHeight),
                    width: Helper.getDoubleFromBRLNumber(inputWidth),
                    // packing: widget.itemHasPacking,
                    packing:
                        widget.itemHasPacking != null && widget.itemHasPacking!
                            ? 1
                            : 0,
                  );

                  Navigator.pop(context, true);
                  break;
                case 'edit_inputs_weight':
                  print('inputId: ' + widget.itemId.toString());
                  print('inputCost: ' + inputCost);
                  print('weight: ' + inputWeight);
                  print('type: ' + widget.form.substring(12));
                  updateInput(
                    int.parse(widget.itemId.toString()),
                    inputName,
                    // double.parse(inputCost),
                    Helper.getDoubleFromBRL(inputCost),
                    widget.form.substring(12),
                    // weight: double.parse(inputWeight),
                    weight: Helper.getDoubleFromBRLNumber(inputWeight),
                    // packing: widget.itemHasPacking,
                    packing:
                        widget.itemHasPacking != null && widget.itemHasPacking!
                            ? 1
                            : 0,
                  );

                  Navigator.pop(context, true);
                  break;
                case 'edit_inputs_volume':
                  print('inputId: ' + widget.itemId.toString());
                  print('inputCost: ' + inputCost);
                  print('volume: ' + inputVolume);
                  print('type: ' + widget.form.substring(12));
                  updateInput(
                    int.parse(widget.itemId.toString()),
                    inputName,
                    // double.parse(inputCost),
                    Helper.getDoubleFromBRL(inputCost),
                    widget.form.substring(12),
                    // volume: double.parse(inputVolume),
                    volume: Helper.getDoubleFromBRLNumber(inputVolume),
                    // packing: widget.itemHasPacking,
                    packing:
                        widget.itemHasPacking != null && widget.itemHasPacking!
                            ? 1
                            : 0,
                  );

                  Navigator.pop(context, true);
                  break;
                case 'salary':
                  addSalary(salary);
                  Navigator.pop(context, true);
                  break;
                case 'selectInputs':
                  print('selectInputName:' + selectInputName);
                  sharedPreferences.saveDouble(
                    'input_' + selectInputName,
                    Helper.materialCost(
                      widget.itemUnityCost,
                      widget.itemQuantity!,
                      Helper.getDoubleFromBRLNumber(selectInputQuantity),
                    ),
                  );
                  Navigator.pop(context, selectInputQuantity);

                  break;
                case 'selectVariableCosts':
                  sharedPreferences.saveDouble(
                    'packing_' + selectInputName,
                    Helper.materialCost(
                      widget.itemUnityCost,
                      widget.itemQuantity,
                      selectInputQuantity,
                    ),
                  );
                  Navigator.pop(context, selectInputQuantity);
                  break;

                case 'editFixedCosts':
                  updateFixedCost(widget.itemId, editFixedCostsName,
                      editFixedCostsUnityCost);
                  Navigator.pop(context, true);
                  break;
                case 'editVariableCosts':
                  updateVariableCost(widget.itemId, editVariableCostsName,
                      editVariableCostsQuantity, editVariableCostsUnityCost);
                  Navigator.pop(context, true);
                  break;
                case 'editSalary':
                  updateSalary(widget.itemId, salary);
                  Navigator.pop(context, true);
                  break;
                default:
              }
              // Navigator.pop(context, true);
            }
          },
        ),
      ],
    );
  }
}

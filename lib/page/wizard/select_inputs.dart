import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:precific_arte/model/input.dart';
import 'package:precific_arte/page/wizard/select_variable_costs.dart';
import 'package:precific_arte/repositories/database_handler.dart';
import 'package:precific_arte/test.dart';
import 'package:precific_arte/widget/custom_dialog.dart';
import 'package:precific_arte/constants.dart';
import 'package:precific_arte/widget/pill.dart';

class SelectInputsScreen extends StatefulWidget {
  @override
  _SelectInputsScreenState createState() => _SelectInputsScreenState();
}

class _SelectInputsScreenState extends State<SelectInputsScreen>
    with SingleTickerProviderStateMixin {
  late DatabaseHandler handler;
  bool isLoading = false;
  bool refreshList = false;

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
    this.handler.initializeDB();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<Widget> _pills = <Widget>[];

  List<Widget> addPill(quantity, itemName) {
    // _pills.
    // // _pills.
    // _pills.add(
    //   Pill(title: quantity.toString() + 'x ' + itemName),
    // );
    // setState(() {
    _pills.add(Pill(title: quantity.toString() + 'x ' + itemName));
    // });
    print(_pills);

    return _pills;
  }

  Stream<List<Widget>> pills() {
    return _pills as Stream<List<Widget>>;
  }

  List<Widget> myPills() {
    setState(() {});
    return _pills;
  }

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
      body: Container(
        decoration: new BoxDecoration(color: Color(Constants.colorPink)),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 1,
              child: Text(
                'Selecione os materiais utilizados no processo de fabricação do produto.',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Wrap(
                children: myPills(),
              ),
            ),
            Expanded(
              flex: 9,
              child: FutureBuilder(
                future: this.handler.retrieveInputs(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Input>> snapshot) {
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
                        return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: ListTile(
                                tileColor: Color(Constants.colorWhite),
                                contentPadding: EdgeInsets.all(8.0),
                                title: Text(
                                  snapshot.data![index].name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                                onTap: () => _dialogShow(
                                  context,
                                  snapshot.data![index].id,
                                  snapshot.data![index].name,
                                  snapshot.data![index].type == 'unitary'
                                      ? Helper.unityCost(
                                          snapshot.data![index].totalCost,
                                          'unitary',
                                          quantity:
                                              snapshot.data![index].quantity,
                                        )
                                      : snapshot.data![index].type == 'area'
                                          ? Helper.unityCost(
                                              snapshot.data![index].totalCost,
                                              'area',
                                              width:
                                                  snapshot.data![index].width,
                                              height:
                                                  snapshot.data![index].height,
                                            )
                                          : snapshot.data![index].type ==
                                                  'weight'
                                              ? Helper.unityCost(
                                                  snapshot
                                                      .data![index].totalCost,
                                                  'weight',
                                                  weight: snapshot
                                                      .data![index].weight,
                                                )
                                              : snapshot.data![index].type ==
                                                      'volume'
                                                  ? Helper.unityCost(
                                                      snapshot.data![index]
                                                          .totalCost,
                                                      'volume',
                                                      volume: snapshot
                                                          .data![index].volume,
                                                    )
                                                  : snapshot.data![index]
                                                              .type ==
                                                          'length'
                                                      ? Helper.unityCost(
                                                          snapshot.data![index]
                                                              .totalCost,
                                                          'length',
                                                          length: snapshot
                                                              .data![index]
                                                              .length,
                                                        )
                                                      : '',
                                  snapshot.data![index].type == 'unitary'
                                      ? snapshot.data![index].quantity
                                      : snapshot.data![index].type == 'area'
                                          ? Helper.multiply(
                                              snapshot.data![index].width,
                                              snapshot.data![index].height,
                                            )
                                          : snapshot.data![index].type ==
                                                  'weight'
                                              ? snapshot.data![index].weight
                                              : snapshot.data![index].type ==
                                                      'volume'
                                                  ? snapshot.data![index].volume
                                                  : snapshot.data![index]
                                                              .type ==
                                                          'length'
                                                      ? snapshot
                                                          .data![index].length
                                                      : '',
                                  snapshot.data![index].type,
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text(
                            'Você não tem materiais.',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        );
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SelectVariableCostsScreen(),
            ),
          );
        },
        child: const Icon(Icons.navigate_next),
        backgroundColor: Color(Constants.colorGreen),
        foregroundColor: Color(Constants.colorGray),
      ),
    );
  }

  void _dialogShow(BuildContext context, itemId, itemName, itemUnityCost,
      itemQuantity, itemMeasurementUnity) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Informe a quantidade utilizada",
            descriptions: '',
            //     "Adicione os materiais para realizar o cálculo do preço de venda",
            form: 'selectInputs',
            btnCancel: 'Cancelar',
            btnSave: 'Salvar',
            itemId: itemId.toString(),
            itemName: itemName.toString(),
            itemUnityCost: itemUnityCost.toString(),
            itemQuantity: itemQuantity.toString(),
            itemMeasurementUnity: itemMeasurementUnity.toString(),
          );
        });

    if (result != null) {
      // debugPrint(result);
      addPill(result, itemName);
      // setState(() => addPill(result, itemName));
      setState(() {});
    }
  }
}

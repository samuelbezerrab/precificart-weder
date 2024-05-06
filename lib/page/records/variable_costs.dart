import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:precific_arte/model/variable_cost.dart';
import 'package:precific_arte/repositories/database_handler.dart';
import 'package:precific_arte/widget/custom_dialog.dart';
import 'package:precific_arte/widget/dialog_form.dart';
import 'package:precific_arte/constants.dart';
import 'package:precific_arte/widget/input_form.dart';
import 'package:intl/intl.dart';
// import 'package:precific_arte/page/edit_note_page.dart';
// import 'package:sqflite_database_example/page/note_detail_page.dart';
// import 'package:sqflite_database_example/widget/note_card_widget.dart';

class VariableCostsScreen extends StatefulWidget {
  @override
  _VariableCostsScreenState createState() => _VariableCostsScreenState();
}

class _VariableCostsScreenState extends State<VariableCostsScreen>
    with SingleTickerProviderStateMixin {
  late DatabaseHandler handler;
  bool isLoading = false;
  bool refreshList = false;

  var brCurrencyFormat =
      new NumberFormat.currency(locale: "pt_BR", symbol: "R\$");

  var brNumberFormat = new NumberFormat.compact(locale: "pt_BR");

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: true,
        title: Text(
          'Custos com Embalagens',
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
        child: FutureBuilder(
          future: this.handler.retrieveVariableCost(),
          builder: (BuildContext context,
              AsyncSnapshot<List<VariableCost>> snapshot) {
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
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Icon(Icons.delete_forever),
                        ),
                        key: ValueKey<int>(snapshot.data![index].id!),
                        onDismissed: (DismissDirection direction) async {
                          await this
                              .handler
                              .deleteVariableCost(snapshot.data![index].id!);
                          setState(() {
                            snapshot.data!.remove(snapshot.data![index]);
                          });
                        },
                        child: Card(
                          child: ListTile(
                            tileColor: Color(Constants.colorPink),
                            contentPadding: EdgeInsets.all(8.0),
                            title: Text(
                              snapshot.data![index].name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                            subtitle: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                FractionallySizedBox(
                                  widthFactor: 0.95,
                                  child: Text('Quantidade'),
                                ),
                                FractionallySizedBox(
                                  widthFactor: 0.95,
                                  child: Container(
                                    color: Color(Constants.colorPinkDarker),
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      brNumberFormat
                                          .format(
                                              snapshot.data![index].quantity)
                                          .toString(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                FractionallySizedBox(
                                  widthFactor: 0.95,
                                  child: Text(
                                    'Custo por unidade',
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: 0.95,
                                  child: Container(
                                    color: Color(Constants.colorPinkDarker),
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      // unityCost(snapshot.data![index].quantity,
                                      //     snapshot.data![index].price),
                                      brCurrencyFormat.format(
                                        double.parse(
                                          unityCost(
                                            snapshot.data![index].quantity,
                                            snapshot.data![index].price,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              _editDialogShow(
                                context,
                                snapshot.data![index].id,
                                snapshot.data![index].name,
                                snapshot.data![index].quantity,
                                snapshot.data![index].price,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text(
                      'Você não tem custos com embalagens.',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  );
                }
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _dialogShow(context),
        child: const Icon(Icons.add),
        backgroundColor: Color(Constants.colorGreen),
        foregroundColor: Color(Constants.colorGray),
      ),
    );
  }

  String unityCost(quantity, totalCost) {
    var unCost = totalCost / quantity;
    return unCost.toString();
  }

  void _dialogShow(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Adicionar custo com embalagem",
            descriptions:
                "Adicione os seus custos com embalagens para realizar o cálculo do preço de venda",
            form: 'variable_costs',
            btnCancel: 'Cancelar',
            btnSave: 'Salvar',
          );
        });

    if (result != null) {
      setState(() {});
    }
  }

  void _editDialogShow(
    BuildContext context,
    itemId,
    itemName,
    itemQuantity,
    itemUnityCost,
  ) async {
    final result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Atualizar custo com embalagem",
            descriptions: '',
            //     "Adicione os materiais para realizar o cálculo do preço de venda",
            form: 'editVariableCosts',
            btnCancel: 'Cancelar',
            btnSave: 'Salvar',
            itemId: itemId.toString(),
            itemName: itemName.toString(),
            itemQuantity: itemQuantity.toString(),
            itemUnityCost: itemUnityCost.toString(),
          );
        });

    if (result != null) {
      // debugPrint(result);
      // addPill(result, itemName);
      // setState(() => addPill(result, itemName));
      setState(() {});
    }
  }
}

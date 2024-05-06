import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:precific_arte/model/salary.dart';
import 'package:precific_arte/repositories/database_handler.dart';
import 'package:precific_arte/widget/custom_dialog.dart';
import 'package:precific_arte/constants.dart';
import 'package:intl/intl.dart';
// import 'package:precific_arte/page/edit_note_page.dart';
// import 'package:sqflite_database_example/page/note_detail_page.dart';
// import 'package:sqflite_database_example/widget/note_card_widget.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class SalaryScreen extends StatefulWidget {
  @override
  _SalaryScreenState createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen>
    with SingleTickerProviderStateMixin {
  late DatabaseHandler handler;
  bool isLoading = false;

  var brCurrencyFormat =
      new NumberFormat.currency(locale: "pt_BR", symbol: "R\$");

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
          'Salário',
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
          future: this.handler.retrieveSalary(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Salary>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                  // return SnackBar(
                  //   content: Text('${snapshot.error}'),
                  //   backgroundColor: Colors.red,
                  // );
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
                              .deleteSalary(snapshot.data![index].id!);
                          setState(() {
                            snapshot.data!.remove(snapshot.data![index]);
                          });
                        },
                        child: Card(
                          child: ListTile(
                            tileColor: Color(Constants.colorPink),
                            contentPadding: EdgeInsets.all(8.0),
                            title: Text('Salário mensal'),
                            onTap: () {
                              _dialogShow(
                                context,
                                'Atualizar salário',
                                'Altere o valor que você deseja receber por mês.',
                                'editSalary',
                                id: snapshot.data![index].id.toString(),
                                salary: snapshot.data![index].salary.toString(),
                              );
                            },
                            subtitle: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                FractionallySizedBox(
                                  widthFactor: 0.95,
                                  child: Text('Salário'),
                                ),
                                FractionallySizedBox(
                                  widthFactor: 0.95,
                                  child: Container(
                                    color: Color(Constants.colorPinkDarker),
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        // snapshot.data![index].salary.toString(),
                                        brCurrencyFormat.format(
                                            snapshot.data![index].salary)),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                FractionallySizedBox(
                                  widthFactor: 0.95,
                                  child: Text(
                                    'Valor por hora',
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: 0.95,
                                  child: Container(
                                    color: Color(Constants.colorPinkDarker),
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        // hourPrice(snapshot.data![index].salary),
                                        brCurrencyFormat.format(
                                      double.parse(
                                        hourPrice(snapshot.data![index].salary),
                                      ),
                                    )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text(
                      'Você não tem um salário definido.',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  );
                }
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _dialogShow(
          context,
          'Adicionar salário',
          'Insira o valor que você deseja receber por mês.',
          'salary',
        ),
        child: const Icon(Icons.add),
        backgroundColor: Color(Constants.colorGreen),
        foregroundColor: Color(Constants.colorGray),
      ),
    );
  }

  String hourPrice(salary) {
    var hourPrice = salary / 220;
    return hourPrice.toString();
  }

  void _dialogShow(
      BuildContext context, String title, String description, String form,
      {id, salary}) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: title,
            descriptions: description,
            form: form,
            btnCancel: 'Cancelar',
            btnSave: 'Salvar',
            itemId: id,
            itemSalary: salary,
          );
        });

    if (result != null) {
      setState(() {});
    }
  }
}

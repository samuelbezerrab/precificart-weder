import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:precific_arte/model/input.dart';
import 'package:precific_arte/repositories/database_handler.dart';
import 'package:precific_arte/widget/custom_dialog.dart';
import 'package:precific_arte/constants.dart';
// import 'package:precific_arte/page/edit_note_page.dart';
// import 'package:sqflite_database_example/page/note_detail_page.dart';
// import 'package:sqflite_database_example/widget/note_card_widget.dart';
import 'package:intl/intl.dart';
import 'package:precific_arte/widget/fab.dart';

import '../../test.dart';

class PackingScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<PackingScreen>
    with SingleTickerProviderStateMixin {
  late DatabaseHandler handler;
  bool isLoading = false;
  bool refreshList = false;

  var brCurrencyFormat =
      new NumberFormat.currency(locale: "pt_BR", symbol: "R\$");

  var brNumberFormat = new NumberFormat.compact(locale: "pt_BR");

  // var brNumberFormat = new NumberFormat.decimalPattern()

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
          'Embalagens',
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
          future: this.handler.retrieveInputsForPacking(),
          builder: (BuildContext context, AsyncSnapshot<List<Input>> snapshot) {
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
                              .deleteInput(snapshot.data![index].id!);
                          setState(() {
                            snapshot.data!.remove(snapshot.data![index]);
                          });
                        },
                        child: GestureDetector(
                          onTap: () => _dialogShow(
                            context,
                            'Atualizar material',
                            'Altere os valores do material',
                            'edit_inputs_' + snapshot.data![index].type,
                            id: snapshot.data![index].id.toString(),
                            name: snapshot.data![index].name,
                            totalCost:
                                snapshot.data![index].totalCost.toString(),
                            quantity: snapshot.data![index].quantity.toString(),
                            width: snapshot.data![index].width.toString(),
                            height: snapshot.data![index].height.toString(),
                            length: snapshot.data![index].length.toString(),
                            weight: snapshot.data![index].weight.toString(),
                            volume: snapshot.data![index].volume.toString(),
                            hasPacking: true,
                          ),
                          child: Card(
                            child: ListTile(
                              tileColor: Color(Constants.colorPink),
                              contentPadding: EdgeInsets.all(8.0),
                              title: Text(
                                snapshot.data![index].name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              subtitle: mount(
                                snapshot.data![index].type,
                                snapshot.data![index].totalCost,
                                quantity: snapshot.data![index].quantity,
                                width: snapshot.data![index].width,
                                height: snapshot.data![index].height,
                                length: snapshot.data![index].length,
                                weight: snapshot.data![index].weight,
                                volume: snapshot.data![index].volume,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text(
                      'Você não tem custos com embalagens.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  );
                }
            }
          },
        ),
      ),
      floatingActionButton: ExpandableFab(
        distance: 200.0,
        children: [
          ActionButton(
            // onPressed: () => _dialogShow(context, 'inputs_length'),
            onPressed: () => _dialogShow(
              context,
              'Adicionar material',
              'Adicione os materiais para realizar o cálculo do preço de venda',
              'inputs_length',
              hasPacking: true,
            ),
            icon: const Icon(Icons.earbuds),
            title: 'Comprimento',
          ),
          ActionButton(
            // onPressed: () => _dialogShow(context, 'inputs_volume'),
            onPressed: () => _dialogShow(
              context,
              'Adicionar material',
              'Adicione os materiais para realizar o cálculo do preço de venda',
              'inputs_volume',
              hasPacking: true,
            ),
            icon: const Icon(Icons.local_drink),
            title: 'Volume',
          ),
          ActionButton(
            // onPressed: () => _dialogShow(context, 'inputs_weight'),
            onPressed: () => _dialogShow(
              context,
              'Adicionar material',
              'Adicione os materiais para realizar o cálculo do preço de venda',
              'inputs_weight',
              hasPacking: true,
            ),
            icon: const Icon(Icons.monitor_weight),
            title: 'Peso',
          ),
          ActionButton(
            // onPressed: () => _dialogShow(context, 'inputs'),
            onPressed: () => _dialogShow(
              context,
              'Adicionar material',
              'Adicione os materiais para realizar o cálculo do preço de venda',
              'inputs',
              hasPacking: true,
            ),
            icon: const Icon(Icons.widgets),
            title: 'Unidade',
          ),
          ActionButton(
            // onPressed: () => _dialogShow(context, 'inputs_area'),
            onPressed: () => _dialogShow(
              context,
              'Adicionar material',
              'Adicione os materiais para realizar o cálculo do preço de venda',
              'inputs_area',
              hasPacking: true,
            ),
            icon: const Icon(Icons.grid_4x4),
            title: 'Área',
          ),
        ],
        // children: [
        //   ActionButton(
        //     onPressed: () =>
        //         _dialogShow(context, 'inputs_length', hasPacking: true),
        //     icon: const Icon(Icons.earbuds),
        //     title: 'Comprimento',
        //   ),
        //   ActionButton(
        //     onPressed: () =>
        //         _dialogShow(context, 'inputs_volume', hasPacking: true),
        //     icon: const Icon(Icons.local_drink),
        //     title: 'Volume',
        //   ),
        //   ActionButton(
        //     onPressed: () =>
        //         _dialogShow(context, 'inputs_weight', hasPacking: true),
        //     icon: const Icon(Icons.monitor_weight),
        //     title: 'Peso',
        //   ),
        //   ActionButton(
        //     onPressed: () => _dialogShow(context, 'inputs', hasPacking: true),
        //     icon: const Icon(Icons.widgets),
        //     title: 'Unidade',
        //   ),
        //   ActionButton(
        //     onPressed: () =>
        //         _dialogShow(context, 'inputs_area', hasPacking: true),
        //     icon: const Icon(Icons.grid_4x4),
        //     title: 'Área',
        //   ),
        // ],
      ),
    );
  }

  // String unityCost(totalCost, type, {quantity, width, height}) {
  //   var unCost;

  //   switch (type) {
  //     case 'unitary':
  //       unCost = totalCost / quantity;
  //       break;
  //       case 'length':

  //     case 'area':
  //       unCost = totalCost / (width * height);
  //       break;
  //     default:
  //   }

  //   return unCost.toString();
  // }

  Widget mount(type, totalCost,
      {quantity, width, height, length, weight, volume}) {
    return Column(
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
              type == 'unitary'
                  ? brNumberFormat.format(quantity).toString()
                  : type == 'area'
                      ? brNumberFormat.format(height * width).toString()
                      : type == 'length'
                          ? brNumberFormat.format(length).toString()
                          : type == 'weight'
                              ? brNumberFormat.format(weight).toString()
                              : type == 'volume'
                                  ? brNumberFormat.format(volume).toString()
                                  : '',
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        // FractionallySizedBox(
        //   widthFactor: 0.95,
        //   child: Text(
        //     'Custo por unidade',
        //     textAlign: TextAlign.left,
        //   ),
        // ),
        // FractionallySizedBox(
        //   widthFactor: 0.95,
        //   child: Container(
        //     color: Color(Constants.colorPinkDarker),
        //     padding: EdgeInsets.all(8.0),
        //     child: Text(
        //       brCurrencyFormat
        //           .format(
        //             double.parse(
        //               type == 'unitary'
        //                   ? Helper.unityCost(
        //                       totalCost,
        //                       'unitary',
        //                       quantity: quantity,
        //                     )
        //                   : type == 'area'
        //                       ? Helper.unityCost(
        //                           totalCost,
        //                           'area',
        //                           width: width,
        //                           height: height,
        //                         )
        //                       : type == 'length'
        //                           ? Helper.unityCost(
        //                               totalCost,
        //                               'length',
        //                               length: length,
        //                             )
        //                           : type == 'weight'
        //                               ? Helper.unityCost(
        //                                   totalCost,
        //                                   'weight',
        //                                   weight: weight,
        //                                 )
        //                               : type == 'volume'
        //                                   ? Helper.unityCost(
        //                                       totalCost,
        //                                       'volume',
        //                                       volume: volume,
        //                                     )
        //                                   : '0.0',
        //             ),
        //           )
        //           .toString(),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  void _dialogShow(
      // BuildContext context, form,
      //   [id, name, totalCost, quantity]
      BuildContext context,
      String title,
      String description,
      String form,
      {id,
      name,
      totalCost,
      quantity,
      width,
      height,
      length,
      weight,
      volume,
      hasPacking}) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
              // title: id ? "Atualizar material" : "Adicionar material",
              title: title,
              descriptions: description,
              // id ? "Atualize os dados do material para realizar o cálculo do preço de venda" : "Adicione os materiais para realizar o cálculo do preço de venda",
              form: form,
              btnCancel: 'Cancelar',
              btnSave: 'Salvar',
              itemId: id.toString(),
              itemName: name.toString(),
              itemUnityCost: totalCost.toString(),
              itemQuantity: quantity.toString(),
              itemWidth: width.toString(),
              itemHeight: height.toString(),
              itemLength: length.toString(),
              itemWeight: weight.toString(),
              itemVolume: volume.toString(),
              itemHasPacking: hasPacking);
        });

    if (result != null) {
      setState(() {});
    }
  }
  // void _dialogShow(BuildContext context, form, {hasPacking}) async {
  //   // Navigator.push returns a Future that completes after calling
  //   // Navigator.pop on the Selection Screen.
  //   final result = await showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return CustomDialogBox(
  //             // title: id ? "Atualizar material" : "Adicionar material",
  //             title: "Adicionar custo com embalagem",
  //             descriptions:
  //                 "Adicione os custos com embalagem para realizar o cálculo do preço de venda",
  //             // id ? "Atualize os dados do material para realizar o cálculo do preço de venda" : "Adicione os materiais para realizar o cálculo do preço de venda",
  //             form: form,
  //             btnCancel: 'Cancelar',
  //             btnSave: 'Salvar',
  //             // itemId: id.toString(),
  //             // itemName: name.toString(),
  //             // itemUnityCost: totalCost.toString(),
  //             // itemQuantity: quantity.toString(),
  //             itemHasPacking: hasPacking);
  //       });

  //   if (result != null) {
  //     setState(() {});
  //   }
  // }
}

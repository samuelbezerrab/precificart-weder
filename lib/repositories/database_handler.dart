import 'package:precific_arte/model/fixed_cost.dart';
import 'package:precific_arte/model/input.dart';
import 'package:precific_arte/model/salary.dart';
import 'package:precific_arte/model/variable_cost.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(join(path, 'db_precific_artef_v11.db'),
        onCreate: (db, version) => _createDb(db), version: 12);
  }

  Future _createDb(Database db) async {
    await db.execute(
        '''CREATE TABLE fixed_costs(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,price DOUBLE NOT NULL)''');
    await db.execute(
        '''CREATE TABLE variable_costs(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, quantity DOUBLE NOT NULL, price DOUBLE NOT NULL)''');
    await db.execute(
        '''CREATE TABLE salaries(id INTEGER PRIMARY KEY AUTOINCREMENT, salary DOUBLE NOT NULL)''');
    await db.execute(
        '''CREATE TABLE inputs(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, quantity INTEGER, height DOUBLE, width DOUBLE, weight DOUBLE, length DOUBLE, volume DOUBLE, unity TEXT, total_cost DOUBLE NOT NULL, type TEXT NOT NULL, packing INTEGER)''');
    // await db.execute(
    //     '''CREATE TABLE inputs(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, quantity DOUBLE NOT NULL, unity TEXT NOT NULL, unity_cost DOUBLE NOT NULL, total_cost DOUBLE NOT NULL)''');
  }

  Future<int> insertFixedCost(List<FixedCost> fixedCosts) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var fixedCost in fixedCosts) {
      result = await db.insert('fixed_costs', fixedCost.toMap());
    }
    return result;
  }

  Future<List<FixedCost>> retrieveFixedCost() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('fixed_costs');
    return queryResult.map((e) => FixedCost.fromMap(e)).toList();
  }

  Future<int> updateFixedCost(FixedCost fixedCost) async {
    final db = await initializeDB();
    print('fixedcost to be updated');
    print(fixedCost.name);
    print(fixedCost.price);
    var res = await db.update(
      'fixed_costs',
      fixedCost.toMap(),
      where: "id = ?",
      whereArgs: [fixedCost.id],
    );

    return res;
  }

  Future<void> deleteFixedCost(int id) async {
    final db = await initializeDB();
    await db.delete(
      'fixed_costs',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> insertVariableCost(List<VariableCost> variableCosts) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var variableCost in variableCosts) {
      result = await db.insert('variable_costs', variableCost.toMap());
    }

    return result;
  }

  Future<int> updateVariableCost(VariableCost variableCost) async {
    final db = await initializeDB();
    print('fixedcost to be updated');
    print(variableCost.name);
    print(variableCost.price);
    var res = await db.update(
      'variable_costs',
      variableCost.toMap(),
      where: "id = ?",
      whereArgs: [variableCost.id],
    );

    return res;
  }

  Future<List<VariableCost>> retrieveVariableCost() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('variable_costs');
    return queryResult.map((e) => VariableCost.fromMap(e)).toList();
  }

  Future<void> deleteVariableCost(int id) async {
    final db = await initializeDB();
    await db.delete(
      'variable_costs',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> insertSalary(List<Salary> salaries) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var salary in salaries) {
      result = await db.insert('salaries', salary.toMap());
    }
    return result;
  }

  Future<int> updateSalary(Salary salary) async {
    int result = 0;
    final Database db = await initializeDB();
    print('Salary: ' + salary.id.toString() + ' ' + salary.salary.toString());
    result = await db.update(
      'salaries',
      salary.toMap(),
      where: "id = ?",
      whereArgs: [salary.id],
    );

    return result;
  }

  Future<List<Salary>> retrieveSalary() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('salaries', limit: 1, orderBy: 'id DESC');
    return queryResult.map((e) => Salary.fromMap(e)).toList();
  }

  // Future<Salary> retrieveSalaryUnique(int id) async {
  //   final db = await initializeDB();
  //   return await db.query(
  //     'salaries',
  //     where: "id = ?",
  //     whereArgs: [id],
  //   );
  // }

  Future<void> deleteSalary(int id) async {
    final db = await initializeDB();
    await db.delete(
      'salaries',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> insertInput(List<Input> inputs) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var input in inputs) {
      result = await db.insert('inputs', input.toMap());
    }
    developer.log('Input: result');
    return result;
  }

  Future<List<Input>> retrieveInputs() async {
    final Database db = await initializeDB();
    // final List<Map<String, Object?>> queryResult = await db.query('inputs');
    final List<Map<String, Object?>> queryResult = await db.query(
      'inputs',
      where: "packing = 0",
    );
    return queryResult.map((e) => Input.fromMap(e)).toList();
  }

  Future<List<Input>> retrieveInputsForPacking() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query(
      'inputs',
      where: "packing = 1",
    );
    return queryResult.map((e) => Input.fromMap(e)).toList();
  }

  Future<int> updateInput(Input input) async {
    final db = await initializeDB();
    int result = 0;

    print('inputs id' + input.id.toString());
    result = await db.update(
      'inputs',
      input.toMap(),
      where: "id = ?",
      whereArgs: [input.id],
    );

    return result;
  }

  Future<void> deleteInput(int id) async {
    final db = await initializeDB();
    await db.delete(
      'inputs',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}

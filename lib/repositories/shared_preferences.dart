import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  List<String>? calc;
  // MySharedPreferences._privateConstructor(this.calc);

  // static final MySharedPreferences instance =
  //     MySharedPreferences._privateConstructor();

  saveString(name, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(name, value);
  }

  saveDouble(name, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(name, value);
  }

  getDouble(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  get(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  getKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getKeys();
  }

  setListData(value) async {
    List<String>? cal = await getListData('calc');
    // calc = await getListData('calc');
    // calc!.add(value);
    cal?.add(value);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('calc', cal!);
  }

  Future<List<String>?> getListData(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  Future<bool> removeAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  getAllValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    final prefsMap = Map<String, dynamic>();
    for (String key in keys) {
      prefsMap[key] = prefs.get(key);
    }

    return prefsMap;
  }
}

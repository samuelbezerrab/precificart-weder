class Helper {
  static double getDoubleFromBRL(String value) {
    // Removing periods
    String nValue = value.replaceAll('.', '');
    print('doubleFromBRL: ' + nValue);

    // Remove BRL symbol and change last comma for period
    nValue = nValue.substring(2, nValue.length - 3) +
        '.' +
        nValue.substring(nValue.length - 2).trim();

    print('doubleFromBRL 2: ' + nValue);

    return double.parse(nValue);
  }

  static getDoubleFromBRLNumber(String value) {
    // Removing periods
    String nValue = value.replaceAll('.', '');
    print('doubleFromBRLNumber: ' + nValue);

    // Remove last comma for period
    nValue = nValue.substring(0, nValue.length - 3) +
        '.' +
        nValue.substring(nValue.length - 2).trim();

    print('doubleFromBRLNumber 2: ' + nValue);

    return double.parse(nValue);
  }

  static getIntFromBRLNumber(String value) {
    // Removing periods
    String nValue = value.replaceAll('.', '');
    print('doubleFromBRLNumber: ' + nValue);

    return int.parse(nValue);
  }

  static String unityCost(totalCost, type,
      {quantity, width, height, weight, length, volume}) {
    var unCost;

    switch (type) {
      case 'unitary':
        unCost = totalCost / quantity;
        break;
      case 'area':
        unCost = totalCost / (width * height);
        break;
      case 'length':
        unCost = totalCost / length;
        break;
      case 'weight':
        unCost = totalCost / weight;
        break;
      case 'volume':
        unCost = totalCost / volume;
        break;
      default:
    }

    print(unCost);

    return unCost.toString();
  }

  static double materialCost(unityCost, itemQuantity, selectedItemQuantity) {
    print(selectedItemQuantity);
    // var res = (double.parse(unityCost) / double.parse(itemQuantity)) *
    //     double.parse(selectedItemQuantity);
    var res = double.parse(unityCost) * double.parse(selectedItemQuantity);

    return res;
  }

  static double multiply(num1, num2) {
    return num1 * num2;
  }

  static String simplifiedMeasurementUnity(String measurementUnity) {
    String simplifiedMeasurementUnity = '';

    switch (measurementUnity.toLowerCase()) {
      case 'unitary':
        simplifiedMeasurementUnity = 'unidades';
        break;
      case 'area':
        simplifiedMeasurementUnity = 'cm²';
        break;
      case 'volume':
        simplifiedMeasurementUnity = 'ml';
        break;
      case 'weight':
        simplifiedMeasurementUnity = 'gramas';
        break;
      case 'length':
        simplifiedMeasurementUnity = 'cm';
        break;
      default:
    }

    return simplifiedMeasurementUnity;
  }
}

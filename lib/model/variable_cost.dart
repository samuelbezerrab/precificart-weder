// final String tableVariableCosts = 'fixed_costs';

class VariableCost {
  final int? id;
  final String name;
  final double quantity;
  final double price;

  VariableCost({
    this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  VariableCost.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        quantity = res["quantity"],
        price = res["price"];

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'quantity': quantity, 'price': price};
  }
}

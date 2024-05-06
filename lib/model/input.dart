class Input {
  final int? id;
  final String name;
  final int? quantity;
  final double? height;
  final double? width;
  final double? weight;
  final double? length;
  final double? volume;
  final String? unity;
  // final double unityCost;
  final double totalCost;
  final String type;
  final int? packing;

  Input({
    this.id,
    required this.name,
    this.quantity,
    this.height,
    this.width,
    this.weight,
    this.length,
    this.volume,
    this.unity,
    // required this.unityCost,
    required this.totalCost,
    required this.type,
    this.packing,
  });

  Input.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        quantity = res["quantity"],
        height = res["height"],
        width = res["width"],
        weight = res["weight"],
        length = res["length"],
        volume = res["volume"],
        unity = res["unity"],
        // unityCost = res["unity_cost"],
        totalCost = res["total_cost"],
        type = res["type"],
        packing = res["packing"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'height': height,
      'width': width,
      'weight': weight,
      'length': length,
      'volume': volume,
      'unity': unity,
      // 'unity_cost': unityCost,
      'total_cost': totalCost,
      'type': type,
      'packing': packing,
    };
  }
}

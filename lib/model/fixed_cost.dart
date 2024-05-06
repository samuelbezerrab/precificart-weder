// final String tableFixedCosts = 'fixed_costs';

class FixedCost {
  final int? id;
  final String name;
  final double price;

  FixedCost({
    this.id,
    required this.name,
    required this.price,
  });

  FixedCost.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        price = res["price"];

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'price': price};
  }
}

// class FixedCostFields {
//   static final List<String> values = [id, name, price];

//   static final String id = '_id';
//   static final String name = 'name';
//   static final String price = 'price';
// }

// class FixedCost {
//   final int? id;
//   final String name;
//   final double price;

//   const FixedCost({
//     this.id,
//     required this.name,
//     required this.price,
//   });

//   FixedCost copy({
//     int? id,
//     String? name,
//     double? price,
//   }) =>
//       FixedCost(
//         id: id ?? this.id,
//         name: name ?? this.name,
//         price: price ?? this.price,
//       );

//   fixedCostMap() {
//     var mapping = Map<String, dynamic>();
//     mapping['id'] = id;
//     mapping['name'] = name;
//     mapping['price'] = price;

//     return mapping;
//   }

//   static FixedCost fromJson(Map<String, Object?> json) => FixedCost(
//         id: json[FixedCostFields.id] as int?,
//         price: json[FixedCostFields.price] as double,
//         name: json[FixedCostFields.name] as String,
//       );

//   Map<String, Object?> toJson() => {
//         FixedCostFields.id: id,
//         FixedCostFields.name: name,
//         FixedCostFields.price: price,
//       };
// }

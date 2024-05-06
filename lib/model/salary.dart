class Salary {
  final int? id;
  final double salary;

  Salary({
    this.id,
    required this.salary,
  });

  Salary.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        salary = res["salary"];

  Map<String, Object?> toMap() {
    return {'id': id, 'salary': salary};
  }
}

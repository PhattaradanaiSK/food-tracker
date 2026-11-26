/// Immutable row of `public.food_tracker_tb`.
///
/// Field names mirror the Supabase columns exactly (the quoted camelCase
/// columns plus the `created_at` snake_case default). Dates are TEXT and are
/// stored as `YYYY-MM-DD`; `foodPrice` is a double, `foodPerson` an int.
class Food {
  const Food({
    required this.id,
    required this.foodName,
    required this.foodDate,
    required this.foodMeal,
    required this.foodPrice,
    required this.foodPerson,
    this.foodImageUrl = '',
    this.createdAt,
  });

  final String id;
  final String foodDate;
  final String foodMeal;
  final String foodName;
  final double foodPrice;
  final int foodPerson;
  final String foodImageUrl;
  final DateTime? createdAt;

  Food copyWith({
    String? id,
    String? foodDate,
    String? foodMeal,
    String? foodName,
    double? foodPrice,
    int? foodPerson,
    String? foodImageUrl,
    DateTime? createdAt,
  }) {
    return Food(
      id: id ?? this.id,
      foodDate: foodDate ?? this.foodDate,
      foodMeal: foodMeal ?? this.foodMeal,
      foodName: foodName ?? this.foodName,
      foodPrice: foodPrice ?? this.foodPrice,
      foodPerson: foodPerson ?? this.foodPerson,
      foodImageUrl: foodImageUrl ?? this.foodImageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Maps a Supabase row. Accepts both `created_at` and `createdAt`.
  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      id: (map['id'] ?? '').toString(),
      foodDate: (map['foodDate'] ?? '').toString(),
      foodMeal: (map['foodMeal'] ?? '').toString(),
      foodName: (map['foodName'] ?? '').toString(),
      foodPrice: _toDouble(map['foodPrice']),
      foodPerson: _toInt(map['foodPerson']),
      foodImageUrl: (map['foodImageUrl'] ?? '').toString(),
      createdAt: _toDate(map['created_at'] ?? map['createdAt']),
    );
  }

  /// Column-name payload. `created_at` is left to the database default.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'foodDate': foodDate,
      'foodMeal': foodMeal,
      'foodName': foodName,
      'foodPrice': foodPrice,
      'foodPerson': foodPerson,
      'foodImageUrl': foodImageUrl,
    };
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'created_at': createdAt?.toIso8601String(),
        ...toMap(),
      };

  factory Food.fromJson(Map<String, dynamic> json) => Food.fromMap(json);

  static double _toDouble(Object? v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  static int _toInt(Object? v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  static DateTime? _toDate(Object? v) {
    if (v == null) return null;
    return DateTime.tryParse(v.toString());
  }

  @override
  bool operator ==(Object other) =>
      other is Food &&
      other.id == id &&
      other.foodName == foodName &&
      other.foodDate == foodDate &&
      other.foodMeal == foodMeal &&
      other.foodPrice == foodPrice &&
      other.foodPerson == foodPerson &&
      other.foodImageUrl == foodImageUrl;

  @override
  int get hashCode => Object.hash(
        id,
        foodName,
        foodDate,
        foodMeal,
        foodPrice,
        foodPerson,
        foodImageUrl,
      );

  @override
  String toString() =>
      'Food(id: $id, foodName: $foodName, foodDate: $foodDate, foodMeal: $foodMeal, '
      'foodPrice: $foodPrice, foodPerson: $foodPerson, foodImageUrl: $foodImageUrl)';
}

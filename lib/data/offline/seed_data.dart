import '../../models/food.dart';

/// Sample rows shown when the app runs without a Supabase configuration.
/// Newest date first; rows that share a date keep this insertion order.
const String kSeedRadna = 'assets/sample/radna.jpg';
const String kSeedTeenoi = 'assets/sample/teenoi.jpg';
const String kSeedKfc = 'assets/sample/kfc.jpg';
const String kSeedMookata = 'assets/sample/mookata.jpg';
const String kSeedKuaytiew = 'assets/sample/kuaytiew.jpg';
const String kSeedKuaytiew2 = 'assets/sample/kuaytiew2.jpg';

List<Food> seedFoods() {
  final DateTime base = DateTime.utc(2026, 3, 25, 12);
  final List<Food> rows = <Food>[
    const Food(
      id: 'seed-1',
      foodName: 'ราดหน้า',
      foodDate: '2026-03-25',
      foodMeal: 'กลางวัน',
      foodPrice: 65.00,
      foodPerson: 2,
      foodImageUrl: kSeedRadna,
    ),
    const Food(
      id: 'seed-2',
      foodName: 'ตี๋น้อย',
      foodDate: '2026-03-19',
      foodMeal: 'เย็น',
      foodPrice: 289.00,
      foodPerson: 3,
      foodImageUrl: kSeedTeenoi,
    ),
    const Food(
      id: 'seed-3',
      foodName: 'KFC',
      foodDate: '2026-03-19',
      foodMeal: 'เช้า',
      foodPrice: 234.75,
      foodPerson: 2,
      foodImageUrl: kSeedKfc,
    ),
    const Food(
      id: 'seed-4',
      foodName: 'หมูกระทะ',
      foodDate: '2026-03-19',
      foodMeal: 'ว่าง',
      foodPrice: 399.00,
      foodPerson: 4,
      foodImageUrl: kSeedMookata,
    ),
    const Food(
      id: 'seed-5',
      foodName: 'ก๋วยเตี๋ยวไก่',
      foodDate: '2026-03-13',
      foodMeal: 'ว่าง',
      foodPrice: 55.00,
      foodPerson: 1,
      foodImageUrl: kSeedKuaytiew,
    ),
    const Food(
      id: 'seed-6',
      foodName: 'ก๋วยเตี๋ยวไก่',
      foodDate: '2026-03-12',
      foodMeal: 'กลางวัน',
      foodPrice: 60.00,
      foodPerson: 2,
      foodImageUrl: kSeedKuaytiew2,
    ),
  ];

  // Newest date first; within the same date keep insertion order.
  final List<Food> sorted = <Food>[];
  for (int i = 0; i < rows.length; i++) {
    sorted.add(rows[i].copyWith(createdAt: base.subtract(Duration(hours: i))));
  }
  return sortFoods(sorted);
}

/// Newest `foodDate` first, then newest `createdAt`.
/// Used by both repositories so the list order stays consistent.
List<Food> sortFoods(List<Food> rows) {
  final List<Food> copy = List<Food>.of(rows);
  copy.sort((Food a, Food b) {
    final int byDate = b.foodDate.compareTo(a.foodDate);
    if (byDate != 0) return byDate;
    final DateTime? ac = a.createdAt;
    final DateTime? bc = b.createdAt;
    if (ac != null && bc != null) {
      final int byCreated = bc.compareTo(ac);
      if (byCreated != 0) return byCreated;
    } else if (ac != null) {
      return -1;
    } else if (bc != null) {
      return 1;
    }
    return 0;
  });
  return copy;
}

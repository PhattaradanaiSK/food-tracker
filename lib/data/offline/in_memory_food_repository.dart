import '../../models/food.dart';
import '../food_repository.dart';
import 'seed_data.dart';

/// In-memory repository used as offline demo data when no Supabase
/// configuration is present, so the app can still start.
class InMemoryFoodRepository implements FoodRepository {
  InMemoryFoodRepository({bool seed = true, List<Food>? initial})
      : _rows = initial != null
            ? List<Food>.of(initial)
            : (seed ? seedFoods() : <Food>[]);

  final List<Food> _rows;
  int _autoId = 0;

  @override
  Future<List<Food>> listFoods() async => sortFoods(_rows);

  @override
  Future<Food?> getFood(String id) async {
    for (final Food row in _rows) {
      if (row.id == id) return row;
    }
    return null;
  }

  @override
  Future<Food> createFood(Food food) async {
    _autoId++;
    final Food stored = food.copyWith(
      id: food.id.isEmpty ? 'local-${DateTime.now().microsecondsSinceEpoch}-$_autoId' : food.id,
      createdAt: food.createdAt ?? DateTime.now().toUtc(),
    );
    _rows.add(stored);
    return stored;
  }

  @override
  Future<Food> updateFood(Food food) async {
    final int index = _rows.indexWhere((Food r) => r.id == food.id);
    if (index == -1) {
      throw StateError('ไม่พบข้อมูลที่ต้องการแก้ไข (${food.id})');
    }
    final Food stored = food.createdAt == null
        ? food.copyWith(createdAt: _rows[index].createdAt)
        : food;
    _rows[index] = stored;
    return stored;
  }

  @override
  Future<void> deleteFood(String id) async {
    _rows.removeWhere((Food r) => r.id == id);
  }
}

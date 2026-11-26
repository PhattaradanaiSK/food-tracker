import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import '../models/food.dart';
import 'food_repository.dart';
import 'local_photo_store.dart';
import 'offline/in_memory_food_repository.dart';
import 'offline/seed_data.dart';
import 'supabase_food_repository.dart';

/// Injected at startup by `main()`.
final Provider<AppConfig> appConfigProvider =
    Provider<AppConfig>((Ref ref) => AppConfig.empty);

/// The live Supabase backend, or the in-memory repository with offline demo
/// data when no Supabase configuration is present.
final Provider<FoodRepository> foodRepositoryProvider =
    Provider<FoodRepository>((Ref ref) {
  final AppConfig config = ref.watch(appConfigProvider);
  if (config.hasSupabase) {
    return SupabaseFoodRepository(ref.watch(supabaseClientProvider));
  }
  return InMemoryFoodRepository();
});

final Provider<PhotoStore> photoStoreProvider = Provider<PhotoStore>((Ref ref) {
  final AppConfig config = ref.watch(appConfigProvider);
  if (config.hasSupabase) {
    return SupabasePhotoStore(ref.watch(supabaseClientProvider));
  }
  return const LocalPhotoStore();
});

/// Real picker is provided in `main()`. Defaults to unavailable (no camera).
final Provider<CameraPicker> cameraPickerProvider =
    Provider<CameraPicker>((Ref ref) => const UnavailableCameraPicker());

/// Fetched once at startup, right after `Supabase.initialize`.
final Provider<SupabaseClient> supabaseClientProvider =
    Provider<SupabaseClient>((Ref ref) {
  throw UnimplementedError(
    'supabaseClientProvider must be overridden at startup when AppConfig.hasSupabase',
  );
});

/// The list state. `refresh()` re-reads the repository.
final AsyncNotifierProvider<FoodListNotifier, List<Food>> foodListProvider =
    AsyncNotifierProvider<FoodListNotifier, List<Food>>(FoodListNotifier.new);

class FoodListNotifier extends AsyncNotifier<List<Food>> {
  @override
  Future<List<Food>> build() {
    return ref.watch(foodRepositoryProvider).listFoods();
  }

  Future<void> refresh() async {
    state = const AsyncValue<List<Food>>.loading();
    state = await AsyncValue.guard<List<Food>>(
      () => ref.read(foodRepositoryProvider).listFoods(),
    );
  }

  Future<void> create(Food food) async {
    await ref.read(foodRepositoryProvider).createFood(food);
    await refresh();
  }

  Future<void> updateFood(Food food) async {
    await ref.read(foodRepositoryProvider).updateFood(food);
    await refresh();
  }

  Future<void> delete(String id) async {
    await ref.read(foodRepositoryProvider).deleteFood(id);
    await refresh();
  }

  /// Single row for the edit screen; falls back to the cached list.
  Future<Food?> findById(String id) async {
    final Food? direct = await ref.read(foodRepositoryProvider).getFood(id);
    if (direct != null) return direct;
    final List<Food> cached = state.value ?? const <Food>[];
    for (final Food row in cached) {
      if (row.id == id) return row;
    }
    return null;
  }
}

/// Keeps the offline list-ordering helper available to the UI layer.
List<Food> sortFoodRows(List<Food> rows) => sortFoods(rows);

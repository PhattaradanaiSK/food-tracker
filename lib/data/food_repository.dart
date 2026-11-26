import '../models/food.dart';

/// The only thing widgets are allowed to talk to. No widget imports Supabase
/// or `http`; both live behind these interfaces.
abstract interface class FoodRepository {
  /// All rows, newest `foodDate` first (then newest `createdAt`).
  Future<List<Food>> listFoods();

  Future<Food?> getFood(String id);

  /// Returns the stored row (with its generated id).
  Future<Food> createFood(Food food);

  Future<Food> updateFood(Food food);

  Future<void> deleteFood(String id);
}

/// Photo persistence: store a captured file, drop a replaced one, and resolve
/// a value for display.
abstract interface class PhotoStore {
  /// Uploads [localPath] and returns the value to persist in `foodImageUrl`.
  Future<String> upload(String localPath);

  /// Removes the object behind [url] when it is a managed object.
  Future<void> delete(String url);

  /// Displayable source for a stored `foodImageUrl` ('' means: use the logo).
  String displayUrl(String stored);
}

/// Camera capture port. Optional by design: when it is unavailable the form
/// still works without a photo.
abstract interface class CameraPicker {
  /// Returns a local file path, or null when the user cancels / no camera.
  Future<String?> pickFromCamera();
}

/// Returns null so the UI simply keeps the placeholder / existing photo.
class UnavailableCameraPicker implements CameraPicker {
  const UnavailableCameraPicker();

  @override
  Future<String?> pickFromCamera() async => null;
}

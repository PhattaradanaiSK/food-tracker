import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/food.dart';
import 'food_repository.dart';

/// Live repository. Table / bucket names are fixed:
/// `public.food_tracker_tb` and the public bucket `food_tracker_bk`.
/// No secret is stored here — the client is created from AppConfig.
class SupabaseFoodRepository implements FoodRepository {
  SupabaseFoodRepository(this._client);

  static const String table = 'food_tracker_tb';
  static const String bucket = 'food_tracker_bk';

  final SupabaseClient _client;

  @override
  Future<List<Food>> listFoods() async {
    final List<Map<String, dynamic>> data = await _client
        .from(table)
        .select()
        .order('foodDate', ascending: false)
        .order('created_at', ascending: false);
    return data.map(Food.fromMap).toList();
  }

  @override
  Future<Food?> getFood(String id) async {
    final Map<String, dynamic>? data =
        await _client.from(table).select().eq('id', id).maybeSingle();
    if (data == null) return null;
    return Food.fromMap(data);
  }

  @override
  Future<Food> createFood(Food food) async {
    final Map<String, dynamic> data = await _client
        .from(table)
        .insert(food.toMap())
        .select()
        .single();
    return Food.fromMap(data);
  }

  @override
  Future<Food> updateFood(Food food) async {
    final Map<String, dynamic> data = await _client
        .from(table)
        .update(food.toMap())
        .eq('id', food.id)
        .select()
        .single();
    return Food.fromMap(data);
  }

  @override
  Future<void> deleteFood(String id) async {
    await _client.from(table).delete().eq('id', id);
  }
}

/// Storage port. Public bucket so `getPublicUrl` returns a usable link.
class SupabasePhotoStore implements PhotoStore {
  SupabasePhotoStore(this._client);

  final SupabaseClient _client;

  @override
  Future<String> upload(String localPath) async {
    final String name = objectNameFor(localPath);
    await _client.storage.from(SupabaseFoodRepository.bucket).upload(name, File(localPath));
    return publicUrl(name);
  }

  @override
  Future<void> delete(String url) async {
    final String? name = objectNameFromUrl(url, SupabaseFoodRepository.bucket);
    if (name == null || name.isEmpty) return;
    await _client.storage.from(SupabaseFoodRepository.bucket).remove(<String>[name]);
  }

  @override
  String displayUrl(String stored) => stored;

  String publicUrl(String name) =>
      _client.storage.from(SupabaseFoodRepository.bucket).getPublicUrl(name);

  static String objectNameFor(String localPath) {
    final String base = localPath.split(RegExp(r'[/\\]')).last;
    return '${DateTime.now().millisecondsSinceEpoch}-$base';
  }

  /// Extracts the object path from a public URL of [bucket], else null.
  static String? objectNameFromUrl(String url, String bucket) {
    final String marker = '/object/public/$bucket/';
    final int i = url.indexOf(marker);
    if (i == -1) return null;
    final String rest = url.substring(i + marker.length);
    final int q = rest.indexOf('?');
    return q == -1 ? rest : rest.substring(0, q);
  }
}

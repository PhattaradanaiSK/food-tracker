import 'dart:io';

import 'food_repository.dart';

/// [PhotoStore] used with offline demo data.
/// Keeps a captured file on the device and returns a local path.
/// Nothing leaves the device.
class LocalPhotoStore implements PhotoStore {
  const LocalPhotoStore();

  @override
  Future<String> upload(String localPath) async => localPath;

  @override
  Future<void> delete(String url) async {
    if (url.isEmpty || url.startsWith('assets/')) return;
    final File file = File(url);
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  String displayUrl(String stored) => stored;
}

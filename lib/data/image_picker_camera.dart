import 'package:image_picker/image_picker.dart';

import 'food_repository.dart';

/// Real camera capture. Returns null when the device has no camera or the
/// user cancels — the form then simply keeps what it had.
class ImagePickerCamera implements CameraPicker {
  ImagePickerCamera({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<String?> pickFromCamera() async {
    try {
      final XFile? shot = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1280,
        imageQuality: 85,
      );
      return shot?.path;
    } catch (_) {
      return null;
    }
  }
}

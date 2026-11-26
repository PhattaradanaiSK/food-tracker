import 'dart:io';

import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// The large camera area on the form screens.
///
/// Empty state: big gray camera glyph (add screen). With a photo: the photo
/// itself (update screen). Tapping either calls [onTap] to open the camera.
class PhotoPickerBox extends StatelessWidget {
  const PhotoPickerBox({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  final String imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const ValueKey<String>('photo-picker-box'),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 170,
        width: double.infinity,
        child: Center(
          child: imagePath.trim().isEmpty ? _placeholder() : _preview(imagePath),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Icon(
      Icons.photo_camera_outlined,
      size: 120,
      color: AppColors.cameraPlaceholder.withValues(alpha: 0.75),
    );
  }

  Widget _preview(String path) {
    final Widget image = path.startsWith('assets/')
        ? Image.asset(path, fit: BoxFit.contain)
        : Image.file(
            File(path),
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => _placeholder(),
          );
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 160, maxWidth: 220),
      child: ClipRRect(borderRadius: BorderRadius.circular(2), child: image),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';

/// The burger + fries + blue cup mark. Bundled asset, never a remote URL.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 180, this.onRed = false});

  final double size;
  final bool onRed;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      onRed ? 'assets/logo_on_red.png' : 'assets/logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      semanticLabel: 'Food Tracker logo',
    );
  }
}

/// Square thumbnail: the stored photo when it exists, else the logo fallback.
class FoodThumbnail extends StatelessWidget {
  const FoodThumbnail({
    super.key,
    required this.imageUrl,
    this.size = 64,
    this.radius = 2,
  });

  final String imageUrl;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final String stored = imageUrl.trim();
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: size,
        height: size,
        child: stored.isEmpty
            ? _fallback()
            : Image(
                image: _providerFor(stored),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _fallback(),
              ),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      padding: EdgeInsets.all(size * 0.1),
      child: Image.asset('assets/logo.png', fit: BoxFit.contain),
    );
  }

  ImageProvider _providerFor(String stored) {
    if (stored.startsWith('assets/')) return AssetImage(stored);
    if (stored.startsWith('http://') || stored.startsWith('https://')) {
      return NetworkImage(stored);
    }
    return FileImage(File(stored));
  }
}

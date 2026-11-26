import 'dart:async';

import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import '../widgets/app_logo.dart';

/// Splash: full red background, centered mark, yellow wordmark, a row of six
/// food emoji, then a small gold progress arc. No app bar, no footer.
class SplashScreenUi extends StatefulWidget {
  const SplashScreenUi({
    super.key,
    this.splashDuration = const Duration(milliseconds: 1600),
    this.onFinished,
  });

  final Duration splashDuration;

  /// Called once the splash timer elapses. The router supplies navigation.
  final VoidCallback? onFinished;

  @override
  State<SplashScreenUi> createState() => _SplashScreenUiState();
}

class _SplashScreenUiState extends State<SplashScreenUi> {
  /// Bundled PNG emoji so the row renders identically on every device
  /// (no dependency on a colour emoji font being present).
  static const List<String> _emojiAssets = <String>[
    'assets/emoji/burger.png',
    'assets/emoji/fries.png',
    'assets/emoji/hotdog.png',
    'assets/emoji/popcorn.png',
    'assets/emoji/icecream.png',
    'assets/emoji/cupcake.png',
  ];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.splashDuration, () {
      if (!mounted) return;
      widget.onFinished?.call();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const AppLogo(size: AppDims.logoSplashSize, onRed: true),
              const SizedBox(height: 14),
              const Text(
                'Food Tracker',
                style: TextStyle(
                  fontFamily: 'Prompt',
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  color: AppColors.wordmark,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (final String asset in _emojiAssets)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Image.asset(
                        asset,
                        width: 34,
                        height: 34,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 22),
              const SizedBox(
                width: 38,
                height: 38,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.wordmark),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

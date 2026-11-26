import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_router.dart';
import 'theme/app_theme.dart';

/// Root widget. The router is created once per app instance.
class FoodTrackerApp extends StatefulWidget {
  const FoodTrackerApp({super.key});

  @override
  State<FoodTrackerApp> createState() => _FoodTrackerAppState();
}

class _FoodTrackerAppState extends State<FoodTrackerApp> {
  late final GoRouter _router = buildRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Food Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      routerConfig: _router,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'config/app_config.dart';
import 'data/image_picker_camera.dart';
import 'data/providers.dart';

/// Startup: load config, optionally initialize Supabase, then run the app.
/// The anon key is only ever handed to the SDK — never logged.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);

  final AppConfig config = await AppConfig.load();

  if (config.hasSupabase) {
    await Supabase.initialize(
      url: config.supabaseUrl,
      publishableKey: config.supabaseAnonKey,
    );
  }

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        cameraPickerProvider.overrideWithValue(ImagePickerCamera()),
        if (config.hasSupabase)
          supabaseClientProvider.overrideWithValue(Supabase.instance.client),
      ],
      child: const FoodTrackerApp(),
    ),
  );
}

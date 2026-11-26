import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/add_food_tracker_ui.dart';
import 'screens/show_all_food_tracker_ui.dart';
import 'screens/splash_screen_ui.dart';
import 'screens/update_delete_food_tracker_ui.dart';

/// Splash → list → add | edit. No bottom nav, no login.
GoRouter buildRouter({String initialLocation = '/'}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) => SplashScreenUi(
          onFinished: () => context.go('/foods'),
        ),
      ),
      GoRoute(
        path: '/foods',
        builder: (BuildContext context, GoRouterState state) =>
            const ShowAllFoodTrackerUi(),
        routes: <RouteBase>[
          GoRoute(
            path: 'add',
            builder: (BuildContext context, GoRouterState state) =>
                const AddFoodTrackerUi(),
          ),
          GoRoute(
            path: ':id',
            builder: (BuildContext context, GoRouterState state) =>
                UpdateDeleteFoodTrackerUi(
              foodId: state.pathParameters['id'] ?? '',
            ),
          ),
        ],
      ),
    ],
  );
}

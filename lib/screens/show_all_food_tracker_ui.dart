import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/providers.dart';
import '../models/food.dart';
import '../theme/tokens.dart';
import '../widgets/app_logo.dart';

/// The list: red app bar, the logo under it, then the six cards.
/// Empty state shows only the logo and the FAB.
class ShowAllFoodTrackerUi extends ConsumerWidget {
  const ShowAllFoodTrackerUi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Food>> foods = ref.watch(foodListProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('Food Tracker')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _AddFab(
        onPressed: () => context.push('/foods/add'),
      ),
      body: Stack(
        children: <Widget>[
          SafeArea(
            bottom: false,
            child: Column(
              children: <Widget>[
                const _ListHeaderLogo(),
                Expanded(
                  child: foods.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                    error: (Object error, StackTrace stack) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'โหลดข้อมูลไม่สำเร็จ',
                          style: const TextStyle(
                            fontFamily: 'Prompt',
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    data: (List<Food> rows) => rows.isEmpty
                        ? const SizedBox.shrink()
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(
                              AppDims.screenPadH,
                              0,
                              AppDims.screenPadH,
                              96,
                            ),
                            itemCount: rows.length,
                            separatorBuilder: (_, _) => const SizedBox(height: AppDims.cardGap),
                            itemBuilder: (BuildContext context, int index) {
                              return _FoodCard(
                                food: rows[index],
                                index: index,
                                onTap: () => context.push('/foods/${rows[index].id}'),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ListHeaderLogo extends StatelessWidget {
  const _ListHeaderLogo();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 62, bottom: 22),
      child: AppLogo(size: AppDims.logoListSize),
    );
  }
}

/// Red rounded square (not a circle, not end-docked), white "+", centered.
class _AddFab extends StatelessWidget {
  const _AddFab({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppDims.fabSize,
      height: AppDims.fabSize,
      child: Material(
        color: AppColors.primary,
        elevation: 3,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(AppDims.fabRadius),
        child: InkWell(
          key: const ValueKey<String>('add-food-fab'),
          borderRadius: BorderRadius.circular(AppDims.fabRadius),
          onTap: onPressed,
          child: const Center(
            child: Icon(Icons.add, color: AppColors.onPrimary, size: 32),
          ),
        ),
      ),
    );
  }
}

class _FoodCard extends StatelessWidget {
  const _FoodCard({required this.food, required this.index, required this.onTap});

  final Food food;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color background =
        index.isEven ? AppColors.cardGreen : AppColors.cardGray;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(AppDims.cardRadius),
      child: InkWell(
        key: ValueKey<String>('food-card-${food.id}'),
        borderRadius: BorderRadius.circular(AppDims.cardRadius),
        onTap: onTap,
        child: Container(
          height: AppDims.cardHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppDims.cardPadH),
          child: Row(
            children: <Widget>[
              FoodThumbnail(
                imageUrl: food.foodImageUrl,
                size: AppDims.thumbSize,
                radius: 2,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'กิน: ${food.foodName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: 15,
                        height: 1.25,
                        fontWeight: FontWeight.w400,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      'วันที่: ${food.foodDate} มื้อ: ${food.foodMeal}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: 13,
                        height: 1.3,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: AppColors.primary, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}

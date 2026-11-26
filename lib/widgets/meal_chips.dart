import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Four pill chips in one row: เช้า / กลางวัน / เย็น / ว่าง.
/// The selected chip is [AppColors.success], the rest [AppColors.chipOff];
/// labels stay white in both states. The Thai word itself is the value.
class MealChips extends StatelessWidget {
  const MealChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: <Widget>[
          for (int i = 0; i < kMeals.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(width: 8),
            Expanded(child: _chip(kMeals[i])),
          ],
        ],
      ),
    );
  }

  Widget _chip(String meal) {
    final bool isOn = meal == selected;
    return Material(
      color: isOn ? AppColors.success : AppColors.chipOff,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        key: ValueKey<String>('meal-chip-$meal'),
        borderRadius: BorderRadius.circular(22),
        onTap: () => onSelected(meal),
        child: Container(
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isOn ? AppColors.success : AppColors.chipOff,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Text(
            meal,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Prompt',
              color: AppColors.onPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

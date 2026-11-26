import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'field_label.dart';
import 'meal_chips.dart';
import 'photo_picker_box.dart';

/// The five-field form shared by the add and edit screens.
///
/// Controllers and the selected meal live in the screen so both buttons can
/// read and reset the same state.
class FoodFormBody extends StatelessWidget {
  const FoodFormBody({
    super.key,
    required this.photoPath,
    required this.onPickPhoto,
    required this.nameController,
    required this.meal,
    required this.onMealSelected,
    required this.priceController,
    required this.personController,
    required this.dateController,
    required this.onPickDate,
    this.fieldErrors = const <String, String>{},
  });

  final String photoPath;
  final VoidCallback onPickPhoto;
  final TextEditingController nameController;
  final String? meal;
  final ValueChanged<String> onMealSelected;
  final TextEditingController priceController;
  final TextEditingController personController;
  final TextEditingController dateController;
  final VoidCallback onPickDate;
  final Map<String, String> fieldErrors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        PhotoPickerBox(imagePath: photoPath, onTap: onPickPhoto),
        const SizedBox(height: 8),
        const FieldLabel('กินอะไร'),
        TextField(
          key: const ValueKey<String>('field-foodName'),
          controller: nameController,
          textInputAction: TextInputAction.next,
          style: const TextStyle(fontFamily: 'Prompt', fontSize: 16),
          decoration: InputDecoration(
            hintText: 'เช่น KFC, Pizza',
            errorText: fieldErrors['foodName'],
          ),
        ),
        const SizedBox(height: 14),
        const FieldLabel('กินมื้อไหน'),
        MealChips(selected: meal, onSelected: onMealSelected),
        if (fieldErrors['foodMeal'] != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              fieldErrors['foodMeal']!,
              style: const TextStyle(
                fontFamily: 'Prompt',
                fontSize: 12,
                color: AppColors.primary,
              ),
            ),
          ),
        const SizedBox(height: 14),
        const FieldLabel('กินไปเท่าไหร่'),
        TextField(
          key: const ValueKey<String>('field-foodPrice'),
          controller: priceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          style: const TextStyle(fontFamily: 'Prompt', fontSize: 16),
          decoration: InputDecoration(
            hintText: 'เช่น 299.50',
            errorText: fieldErrors['foodPrice'],
          ),
        ),
        const SizedBox(height: 14),
        const FieldLabel('กินกันกี่คน'),
        TextField(
          key: const ValueKey<String>('field-foodPerson'),
          controller: personController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          style: const TextStyle(fontFamily: 'Prompt', fontSize: 16),
          decoration: InputDecoration(
            hintText: 'เช่น 3',
            errorText: fieldErrors['foodPerson'],
          ),
        ),
        const SizedBox(height: 14),
        const FieldLabel('กินไปวันไหน'),
        TextField(
          key: const ValueKey<String>('field-foodDate'),
          controller: dateController,
          keyboardType: TextInputType.datetime,
          style: const TextStyle(fontFamily: 'Prompt', fontSize: 16),
          onTap: onPickDate,
          decoration: InputDecoration(
            hintText: 'เช่น 2020-01-31',
            errorText: fieldErrors['foodDate'],
            suffixIcon: IconButton(
              key: const ValueKey<String>('pick-date-button'),
              onPressed: onPickDate,
              icon: const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.onSurfaceVariant,
                size: 22,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Full-width stacked green / red action buttons.
class FormActions extends StatelessWidget {
  const FormActions({
    super.key,
    required this.primaryLabel,
    required this.onPrimary,
    required this.dangerLabel,
    required this.onDanger,
    this.busy = false,
  });

  final String primaryLabel;
  final VoidCallback onPrimary;
  final String dangerLabel;
  final VoidCallback onDanger;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: AppDims.buttonHeight,
          child: Material(
            color: AppColors.success,
            borderRadius: BorderRadius.circular(AppDims.buttonRadius),
            child: InkWell(
              key: const ValueKey<String>('primary-action'),
              borderRadius: BorderRadius.circular(AppDims.buttonRadius),
              onTap: busy ? null : onPrimary,
              child: Center(
                child: busy
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
                        ),
                      )
                    : Text(
                        primaryLabel,
                        style: const TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: AppColors.onPrimary,
                        ),
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: AppDims.buttonHeight,
          child: Material(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppDims.buttonRadius),
            child: InkWell(
              key: const ValueKey<String>('danger-action'),
              borderRadius: BorderRadius.circular(AppDims.buttonRadius),
              onTap: busy ? null : onDanger,
              child: Center(
                child: Text(
                  dangerLabel,
                  style: const TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

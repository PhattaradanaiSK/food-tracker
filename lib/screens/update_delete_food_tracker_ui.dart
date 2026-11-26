import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/food_repository.dart';
import '../data/providers.dart';
import '../models/food.dart';
import '../models/food_form.dart';
import '../theme/tokens.dart';
import '../widgets/food_form_body.dart';

/// Edit / delete screen: same fields pre-filled from the selected row,
/// green `บันทึกแก้ไข` and red `ลบข้อมูล`.
class UpdateDeleteFoodTrackerUi extends ConsumerStatefulWidget {
  const UpdateDeleteFoodTrackerUi({super.key, required this.foodId});

  final String foodId;

  @override
  ConsumerState<UpdateDeleteFoodTrackerUi> createState() =>
      _UpdateDeleteFoodTrackerUiState();
}

class _UpdateDeleteFoodTrackerUiState
    extends ConsumerState<UpdateDeleteFoodTrackerUi> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _person = TextEditingController();
  final TextEditingController _date = TextEditingController();

  String? _meal;
  String _photoPath = '';
  String _originalImageUrl = '';
  Map<String, String> _errors = const <String, String>{};
  bool _busy = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final Food? food =
        await ref.read(foodListProvider.notifier).findById(widget.foodId);
    if (!mounted || food == null) {
      if (mounted) setState(() => _loaded = true);
      return;
    }
    _fill(food);
    setState(() => _loaded = true);
  }

  void _fill(Food food) {
    _name.text = food.foodName;
    _price.text = _formatPrice(food.foodPrice);
    _person.text = food.foodPerson.toString();
    _date.text = food.foodDate;
    _meal = food.foodMeal;
    _originalImageUrl = food.foodImageUrl;
    _photoPath = food.foodImageUrl;
  }

  static String _formatPrice(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(2)
        : value.toString();
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _person.dispose();
    _date.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final String? path = await ref.read(cameraPickerProvider).pickFromCamera();
    if (!mounted || path == null) return;
    setState(() => _photoPath = path);
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_date.text.trim()) ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 5),
    );
    if (picked == null || !mounted) return;
    setState(() => _date.text = FoodValidator.formatDate(picked));
  }

  Future<void> _save() async {
    final FoodFormResult result = FoodValidator.validate(
      foodName: _name.text,
      foodMeal: _meal,
      foodPrice: _price.text,
      foodPerson: _person.text,
      foodDate: _date.text,
    );

    if (!result.isValid) {
      setState(() => _errors = result.fieldErrors);
      _snack(result.errorMessage ?? 'ข้อมูลไม่ครบถ้วน');
      return;
    }

    setState(() {
      _errors = const <String, String>{};
      _busy = true;
    });

    final PhotoStore photos = ref.read(photoStoreProvider);
    try {
      String imageUrl = _originalImageUrl;
      if (_photoPath.isNotEmpty && _photoPath != _originalImageUrl) {
        imageUrl = await photos.upload(_photoPath);
        if (_originalImageUrl.isNotEmpty) {
          await photos.delete(_originalImageUrl);
        }
      }

      await ref.read(foodListProvider.notifier).updateFood(
            Food(
              id: widget.foodId,
              foodName: result.foodName!,
              foodDate: result.foodDate!,
              foodMeal: result.foodMeal!,
              foodPrice: result.foodPrice!,
              foodPerson: result.foodPerson!,
              foodImageUrl: imageUrl,
            ),
          );

      if (!mounted) return;
      context.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      _snack('บันทึกการแก้ไขไม่สำเร็จ กรุณาลองใหม่');
    }
  }

  Future<void> _delete() async {
    setState(() => _busy = true);
    final PhotoStore photos = ref.read(photoStoreProvider);
    try {
      if (_originalImageUrl.isNotEmpty) {
        await photos.delete(_originalImageUrl);
      }
      await ref.read(foodListProvider.notifier).delete(widget.foodId);
      if (!mounted) return;
      context.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      _snack('ลบข้อมูลไม่สำเร็จ กรุณาลองใหม่');
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('Food Tracker (แก้ไข/ลบ)')),
      body: SafeArea(
        child: !_loaded
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppDims.screenPadH,
                  8,
                  AppDims.screenPadH,
                  24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    FoodFormBody(
                      photoPath: _photoPath,
                      onPickPhoto: _pickPhoto,
                      nameController: _name,
                      meal: _meal,
                      onMealSelected: (String value) =>
                          setState(() => _meal = value),
                      priceController: _price,
                      personController: _person,
                      dateController: _date,
                      onPickDate: _pickDate,
                      fieldErrors: _errors,
                    ),
                    const SizedBox(height: 22),
                    FormActions(
                      primaryLabel: 'บันทึกแก้ไข',
                      onPrimary: _save,
                      dangerLabel: 'ลบข้อมูล',
                      onDanger: _delete,
                      busy: _busy,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

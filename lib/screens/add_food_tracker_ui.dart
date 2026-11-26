import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/providers.dart';
import '../models/food.dart';
import '../models/food_form.dart';
import '../theme/tokens.dart';
import '../widgets/food_form_body.dart';

/// Add screen: camera area, four fields, meal chips, green save + red clear.
class AddFoodTrackerUi extends ConsumerStatefulWidget {
  const AddFoodTrackerUi({super.key});

  @override
  ConsumerState<AddFoodTrackerUi> createState() => _AddFoodTrackerUiState();
}

class _AddFoodTrackerUiState extends ConsumerState<AddFoodTrackerUi> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _person = TextEditingController();
  final TextEditingController _date = TextEditingController();

  String? _meal;
  String _photoPath = '';
  Map<String, String> _errors = const <String, String>{};
  bool _busy = false;

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

  /// The red button: clear every typed value, the meal and any chosen photo.
  /// It does not leave the screen — the app-bar back does that.
  void _clearAll() {
    setState(() {
      _name.clear();
      _price.clear();
      _person.clear();
      _date.clear();
      _meal = null;
      _photoPath = '';
      _errors = const <String, String>{};
    });
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

    try {
      String imageUrl = '';
      if (_photoPath.isNotEmpty) {
        imageUrl = await ref.read(photoStoreProvider).upload(_photoPath);
      }

      await ref.read(foodListProvider.notifier).create(
            Food(
              id: '',
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
      _snack('บันทึกไม่สำเร็จ กรุณาลองใหม่');
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
      appBar: AppBar(title: const Text('Food Tracker (เพิ่ม)')),
      body: SafeArea(
        child: SingleChildScrollView(
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
                onMealSelected: (String value) => setState(() => _meal = value),
                priceController: _price,
                personController: _person,
                dateController: _date,
                onPickDate: _pickDate,
                fieldErrors: _errors,
              ),
              const SizedBox(height: 22),
              FormActions(
                primaryLabel: 'บันทึก',
                onPrimary: _save,
                dangerLabel: 'ยกเลิก',
                onDanger: _clearAll,
                busy: _busy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

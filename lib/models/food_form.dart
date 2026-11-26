import '../theme/tokens.dart';

/// Result of validating the add / edit form.
///
/// [errorMessage] is the Thai message shown in a SnackBar; [fieldErrors] maps a
/// field key to its inline Thai error so the form can highlight the field.
class FoodFormResult {
  const FoodFormResult({
    this.foodName,
    this.foodMeal,
    this.foodPrice,
    this.foodPerson,
    this.foodDate,
    this.fieldErrors = const <String, String>{},
  });

  final String? foodName;
  final String? foodMeal;
  final double? foodPrice;
  final int? foodPerson;
  final String? foodDate;
  final Map<String, String> fieldErrors;

  bool get isValid => fieldErrors.isEmpty;

  String? get errorMessage =>
      fieldErrors.isEmpty ? null : fieldErrors.values.first;
}

/// Field keys used by [FoodFormResult.fieldErrors].
abstract final class FoodField {
  static const String name = 'foodName';
  static const String meal = 'foodMeal';
  static const String price = 'foodPrice';
  static const String person = 'foodPerson';
  static const String date = 'foodDate';
}

/// Pure validation — no Flutter widgets and no I/O.
abstract final class FoodValidator {
  static final RegExp _datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
  static final RegExp _intPattern = RegExp(r'^[+-]?\d+$');

  /// `foodName` — any non-blank text.
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'กรุณากรอกชื่ออาหาร';
    }
    return null;
  }

  /// `foodMeal` — must be exactly one of the four Thai words.
  static String? validateMeal(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'กรุณาเลือกมื้ออาหาร';
    }
    if (!kMeals.contains(value)) {
      return 'มื้ออาหารไม่ถูกต้อง';
    }
    return null;
  }

  /// `foodPrice` — a valid, non-negative number; decimals allowed.
  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'กรุณากรอกราคา';
    }
    final String raw = value.trim().replaceAll(',', '');
    final double? parsed = double.tryParse(raw);
    if (parsed == null) {
      return 'ราคาต้องเป็นตัวเลข';
    }
    if (parsed.isNaN || parsed.isInfinite || parsed < 0) {
      return 'ราคาต้องเป็นตัวเลขที่ถูกต้อง';
    }
    return null;
  }

  /// `foodPerson` — a valid, positive integer.
  static String? validatePerson(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'กรุณากรอกจำนวนคน';
    }
    final String raw = value.trim();
    if (!_intPattern.hasMatch(raw)) {
      return 'จำนวนคนต้องเป็นจำนวนเต็ม';
    }
    final int? parsed = int.tryParse(raw);
    if (parsed == null || parsed <= 0) {
      return 'จำนวนคนต้องมากกว่า 0';
    }
    return null;
  }

  /// `foodDate` — text in `YYYY-MM-DD` (not a Postgres date type).
  static String? validateDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'กรุณากรอกวันที่';
    }
    final String raw = value.trim();
    if (!_datePattern.hasMatch(raw)) {
      return 'วันที่ต้องอยู่ในรูปแบบ YYYY-MM-DD';
    }
    final DateTime? parsed = DateTime.tryParse(raw);
    if (parsed == null || formatDate(parsed) != raw) {
      return 'วันที่ไม่ถูกต้อง';
    }
    return null;
  }

  /// Validates the whole form and returns parsed values plus per-field errors.
  static FoodFormResult validate({
    required String? foodName,
    required String? foodMeal,
    required String? foodPrice,
    required String? foodPerson,
    required String? foodDate,
  }) {
    final Map<String, String> errors = <String, String>{};
    final String? nameError = validateName(foodName);
    if (nameError != null) errors[FoodField.name] = nameError;
    final String? mealError = validateMeal(foodMeal);
    if (mealError != null) errors[FoodField.meal] = mealError;
    final String? priceError = validatePrice(foodPrice);
    if (priceError != null) errors[FoodField.price] = priceError;
    final String? personError = validatePerson(foodPerson);
    if (personError != null) errors[FoodField.person] = personError;
    final String? dateError = validateDate(foodDate);
    if (dateError != null) errors[FoodField.date] = dateError;

    if (errors.isNotEmpty) {
      return FoodFormResult(fieldErrors: errors);
    }

    return FoodFormResult(
      foodName: foodName?.trim(),
      foodMeal: foodMeal,
      foodPrice: double.parse(foodPrice!.trim().replaceAll(',', '')),
      foodPerson: int.parse(foodPerson!.trim()),
      foodDate: foodDate!.trim(),
    );
  }

  /// `YYYY-MM-DD`, zero padded.
  static String formatDate(DateTime date) {
    final String y = date.year.toString().padLeft(4, '0');
    final String m = date.month.toString().padLeft(2, '0');
    final String d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}

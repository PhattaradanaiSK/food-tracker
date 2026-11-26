import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// The small dark label that sits above each outlined field.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Prompt',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}

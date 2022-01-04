import 'package:flutter/material.dart';
import 'package:scrumpoker/constant/color.dart';

// ignore: avoid_classes_with_only_static_members
class StyleUtils {
  static InputDecoration getDecorationTextFieldIcon(Widget icon, String? hint) {
    return InputDecoration(
      hintText: hint,
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: strokeGrey, width: 0.5)),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: strokeGrey, width: 0.5)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: strokeGrey, width: 0.5)),
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
      prefixIcon: Container(
        margin: const EdgeInsets.only(right: 16, left: 16, top: 4, bottom: 4),
        padding: const EdgeInsets.only(right: 10),
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(
              color: strokeGrey,
              width: 0.5,
            ),
          ),
        ),
        child: icon,
      ),
    );
  }
}

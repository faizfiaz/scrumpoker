// ignore_for_file: avoid_classes_with_only_static_members, deprecated_member_use

import 'package:SuperNinja/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

class AppBarCustom {
  static Widget buildAppBar(BuildContext context, String title) {
    return AppBar(
      backgroundColor: primary,
      centerTitle: true,
      titleSpacing: 0,
      elevation: 0,
      title: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          textAlign: TextAlign.start,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      leading: IconButton(
        iconSize: 28,
        icon: const Icon(Feather.chevron_left, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  static Widget buildAppBarInverse(BuildContext context, String title) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      brightness: Brightness.light,
      titleSpacing: 0,
      elevation: 0,
      title: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          textAlign: TextAlign.start,
          style: const TextStyle(
              color: primary, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      leading: IconButton(
        iconSize: 28,
        icon: const Icon(Feather.chevron_left, color: primary),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  static Widget buildAppBarInverseWithActionBack(
      BuildContext context, String title, Function() action) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      brightness: Brightness.light,
      titleSpacing: 0,
      elevation: 0,
      title: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          textAlign: TextAlign.start,
          style: const TextStyle(
              color: primary, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      leading: IconButton(
        iconSize: 28,
        icon: const Icon(Feather.chevron_left, color: primary),
        onPressed: () => action.call(),
      ),
    );
  }

  static Widget buildAppBarNoTitleTrans(BuildContext context) {
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
        iconSize: 28,
        icon: const Icon(Feather.chevron_left, color: primary),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  static Widget trans() {
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}

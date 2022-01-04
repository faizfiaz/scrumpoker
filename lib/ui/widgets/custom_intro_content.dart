import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroContent extends StatelessWidget {
  final PageViewModel page;

  const IntroContent({Key? key, required this.page}) : super(key: key);

  Widget _buildWidget(Widget? widget, String? text, TextStyle style) {
    return widget ?? Text(text!, style: style, textAlign: TextAlign.center);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: page.decoration.descriptionPadding,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.zero,
            child: _buildWidget(
              page.titleWidget,
              page.title,
              page.decoration.titleTextStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: _buildWidget(
              page.bodyWidget,
              page.body,
              page.decoration.bodyTextStyle,
            ),
          ),
          if (page.footer != null)
            Padding(
              padding: EdgeInsets.zero,
              child: page.footer,
            ),
        ],
      ),
    );
  }
}

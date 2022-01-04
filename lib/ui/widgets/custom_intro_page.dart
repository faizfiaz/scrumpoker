// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:introduction_screen/src/model/page_view_model.dart';
import 'package:introduction_screen/src/ui/intro_content.dart';

class IntroPage extends StatelessWidget {
  final PageViewModel page;

  const IntroPage({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          if (page.image != null) page.image!,
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                flex: page.decoration.imageFlex,
                child: Container(
                  color: Colors.transparent,
                ),
              ),
              Expanded(
                flex: page.decoration.bodyFlex,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: page.decoration.pageColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: IntroContent(page: page),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

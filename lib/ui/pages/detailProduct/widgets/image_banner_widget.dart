import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

// ignore: must_be_immutable
class ImageBannerWidget extends StatefulWidget {
  List<String?> imageList;

  ImageBannerWidget(this.imageList);

  @override
  State<StatefulWidget> createState() {
    return _ImageBannerWidget();
  }
}

class _ImageBannerWidget extends BaseStateWidget<ImageBannerWidget> {
  int _current = 0;

  CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        CarouselSlider(
          carouselController: buttonCarouselController,
          options: CarouselOptions(
              height: ScreenUtils.getScreenHeight(context) / 3 +
                  ScreenUtils.getScreenHeight(context) / 10,
              autoPlay: true,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
          items: widget.imageList.map((url) {
            return Builder(
              builder: (context) {
                return InkWell(
                  onTap: () => showDialogImage(url),
                  child: Container(
                    width: double.infinity,
                    child: Image.network(
                      url!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, exception, stackTrace) {
                        return Image.asset(
                          placeholderProduct,
                          height: 145,
                          width: double.infinity,
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(bottom: 32, left: 16),
          child: DotsIndicator(
            dotsCount: widget.imageList.isEmpty ? 1 : widget.imageList.length,
            position: _current.toDouble(),
            decorator: const DotsDecorator(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: primaryTrans, width: 1.2),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              size: Size(10, 10),
              activeSize: Size(18, 10),
              spacing: EdgeInsets.all(2),
              activeColor: primary,
            ),
          ),
        )
      ],
    );
  }

  void showDialogImage(String? url) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            clipBehavior: Clip.antiAlias,
            insetPadding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            elevation: 16,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: PhotoView(
                      imageProvider: NetworkImage(url!),
                    ),
                  )
                ],
              ),
            ));
      },
    );
  }
}

import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/tracking_utils.dart';
import 'package:SuperNinja/domain/models/entity/banners.dart';
import 'package:SuperNinja/ui/pages/webviewScreen/webview_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';

// ignore: must_be_immutable
class BannerDashboardWidget extends StatefulWidget {
  List<Banners>? sliderBanners;
  bool autoPlayBanner;

  BannerDashboardWidget(this.sliderBanners, {this.autoPlayBanner = false});

  @override
  State<StatefulWidget> createState() {
    return _BannerDashboardWidget();
  }
}

class _BannerDashboardWidget extends BaseStateWidget<BannerDashboardWidget> {
  int _current = 0;

  CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    if (!widget.autoPlayBanner) {
      buttonCarouselController.stopAutoPlay();
    }
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 12,
          ),
          CarouselSlider(
            carouselController: buttonCarouselController,
            options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 3,
                autoPlayInterval: const Duration(seconds: 10),
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
            items: widget.sliderBanners!.map((banner) {
              return Builder(
                builder: (context) {
                  return InkWell(
                    onTap: () => handleClick(banner),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          child: Stack(
                            children: <Widget>[
                              Image.network(
                                banner.imageUrl!,
                                fit: BoxFit.cover,
                                width: 1000,
                                height: 300,
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(200, 0, 0, 0),
                                        Color.fromARGB(0, 0, 0, 0)
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Text(
                                    banner.name!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, top: 10),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: DotsIndicator(
                    dotsCount: widget.sliderBanners!.isEmpty
                        ? 1
                        : widget.sliderBanners!.length,
                    position: _current.toDouble(),
                    decorator: const DotsDecorator(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: primary, width: 1.2),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      size: Size(10, 10),
                      activeSize: Size(18, 10),
                      spacing: EdgeInsets.all(2),
                      activeColor: primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void handleClick(Banners banner) {
    final payload = {"banner_id": banner.id, "banner_name": banner.name};
    SmartechPlugin().trackEvent(TrackingUtils.HOMEPAGE_PROMO_PLU, payload);

    if (banner.urlWebview != null) {
      push(
          context,
          MaterialPageRoute(
              builder: (context) => WebviewScreen(banner.urlWebview,
                  banner.name, null, TypeWebView.banner, 0)));
    } else if (banner.deeplinkPath != null) {
      /*Check Deeplink Url going to where*/
    }
  }
}

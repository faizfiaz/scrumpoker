import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/domain/commons/tracking_utils.dart';
import 'package:SuperNinja/domain/usecases/user/user_usecase.dart';
import 'package:SuperNinja/ui/pages/home/home_screen.dart';
import 'package:SuperNinja/ui/widgets/custom_introduction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart' as lib;
import 'package:smartech_flutter_plugin/smartech_plugin.dart';

class IntroScreen extends StatelessWidget {
  Future<void> _onIntroEnd(context) async {
    final usecase = UserUsecase.empty();
    final alreadyLogin = await usecase.hasToken();
    await usecase.setAlreadySeenIntro();
    await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen(
                  0,
                  alreadyLogin: alreadyLogin,
                )),
        (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    trackingEvent(0);
    const pageDecoration = lib.PageDecoration(
      titlePadding: EdgeInsets.zero,
      titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      contentMargin: EdgeInsets.zero,
      footerPadding: EdgeInsets.zero,
      pageColor: pageIntro,
    );

    return IntroductionScreen(
      pages: [
        lib.PageViewModel(
          title: "",
          image: Image.asset(
            splash1,
            fit: BoxFit.cover,
            width: double.infinity,
            height: ScreenUtils.getScreenHeight(context),
          ),
          body: "",
          //image: Image.asset(logoSuperNinja),
          decoration: pageDecoration,
        ),
        lib.PageViewModel(
          title: "",
          image: Image.asset(
            splash2,
            fit: BoxFit.cover,
            width: double.infinity,
            height: ScreenUtils.getScreenHeight(context),
          ),
          body: "",
          decoration: pageDecoration,
        ),
        lib.PageViewModel(
          title: "",
          image: Image.asset(
            splash3,
            fit: BoxFit.cover,
            width: double.infinity,
            height: ScreenUtils.getScreenHeight(context),
          ),
          body: "",
          decoration: pageDecoration,
        ),
        lib.PageViewModel(
          title: "",
          image: Image.asset(
            splash4,
            fit: BoxFit.cover,
            width: double.infinity,
            height: ScreenUtils.getScreenHeight(context),
          ),
          body: "",
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      skipFlex: 0,
      onChange: (index) => {trackingEvent(index)},
      nextFlex: 0,
      skip: const Text('Lewati', style: TextStyle(color: Colors.grey)),
      next: const Icon(
        Icons.arrow_forward,
        size: 32,
        color: Colors.white,
      ),
      done: const Text('Lanjut',
          style: TextStyle(
              fontWeight: FontWeight.w700, fontSize: 20, color: Colors.white)),
      dotsDecorator: const lib.DotsDecorator(
        size: Size(10, 10),
        color: Colors.white,
        activeColor: pageIntro,
        activeSize: Size(22, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
      ),
    );
  }

  void trackingEvent(int index) {
    var eventName = "";
    if (index == 0) {
      eventName = TrackingUtils.ONBOARDING_1;
    } else if (index == 1) {
      eventName = TrackingUtils.ONBOARDING_2;
    } else if (index == 2) {
      eventName = TrackingUtils.ONBOARDING_3;
    } else if (index == 3) {
      eventName = TrackingUtils.ONBOARDING_4;
    }
    SmartechPlugin().trackEvent(eventName, TrackingUtils.getEmptyPayload());
  }
}

// ignore_for_file: deprecated_member_use

import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/domain/commons/tracking_utils.dart';
import 'package:SuperNinja/ui/pages/cart/cart_screen.dart';
import 'package:SuperNinja/ui/pages/dashboard/dashboard_screen.dart';
import 'package:SuperNinja/ui/pages/detailOrder/detail_order_screen.dart';
import 'package:SuperNinja/ui/pages/home/home_navigator.dart';
import 'package:SuperNinja/ui/pages/home/home_view_model.dart';
import 'package:SuperNinja/ui/pages/login/login_screen.dart';
import 'package:SuperNinja/ui/pages/notification/notification_screen.dart';
import 'package:SuperNinja/ui/pages/parentWishAndRoutines/parent_wish_routine_list_screen.dart';
import 'package:SuperNinja/ui/pages/profile/profile_screen.dart';
import 'package:SuperNinja/ui/pages/promo/promo_screen.dart';
import 'package:SuperNinja/ui/pages/under_construction_page.dart';
import 'package:SuperNinja/ui/widgets/default_button.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

import '../under_construction_page.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  int goIndex;
  bool alreadyLogin;
  bool showSuccessOrder;
  int? orderId;

  HomeScreen(this.goIndex,
      {this.alreadyLogin = true,
      this.showSuccessOrder = false,
      this.orderId = 0});

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends BaseStateWidget<HomeScreen>
    with SingleTickerProviderStateMixin
    implements HomeNavigator {
  int _currentIndex = 0;

  final List<Widget> _bodyContent = [
    UnderConstructionPage(),
    ProfileScreen(),
  ];

  TabController? controller;
  HomeViewModel? _viewModel;

  @override
  void onResume() {
    _viewModel!.loadDataApi();
  }

  @override
  void onReady() {
    super.onReady();
    if (widget.orderId! > 0) {
      push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailOrderScreen(widget.orderId)));
    }
  }

  @override
  void initState() {
    controller = TabController(vsync: this, length: 4);
    super.initState();
    _bodyContent.insert(0, DashboardScreen(callbackProduct: onResume));
    _bodyContent.insert(1, PromoScreen(callbackProduct: onResume));
    _bodyContent.insert(
        3,
        ParentWishRoutineListScreen(
          callbackProduct: onResume,
        ));
    _viewModel = HomeViewModel().setView(this) as HomeViewModel?;
    showSuccessOrder(context);

    SmartechPlugin()
        .trackEvent(TrackingUtils.HOMEPAGE, TrackingUtils.getEmptyPayload());

    final payload = {"category_name": "All"};
    SmartechPlugin().trackEvent(TrackingUtils.CATEGORYNAME_LISTING, payload);
    try {
      getInitialLink().then((value) {
        if (value != null && value.contains("/order")) {
          final orderId = value.replaceAll("poc://superninja.com/order/", "");
          push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailOrderScreen(int.parse(orderId))));
        }
      });
      // ignore: empty_catches
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return ChangeNotifierProvider<HomeViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<HomeViewModel>(
          builder: (context, viewModel, _) => Scaffold(
            appBar: buildAppBar(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: buildFloatingButtonCheckout(),
            bottomNavigationBar: buildBottomBar(),
            body: _bodyContent[_currentIndex],
          ),
        ));
  }

  @override
  void refreshState() {
    setState(() {
      if (_currentIndex == 0) {
        (_bodyContent[_currentIndex] as DashboardScreen)
            .stateDashboard
            .onRefresh();
      }
    });
  }

  AppBar buildAppBarHome() {
    var name = "";
    if (_viewModel!.profile != null) {
      if (_viewModel!.profile!.displayName != null &&
          _viewModel!.profile!.displayName!.isNotEmpty) {
        name = _viewModel!.profile!.displayName!;
      } else if (_viewModel!.profile!.name != null) {
        name = _viewModel!.profile!.name!;
      } else {
        name = "";
      }
    }

    return AppBar(
      elevation: 0,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Container(
        alignment: Alignment.centerLeft,
        child: widget.alreadyLogin && _viewModel!.profile != null
            ? Text(
                txt("hi") + ", $name",
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              )
            : Container(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  logoSuperNinja,
                  width: 40,
                  height: 40,
                ),
              ),
      ),
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => _viewModel!.changeLanguage(context),
              child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    txt("current_language"),
                    style: const TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  )),
            )),
        Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: displayNotificationPage,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.notifications,
                    color: primary,
                    size: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 20, left: 20),
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        shape: BoxShape.circle,
                        color: orange),
                    child: Text(
                      _viewModel!.totalUnreadNotification! > 99
                          ? "9+"
                          : _viewModel!.totalUnreadNotification.toString(),
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  BottomAppBar buildBottomBar() {
    return BottomAppBar(
      notchMargin: 5,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const CircularNotchedRectangle(),
      child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15)),
            boxShadow: [
              BoxShadow(color: Colors.black38),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: BottomNavigationBar(
              onTap: onTabTapped,
              currentIndex: _currentIndex,
              selectedFontSize: 10,
              unselectedFontSize: 10,
              selectedItemColor: primary,
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: const Icon(Icons.home), label: txt("home")),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      icPromo,
                      color: Colors.grey,
                    ),
                    activeIcon: SvgPicture.asset(icPromo, color: primary),
                    label: txt("promo")),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.home), label: txt("cart")),
                BottomNavigationBarItem(
                    icon: const Icon(FontAwesome.gratipay),
                    label: txt("wishlist")),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.person), label: txt("profile")),
              ],
            ),
          )),
    );
  }

  FloatingActionButton buildFloatingButtonCheckout() {
    return FloatingActionButton(
      onPressed: displayCartPage,
      backgroundColor: primary,
      tooltip: 'Cart',
      elevation: 2,
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_viewModel!.countCarts != null)
              Text(
                _viewModel!.countCarts!.total.toString(),
                style: const TextStyle(fontSize: 10),
              )
            else
              Container(),
            const Icon(
              Icons.shopping_cart,
              size: 18,
            ),
            const SizedBox(
              height: 4,
            )
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    if (index != 2) {
      if (index == 4 && !widget.alreadyLogin) {
        push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        return;
      }
      setState(() {
        _currentIndex = index;
      });
    }
  }

  PreferredSizeWidget buildAppBar() {
    if (_currentIndex == 0) {
      return buildAppBarHome();
    } else if (_currentIndex == 1) {
      return buildAppBarPromo();
    } else if (_currentIndex == 3) {
      return buildAppBarWishlist();
    } else if (_currentIndex == 4) {
      return buildAppBarProfile();
    } else {
      return AppBar();
    }
  }

  PreferredSizeWidget buildAppBarProfile() {
    return AppBar(
        backgroundColor: primary,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                    alignment: Alignment.center,
                    child: DefaultButton.whiteButtonSmall(
                        context,
                        txt("logout"),
                        () => ScreenUtils.showLogout(context, doLogout))),
              )),
        ]);
  }

  PreferredSizeWidget buildAppBarPromo() {
    return AppBar(
      elevation: 0,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Container(
        alignment: Alignment.centerLeft,
        child: Image.asset(
          logoSuperNinja,
          width: 40,
          height: 40,
        ),
      ),
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    txt("current_language"),
                    style: const TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  )),
            )),
        Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.notifications,
                color: primary,
                size: 20,
              ),
            )),
      ],
    );
  }

  PreferredSizeWidget buildAppBarWishlist() {
    return AppBar(
      elevation: 0,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      titleSpacing: 0,
      title: Container(
        padding: const EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: const Text(
          "Wishlist",
          textAlign: TextAlign.start,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: primary),
        ),
      ),
      actions: const <Widget>[],
    );
  }

  void displayCartPage() {
    push(context, MaterialPageRoute(builder: (context) => CartScreen()));
  }

  void displayNotificationPage() {
    if (_viewModel!.isAlreadyLogin) {
      push(context,
          MaterialPageRoute(builder: (context) => NotificationScreen()));
    } else {
      push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  void showSuccessOrder(BuildContext context) {
    if (!widget.showSuccessOrder) {
      return;
    } else {
      Alert(
        context: context,
        type: AlertType.success,
        title: "",
        desc: txt("message_thanks_order"),
        buttons: [
          DialogButton(
            color: Colors.red,
            onPressed: () {
              Navigator.of(context).pop();
            },
            width: 120,
            child: Text(
              txt("close"),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          )
        ],
      ).show();
    }
  }

  void doLogout() {
    _viewModel!.doLogout();
  }

  @override
  void logoutSuccess() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen(
                  0,
                  alreadyLogin: false,
                )),
        (r) => false);
  }

  @override
  void showMustUpdate(String? link) {
    Alert(
      context: context,
      style: const AlertStyle(
          isOverlayTapDismiss: false,
          isCloseButton: false,
          descStyle: TextStyle(fontSize: 11)),
      type: AlertType.info,
      title: txt("app_need_update_title"),
      desc: txt("app_must_update_message"),
      buttons: [
        DialogButton(
          color: Colors.red,
          onPressed: () {
            openLink(link!);
          },
          width: 120,
          child: Text(
            txt("app_update_action"),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        )
      ],
    ).show();
  }

  @override
  void showNeedUpdate(String? link) {
    Alert(
      context: context,
      style: const AlertStyle(
          isCloseButton: false, descStyle: TextStyle(fontSize: 11)),
      type: AlertType.info,
      title: txt("app_need_update_title"),
      desc: txt("app_need_update_message"),
      buttons: [
        DialogButton(
          color: Colors.red,
          onPressed: () {
            Navigator.of(context).pop();
          },
          width: 120,
          child: Text(
            txt("close"),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        DialogButton(
          color: Colors.red,
          onPressed: () {
            Navigator.of(context).pop();
            openLink(link!);
          },
          width: 120,
          child: Text(
            txt("app_update_action"),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        )
      ],
    ).show();
  }

  Future<void> openLink(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      // ignore: only_throw_errors
      throw "Could not launch $link";
    }
  }
}

// ignore_for_file: only_throw_errors

import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/ui/pages/address/list/list_address_screen.dart';
import 'package:SuperNinja/ui/pages/changeCL/change_cl_screen.dart';
import 'package:SuperNinja/ui/pages/editProfile/edit_profile_screen.dart';
import 'package:SuperNinja/ui/pages/historyOrder/history_order_list_screen.dart';
import 'package:SuperNinja/ui/pages/orderListStatus/order_list_screen.dart';
import 'package:SuperNinja/ui/pages/profile/profile_navigator.dart';
import 'package:SuperNinja/ui/pages/profile/profile_view_model.dart';
import 'package:SuperNinja/ui/pages/selectPage/select_page_screen.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator_only.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileScreen();
  }
}

class _ProfileScreen extends BaseStateWidget<ProfileScreen>
    implements ProfileNavigator {
  ProfileViewModel? _viewModel;

  bool imageProfileError = false;

  @override
  void initState() {
    _viewModel = ProfileViewModel().setView(this) as ProfileViewModel?;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<ProfileViewModel>(
          builder: (context, viewModel, _) => Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: greysBackgroundMedium,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 250,
                    color: primary,
                  ),
                  if (!_viewModel!.isLoading)
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          if (_viewModel!.profile != null)
                            buildTopWidget()
                          else
                            Container(),
                          const SizedBox(
                            height: 32,
                          ),
                        ],
                      ),
                    )
                  else
                    LoadingIndicator()
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildTopWidget() {
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

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 250,
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  if (_viewModel!.profile != null &&
                      _viewModel!.profile!.details!.profilePicture != null)
                    Stack(
                      children: [
                        Container(
                            width: 100,
                            height: 100,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.network(
                              _viewModel!.profile!.details!.profilePicture!,
                              width: 100,
                              height: 100,
                              loadingBuilder: getLoadingImage,
                              errorBuilder: getErrorImage,
                              fit: BoxFit.cover,
                            )),
                      ],
                    )
                  else
                    Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(logoSuperNinja)))),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                name,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "+${_viewModel!.profile!.phoneNumber}",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Column(
          children: [
            const SizedBox(
              height: 180,
            ),
            buildCardStoreAgent(),
            buildCardEditProfile(),
            buildCardAddress(),
            buildCardOrder(),
            buildCardTerms(),
            buildCardFAQ(),
            buildCardCall()
          ],
        )
      ],
    );
  }

  Widget buildCardEditProfile() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 4),
      width: double.infinity,
      child: Card(
        color: Colors.white,
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: displayEditProfile,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 17, right: 17, top: 12, bottom: 12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: primary,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(txt("change_profile"),
                          style: const TextStyle(
                              color: primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                      const Expanded(child: SizedBox()),
                      const Icon(
                        Icons.chevron_right,
                        color: primary,
                      )
                    ],
                  ),
                ))),
      ),
    );
  }

  Widget buildCardAddress() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      width: double.infinity,
      child: Card(
        color: Colors.white,
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () => push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ListAddressScreen())),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 17, right: 17, top: 12, bottom: 12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.map_outlined,
                        color: primary,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(txt("shipping_address"),
                          style: const TextStyle(
                              color: primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                      const Expanded(child: SizedBox()),
                      const Icon(
                        Icons.chevron_right,
                        color: primary,
                      )
                    ],
                  ),
                ))),
      ),
    );
  }

  Widget buildCardStoreAgent() {
    if (_viewModel!.profile!.userCl != null) {
      return Container(
        margin: const EdgeInsets.only(left: 16, right: 16, top: 10),
        width: double.infinity,
        child: Card(
          color: Colors.white,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 17, right: 17, top: 12, bottom: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(_viewModel!.profile!.userCl!.name!,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                    const Expanded(child: SizedBox()),
                    Material(
                      child: InkWell(
                        onTap: openOptionStoreAgent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              txt("change_store_or_agent"),
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: primary),
                            ),
                            const Icon(Ionicons.arrow_forward_sharp,
                                color: primary, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: primary,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Flexible(
                      child: Text(
                        _viewModel!.profile!.userCl!.address ?? "-",
                        style: const TextStyle(fontSize: 12),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      color: primary,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(_viewModel!.profile!.userCl!.phoneNumber ?? "-",
                        style: const TextStyle(fontSize: 12))
                  ],
                )
              ],
            ),
          ),
        ),
      );
    } else if (_viewModel!.profile!.store != null) {
      return Container(
          margin: const EdgeInsets.only(left: 16, right: 16, top: 40),
          width: double.infinity,
          child: Card(
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.only(
                      left: 17, right: 17, top: 12, bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                          child: Text(
                            txt("store_choosed"),
                            style: const TextStyle(
                                color: primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Material(
                          child: InkWell(
                            onTap: openOptionStoreAgent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  txt("change_store_or_agent"),
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: primary),
                                ),
                                const Icon(Ionicons.arrow_forward_sharp,
                                    color: primary, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Icon(FontAwesome.map_marker,
                              color: primary, size: 22),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(_viewModel!.profile!.store!.name,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ))));
    } else {
      return Container(
          margin: const EdgeInsets.only(left: 16, right: 16, top: 40),
          width: double.infinity,
          child: Card(
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.only(
                      left: 17, right: 17, top: 12, bottom: 12),
                  child: Column(
                    children: [
                      Text(
                        txt("empty_store_and_agent"),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Material(
                        child: InkWell(
                          onTap: openOptionStoreAgent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                txt("choose_store_or_agent"),
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: primary),
                              ),
                              const Icon(Ionicons.arrow_forward_sharp,
                                  color: primary, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ))));
    }
  }

  Widget buildCardTerms() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 4),
      width: double.infinity,
      child: Card(
        color: Colors.white,
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: openTermAndConditions,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 17, right: 17, top: 12, bottom: 12),
                  child: Row(
                    children: [
                      Text(txt("term_and_conditions"),
                          style: const TextStyle(
                              color: primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                      const Expanded(child: SizedBox()),
                      const Icon(
                        Icons.chevron_right,
                        color: primary,
                      )
                    ],
                  ),
                ))),
      ),
    );
  }

  Widget buildCardFAQ() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 4),
      width: double.infinity,
      child: Card(
        color: Colors.white,
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: openFAQ,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 17, right: 17, top: 12, bottom: 12),
                  child: Row(
                    children: [
                      Text(txt("faq"),
                          style: const TextStyle(
                              color: primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                      const Expanded(child: SizedBox()),
                      const Icon(
                        Icons.chevron_right,
                        color: primary,
                      )
                    ],
                  ),
                ))),
      ),
    );
  }

  Widget buildCardCall() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      width: double.infinity,
      child: Card(
        color: Colors.white,
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: displayContactUsOption,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 17, right: 17, top: 12, bottom: 12),
                  child: Row(
                    children: [
                      Text(txt("call_us"),
                          style: const TextStyle(
                              color: primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                      const Expanded(child: SizedBox()),
                      const Icon(
                        Icons.chevron_right,
                        color: primary,
                      )
                    ],
                  ),
                ))),
      ),
    );
  }

  Future<void> displayChangeCL() async {
    final data = await push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeCLScreen(_viewModel!.profile)));
    if (data != null && data == true) {
      await _viewModel!.getProfile();
    }
  }

  Widget buildCardOrder() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 1),
      width: double.infinity,
      child: Card(
        color: Colors.white,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 17, right: 17, top: 12, bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(txt("my_order"),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                  const Expanded(child: SizedBox()),
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      child: Text(
                        txt("see_all"),
                        style: const TextStyle(color: primary, fontSize: 10),
                      ),
                      onTap: () => openOrderList(5),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  itemOrder(
                      0,
                      _viewModel!.countOrder != null
                          ? _viewModel!.countOrder!.totalWaitingPayment
                              .toString()
                          : "0"),
                  itemOrder(
                      1,
                      _viewModel!.countOrder != null
                          ? _viewModel!.countOrder!.totalInprogress.toString()
                          : "0"),
                  itemOrder(
                      2,
                      _viewModel!.countOrder != null
                          ? _viewModel!.countOrder!.totalDelivery.toString()
                          : "0"),
                  itemOrder(
                      3,
                      _viewModel!.countOrder != null
                          ? _viewModel!.countOrder!.totalArrived.toString()
                          : "0"),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Material(
                color: Colors.white,
                child: InkWell(
                  onTap: displayHistoryOrder,
                  child: Text(
                    txt("see_history"),
                    style: const TextStyle(color: primary, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemOrder(int position, String total) {
    var title = txt("waiting_payment");
    var image = icOrderPayment;
    if (position == 1) {
      title = txt("order_process");
      image = icOrderProccess;
    } else if (position == 2) {
      title = txt("order_delivery");
      image = icOrderDeliver;
    } else if (position == 3) {
      title = txt("order_arrived");
      image = icOrderReady;
    }

    return Expanded(
      child: Material(
        child: InkWell(
          onTap: () => openOrderList(position),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  SvgPicture.asset(
                    image,
                    width: 40,
                    height: 40,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        shape: BoxShape.circle,
                        color: orange),
                    child: Text(
                      total,
                      style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  title + '\n',
                  maxLines: 2,
                  style: const TextStyle(fontSize: 9, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onResume() {
    _viewModel!.loadCountData();
  }

  void openOrderList(int position) {
    push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                OrderListScreen(position, _viewModel!.countOrder)));
  }

  Future<void> displayEditProfile() async {
    final data = await push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfileScreen(_viewModel!.profile)));
    if (data != null && data == true) {
      await _viewModel!.getProfile();
    }
  }

  void displayHistoryOrder() {
    push(
        context,
        MaterialPageRoute(
            builder: (context) => const HistoryOrderListScreen()));
  }

  Widget getErrorImage(
      BuildContext context, Object error, StackTrace? stackTrace) {
    return Image.network(
        "https://cohenwoodworking.com/wp-content/uploads/2016/09/image-placeholder-500x500.jpg");
  }

  Widget getLoadingImage(
      BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) {
      return child;
    } else {
      return Container(width: 100, height: 100, child: LoadingIndicatorOnly());
    }
  }

  Future<void> openTermAndConditions() async {
    const url =
        'https://storage.googleapis.com/static-superindo/privacy-policy.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> openFAQ() async {
    const url = 'https://storage.googleapis.com/static-superindo/faq.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void displayContactUsOption() {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (bc) {
          return Wrap(children: <Widget>[
            Container(
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(bc);
                        openCallUs();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 20, right: 20, bottom: 12),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.email,
                              color: primary,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text("Email")
                          ],
                        ),
                      ),
                    ),
                  ),
                  Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(bc);
                          openWhatsapp();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 12, right: 20, bottom: 14),
                          child: Row(
                            children: const [
                              Icon(
                                FontAwesome.whatsapp,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text("Whatsapp")
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            )
          ]);
        });
  }

  Future<void> openCallUs() async {
    final params = Uri(
      scheme: 'mailto',
      path: 'superninja@superindo.co.id',
      query: 'subject=App Feedback',
    );

    final url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> openWhatsapp() async {
    const url =
        'https://api.whatsapp.com/send/?phone=6281519353705&text=Hi,+Super+Ninja+support.';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void openOptionStoreAgent() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, modalState) {
            return Container(
              color: Colors.white,
              child: Wrap(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          txt("choose_store_or_agent"),
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                      ),
                      const Divider(
                        color: greys,
                        height: 0.5,
                      ),
                      buildOptionStoreAgent(txt("store"), txt("desc_store"),
                          FontAwesome.map_marker, () {
                        Navigator.pop(context);
                        openSelectPage(TypeSelect.store);
                      }),
                      const Divider(
                        color: greys,
                        height: 0.5,
                      ),
                      buildOptionStoreAgent(
                          txt("community_leader"),
                          txt("desc_agent"),
                          Ionicons.ios_person_circle_sharp, () {
                        Navigator.pop(context);
                        displayChangeCL();
                      }),
                      const Divider(
                        color: greys,
                        height: 0.5,
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  Widget buildOptionStoreAgent(
      String title, String value, IconData icon, Function() action) {
    return Material(
      color: white,
      child: InkWell(
        onTap: action,
        child: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Icon(icon, color: primary),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                          color: primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                value,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> openSelectPage(TypeSelect typeSelect) async {
    int? id;
    final data = await push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectPageScreen(
                  typeSelect,
                  id: id,
                )));
    if (data != null) {
      ScreenUtils.showConfirmDialog(
          context,
          AlertType.info,
          txt("title_change_store_or_agent"),
          txt("message_change_store_or_agent"), () {
        _viewModel!.changeStore(data.id);
      });
    }
  }
}

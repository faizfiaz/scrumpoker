import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/other_utils.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/domain/models/response/response_list_address.dart';
import 'package:SuperNinja/ui/pages/address/form/form_address_screen.dart';
import 'package:SuperNinja/ui/pages/address/list/list_address_view_model.dart';
import 'package:SuperNinja/ui/widgets/default_button.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'list_address_navigator.dart';

// ignore: must_be_immutable
class ListAddressScreen extends StatefulWidget {
  final bool isSelect;

  const ListAddressScreen({this.isSelect = false});

  @override
  State<StatefulWidget> createState() {
    return _ListAddressScreen();
  }
}

class _ListAddressScreen extends BaseStateWidget<ListAddressScreen>
    implements ListAddressNavigator {
  ListAddressViewModel? _viewModel;

  @override
  void initState() {
    _viewModel = ListAddressViewModel().setView(this) as ListAddressViewModel?;
    super.initState();
  }

  @override
  void onResume() {
    super.onResume();
    _viewModel!.initData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ListAddressViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<ListAddressViewModel>(
          builder: (context, viewModel, _) => WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              appBar: buildAppBar(),
              body: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: Stack(
                  children: <Widget>[
                    if (!_viewModel!.isLoading)
                      buildListAddress()
                    else
                      Container(),
                    if (_viewModel!.isLoading)
                      LoadingIndicator()
                    else
                      Container()
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<bool> _onWillPop() {
    Navigator.pop(context, _viewModel!.needRefresh);
    return Future.value(true);
  }

  Widget buildListAddress() {
    if (_viewModel!.addresses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              emptyAddress,
              width: 240,
            ),
            const SizedBox(
              height: 40,
            ),
            Text(txt("empty_address")),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
              child: DefaultButton.redButton(
                  context, txt("button_add_adrress"), toFormAddress),
            )
          ],
        ),
      );
    }
    return ListView.builder(
        itemCount: _viewModel!.addresses.length,
        itemBuilder: (context, index) =>
            buildCardAddress(index, _viewModel!.addresses[index]));
  }

  Widget buildCardAddress(int index, UserAddress address) {
    return InkWell(
      onTap: widget.isSelect ? () => selectAddress(address) : null,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDefaultAddressWidget(
                        isDefaultAddress: address.isDefaultAddress),
                    Text(OtherUtils.nullReturnStripe(address.addressLabel),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500)),
                    Text(OtherUtils.nullReturnStripe(address.receiverName),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(OtherUtils.nullReturnStripe(address.address),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    buildPinPoint(address.latitude, address.longitude),
                  ],
                ),
              ),
              IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  color: Colors.black,
                  onPressed: () =>
                      toFormAddress(isAdd: false, address: address),
                  icon: const Icon(
                    FontAwesome5.edit,
                  )),
              IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  onPressed: () => deleteAddress(address.id),
                  color: primary,
                  icon: const Icon(
                    FontAwesome5.trash_alt,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDefaultAddressWidget({bool? isDefaultAddress = false}) {
    if (isDefaultAddress!) {
      return Container(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 1, bottom: 1),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: const BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.all(Radius.circular(60))),
        child: Text(txt("primary_address"),
            style: const TextStyle(
                fontSize: 10, fontWeight: FontWeight.w500, color: white)),
      );
    }
    return Container();
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      backgroundColor: primary,
      centerTitle: true,
      titleSpacing: 0,
      elevation: 0,
      title: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          txt("shipping_address"),
          textAlign: TextAlign.start,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      leading: IconButton(
        iconSize: 28,
        icon: const Icon(Feather.chevron_left, color: Colors.white),
        onPressed: _onWillPop,
      ),
      actions: [
        if (_viewModel!.addresses.length < 3)
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: toFormAddress,
                child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      txt("add_address"),
                      style: const TextStyle(
                          color: white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    )),
              ))
        else
          Container()
      ],
    );
  }

  void toFormAddress({bool isAdd = true, UserAddress? address}) {
    push(
        context,
        MaterialPageRoute(
            builder: (context) => FormAddressScreen(
                  isAdd: isAdd,
                  userAddress: address,
                )));
  }

  Widget buildPinPoint(double? latitude, double? longitude) {
    if ((latitude == null || longitude == null) ||
        (latitude == 0 && longitude == 0)) {
      return Row(
        children: [
          const Icon(Ionicons.close_circle, color: primary, size: 18),
          const SizedBox(width: 4),
          Text(txt("address_empty_pinpoint"),
              style: const TextStyle(
                  fontSize: 10, color: primary, fontWeight: FontWeight.w500)),
        ],
      );
    }
    return Row(
      children: [
        const Icon(FontAwesome.check_circle, color: primary, size: 18),
        const SizedBox(width: 4),
        Text(txt("address_filled_pinpoint"),
            style: const TextStyle(
                fontSize: 10,
                color: Colors.black,
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  void deleteAddress(int? id) {
    ScreenUtils.showConfirmDialog(
        context,
        AlertType.warning,
        txt("delete_address"),
        txt("delete_address_message"),
        () => _viewModel!.deleteAddress(id));
  }

  @override
  void showSuccess() {
    ScreenUtils.showToastMessage(txt("success_delete_address"));
  }

  void selectAddress(UserAddress address) {
    Navigator.pop(context, address);
  }
}

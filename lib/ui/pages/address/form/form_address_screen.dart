import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/domain/models/entity/city.dart';
import 'package:SuperNinja/domain/models/entity/province.dart';
import 'package:SuperNinja/domain/models/response/response_list_address.dart';
import 'package:SuperNinja/ui/pages/address/form/form_address_view_model.dart';
import 'package:SuperNinja/ui/pages/address/map/pinpoint_map_screen.dart';
import 'package:SuperNinja/ui/pages/selectPage/select_page_screen.dart';
import 'package:SuperNinja/ui/widgets/always_disabled_focus_node.dart';
import 'package:SuperNinja/ui/widgets/default_button.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import 'form_address_navigator.dart';

// ignore: must_be_immutable
class FormAddressScreen extends StatefulWidget {
  final bool isAdd;
  final UserAddress? userAddress;

  const FormAddressScreen({required this.isAdd, this.userAddress});

  @override
  State<StatefulWidget> createState() {
    return _FormAddressScreen();
  }
}

class _FormAddressScreen extends BaseStateWidget<FormAddressScreen>
    implements FormAddressNavigator {
  FormAddressViewModel? _viewModel;

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  TextEditingController controllerLabelAddress = TextEditingController();
  TextEditingController controllerReceiverName = TextEditingController();
  TextEditingController controllerProvince = TextEditingController();
  TextEditingController controllerCity = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerPostalCode = TextEditingController();

  String? errorText = txt("field_required");
  String buttonPinpointText = txt("button_pinpoint");

  bool isAutoValidate = false;
  bool isDefaultAddress = false;

  @override
  void initState() {
    _viewModel = FormAddressViewModel(address: widget.userAddress).setView(this)
        as FormAddressViewModel?;
    if (!widget.isAdd && widget.userAddress != null) {
      final address = widget.userAddress;
      controllerLabelAddress.text = address!.addressLabel ?? "";
      controllerReceiverName.text = address.receiverName ?? "";
      controllerProvince.text = address.provinceName ?? "";
      controllerCity.text = address.cityName ?? "";
      controllerAddress.text = address.address ?? "";
      controllerPostalCode.text = address.postalCode ?? "";
      if (address.latitude != null && address.longitude != null) {
        buttonPinpointText = txt("button_pinpoint_fill");
      }
      if (address.isDefaultAddress!) {
        isDefaultAddress = true;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FormAddressViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<FormAddressViewModel>(
          builder: (context, viewModel, _) => Scaffold(
            appBar: buildAppBar(),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: buildForm(),
                  ),
                  if (_viewModel!.isLoading) LoadingIndicator() else Container()
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildForm() {
    return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FormBuilder(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        txt("address_label"),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      FormBuilderTextField(
                        name: "address_label",
                        style: getStyle(),
                        controller: controllerLabelAddress,
                        autovalidateMode: isAutoValidate
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        decoration:
                            getDecorationWithoutIcon(txt("ex_address_label")),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText: errorText)
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        txt("receiver_name"),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      FormBuilderTextField(
                        name: "receiver_name",
                        style: getStyle(),
                        controller: controllerReceiverName,
                        autovalidateMode: isAutoValidate
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        decoration:
                            getDecorationWithoutIcon(txt("ex_receiver_name")),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText: errorText)
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        txt("province"),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      FormBuilderTextField(
                        name: "province",
                        style: getStyle(),
                        controller: controllerProvince,
                        autovalidateMode: isAutoValidate
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        focusNode: AlwaysDisabledFocusNode(),
                        onTap: () => openSelectPage(TypeSelect.province),
                        decoration:
                            getDecorationWithoutIcon2(txt("select_location")),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText: errorText)
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        txt("city"),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      FormBuilderTextField(
                        name: "city",
                        style: getStyle(),
                        controller: controllerCity,
                        focusNode: AlwaysDisabledFocusNode(),
                        autovalidateMode: isAutoValidate
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        onTap: () => openSelectPage(TypeSelect.city),
                        decoration:
                            getDecorationWithoutIcon2(txt("select_location")),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText: errorText)
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        txt("shipping_address"),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      FormBuilderTextField(
                        name: "address",
                        maxLines: 6,
                        maxLength: 200,
                        style: getStyle(),
                        autovalidateMode: isAutoValidate
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        controller: controllerAddress,
                        decoration: getDecorationWithoutIcon3(
                            txt("ex_shipping_address")),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText: errorText)
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        txt("postal_code"),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      FormBuilderTextField(
                        name: "postal_code",
                        style: getStyle(),
                        controller: controllerPostalCode,
                        autovalidateMode: isAutoValidate
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        decoration:
                            getDecorationWithoutIcon(txt("ex_postal_code")),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText: errorText)
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FormBuilderSwitch(
                          name: "is_default_address",
                          decoration:
                              getDecorationWithoutIcon(txt("ex_postal_code")),
                          title: Text(txt("set_primary_address"),
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600)),
                          initialValue: isDefaultAddress,
                          activeColor: primary),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: DefaultButton.redButtonSmall(
                            context, buttonPinpointText, openPinpointMapScreen),
                      )
                    ]))
          ],
        ));
  }

  Future<void> openSelectPage(TypeSelect typeSelect) async {
    int? id;
    if (typeSelect == TypeSelect.city) {
      if (_viewModel!.provinceSelected == null) {
        ScreenUtils.showToastMessage(txt("select_the_province_first"));
        return;
      } else {
        id = _viewModel!.provinceSelected!.id;
      }
    }

    final data = await push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectPageScreen(
                  typeSelect,
                  id: id,
                )));
    if (data != null) {
      if (data is Province) {
        _viewModel!.provinceSelected = data;
        controllerProvince.text = data.name!;
      } else if (data is City) {
        _viewModel!.citySelected = data;
        controllerCity.text = data.name!;
      }
    }
  }

  void validateForm() {
    setState(() {
      isAutoValidate = true;
    });
    if (_formKey.currentState!.saveAndValidate()) {
      _viewModel!.doAddAddress(_formKey.currentState!.value);
    }
  }

  TextStyle getStyle() {
    return const TextStyle(fontSize: 12);
  }

  InputDecoration getDecorationWithoutIcon(String? hint) {
    return InputDecoration(
      hintText: hint,
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: strokeGrey, width: 0.5)),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: strokeGrey, width: 0.5)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: strokeGrey, width: 0.5)),
      contentPadding: const EdgeInsets.only(left: 14),
    );
  }

  InputDecoration getDecorationWithoutIcon3(String? hint) {
    return InputDecoration(
      hintText: hint,
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: strokeGrey, width: 0.5)),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: strokeGrey, width: 0.5)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: strokeGrey, width: 0.5)),
      contentPadding: const EdgeInsets.all(14),
    );
  }

  InputDecoration getDecorationWithoutIcon2(String? hint) {
    return InputDecoration(
      hintText: hint,
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: strokeGrey, width: 0.5)),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: strokeGrey, width: 0.5)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: strokeGrey, width: 0.5)),
      contentPadding: const EdgeInsets.only(left: 14, top: 24),
    );
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
          widget.isAdd ? txt("add_address") : txt("change_address"),
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
      actions: [
        Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: validateForm,
              child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    txt("save"),
                    style: const TextStyle(
                        color: white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  )),
            )),
      ],
    );
  }

  Future<void> openPinpointMapScreen() async {
    final data = await push(context,
        MaterialPageRoute(builder: (context) => const PinpointMapScreen()));
    if (data != null) {
      final listLatLong = data as List<double>;
      _viewModel!.latitudeSelected = listLatLong[0];
      _viewModel!.longitudeSelected = listLatLong[1];
      if (listLatLong.isNotEmpty) {
        setState(() {
          buttonPinpointText = txt("button_pinpoint_fill");
        });
      }
    }
  }

  @override
  void showSuccess() {
    ScreenUtils.showToastMessage(txt("success_add_address"));
    Navigator.pop(context);
  }

  @override
  void showErrorMessage(String message) {
    ScreenUtils.showToastMessage(message);
  }
}

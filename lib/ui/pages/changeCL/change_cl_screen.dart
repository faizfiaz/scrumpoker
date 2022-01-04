import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/domain/models/entity/city.dart';
import 'package:SuperNinja/domain/models/entity/community_leader.dart';
import 'package:SuperNinja/domain/models/entity/province.dart';
import 'package:SuperNinja/domain/models/error/error_message.dart';
import 'package:SuperNinja/domain/models/response/response_profile.dart';
import 'package:SuperNinja/ui/pages/changeCL/change_cl_view_model.dart';
import 'package:SuperNinja/ui/pages/selectPage/select_page_screen.dart';
import 'package:SuperNinja/ui/widgets/always_disabled_focus_node.dart';
import 'package:SuperNinja/ui/widgets/app_bar_custom.dart';
import 'package:SuperNinja/ui/widgets/default_button.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'change_cl_navigator.dart';

// ignore: must_be_immutable
class ChangeCLScreen extends StatefulWidget {
  Profile? profile;

  ChangeCLScreen(this.profile);

  @override
  State<StatefulWidget> createState() {
    return _ChangeCLScreen();
  }
}

class _ChangeCLScreen extends BaseStateWidget<ChangeCLScreen>
    implements ChangeCLNavigator {
  ChangeCLViewModel? _viewModel;

  TextEditingController controllerProvince = TextEditingController();
  TextEditingController controllerCity = TextEditingController();
  TextEditingController controllerCommunityLeader = TextEditingController();

  final GlobalKey<FormBuilderState> _regKey = GlobalKey<FormBuilderState>();
  ScrollController scrollController = ScrollController();

  String? errorText = txt("field_required");

  @override
  void initState() {
    _viewModel = ChangeCLViewModel().setView(this) as ChangeCLViewModel?;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChangeCLViewModel?>(
      create: (context) => _viewModel,
      child: Consumer<ChangeCLViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          backgroundColor: white,
          appBar: AppBarCustom.buildAppBar(context, txt("pick_up_point"))
              as PreferredSizeWidget?,
          body: Container(
            color: Colors.white,
            height: double.infinity,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormBuilder(
                            key: _regKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  txt("current_cl"),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                buildCardCL(),
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  txt("choose_pickup_point"),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  txt("province"),
                                  style: const TextStyle(
                                      fontSize: 12, color: primary),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                FormBuilderTextField(
                                  name: "province",
                                  style: getStyle(),
                                  controller: controllerProvince,
                                  focusNode: AlwaysDisabledFocusNode(),
                                  onTap: () =>
                                      openSelectPage(TypeSelect.province),
                                  decoration: getDecorationWithoutIcon2(
                                      txt("select_location")),
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
                                      fontSize: 12, color: primary),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                FormBuilderTextField(
                                  name: "city",
                                  style: getStyle(),
                                  controller: controllerCity,
                                  focusNode: AlwaysDisabledFocusNode(),
                                  onTap: () => openSelectPage(TypeSelect.city),
                                  decoration: getDecorationWithoutIcon2(
                                      txt("select_location")),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(context,
                                        errorText: errorText)
                                  ]),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  txt("select_community_leader"),
                                  style: const TextStyle(
                                      fontSize: 12, color: primary),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                FormBuilderTextField(
                                  name: "user_cl_id",
                                  style: getStyle(),
                                  controller: controllerCommunityLeader,
                                  focusNode: AlwaysDisabledFocusNode(),
                                  onTap: () => openSelectPage(TypeSelect.cl),
                                  decoration: getDecorationWithoutIcon2(
                                      txt("select_community_leader")),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(context,
                                        errorText: errorText)
                                  ]),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                DefaultButton.redButton(
                                    context, txt("change_now"), validateForm),
                                const SizedBox(
                                  height: 80,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                if (viewModel.isLoading) LoadingIndicator() else Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCardCL() {
    if (widget.profile!.userCl == null) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Text(txt("empty_agent"), style: const TextStyle(fontSize: 12)),
        ),
      );
    }
    return Container(
      width: double.infinity,
      child: Card(
        color: Colors.white,
        elevation: 10,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 17, right: 17, top: 12, bottom: 12),
          child: Column(
            children: [
              Row(
                children: [
                  Text(widget.profile!.userCl!.name!,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                  const Expanded(child: SizedBox()),
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
                      widget.profile!.userCl!.address ?? "-",
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
                  Text(widget.profile!.userCl!.phoneNumber ?? "-",
                      style: const TextStyle(fontSize: 12))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void showError(List<Errors>? error, int? httpCode) {
    ScreenUtils.showAlertMessage(context, error, httpCode);
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

    if (typeSelect == TypeSelect.cl) {
      if (_viewModel!.citySelected == null) {
        ScreenUtils.showToastMessage(txt("select_the_city_first"));
        return;
      } else {
        id = _viewModel!.citySelected!.id;
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
      } else if (data is CommunityLeader) {
        _viewModel!.communityLeaderSelected = data;
        controllerCommunityLeader.text = data.name!;
      }
    }
  }

  void validateForm() {
    if (_regKey.currentState!.saveAndValidate()) {
      ScreenUtils.showConfirmDialog(
          context,
          AlertType.info,
          txt("title_change_store_or_agent"),
          txt("message_change_store_or_agent"), () {
        _viewModel!.doChangeCL(_regKey.currentState!.value);
      });
    }
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

  TextStyle getStyle() {
    return const TextStyle(fontSize: 12);
  }

  @override
  void successChangeCL() {
    Navigator.pop(context, true);
  }
}

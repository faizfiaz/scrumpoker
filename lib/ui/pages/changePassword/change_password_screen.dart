import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/domain/models/error/error_message.dart';
import 'package:SuperNinja/ui/pages/changePassword/change_password_view_model.dart';
import 'package:SuperNinja/ui/pages/changePassword/change_register_navigator.dart';
import 'package:SuperNinja/ui/widgets/app_bar_custom.dart';
import 'package:SuperNinja/ui/widgets/default_button.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen();

  @override
  State<StatefulWidget> createState() {
    return _ChangePasswordScreen();
  }
}

class _ChangePasswordScreen extends BaseStateWidget<ChangePasswordScreen>
    implements ChangePasswordNavigator {
  ChangePasswordViewModel? _viewModel;
  bool oldPasswordVisible = false;
  bool passwordVisible = false;
  bool rePasswordVisible = false;

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  double cardRadius = 1;

  @override
  void initState() {
    super.initState();
    _viewModel =
        ChangePasswordViewModel().setView(this) as ChangePasswordViewModel?;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<ChangePasswordViewModel?>(
      create: (context) => _viewModel,
      child: Consumer<ChangePasswordViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          backgroundColor: white,
          appBar: AppBarCustom.buildAppBarNoTitleTrans(context)
              as PreferredSizeWidget?,
          body: Container(
            color: white,
            height: double.infinity,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormBuilder(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: Text(
                                    txt("change_password"),
                                    style: const TextStyle(
                                        color: primary,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  txt("old_password"),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 21,
                                ),
                                FormBuilderTextField(
                                  obscureText: !oldPasswordVisible,
                                  name: "old_password",
                                  style: getStyle(),
                                  decoration: getDecorationOld(
                                      const Icon(
                                        Ionicons.lock_closed_sharp,
                                        size: 18,
                                        color: primary,
                                      ),
                                      txt("old_password")),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                      context,
                                    ),
                                    FormBuilderValidators.minLength(context, 4),
                                  ]),
                                ),
                                const SizedBox(
                                  height: 31,
                                ),
                                Text(
                                  txt("new_password"),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 21,
                                ),
                                FormBuilderTextField(
                                  obscureText: !passwordVisible,
                                  name: "new_password",
                                  style: getStyle(),
                                  controller: _viewModel!.controllerPassword,
                                  decoration: getDecoration(
                                      const Icon(
                                        Ionicons.lock_closed_sharp,
                                        size: 18,
                                        color: primary,
                                      ),
                                      txt("new_password")),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                      context,
                                    ),
                                    FormBuilderValidators.minLength(context, 6),
                                  ]),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                FormBuilderTextField(
                                  obscureText: !rePasswordVisible,
                                  name: "confirm_password",
                                  style: getStyle(),
                                  controller: _viewModel!.controllerNewPassword,
                                  decoration: getDecorationPassword(
                                      const Icon(
                                        Ionicons.lock_closed_sharp,
                                        size: 18,
                                        color: primary,
                                      ),
                                      txt("confirm_new_password")),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                      context,
                                    ),
                                    FormBuilderValidators.minLength(context, 4),
                                  ]),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                DefaultButton.redButton(context,
                                    txt("change_password"), validateForm),
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

  void displayLoginScreen() {
    Navigator.pop(context);
  }

  @override
  void showError(List<Errors>? error, int? httpCode) {
    ScreenUtils.showAlertMessage(context, error, httpCode);
  }

  InputDecoration getDecorationPassword(Widget icon, String? hint) {
    return InputDecoration(
        hintText: hint,
        errorText: _viewModel!.controllerNewPassword.text !=
                _viewModel!.controllerPassword.text
            ? txt("password_not_match")
            : null,
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: strokeGrey, width: 0.5)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: strokeGrey, width: 0.5)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: strokeGrey, width: 0.5)),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        prefixIcon: Container(
          margin: const EdgeInsets.only(right: 16, left: 16, top: 4, bottom: 4),
          padding: const EdgeInsets.only(right: 10),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(
                color: strokeGrey,
                width: 0.5,
              ),
            ),
          ),
          child: icon,
        ),
        suffixIcon: IconButton(
          icon:
              Icon(rePasswordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              rePasswordVisible = !rePasswordVisible;
            });
          },
        ));
  }

  InputDecoration getDecorationOld(Widget icon, String? hint) {
    return InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: strokeGrey, width: 0.5)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: strokeGrey, width: 0.5)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: strokeGrey, width: 0.5)),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        prefixIcon: Container(
          margin: const EdgeInsets.only(right: 16, left: 16, top: 4, bottom: 4),
          padding: const EdgeInsets.only(right: 10),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(
                color: strokeGrey,
                width: 0.5,
              ),
            ),
          ),
          child: icon,
        ),
        suffixIcon: IconButton(
          icon: Icon(
              oldPasswordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              oldPasswordVisible = !oldPasswordVisible;
            });
          },
        ));
  }

  InputDecoration getDecoration(Widget icon, String? hint) {
    return InputDecoration(
        hintText: hint,
        errorMaxLines: 7,
        errorText: _viewModel!.isNotStrongPassword
            ? txt("error_password_strong")
            : null,
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: strokeGrey, width: 0.5)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: strokeGrey, width: 0.5)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: strokeGrey, width: 0.5)),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        prefixIcon: Container(
          margin: const EdgeInsets.only(right: 16, left: 16, top: 4, bottom: 4),
          padding: const EdgeInsets.only(right: 10),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(
                color: strokeGrey,
                width: 0.5,
              ),
            ),
          ),
          child: icon,
        ),
        suffixIcon: IconButton(
          icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              passwordVisible = !passwordVisible;
            });
          },
        ));
  }

  TextStyle getStyle() {
    return const TextStyle(fontSize: 12);
  }

  @override
  void successChangePassword() {
    ScreenUtils.showToastMessage("Success change password");
    Navigator.pop(context);
  }

  void validateForm() {
    if (_formKey.currentState!.saveAndValidate()) {
      if (_viewModel!.controllerPassword.text !=
          _viewModel!.controllerNewPassword.text) {
        setState(() {
          _formKey.currentState!.validate();
        });
      } else {
        _viewModel!.doChangePassword(_formKey.currentState!.value);
      }
    }
  }
}

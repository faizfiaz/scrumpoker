import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/domain/models/error/error_message.dart';
import 'package:SuperNinja/ui/pages/login/login_screen.dart';
import 'package:SuperNinja/ui/pages/recovery/recovery_navigator.dart';
import 'package:SuperNinja/ui/pages/recovery/recovery_view_model.dart';
import 'package:SuperNinja/ui/widgets/app_bar_custom.dart';
import 'package:SuperNinja/ui/widgets/default_button.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RecoveryScreen extends StatefulWidget {
  String identity;
  int? codeId;

  RecoveryScreen(this.identity, this.codeId);

  @override
  State<StatefulWidget> createState() {
    return _RecoveryScreen();
  }
}

class _RecoveryScreen extends BaseStateWidget<RecoveryScreen>
    implements RecoveryNavigator {
  RecoveryViewModel? _viewModel;

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _viewModel = RecoveryViewModel(widget.identity, widget.codeId).setView(this)
        as RecoveryViewModel?;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return ChangeNotifierProvider<RecoveryViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<RecoveryViewModel>(
            builder: (context, viewModel, _) => Scaffold(
                  appBar: AppBarCustom.buildAppBarNoTitleTrans(context)
                      as PreferredSizeWidget?,
                  backgroundColor: white,
                  body: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.white,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              buildTitle(),
                              const SizedBox(
                                height: 8,
                              ),
                              buildContentLogin()
                            ],
                          ),
                        ),
                      ),
                      if (viewModel.isLoading)
                        LoadingIndicator()
                      else
                        Container()
                    ],
                  ),
                )));
  }

  Widget buildTitle() {
    return Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: Text(
          txt("title_recovery"),
          style: const TextStyle(
              color: primary, fontSize: 25, fontWeight: FontWeight.bold),
        ));
  }

  @override
  void showError(List<Errors>? error, int? httpCode) {
    ScreenUtils.showAlertMessage(context, error, httpCode);
  }

  Widget buildContentLogin() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                txt("new_password"),
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _viewModel!.controllerPassword,
                obscureText: !passwordVisible,
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    prefixIcon: Container(
                      margin: const EdgeInsets.only(
                          right: 16, left: 16, top: 4, bottom: 4),
                      padding: const EdgeInsets.only(right: 10),
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            //                   <--- left side
                            color: strokeGrey,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: const Icon(
                        Ionicons.lock_closed_sharp,
                        color: primary,
                        size: 18,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: strokeGrey, width: 0.5)),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: strokeGrey, width: 0.5)),
                    hintText: txt("hint_new_password"),
                    errorText: _viewModel!.isNotStrongPassword
                        ? txt("error_password_strong")
                        : null,
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    )),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: _viewModel!.controllerConfirmPassword,
                obscureText: !confirmPasswordVisible,
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    prefixIcon: Container(
                      margin: const EdgeInsets.only(
                          right: 16, left: 16, top: 4, bottom: 4),
                      padding: const EdgeInsets.only(right: 10),
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: strokeGrey,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: const Icon(
                        Ionicons.lock_closed_sharp,
                        color: primary,
                        size: 18,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: strokeGrey, width: 0.5)),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: strokeGrey, width: 0.5)),
                    hintText: txt("hint_confirm_password"),
                    errorText: _viewModel!.errorConfirmPassword
                        ? txt("password_not_match")
                        : null,
                    suffixIcon: IconButton(
                      icon: Icon(confirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          confirmPasswordVisible = !confirmPasswordVisible;
                        });
                      },
                    )),
              ),
              const SizedBox(
                height: 60,
              ),
              DefaultButton.redButton(context, txt("button_recovery"),
                  () => _viewModel!.doNewPassword()),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void showLoginPage() {
    ScreenUtils.showToastMessage(txt("success_new_password"));
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => LoginScreen()), (r) => false);
  }
}

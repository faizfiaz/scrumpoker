import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/data/remote/endpoints/endpoints.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/ui/pages/forgotPassword/forgot_password_navigator.dart';
import 'package:SuperNinja/ui/pages/forgotPassword/forgot_password_view_model.dart';
import 'package:SuperNinja/ui/pages/recovery/recovery_screen.dart';
import 'package:SuperNinja/ui/pages/register/register_screen.dart';
import 'package:SuperNinja/ui/widgets/app_bar_custom.dart';
import 'package:SuperNinja/ui/widgets/default_button.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ForgotPasswordScreen();
  }
}

class _ForgotPasswordScreen extends BaseStateWidget<ForgotPasswordScreen>
    implements ForgotPasswordNavigator {
  ForgotPasswordViewModel? _viewModel;

  bool successRequestRecoveryCode = false;

  @override
  void initState() {
    super.initState();
    _viewModel =
        ForgotPasswordViewModel().setView(this) as ForgotPasswordViewModel?;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ForgotPasswordViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<ForgotPasswordViewModel>(
            builder: (context, viewModel, _) => Scaffold(
                  appBar: AppBarCustom.buildAppBarNoTitleTrans(context)
                      as PreferredSizeWidget?,
                  body: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(16),
                        height: double.infinity,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildTitle(),
                              const SizedBox(
                                height: 8,
                              ),
                              buildContentForm()
                            ],
                          ),
                        ),
                      ),
                      if (_viewModel!.isLoading)
                        LoadingIndicator()
                      else
                        Container()
                    ],
                  ),
                )));
  }

  Widget buildTitle() {
    return Container(
        width: double.infinity,
        child: Image.asset(
          logoSuperNinja,
          width: 160,
          height: 160,
        ));
  }

  Widget buildContentForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                txt("title_forgot"),
                style:
                    const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: strokeGrey, width: 0.5)),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: strokeGrey, width: 0.5)),
                    hintText: txt("hint_forgot"),
                    errorText:
                        _viewModel!.errorIdentity ? txt("error_forgot") : null),
                controller: _viewModel!.controllerIdentity,
              ),
              if (successRequestRecoveryCode)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextField(
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 14),
                        enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: strokeGrey, width: 0.5)),
                        border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: strokeGrey, width: 0.5)),
                        hintText: txt("input_recovery_code"),
                        errorText: _viewModel!.errorCode
                            ? txt("error_forgot_code")
                            : null),
                    controller: _viewModel!.controllerCode,
                  ),
                )
              else
                Container(),
              const SizedBox(
                height: 16,
              ),
              DefaultButton.redButton(
                  context,
                  !successRequestRecoveryCode
                      ? txt("send_recovery_code")
                      : txt("submit_code"),
                  () => !successRequestRecoveryCode
                      ? _viewModel!.doForgotPassword()
                      : _viewModel!.doSubmitCode()),
            ],
          ),
          const SizedBox(
            height: 160,
          ),
          Material(
            color: white,
            child: InkWell(
              onTap: displayRegister,
              child: RichText(
                text: TextSpan(
                    text: txt("signup_message"),
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                    children: <TextSpan>[
                      TextSpan(
                          text: "  ${txt("signup_here")}",
                          style: const TextStyle(
                              color: primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w800))
                    ]),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  void displayRegister() {
    push(
        context,
        MaterialPageRoute(
            builder: (context) => RegisterScreen(
                  registerVia: Endpoints.manualKey,
                )));
  }

  @override
  void showInputCode(bool isEmail) {
    setState(() {
      successRequestRecoveryCode = true;
    });
    ScreenUtils.showDialog(
        context,
        AlertType.success,
        txt("forgot_success_code_title"),
        isEmail
            ? txt("forgot_success_code_email")
            : txt("forgot_success_code_sms"));
  }

  @override
  void showRecoveryPage(String identity, int? codeId) {
    push(
        context,
        MaterialPageRoute(
            builder: (context) => RecoveryScreen(identity, codeId)));
  }
}

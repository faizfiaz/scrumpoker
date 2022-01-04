import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/constant/strings.dart';
import 'package:SuperNinja/data/remote/endpoints/endpoints.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/nav_key.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/domain/models/error/error_message.dart';
import 'package:SuperNinja/ui/pages/forgotPassword/forgot_password_screen.dart';
import 'package:SuperNinja/ui/pages/home/home_screen.dart';
import 'package:SuperNinja/ui/pages/login/login_navigator.dart';
import 'package:SuperNinja/ui/pages/login/login_view_model.dart';
import 'package:SuperNinja/ui/pages/register/register_screen.dart';
import 'package:SuperNinja/ui/widgets/app_bar_custom.dart';
import 'package:SuperNinja/ui/widgets/default_button.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  bool backToPreviousPage;

  LoginScreen({this.backToPreviousPage = false});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends BaseStateWidget<LoginScreen>
    implements LoginNavigator {
  LoginViewModel? _viewModel;

  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _viewModel = LoginViewModel().setView(this) as LoginViewModel?;
  }

  @override
  void dispose() {
    super.dispose();
    NavKey.isInLogin = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return ChangeNotifierProvider<LoginViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<LoginViewModel>(
            builder: (context, viewModel, _) => Scaffold(
                  appBar: AppBarCustom.trans() as PreferredSizeWidget?,
                  backgroundColor: white,
                  body: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
        width: double.infinity,
        child: Image.asset(
          logoSuperNinja,
          width: 160,
          height: 160,
        ));
  }

  @override
  void showError(List<Errors>? error, int? httpCode) {
    ScreenUtils.showAlertMessage(context, error, httpCode);
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
  void showMainPage() {
    if (widget.backToPreviousPage) {
      Navigator.pop(context, true);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    0,
                  )),
          (r) => false);
    }
  }

  Widget buildContentLogin() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
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
                        Icons.email_rounded,
                        color: primary,
                        size: 18,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: strokeGrey, width: 0.5)),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: strokeGrey, width: 0.5)),
                    hintText: Strings.login_hint_email,
                    errorText:
                        _viewModel!.errorEmail ? txt("email_not_valid") : null),
                controller: _viewModel!.controllerEmail,
              ),
              const SizedBox(
                height: 16,
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
                    hintText: Strings.login_label_password,
                    errorText: _viewModel!.errorPassword
                        ? txt("password_minimum_6")
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
              DefaultButton.redButton(
                  context, txt("login"), () => _viewModel!.doLogin()),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    onTap: displayForgotPassword,
                    child: Container(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Text(
                          txt("forgot_password"),
                          style: const TextStyle(color: primary, fontSize: 12),
                        )),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            txt("login_with"),
            style: const TextStyle(
                color: primary, fontWeight: FontWeight.w400, fontSize: 12),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _viewModel!.handleSignInGoogle(),
                  child: SvgPicture.asset(
                    icGoogle,
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _viewModel!.handleSignInFacebook(),
                  child: SvgPicture.asset(
                    icFacebook,
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 48,
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
          Material(
            color: white,
            child: InkWell(
              onTap: () => _viewModel!.changeLanguage(context),
              child: Text(
                txt("current_language"),
                style: const TextStyle(
                    color: primary, fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void showRegisterThirdParty(String? email, String? displayName,
      String? photoUrl, String registerVia) {
    push(
        context,
        MaterialPageRoute(
            builder: (context) => RegisterScreen(
                email: email,
                displayName: displayName,
                photoUrl: photoUrl,
                registerVia: registerVia)));
  }

  void displayForgotPassword() {
    push(context,
        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
  }
}

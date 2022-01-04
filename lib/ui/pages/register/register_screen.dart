import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/constant/strings.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/gps_utils.dart';
import 'package:SuperNinja/domain/commons/other_utils.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/domain/commons/tracking_utils.dart';
import 'package:SuperNinja/domain/models/entity/city.dart';
import 'package:SuperNinja/domain/models/entity/community_leader.dart';
import 'package:SuperNinja/domain/models/entity/province.dart';
import 'package:SuperNinja/domain/models/error/error_message.dart';
import 'package:SuperNinja/ui/pages/home/home_screen.dart';
import 'package:SuperNinja/ui/pages/register/register_navigator.dart';
import 'package:SuperNinja/ui/pages/register/register_view_model.dart';
import 'package:SuperNinja/ui/pages/selectPage/select_page_screen.dart';
import 'package:SuperNinja/ui/widgets/always_disabled_focus_node.dart';
import 'package:SuperNinja/ui/widgets/app_bar_custom.dart';
import 'package:SuperNinja/ui/widgets/default_button.dart';
import 'package:SuperNinja/ui/widgets/formBuilderPhoneField/form_builder_phone_field.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatefulWidget {
  String? email;
  String? displayName;
  String? photoUrl;
  String? registerVia;

  RegisterScreen(
      {this.email, this.displayName, this.photoUrl, this.registerVia});

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreen();
  }
}

class _RegisterScreen extends BaseStateWidget<RegisterScreen>
    implements RegisterNavigator {
  RegisterViewModel? _viewModel;
  bool passwordVisible = false;
  bool rePasswordVisible = false;

  bool isMethodSelected = false;
  bool isMethodEmail = false;

  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPhoneNumber = TextEditingController();
  TextEditingController controllerProvince = TextEditingController();
  TextEditingController controllerCity = TextEditingController();
  TextEditingController controllerCommunityLeader = TextEditingController();
  TextEditingController controllerCode = TextEditingController();
  TextEditingController controllerBirthDate = TextEditingController();
  TextEditingController controllerFullName = TextEditingController();
  TextEditingController controllerDisplayName = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerRepassword = TextEditingController();

  final GlobalKey<FormBuilderState> _regKey = GlobalKey<FormBuilderState>();
  ScrollController scrollController = ScrollController();

  bool isThirdParty = false;
  List imageProfile = [];

  String? errorText = txt("field_required");
  String? errorNumeric = txt("field_numeric");
  String? errorKtpLength = txt("field_ktp_error_length");
  bool isAutoValidate = false;

  bool isNotStrongPassword = false;

  FocusNode fullNameNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode rePasswordNode = FocusNode();
  FocusNode provinceNode = FocusNode();
  FocusNode cityNode = FocusNode();
  FocusNode shoppingAgentNode = FocusNode();
  FocusNode nameNode = FocusNode();
  FocusNode birthDateNode = FocusNode();
  FocusNode birthPlaceNode = FocusNode();
  FocusNode addressNode = FocusNode();
  FocusNode verificationNode = FocusNode();

  @override
  void initState() {
    _viewModel = RegisterViewModel(widget.registerVia).setView(this)
        as RegisterViewModel?;
    SmartechPlugin().trackEvent(
        TrackingUtils.SIGNUP_LANDED, TrackingUtils.getEmptyPayload());

    if (widget.displayName != null && widget.displayName!.isNotEmpty) {
      controllerFullName.text = widget.displayName!;
      final splitName = widget.displayName!.split(" ");
      if (splitName.length > 2) {
        controllerDisplayName.text = splitName[0] + splitName[1];
      } else if (splitName.length > 1) {
        controllerDisplayName.text = splitName[0];
      } else {
        controllerDisplayName.text = widget.displayName!;
      }
    }
    if (widget.email != null && widget.email!.isNotEmpty) {
      controllerEmail.text = widget.email!;
    }
    if (widget.photoUrl != null && widget.photoUrl!.isNotEmpty) {
      imageProfile.add(widget.photoUrl);
    }

    controllerPassword.addListener(() {
      checkPassword(controllerPassword.text);
    });

    controllerRepassword.addListener(() {
      setState(() {});
    });
    super.initState();

    GPSUtils.determinePosition().then((value) {
      if (value.isNotEmpty) {
        if (value.keys.first != null) {
          _viewModel!.latitude = value.keys.first!.latitude;
          _viewModel!.longitude = value.keys.first!.longitude;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<RegisterViewModel?>(
      create: (context) => _viewModel,
      child: Consumer<RegisterViewModel>(
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
                    controller: scrollController,
                    child: Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormBuilder(
                            key: _regKey,
                            initialValue: const {
                              'accept_terms': true,
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: Text(
                                    txt("signup_title"),
                                    style: const TextStyle(
                                        color: primary,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      txt("account"),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const Expanded(child: SizedBox()),
                                    Text(
                                      txt("required_field"),
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontStyle: FontStyle.italic,
                                          color: primary),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  "*${txt("full_name")}",
                                  style: const TextStyle(
                                      fontSize: 12, color: primary),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                FormBuilderTextField(
                                  name: "name",
                                  style: getStyle(),
                                  autovalidateMode: isAutoValidate
                                      ? AutovalidateMode.always
                                      : AutovalidateMode.disabled,
                                  controller: controllerFullName,
                                  decoration: getDecoration(
                                      const Icon(
                                        Icons.person,
                                        color: primary,
                                        size: 18,
                                      ),
                                      txt("full_name")),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(context,
                                        errorText: errorText)
                                  ]),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "*Email",
                                  style:
                                      TextStyle(fontSize: 12, color: primary),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                FormBuilderTextField(
                                  name: "email",
                                  style: getStyle(),
                                  autovalidateMode: isAutoValidate
                                      ? AutovalidateMode.always
                                      : AutovalidateMode.disabled,
                                  controller: controllerEmail,
                                  decoration: getDecoration(
                                      const Icon(
                                        Icons.mail,
                                        size: 18,
                                        color: primary,
                                      ),
                                      Strings.login_hint_email),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(context,
                                        errorText: errorText)
                                  ]),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "*${txt("phone_number")}",
                                  style: const TextStyle(
                                      fontSize: 12, color: primary),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                FormBuilderPhoneField(
                                  name: 'phone_number',
                                  style: getStyle(),
                                  autovalidateMode: isAutoValidate
                                      ? AutovalidateMode.always
                                      : AutovalidateMode.disabled,
                                  controller: controllerPhoneNumber,
                                  defaultSelectedCountryIsoCode: 'ID',
                                  cursorColor: Colors.black,
                                  decoration: getDecorationWithoutIcon(
                                      txt("phone_number")),
                                  priorityListByIsoCode: const ['ID'],
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(context,
                                        errorText: errorText),
                                    FormBuilderValidators.numeric(context,
                                        errorText: errorNumeric)
                                  ]),
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "*${txt("password")}",
                                  style: const TextStyle(
                                      fontSize: 12, color: primary),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                FormBuilderTextField(
                                  obscureText: !passwordVisible,
                                  name: "password",
                                  style: getStyle(),
                                  autovalidateMode: isAutoValidate
                                      ? AutovalidateMode.always
                                      : AutovalidateMode.disabled,
                                  controller: controllerPassword,
                                  decoration: getDecorationPassword(
                                      const Icon(
                                        Ionicons.lock_closed_sharp,
                                        size: 18,
                                        color: primary,
                                      ),
                                      txt("password")),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(context,
                                        errorText: errorText),
                                    FormBuilderValidators.min(context, 6,
                                        errorText: txt("password_minimum_6"))
                                  ]),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "*${txt("confirm_password")}",
                                  style: const TextStyle(
                                      fontSize: 12, color: primary),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                FormBuilderTextField(
                                  obscureText: !rePasswordVisible,
                                  name: "confirm_password",
                                  style: getStyle(),
                                  autovalidateMode: isAutoValidate
                                      ? AutovalidateMode.always
                                      : AutovalidateMode.disabled,
                                  controller: controllerRepassword,
                                  decoration: getDecorationRePassword(
                                      const Icon(
                                        Ionicons.lock_closed_sharp,
                                        size: 18,
                                        color: primary,
                                      ),
                                      txt("confirm_password")),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(context,
                                        errorText: errorText),
                                    FormBuilderValidators.min(context, 6,
                                        errorText: txt("password_minimum_6"))
                                  ]),
                                ),
                                // buildShoppingAgentForm(),
                                // buildPersonalInformation(),
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  txt("verification"),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  txt("select_method"),
                                  style: const TextStyle(
                                      fontSize: 12, color: primary),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                buildVerificationButton(),
                                FormBuilderCheckbox(
                                  name: 'accept_terms',
                                  initialValue: false,
                                  checkColor: Colors.white,
                                  activeColor: primary,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                  title: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: txt("agreement_text"),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 10)),
                                        TextSpan(
                                          text: txt("agreement_terms_text"),
                                          style: const TextStyle(
                                              color: primary, fontSize: 10),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = openPrivacyPolicy,
                                        ),
                                      ],
                                    ),
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                      context,
                                      errorText: txt("terms_error"),
                                    ),
                                  ]),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                DefaultButton.redButton(
                                    context, txt("signup"), validateForm),
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

  @override
  void showError(List<Errors>? error, int? httpCode) {
    ScreenUtils.showAlertMessage(context, error, httpCode);
  }

  @override
  void showMainPage() {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => HomeScreen(1)), (r) => false);
  }

  Widget buildVerificationButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => selectVerificationMethod(0),
                child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      color: isMethodSelected
                          ? isMethodEmail
                              ? primary
                              : Colors.white
                          : Colors.white,
                      border: Border.all(color: strokeGrey),
                      borderRadius: const BorderRadius.all(Radius.circular(4))),
                  alignment: Alignment.center,
                  child: Text(
                    "Email",
                    style: TextStyle(
                        color: isMethodSelected
                            ? isMethodEmail
                                ? Colors.white
                                : primary
                            : primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            Expanded(
              child: InkWell(
                onTap: () => selectVerificationMethod(1),
                child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      color: isMethodSelected
                          ? isMethodEmail
                              ? Colors.white
                              : primary
                          : Colors.white,
                      border: Border.all(color: strokeGrey),
                      borderRadius: const BorderRadius.all(Radius.circular(4))),
                  alignment: Alignment.center,
                  child: Text(
                    "Whatsapp",
                    style: TextStyle(
                        color: isMethodSelected
                            ? isMethodEmail
                                ? primary
                                : Colors.white
                            : primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "*${txt("input_code")}",
          style: const TextStyle(fontSize: 12, color: primary),
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            Expanded(
              child: FormBuilderTextField(
                name: "register_verification_code",
                style: getStyle(),
                autovalidateMode: isAutoValidate
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                controller: controllerCode,
                decoration: getDecorationWithoutIcon2(txt("verification_code")),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context, errorText: errorText)
                ]),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        if (_viewModel!.alreadySentCode)
          Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                txt("already_sent_code") +
                    (isMethodEmail ? "Email" : "Whatsapp"),
                style: const TextStyle(
                    fontSize: 12, color: primary, fontWeight: FontWeight.w600),
              ))
        else
          Container()
      ],
    );
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
        controllerCity.text = "";
        controllerCommunityLeader.text = "";
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
    setState(() {
      isAutoValidate = true;
    });
    if (_regKey.currentState!.saveAndValidate()) {
      if (controllerPassword.text != controllerRepassword.text) {
        setState(() {
          _regKey.currentState!.validate();
        });
        scrollController.animateTo(0,
            duration: const Duration(milliseconds: 500), curve: Curves.ease);
      } else {
        final valueRegister = <String, dynamic>{};
        valueRegister.addAll(_regKey.currentState!.value);
        valueRegister['email'] = controllerEmail.text;
        _viewModel!.doRegister(valueRegister);
      }
    } else {
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  void selectVerificationMethod(int i) {
    if (i == 0 && controllerEmail.text.isEmpty) {
      ScreenUtils.showToastMessage(txt("fill_your_email_first"));
      return;
    }

    if (i == 1 && controllerPhoneNumber.text.isEmpty) {
      ScreenUtils.showToastMessage(txt("fill_your_phone_number_first"));
      return;
    }

    final method = isMethodSelected
        ? isMethodEmail
            ? 0
            : 1
        : -1;
    if (method != i) {
      setState(() {
        isMethodEmail = i == 0;
        isMethodSelected = true;
      });
      final methodSelected = isMethodEmail ? "Email" : "Whatsapp";
      Alert(
        context: context,
        style: const AlertStyle(titleStyle: TextStyle(fontSize: 14)),
        type: AlertType.info,
        title: txt("request_code_verification"),
        desc: txt("code_will_be_sent_to") + methodSelected,
        buttons: [
          DialogButton(
            color: primary,
            onPressed: () {
              _viewModel!.requestCodeVerification(
                  isMethodEmail ? controllerEmail.text : getPhone(),
                  isMethodEmail);
              Navigator.pop(context);
            },
            width: 120,
            child: Text(
              txt("send_code"),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          )
        ],
      ).show();
    }
  }

  String? getPhone() {
    _regKey.currentState!.save();
    return _regKey.currentState!.value["phone_number"];
  }

  Widget buildPersonalInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        Text(
          txt("personal_information"),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "*${txt("display_name")}",
          style: const TextStyle(fontSize: 12, color: primary),
        ),
        const SizedBox(
          height: 3,
        ),
        FormBuilderTextField(
          name: "display_name",
          style: getStyle(),
          autovalidateMode: isAutoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          controller: controllerDisplayName,
          decoration: getDecorationWithoutIcon2(txt("display_name")),
          validator: FormBuilderValidators.compose(
              [FormBuilderValidators.required(context, errorText: errorText)]),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "*${txt("birth_date")}",
          style: const TextStyle(fontSize: 12, color: primary),
        ),
        const SizedBox(
          height: 3,
        ),
        FormBuilderDateTimePicker(
          name: 'birthdate',
          onChanged: (changed) => {},
          controller: controllerBirthDate,
          style: getStyle(),
          autovalidateMode: isAutoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          lastDate: DateTime.now(),
          inputType: InputType.date,
          decoration: getDecorationWithoutIcon2(txt("birth_date")),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(
              context,
            ),
          ]),
          initialDate: DateTime.now(),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "*${txt("place_of_birth")}",
          style: const TextStyle(fontSize: 12, color: primary),
        ),
        const SizedBox(
          height: 3,
        ),
        FormBuilderTextField(
          name: "place_of_birth",
          style: getStyle(),
          autovalidateMode: isAutoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          decoration: getDecorationWithoutIcon2(txt("place_of_birth")),
          validator: FormBuilderValidators.compose(
              [FormBuilderValidators.required(context, errorText: errorText)]),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "*${txt("no_ktp")}",
          style: const TextStyle(fontSize: 12, color: primary),
        ),
        const SizedBox(
          height: 3,
        ),
        FormBuilderTextField(
          name: "identity_number",
          style: getStyle(),
          autovalidateMode: isAutoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          maxLength: 16,
          decoration: getDecorationWithoutIcon2(txt("no_ktp")),
          keyboardType: TextInputType.number,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(context, errorText: errorText),
            FormBuilderValidators.numeric(context, errorText: errorNumeric),
            FormBuilderValidators.minLength(context, 16,
                errorText: errorKtpLength)
          ]),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "*${txt("address")}",
          style: const TextStyle(fontSize: 12, color: primary),
        ),
        const SizedBox(
          height: 3,
        ),
        FormBuilderTextField(
          name: "address",
          style: getStyle(),
          minLines: 4,
          autovalidateMode: isAutoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          maxLines: 6,
          maxLength: 240,
          decoration: getDecorationWithoutIcon2(txt("address")),
          validator: FormBuilderValidators.compose(
              [FormBuilderValidators.required(context, errorText: errorText)]),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          txt("profile_picture"),
          style: const TextStyle(
              fontSize: 12, color: primary, fontWeight: FontWeight.w400),
        ),
        Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: 80,
              height: 100,
              child: FormBuilderImagePicker(
                name: 'profile_picture',
                previewWidth: 80,
                previewHeight: 80,
                initialValue: imageProfile,
                bottomSheetPadding: const EdgeInsets.only(bottom: 80),
                decoration: getDecorationWithoutStroke(),
                maxImages: 1,
                iconColor: greys,
                onChanged: (changed) => {},
              ),
            ),
            const SizedBox(
              width: 18,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  txt("profile_picture_upload_hint"),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  InputDecoration getDecoration(Widget icon, String? hint) {
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
    );
  }

  InputDecoration getDecorationWithoutIcon(String hint) {
    return InputDecoration(
      hintText: hint,
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: strokeGrey, width: 0.5)),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: strokeGrey, width: 0.5)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: strokeGrey, width: 0.5)),
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
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

  TextStyle getStyle() {
    return const TextStyle(fontSize: 12);
  }

  InputDecoration getDecorationWithoutStroke() {
    return const InputDecoration(
      border: OutlineInputBorder(borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
      contentPadding: EdgeInsets.zero,
    );
  }

  InputDecoration getDecorationRePassword(Widget icon, String? hint) {
    return InputDecoration(
        hintText: hint,
        errorText: controllerRepassword.text != controllerPassword.text
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

  InputDecoration getDecorationPassword(Widget icon, String? hint) {
    return InputDecoration(
        hintText: hint,
        errorMaxLines: 7,
        errorText: isNotStrongPassword ? txt("error_password_strong") : null,
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

  void checkPassword(String text) {
    final exp = RegExp(OtherUtils.getRegexPassword());
    setState(() {
      isNotStrongPassword = !exp.hasMatch(text);
    });

    if (isNotStrongPassword) {
      passwordNode.requestFocus();
    }
  }

  Future<void> openPrivacyPolicy() async {
    const url =
        'https://storage.googleapis.com/static-superindo/privacy-policy.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // ignore: only_throw_errors
      throw 'Could not launch $url';
    }
  }

  @override
  void showSuccessSentCode(bool isMethodEmail) {
    ScreenUtils.showDialog(
        context,
        AlertType.success,
        txt("forgot_success_code_title"),
        isMethodEmail
            ? txt("forgot_success_code_email")
            : txt("forgot_success_code_sms"));
  }

  Widget buildShoppingAgentForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(
        height: 40,
      ),
      Text(
        txt("community_leader"),
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      const SizedBox(
        height: 20,
      ),
      Text(
        "*${txt("province")}",
        style: const TextStyle(fontSize: 12, color: primary),
      ),
      const SizedBox(
        height: 3,
      ),
      FormBuilderTextField(
        name: "province",
        style: getStyle(),
        autovalidateMode: isAutoValidate
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        controller: controllerProvince,
        focusNode: AlwaysDisabledFocusNode(),
        onTap: () => openSelectPage(TypeSelect.province),
        decoration: getDecorationWithoutIcon2(txt("select_location")),
        validator: FormBuilderValidators.compose(
            [FormBuilderValidators.required(context, errorText: errorText)]),
      ),
      const SizedBox(
        height: 20,
      ),
      Text(
        "*${txt("city")}",
        style: const TextStyle(fontSize: 12, color: primary),
      ),
      const SizedBox(
        height: 3,
      ),
      FormBuilderTextField(
        name: "city",
        style: getStyle(),
        autovalidateMode: isAutoValidate
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        controller: controllerCity,
        focusNode: AlwaysDisabledFocusNode(),
        onTap: () => openSelectPage(TypeSelect.city),
        decoration: getDecorationWithoutIcon2(txt("select_location")),
        validator: FormBuilderValidators.compose(
            [FormBuilderValidators.required(context, errorText: errorText)]),
      ),
      const SizedBox(
        height: 20,
      ),
      Text(
        "*${txt("select_community_leader")}",
        style: const TextStyle(fontSize: 12, color: primary),
      ),
      const SizedBox(
        height: 3,
      ),
      FormBuilderTextField(
        name: "user_cl_id",
        style: getStyle(),
        autovalidateMode: isAutoValidate
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        controller: controllerCommunityLeader,
        focusNode: AlwaysDisabledFocusNode(),
        onTap: () => openSelectPage(TypeSelect.cl),
        decoration: getDecorationWithoutIcon2(txt("select_community_leader")),
        validator: FormBuilderValidators.compose(
            [FormBuilderValidators.required(context, errorText: errorText)]),
      ),
    ]);
  }
}

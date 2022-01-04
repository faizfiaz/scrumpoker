import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/models/response/response_profile.dart';
import 'package:SuperNinja/ui/pages/changePassword/change_password_screen.dart';
import 'package:SuperNinja/ui/pages/editProfile/edit_profile_navigator.dart';
import 'package:SuperNinja/ui/pages/editProfile/edit_profile_view_model.dart';
import 'package:SuperNinja/ui/widgets/app_bar_custom.dart';
import 'package:SuperNinja/ui/widgets/default_button.dart';
import 'package:SuperNinja/ui/widgets/formBuilderPhoneField/form_builder_phone_field.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EditProfileScreen extends StatefulWidget {
  Profile? profile;
  List imageProfile = [];

  EditProfileScreen(this.profile);

  @override
  State<StatefulWidget> createState() {
    return _EditProfileScreen();
  }
}

class _EditProfileScreen extends BaseStateWidget<EditProfileScreen>
    implements EditProfileNavigator {
  EditProfileViewModel? _viewModel;

  final GlobalKey<FormBuilderState> _regKey = GlobalKey<FormBuilderState>();

  TextEditingController controllerDisplayName = TextEditingController();
  TextEditingController controllerFullName = TextEditingController();
  TextEditingController controllerPhoneNumber = TextEditingController();
  TextEditingController controllerBirthDate = TextEditingController();
  TextEditingController controllerPlaceOfBirth = TextEditingController();
  TextEditingController controllerIdentity = TextEditingController();

  NetworkImage defaultImage = const NetworkImage(
      'https://cohenwoodworking.com/wp-content/uploads/2016/09/image-placeholder-500x500.jpg');

  String? errorNumeric = txt("field_numeric");
  String? errorText = txt("field_required");
  String? errorKtpLength = txt("field_ktp_error_length");
  String? error4Length = txt("field_4_error_length");

  bool isAutoValidate = false;

  @override
  void initState() {
    _viewModel = EditProfileViewModel().setView(this) as EditProfileViewModel?;
    if (widget.profile != null) {
      controllerDisplayName.text = widget.profile!.displayName ?? "";
      controllerFullName.text = widget.profile!.name!;
      controllerBirthDate.text = widget.profile!.details!.birthdate ?? "";
      controllerPlaceOfBirth.text = widget.profile!.details!.placeOfBirth ?? "";
      controllerPhoneNumber.text =
          _viewModel!.getPhoneNumber(widget.profile!.phoneNumber!);
      controllerIdentity.text = _viewModel!.getPhoneNumber(
          decrypt(widget.profile!.details!.identityNumber ?? ""));
      if (widget.profile!.details!.profilePicture != null) {
        if (widget.profile!.details!.profilePicture!.isNotEmpty &&
            !widget.profile!.details!.profilePicture!.endsWith("/")) {
          widget.imageProfile.add(widget.profile!.details!.profilePicture);
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditProfileViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<EditProfileViewModel>(
          builder: (context, viewModel, _) => Scaffold(
            appBar: AppBarCustom.buildAppBar(context, txt("change_profile"))
                as PreferredSizeWidget?,
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: greysBackgroundMedium,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 54,
                    color: primary,
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: const <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[buildEditForm()],
                    ),
                  ),
                  if (_viewModel!.isLoading) LoadingIndicator() else Container()
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildEditForm() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: SingleChildScrollView(
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
                      height: 30,
                    ),
                    Text(
                      txt("personal_information"),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            txt("display_name"),
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          FormBuilderTextField(
                            name: "display_name",
                            style: getStyle(),
                            autovalidateMode: isAutoValidate
                                ? AutovalidateMode.always
                                : AutovalidateMode.disabled,
                            controller: controllerDisplayName,
                            decoration:
                                getDecorationWithoutIcon(txt("display_name")),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                context,
                                errorText: errorText,
                              ),
                              FormBuilderValidators.minLength(context, 4,
                                  errorText: error4Length),
                            ]),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            txt("full_name"),
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
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
                            decoration:
                                getDecorationWithoutIcon(txt("full_name")),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                context,
                                errorText: errorText,
                              ),
                              FormBuilderValidators.minLength(context, 4,
                                  errorText: error4Length),
                            ]),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            txt("phone_number"),
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
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
                            initialValue: _viewModel!
                                .getPhoneNumber(widget.profile!.phoneNumber),
                            defaultSelectedCountryIsoCode: 'ID',
                            cursorColor: Colors.black,
                            decoration:
                                getDecorationWithoutIcon(txt("phone_number")),
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
                            height: 12,
                          ),
                          Text(
                            txt("birth_date"),
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          FormBuilderDateTimePicker(
                            name: 'birthdate',
                            onChanged: print,
                            autovalidateMode: isAutoValidate
                                ? AutovalidateMode.always
                                : AutovalidateMode.disabled,
                            style: getStyle(),
                            initialValue:
                                widget.profile!.details!.birthdate != null
                                    ? DateTime.parse(
                                        widget.profile!.details!.birthdate!)
                                    : null,
                            inputType: InputType.date,
                            decoration:
                                getDecorationWithoutIcon(txt("birth_date")),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                context,
                                errorText: errorText,
                              ),
                            ]),
                            initialDate: DateTime.now(),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            txt("place_of_birth"),
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          FormBuilderTextField(
                            name: "place_of_birth",
                            style: getStyle(),
                            autovalidateMode: isAutoValidate
                                ? AutovalidateMode.always
                                : AutovalidateMode.disabled,
                            controller: controllerPlaceOfBirth,
                            decoration:
                                getDecorationWithoutIcon(txt("place_of_birth")),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                context,
                                errorText: errorText,
                              ),
                              FormBuilderValidators.minLength(context, 4,
                                  errorText: error4Length),
                            ]),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            txt("no_ktp"),
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          FormBuilderTextField(
                            name: "identity_number",
                            style: getStyle(),
                            maxLength: 16,
                            autovalidateMode: isAutoValidate
                                ? AutovalidateMode.always
                                : AutovalidateMode.disabled,
                            controller: controllerIdentity,
                            decoration: getDecorationWithoutIcon(txt("no_ktp")),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                context,
                                errorText: errorText,
                              ),
                              FormBuilderValidators.minLength(context, 16,
                                  errorText: errorKtpLength),
                            ]),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            txt("change_profile_picture"),
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 80,
                            height: 100,
                            margin: const EdgeInsets.only(left: 10),
                            child: FormBuilderImagePicker(
                              name: 'profile_picture',
                              previewWidth: 80,
                              previewHeight: 80,
                              initialValue: widget.imageProfile,
                              bottomSheetPadding:
                                  const EdgeInsets.only(bottom: 80),
                              decoration: getDecorationWithoutStroke(),
                              maxImages: 1,
                              iconColor: greys,
                              onChanged: (changed) => {},
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 12),
                      alignment: Alignment.centerRight,
                      child: DefaultButton.redButtonSmall(
                          context, txt("confirm_edit"), validateForm),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      txt("security"),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 12),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: displayChangePasswordPage,
                          child: Text(
                            txt("change_password"),
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: primary),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        txt("application_version"),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        "v${dotenv.env['VERSION_NAME']!}${dotenv.env['CURRENT_ENV'] == "0" ? "-DEV" : ""}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: primary),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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

  InputDecoration getDecorationWithoutStroke() {
    return const InputDecoration(
      border: OutlineInputBorder(borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
      contentPadding: EdgeInsets.zero,
    );
  }

  void displayChangePasswordPage() {
    push(context,
        MaterialPageRoute(builder: (context) => const ChangePasswordScreen()));
  }

  void validateForm() {
    setState(() {
      isAutoValidate = true;
    });

    if (_regKey.currentState!.saveAndValidate()) {
      final valueEdit = <String, dynamic>{};
      valueEdit.addAll(_regKey.currentState!.value);
      _viewModel!.doEdit(valueEdit);
    }
  }

  @override
  void successEditProfile() {
    Navigator.pop(context, true);
  }

  String? decrypt(String s) {
    if (s.isEmpty) return "";
    final key = enc.Key.fromUtf8("IKaFajZGzdyDzLoyZvizGLVsrHorTtug");
    final iv = enc.IV.fromUtf8("0123456789987654");

    final _e = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final _dctr = _e.decrypt64(s, iv: iv);
    return _dctr;
  }
}

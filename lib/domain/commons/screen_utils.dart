import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/domain/commons/nav_key.dart';
import 'package:SuperNinja/domain/models/entity/product.dart';
import 'package:SuperNinja/domain/models/error/error_message.dart';
import 'package:SuperNinja/domain/usecases/user/user_usecase.dart';
import 'package:SuperNinja/ui/pages/login/login_screen.dart';
import 'package:SuperNinja/ui/pages/shopRoutine/shop_routine_view_model.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// ignore: avoid_classes_with_only_static_members
class ScreenUtils {
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static void showDialog(
      BuildContext context, AlertType alertType, String title, String message,
      {Function()? doSomething}) {
    Alert(
      context: context,
      style: const AlertStyle(
          titleStyle: TextStyle(fontSize: 16),
          descStyle: TextStyle(fontSize: 14)),
      type: alertType,
      title: title,
      desc: message,
      buttons: [
        DialogButton(
          width: 120,
          color: primary,
          onPressed: () => {
            if (doSomething != null) {doSomething.call()},
            Navigator.pop(context)
          },
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        )
      ],
    ).show();
  }

  static void showAlertMessage(
      BuildContext context, List<Errors>? message, int? httpCode) {
    var messageText = "";
    if (message != null && message.isNotEmpty) {
      for (final element in message) {
        // ignore: use_string_buffers
        messageText += "${element.error} \n";
      }
    }
    Alert(
      context: context,
      style: const AlertStyle(titleStyle: TextStyle(fontSize: 14)),
      type: AlertType.error,
      title: txt("something_wrong"),
      desc: messageText.isEmpty ? txt("please_try_again_later") : messageText,
      buttons: [
        DialogButton(
          color: primary,
          onPressed: () => Navigator.pop(context),
          width: 120,
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        )
      ],
    ).show();
  }

  static void showLogout(BuildContext context, Function() doLogout) {
    Alert(
      context: context,
      type: AlertType.info,
      title: "",
      desc: txt("logout_message"),
      buttons: [
        DialogButton(
          color: primary,
          onPressed: () => Navigator.pop(context),
          width: 120,
          child: Text(
            txt("cancel"),
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        DialogButton(
          color: Colors.red,
          onPressed: () {
            doLogout.call();
          },
          width: 120,
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }

  static void showExpiredMessage(BuildContext context) {
    Alert(
      context: context,
      type: AlertType.error,
      title: txt("login_expired"),
      desc: txt("login_again"),
      buttons: [
        DialogButton(
          color: primary,
          onPressed: () => UserUsecase.empty().logout().then((value) =>
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (r) => false)),
          width: 120,
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }

  // ignore: type_annotate_public_apis
  static Future<bool> showAlertRemoveShopRoutine(BuildContext context,
      ShopRoutineViewModel viewModel, Product product) async {
    var shouldUpdate = false;
    await Alert(
        context: context,
        type: AlertType.info,
        title: "",
        desc: txt("info_delete_shop_routine"),
        buttons: [
          DialogButton(
            width: 120,
            color: primary,
            onPressed: () => {
              viewModel.doRoutineShop(product),
              Navigator.pop(context),
              shouldUpdate = true,
              Future.value(shouldUpdate)
            },
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          DialogButton(
            color: primary,
            onPressed: () => {Navigator.pop(context), shouldUpdate = true},
            width: 120,
            child: Text(
              txt("cancel"),
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
    return Future.value(shouldUpdate);
  }

  static void showAlertClearCartShopRoutine(
      BuildContext context, Function(bool isClear) callback) {
    Alert(
        context: context,
        type: AlertType.info,
        title: "",
        desc: txt("info_clear_cart"),
        buttons: [
          DialogButton(
            color: primary,
            onPressed: () => {
              Navigator.pop(context),
            },
            width: 120,
            child: Text(
              txt("cancel"),
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          DialogButton(
            color: primary,
            onPressed: () {
              callback(false);
              Navigator.pop(context);
            },
            width: 120,
            child: Text(
              txt("no"),
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          DialogButton(
            color: primary,
            onPressed: () {
              callback(true);
              Navigator.pop(context);
            },
            width: 120,
            child: Text(
              txt("yes"),
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  static void showOptionImagePicker(
      BuildContext context, Function(bool isGallery) openImagePicker) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, modalState) {
            return Container(
              color: greysBackground,
              height: ScreenUtils.getScreenHeight(context) / 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      txt("choose_image"),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  const Divider(
                    color: greys,
                    height: 0.5,
                  ),
                  Material(
                    color: white,
                    child: InkWell(
                      onTap: () => openImagePicker(true),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: <Widget>[
                            const Icon(Icons.camera_alt),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Text(
                                txt("camera"),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    color: greys,
                    height: 0.5,
                  ),
                  Material(
                    color: white,
                    child: InkWell(
                      onTap: () => openImagePicker(false),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: <Widget>[
                            const Icon(Icons.image),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Text(
                                txt("gallery"),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    color: greys,
                    height: 0.5,
                  ),
                ],
              ),
            );
          });
        });
  }

  static void showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16);
  }

  static void expiredToken() {
    if (!NavKey.isInLogin) {
      showToastMessage(txt("expired_token"));
      UserUsecase.empty().logout().then((value) {
        NavKey.isInLogin = true;
        NavKey.navKey.currentState!.pushNamed('/login');
      });
    }
  }

  static void copyToClipBoard(String? text) {
    Clipboard.setData(ClipboardData(text: text));
    showToastMessage("Copy to clipboard");
  }

  static void showConfirmDialog(BuildContext context, AlertType alertType,
      String? title, String? message, Function() action) {
    Alert(
      context: context,
      style: const AlertStyle(
          titleStyle: TextStyle(fontSize: 16),
          descStyle: TextStyle(fontSize: 14)),
      type: alertType,
      title: title,
      desc: message,
      buttons: [
        DialogButton(
          color: primary,
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
          child: Text(
            txt("cancel"),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        DialogButton(
          color: primary,
          onPressed: () {
            Navigator.pop(context);
            action.call();
          },
          width: 120,
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        )
      ],
    ).show();
  }
}

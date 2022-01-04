import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scrumpoker/constant/color.dart';
import 'package:scrumpoker/domain/models/error/error_message.dart';
import 'package:scrumpoker/ui/widgets/multilanguage.dart';

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

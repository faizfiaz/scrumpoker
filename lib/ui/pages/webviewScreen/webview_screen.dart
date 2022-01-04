import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/formatter_date.dart';
import 'package:SuperNinja/domain/commons/tracking_utils.dart';
import 'package:SuperNinja/ui/pages/home/home_screen.dart';
import 'package:SuperNinja/ui/pages/webviewScreen/webview_navigator.dart';
import 'package:SuperNinja/ui/pages/webviewScreen/webview_view_model.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';

enum TypeWebView { payment, continuePayment, banner }

// ignore: must_be_immutable
class WebviewScreen extends StatefulWidget {
  String? url;
  String? title;
  String? containsCallback;
  int? orderId;
  TypeWebView typeWebView;

  WebviewScreen(this.url, this.title, this.containsCallback, this.typeWebView,
      this.orderId);

  @override
  State<StatefulWidget> createState() {
    return _WebviewScreen();
  }
}

class _WebviewScreen extends BaseStateWidget<WebviewScreen>
    implements WebViewNavigator {
  InAppWebViewController? webView;
  String url = "";
  double progress = 0;
  @override
  // ignore: overridden_fields
  bool isLoading = true;
  Map<String, String>? header;

  WebviewViewModel? _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = WebviewViewModel().setView(this) as WebviewViewModel?;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WebviewViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<WebviewViewModel>(
            builder: (context, viewModel, _) => Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: WillPopScope(
                    onWillPop: () => showAlert(),
                    child: Scaffold(
                      appBar: AppBar(
                        backgroundColor: primary,
                        centerTitle: true,
                        titleSpacing: 0,
                        elevation: 0,
                        title: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            getTitle()!,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        leading: IconButton(
                          iconSize: 28,
                          icon: const Icon(Feather.chevron_left,
                              color: Colors.white),
                          onPressed: showAlert,
                        ),
                      ),
                      body: Stack(
                        children: <Widget>[
                          if (_viewModel!.isLoading)
                            LoadingIndicator()
                          else
                            InAppWebView(
                              initialUrlRequest:
                                  URLRequest(url: Uri.parse(widget.url!)),
                              initialOptions: InAppWebViewGroupOptions(
                                crossPlatform:
                                    InAppWebViewOptions(supportZoom: false),
                              ),
                              onWebViewCreated: (controller) {
                                webView = controller;
                              },
                              onLoadStart: (controller, url) {
                                setState(() {
                                  isLoading = true;
                                  this.url = url.toString();
                                  if (widget.containsCallback != null) {
                                    if (this.url.isNotEmpty &&
                                        this.url.contains(
                                            widget.containsCallback!)) {
                                      action();
                                    }
                                  }
                                });
                              },
                              onLoadStop: (controller, url) async {
                                setState(() {
                                  isLoading = false;
                                });
                              },
                              onProgressChanged: (controller, progress) {
                                setState(() {
                                  this.progress = progress / 100;
                                });
                              },
                            ),
                          if (isLoading) LoadingIndicator() else Container()
                        ],
                      ),
                    ),
                  ),
                )));
  }

  void action() {
    switch (widget.typeWebView) {
      case TypeWebView.payment:
        _viewModel!.checkStatusOrder(widget.orderId);
        break;
      case TypeWebView.continuePayment:
        Navigator.pop(context, true);
        break;
      case TypeWebView.banner:
        Navigator.pop(context, false);
    }
  }

  // ignore: always_declare_return_types, type_annotate_public_apis
  showAlert() {
    if (widget.typeWebView == TypeWebView.banner) {
      Navigator.pop(context);
    } else {
      Alert(
        context: context,
        type: AlertType.info,
        title: txt("title_cancel_payment"),
        desc: txt("message_cancel_payment"),
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
            onPressed: handleCancel,
            width: 120,
            child: Text(
              txt("yes"),
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ).show();
    }
  }

  // ignore: always_declare_return_types, type_annotate_public_apis
  handleCancel() {
    switch (widget.typeWebView) {
      case TypeWebView.payment:
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      3,
                    )),
            (r) => false);
        break;
      case TypeWebView.continuePayment:
        Navigator.pop(context);
        // ignore: unnecessary_null_comparison
        if (context != null) {
          Navigator.pop(context);
        }
        break;
      case TypeWebView.banner:
        Navigator.pop(context);
        // ignore: unnecessary_null_comparison
        if (context != null) {
          Navigator.pop(context);
        }
        break;
    }
  }

  String? getTitle() {
    switch (widget.typeWebView) {
      case TypeWebView.payment:
        return txt("payment");
      case TypeWebView.continuePayment:
        return txt("payment");
      case TypeWebView.banner:
        return widget.title;
      default:
        return widget.title;
    }
  }

  @override
  void showPaymentStatus(bool isSuccess) {
    if (isSuccess) {
      final payload = {"order_date": FormatterDate.getDateTimeNow()};
      SmartechPlugin().trackEvent(TrackingUtils.SUCCESS, payload);
      Alert(
        context: context,
        style:
            const AlertStyle(isCloseButton: false, isOverlayTapDismiss: false),
        type: AlertType.success,
        title: txt("title_thanks_order"),
        desc: txt("message_thanks_order"),
        buttons: [
          DialogButton(
            color: Colors.red,
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            3,
                          )),
                  (r) => false);
            },
            width: 120,
            child: Text(
              txt("close"),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          )
        ],
      ).show();
    } else {
      final payload = {"order_date": FormatterDate.getDateTimeNow()};
      SmartechPlugin().trackEvent(TrackingUtils.FAILED, payload);
      Alert(
        context: context,
        style:
            const AlertStyle(isCloseButton: false, isOverlayTapDismiss: false),
        type: AlertType.error,
        title: txt("title_thanks_order_failed"),
        desc: txt("message_thanks_order_failed"),
        buttons: [
          DialogButton(
            color: Colors.red,
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            3,
                          )),
                  (r) => false);
            },
            width: 120,
            child: Text(
              txt("close"),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          )
        ],
      ).show();
    }
  }

  @override
  void showPaymentProcess() {
    final payload = {"order_date": FormatterDate.getDateTimeNow()};
    SmartechPlugin().trackEvent(TrackingUtils.SUCCESS, payload);
    Alert(
      context: context,
      style: const AlertStyle(isCloseButton: false, isOverlayTapDismiss: false),
      type: AlertType.success,
      title: "Pembayaran sedang di proses",
      desc: "Silahkan cek pembayaran Anda di detail order secara berkala",
      buttons: [
        DialogButton(
          color: Colors.red,
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(
                          3,
                        )),
                (r) => false);
          },
          width: 120,
          child: Text(
            txt("close"),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        )
      ],
    ).show();
  }
}

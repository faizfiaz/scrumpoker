import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/formatter_number.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/domain/commons/tracking_utils.dart';
import 'package:SuperNinja/domain/models/response/response_checkout.dart';
import 'package:SuperNinja/domain/models/response/response_list_address.dart';
import 'package:SuperNinja/domain/models/response/response_list_payment.dart';
import 'package:SuperNinja/ui/pages/payment/payment_navigator.dart';
import 'package:SuperNinja/ui/pages/payment/payment_view_model.dart';
import 'package:SuperNinja/ui/pages/virtualAccountScreen/virtual_account_screen.dart';
import 'package:SuperNinja/ui/pages/webviewScreen/webview_screen.dart';
import 'package:SuperNinja/ui/widgets/app_bar_custom.dart';
import 'package:SuperNinja/ui/widgets/default_button.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class PaymentScreen extends StatefulWidget {
  Checkout? checkout;
  double totalPrice;
  Voucher? voucher;
  UserAddress? address;

  PaymentScreen(this.checkout, this.totalPrice, this.voucher, this.address);

  @override
  State<StatefulWidget> createState() {
    return _PaymentScreen();
  }
}

class _PaymentScreen extends BaseStateWidget<PaymentScreen>
    implements PaymentNavigator {
  PaymentViewModel? _viewModel;

  final RefreshController _refreshController = RefreshController();

  String? _paymentValue = "1";
  bool? isTncAgreed = false;

  @override
  void initState() {
    super.initState();
    _viewModel =
        PaymentViewModel(widget.checkout, widget.voucher, widget.address)
            .setView(this) as PaymentViewModel?;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PaymentViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<PaymentViewModel>(
            builder: (context, viewModel, _) => Scaffold(
                  appBar:
                      AppBarCustom.buildAppBarInverse(context, txt("payment"))
                          as PreferredSizeWidget?,
                  body: Container(
                    width: double.infinity,
                    color: greysBackground,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            if (_viewModel!.paymentList!.isNotEmpty)
                              Expanded(
                                child: SmartRefresher(
                                  header: const ClassicHeader(),
                                  controller: _refreshController,
                                  onRefresh: _onRefresh,
                                  child: ListView.builder(
                                    itemCount: _viewModel!.paymentList!.length,
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return renderItemPayment(index,
                                          _viewModel!.paymentList![index]);
                                    },
                                  ),
                                ),
                              )
                            else
                              buildEmptyListPayment(),
                            Container(
                              color: Colors.white,
                              child: buildTnc(),
                            ),
                            buildCardTotal()
                          ],
                        ),
                        if (_viewModel!.isLoading)
                          LoadingIndicator()
                        else
                          Container()
                      ],
                    ),
                  ),
                )));
  }

  Future<void> _onRefresh() async {
    _viewModel!.loadListPayment();
  }

  Widget buildCardTotal() {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 20,
        margin: EdgeInsets.zero,
        color: Colors.white,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 17, right: 17, top: 12, bottom: 30),
          child: Row(
            children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        txt("total_price"),
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        FormatterNumber.getPriceDisplayRounded(
                            widget.totalPrice),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primary,
                            fontSize: 16),
                      )
                    ]),
              ),
              DefaultButton.redButtonSmallLongWidth(
                  context, txt("pay_now"), checkTnc)
            ],
          ),
        ),
      ),
    );
  }

  Widget renderItemPayment(int index, Payment payment) {
    return Container(
      margin: EdgeInsets.only(
          left: 8,
          right: 8,
          top: 8,
          bottom: index == _viewModel!.paymentList!.length - 1 ? 24 : 0),
      child: payment.id == 1
          ? renderCreditCard(index, payment)
          : renderOtherPayment(index, payment),
    );
  }

  Widget renderOtherPayment(int index, Payment payment) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, top: 16, bottom: 16, right: 16),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 20,
              height: 20,
              child: Radio(
                value: payment.id.toString(),
                activeColor: primary,
                groupValue: _paymentValue,
                onChanged: (dynamic change) {
                  setState(() {
                    _paymentValue = change.toString();
                    _viewModel!.selectPayment(_paymentValue);
                  });
                },
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Image.network(
              payment.icon!,
              width: 48,
              height: 48,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(payment.name!,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget renderCreditCard(int index, Payment payment) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, top: 24, bottom: 24, right: 16),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 20,
              height: 20,
              child: Radio(
                value: payment.id.toString(),
                activeColor: primary,
                groupValue: _paymentValue,
                onChanged: (dynamic change) {
                  setState(() {
                    _paymentValue = change;
                    _viewModel!.selectPayment(_paymentValue);
                  });
                },
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Image.network(
              payment.icon!,
              width: 48,
              height: 32,
              fit: BoxFit.fitHeight,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(txt("credit_debit"),
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const Expanded(
              child: SizedBox(),
            ),
            Image.asset(
              icCCLogo,
              width: 90,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Image.asset(
                icBCALogo,
                width: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEmptyListPayment() {
    return Expanded(
        child: Container(
      alignment: Alignment.center,
      child: _viewModel!.isLoading
          ? Container()
          : Text(
              txt("payment_unavailable"),
              style:
                  const TextStyle(fontWeight: FontWeight.w600, color: primary),
            ),
    ));
  }

  @override
  void successOrder(String? url, int? orderId) {
    var stringProductId = "";
    for (final element in _viewModel!.checkout!.items!) {
      // ignore: use_string_buffers
      stringProductId += "${element.id}, ";
    }

    final payload = {
      "cart_id": _viewModel!.checkout!.cartId.toString(),
      "product_cart_id": stringProductId,
      "total_amount": FormatterNumber.getPriceDisplayTwoZero(
          double.parse(_viewModel!.checkout!.totalPrice!))
    };
    SmartechPlugin().trackEvent(TrackingUtils.CARTVALUE, payload);
    if (url!.contains("BCAVA-")) {
      push(
          context,
          MaterialPageRoute(
              builder: (context) => VirtualAccountScreen(orderId, url, false)));
    } else {
      push(
          context,
          MaterialPageRoute(
              builder: (context) => WebviewScreen(
                  url,
                  "Payment",
                  "https://www.superindo.co.id/",
                  TypeWebView.payment,
                  orderId)));
    }
  }

  Widget buildTnc() {
    return FormBuilderCheckbox(
      name: 'accept_terms',
      initialValue: false,
      checkColor: Colors.white,
      activeColor: primary,
      onChanged: (changed) {
        setState(() {
          isTncAgreed = changed;
        });
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide.none),
      ),
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: txt("agreement_payment_text"),
                style: const TextStyle(color: Colors.black, fontSize: 12)),
            TextSpan(
              text: txt("agreement_payment_terms_text"),
              style: const TextStyle(color: primary, fontSize: 12),
              recognizer: TapGestureRecognizer()..onTap = openPrivacyPolicy,
            ),
            TextSpan(
                text: txt("agreement_payment_text_2"),
                style: const TextStyle(color: Colors.black, fontSize: 12)),
          ],
        ),
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(
          context,
          errorText: txt("terms_error"),
        ),
      ]),
    );
  }

  void checkTnc() {
    if (isTncAgreed!) {
      final payload = {"payment_type": _paymentValue};
      SmartechPlugin().trackEvent(TrackingUtils.PAYMENT_TYPE_PICKED, payload);

      _viewModel!.checkoutOrder(_paymentValue);
    } else {
      ScreenUtils.showToastMessage(txt("terms_error"));
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
  void storeClosed() {
    ScreenUtils.showDialog(context, AlertType.warning,
        txt("title_store_closed"), txt("message_store_closed"));
  }

  @override
  void doneRefresh() {
    _refreshController.refreshCompleted();
  }

  @override
  void addressOutOfRange() {
    ScreenUtils.showDialog(context, AlertType.info, txt("address_out_of_range"),
        txt("address_out_of_range_message"));
  }
}

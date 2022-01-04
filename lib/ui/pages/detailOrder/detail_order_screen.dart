import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/formatter_date.dart';
import 'package:SuperNinja/domain/commons/formatter_number.dart';
import 'package:SuperNinja/domain/commons/other_utils.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/domain/commons/style_utils.dart';
import 'package:SuperNinja/domain/models/entity/list_select_generic.dart';
import 'package:SuperNinja/domain/models/entity/product.dart';
import 'package:SuperNinja/domain/models/response/response_checkout.dart';
import 'package:SuperNinja/domain/models/response/response_detail_order.dart';
import 'package:SuperNinja/domain/models/response/response_driver_mr_speedy.dart';
import 'package:SuperNinja/ui/pages/checkout/checkout_screen.dart';
import 'package:SuperNinja/ui/pages/detailOrder/detail_order_navigator.dart';
import 'package:SuperNinja/ui/pages/detailProduct/detail_product_screen.dart';
import 'package:SuperNinja/ui/pages/selectPage/select_page_screen.dart';
import 'package:SuperNinja/ui/pages/virtualAccountScreen/virtual_account_screen.dart';
import 'package:SuperNinja/ui/pages/webviewScreen/webview_screen.dart';
import 'package:SuperNinja/ui/widgets/always_disabled_focus_node.dart';
import 'package:SuperNinja/ui/widgets/app_bar_custom.dart';
import 'package:SuperNinja/ui/widgets/default_button.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator_only.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

import 'detail_order_view_model.dart';

// ignore: must_be_immutable
class DetailOrderScreen extends StatefulWidget {
  int? orderId;

  DetailOrderScreen(this.orderId);

  @override
  State<StatefulWidget> createState() {
    return _DetailOrderScreen();
  }
}

class _DetailOrderScreen extends BaseStateWidget<DetailOrderScreen>
    implements DetailOrderNavigator {
  DetailOrderViewModel? _viewModel;

  _DetailOrderScreen();

  bool needRefresh = false;
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    _viewModel = DetailOrderViewModel(widget.orderId).setView(this)
        as DetailOrderViewModel?;
    super.initState();
  }

  @override
  void onResume() {
    super.onResume();
    _viewModel!.loadDataAPI();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailOrderViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<DetailOrderViewModel>(
            builder: (context, viewModel, _) => WillPopScope(
                  onWillPop: _onWillPop,
                  child: Scaffold(
                    appBar: AppBarCustom.buildAppBarInverse(
                        context, txt("detail_order")) as PreferredSizeWidget?,
                    body: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white,
                      child: Stack(
                        children: <Widget>[
                          if (_viewModel!.detailOrder != null)
                            Column(
                              children: <Widget>[
                                Expanded(
                                  child: SmartRefresher(
                                      header: const ClassicHeader(),
                                      controller: _refreshController,
                                      onRefresh: onRefresh,
                                      child: CustomScrollView(
                                        slivers: <Widget>[
                                          SliverList(
                                            delegate: SliverChildListDelegate([
                                              buildCardStatus(),
                                              buildCardDriver(),
                                              buildButtonPay(),
                                              if (_viewModel!
                                                  .shouldShowScanButton())
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child:
                                                      DefaultButton.redButton(
                                                          context,
                                                          "Scan QR Code",
                                                          openScanner),
                                                )
                                              else
                                                const SizedBox(
                                                  height: 6,
                                                ),
                                              buildCardDetail(),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              buildCardNotes(),
                                              const SizedBox(
                                                height: 40,
                                              ),
                                            ]),
                                          )
                                        ],
                                      )),
                                ),
                              ],
                            )
                          else
                            Container(),
                          if (_viewModel!.isLoading)
                            LoadingIndicator()
                          else
                            Container()
                        ],
                      ),
                    ),
                  ),
                )));
  }

  Widget buildCardDetail() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      width: double.infinity,
      child: Card(
        elevation: 6,
        color: Colors.white,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 17, right: 17, top: 18, bottom: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                txt("list_product"),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
              ),
              const SizedBox(
                height: 16,
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _viewModel!.detailOrder!.items!.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return renderItemProduct(
                      index, _viewModel!.detailOrder!.items![index]);
                },
              ),
              buildCalculationWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCardStatus() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      width: double.infinity,
      child: Card(
        elevation: 6,
        color: Colors.white,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 17, right: 17, top: 18, bottom: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: double.infinity,
                  child: Text(
                    getStatus()!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: primary, fontWeight: FontWeight.w600),
                  )),
              if (_viewModel!.detailOrder!.status == OtherUtils.canceledByAdmin)
                Container(
                    width: double.infinity,
                    child: Text(
                      txt("reason_cancel") +
                          _viewModel!.detailOrder!.canceledReason,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: primary,
                          fontWeight: FontWeight.w400,
                          fontSize: 9,
                          fontStyle: FontStyle.italic),
                    ))
              else
                Container(),
              if (_viewModel!.shouldShowScanButton())
                Container(
                    width: double.infinity,
                    child: Text(
                      _viewModel!.detailOrder!.userCl!.id == null
                          ? txt("scan_message_direct")
                          : txt("scan_message"),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: primary,
                          fontWeight: FontWeight.w400,
                          fontSize: 8,
                          fontStyle: FontStyle.italic),
                    ))
              else
                Container(),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Text(
                    txt("no_order"),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 12),
                  ),
                  Expanded(
                    child: SelectableText(
                      _viewModel!.detailOrder!.receiptCode!,
                      maxLines: 1,
                      textAlign: TextAlign.end,
                      // overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _viewModel!.detailOrder!.userCl!.id != null
                        ? txt("cl_location")
                        : "Alamat Pengiriman",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 12),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 32),
                      child: Text(
                        _viewModel!.getAddressCL(),
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    txt("payment"),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 12),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 32),
                      child: Text(
                        _viewModel!.detailOrder!.orderPayment!.name!,
                        maxLines: 2,
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    txt("status_payment"),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 12),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 32),
                      child: Text(
                        getStatusPayment()!,
                        maxLines: 2,
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    txt("date_purchased"),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 12),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 32),
                      child: Text(
                        FormatterDate.parseToReadableFull(
                            _viewModel!.detailOrder!.createdAt!),
                        maxLines: 2,
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCardNotes() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      width: double.infinity,
      child: Card(
        elevation: 6,
        color: Colors.white,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 17, right: 17, top: 18, bottom: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                txt("notes"),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
              ),
              const SizedBox(
                height: 8,
              ),
              ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 150,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: greysBackgroundMedium,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    child: Text(
                      _viewModel!.detailOrder!.notes!.isNotEmpty
                          ? _viewModel!.detailOrder!.notes!
                          : txt("no_notes"),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget renderItemProduct(int index, ItemsDetailOrder items) {
    return Container(
      margin: EdgeInsets.only(top: index == 0 ? 0 : 12),
      child: Material(
        color: white,
        child: InkWell(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 85,
                    child: Stack(
                      children: <Widget>[
                        // LoadingIndicatorOnly(),
                        if (items.product!.defaultImageUrl != null)
                          Image.network(
                            items.product!.defaultImageUrl!,
                            width: double.infinity,
                            height: 145,
                            errorBuilder: (context, exception, stackTrace) {
                              return Image.asset(
                                placeholderProduct,
                                height: 145,
                                width: double.infinity,
                              );
                            },
                            fit: BoxFit.cover,
                          )
                        else
                          Image.asset(
                            placeholderProduct,
                            height: 145,
                            width: double.infinity,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          items.product!.name!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              txt("unit_price"),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 12),
                            ),
                            Expanded(
                              child: Text(
                                buildPriceUnit(items),
                                textAlign: TextAlign.end,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: secondary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              txt("total_price"),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 12),
                            ),
                            Expanded(
                              child: Text(
                                FormatterNumber.getPriceDisplay(
                                    double.parse(items.subtotal!)),
                                maxLines: 2,
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (items.modifiedHistories != null &&
                  items.modifiedHistories!.isNotEmpty)
                Container(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () => showHistories(items.modifiedHistories),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          txt("item_changes"),
                          style: const TextStyle(
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                              color: primary),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: primary,
                          size: 12,
                        )
                      ],
                    ),
                  ),
                )
              else
                Container(),
              const SizedBox(
                height: 12,
              ),
              const Divider(
                height: 1,
                thickness: 0.1,
                color: blackTrans,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCalculationWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          txt("summary"),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 1,
          thickness: 0.1,
          color: blackTrans,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              txt("subtotal"),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
            ),
            Expanded(
              child: Text(
                FormatterNumber.getPriceDisplay(
                    (double.parse(_viewModel!.detailOrder!.totalAmount!) +
                            double.parse(
                                _viewModel!.detailOrder!.totalVoucherAmount!)) -
                        double.parse(_viewModel!.detailOrder!.deliveryFee!)),
                maxLines: 2,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          children: [
            Text(
              txt("delivery_fee"),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
            ),
            Expanded(
              child: Text(
                FormatterNumber.getPriceDisplay(
                    double.parse(_viewModel!.detailOrder!.deliveryFee!)),
                maxLines: 2,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        if (_viewModel!.detailOrder!.voucherId != null)
          buildVoucher()
        else
          Container(),
        const SizedBox(
          height: 20,
        ),
        const Divider(
          height: 1,
          thickness: 0.1,
          color: blackTrans,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              txt("total"),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
            Expanded(
              child: Text(
                FormatterNumber.getPriceDisplay(
                    double.parse(_viewModel!.detailOrder!.totalAmount!)),
                maxLines: 2,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 12, color: primary),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        if (_viewModel!.detailOrder!.canDisburse!)
          Row(
            children: [
              Text(
                txt("total_payment"),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
              Expanded(
                child: Text(
                  FormatterNumber.getPriceDisplay(
                      double.parse(_viewModel!.detailOrder!.totalAmount!)),
                  maxLines: 2,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: primary),
                ),
              ),
            ],
          )
        else
          Container(),
        buildDisburseWidget()
      ],
    );
  }

  void seeDetailProduct(Product product) {
    push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DetailProductScreen(false, product: product)));
  }

  Widget buildButtonPay() {
    if (_viewModel!.detailOrder!.orderPayment != null &&
        _viewModel!.detailOrder!.orderPayment!.latestStatus == "pending" &&
        _viewModel!.detailOrder!.orderPayment!.redirectUrl != null) {
      if (_viewModel!.detailOrder!.orderPayment!.redirectUrl!
          .contains("BCAVA-")) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: DefaultButton.redButton(
              context,
              txt("continue_payment"),
              () => push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VirtualAccountScreen(
                          _viewModel!.detailOrder!.id,
                          _viewModel!.detailOrder!.orderPayment!.redirectUrl,
                          true)))),
        );
      }
      if (FormatterDate.divideTwentyMinutes(
          _viewModel!.detailOrder!.createdAt!)) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: DefaultButton.redButton(
                  context,
                  txt("new_transaction_again"),
                  () => createNewTransaction(_viewModel!.detailOrder)),
            )
          ],
        );
      } else {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: DefaultButton.redButton(
              context,
              txt("continue_payment"),
              () => continuePayment(
                  _viewModel!.detailOrder!.orderPayment!.redirectUrl)),
        );
      }
    } else {
      return const SizedBox(
        height: 6,
      );
    }
  }

  Future<void> continuePayment(String? url) async {
    final isNeedRefresh = await push(
        context,
        MaterialPageRoute(
            builder: (context) => WebviewScreen(
                url,
                "Payment",
                "https://www.superindo.co.id/",
                TypeWebView.continuePayment,
                _viewModel!.detailOrder!.id)));
    if (isNeedRefresh != null && isNeedRefresh) {
      _viewModel!.loadDataAPI();
    }
  }

  Future<void> openScanner() async {
    final barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#FFE53535", txt("cancel"), false, ScanMode.DEFAULT);
    if (barcodeScanRes != "-1") {
      if (barcodeScanRes != _viewModel!.detailOrder!.receiptCode) {
        ScreenUtils.showToastMessage(
            txt("failed_scan_order_not_match_receipt_code"));
      } else {
        _viewModel!.doScanBarcode(barcodeScanRes);
      }
    }
  }

  @override
  void successScan() {
    ScreenUtils.showToastMessage(txt("success_scan"));
    needRefresh = true;
  }

  Future<bool> _onWillPop() {
    Navigator.pop(context, needRefresh);
    return Future.value(true);
  }

  String? getStatus() {
    if (_viewModel!.detailOrder!.orderPayment!.paymentType == "bca_va") {
      if (_viewModel!.detailOrder!.status == OtherUtils.waitingPayment &&
          FormatterDate.divideOneHour(_viewModel!.detailOrder!.createdAt!)) {
        return txt("transaction_expired");
      }
    } else if (_viewModel!.detailOrder!.orderPayment!.paymentType == "dana" ||
        _viewModel!.detailOrder!.orderPayment!.paymentType == "linkaja" ||
        _viewModel!.detailOrder!.orderPayment!.paymentType == "shopeepay") {
      if (_viewModel!.detailOrder!.status == OtherUtils.waitingPayment &&
          FormatterDate.divideThirtyMinutes(
              _viewModel!.detailOrder!.createdAt!)) {
        return txt("transaction_expired");
      } else {
        if (_viewModel!.detailOrder!.orderPayment!.latestStatus!
                .toLowerCase() ==
            "waiting_approval_xendit") {
          return txt("waiting_approval_xendit");
        }
      }
    } else {
      if (_viewModel!.detailOrder!.status == OtherUtils.waitingPayment &&
          FormatterDate.divideTwentyMinutes(
              _viewModel!.detailOrder!.createdAt!)) {
        return txt("transaction_expired");
      }
    }
    return _viewModel!.detailOrder!.status == "arrived"
        ? txt("order_text_already_arrived")
        : OtherUtils.translateStatusOrder(_viewModel!.detailOrder!.status);
  }

  String? getStatusPayment() {
    if (_viewModel!.detailOrder!.orderPayment!.paymentType == "bca_va") {
      if (_viewModel!.detailOrder!.status == OtherUtils.waitingPayment &&
          FormatterDate.divideOneHour(_viewModel!.detailOrder!.createdAt!)) {
        return txt("transaction_expired");
      }
    } else if (_viewModel!.detailOrder!.orderPayment!.paymentType == "dana" ||
        _viewModel!.detailOrder!.orderPayment!.paymentType == "linkaja" ||
        _viewModel!.detailOrder!.orderPayment!.paymentType == "shopeepay") {
      if (_viewModel!.detailOrder!.status == OtherUtils.waitingPayment &&
          FormatterDate.divideThirtyMinutes(
              _viewModel!.detailOrder!.createdAt!)) {
        return txt("transaction_expired");
      } else {
        if (_viewModel!.detailOrder!.orderPayment!.latestStatus!
                .toLowerCase() ==
            "waiting_approval_xendit") {
          return txt("waiting_approval_xendit");
        }
      }
    } else {
      if (_viewModel!.detailOrder!.status == OtherUtils.waitingPayment &&
          FormatterDate.divideTwentyMinutes(
              _viewModel!.detailOrder!.createdAt!)) {
        return txt("payment_expired");
      }
    }

    return toBeginningOfSentenceCase(
        _viewModel!.detailOrder!.orderPayment!.latestStatus);
  }

  void createNewTransaction(DetailOrder? detailOrder) {
    Alert(
      context: context,
      type: AlertType.info,
      title: txt("new_transaction"),
      desc: txt("new_transaction_message"),
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
            Navigator.of(context).pop();
            _viewModel!.createNewTransaction(detailOrder);
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

  @override
  void failedCreateNewTransaction() {
    ScreenUtils.showToastMessage(txt("error_new_transaction"));
  }

  @override
  void successCheckout(Checkout? checkout, int? cartId, List<int?> products) {
    push(
        context,
        MaterialPageRoute(
            builder: (context) => CheckoutScreen(checkout, cartId, products)));
  }

  @override
  void errorGetOrder() {
    ScreenUtils.showToastMessage(txt("something_wrong"));
    Navigator.pop(context);
  }

  String buildPriceUnit(ItemsDetailOrder items) {
    if (items.product!.pricePerGram != "0") {
      return "${FormatterNumber.getPriceDisplayTwoZero(double.parse(items.price!))} x ${items.qty} Gram";
    } else {
      return "${FormatterNumber.getPriceDisplay(double.parse(items.price!))} x ${items.qty}";
    }
  }

  Widget buildCardDriver() {
    if (_viewModel!.couriers.isNotEmpty) {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _viewModel!.couriers.length,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return buildDriverWidget(index, _viewModel!.couriers[index]!);
        },
      );
    }
    return Container();
  }

  Widget buildDriverWidget(int index, Courier courier) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      width: double.infinity,
      child: Card(
        elevation: 6,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 17, right: 17, top: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_viewModel!.couriers.length > 1)
                Text(
                  txt("courier") + " ${index + 1}",
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600),
                )
              else
                Container(),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Container(
                      width: 70,
                      height: 70,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        courier.photoUrl.toString(),
                        width: 70,
                        height: 70,
                        loadingBuilder: getLoadingImage,
                        errorBuilder: getErrorImage,
                        fit: BoxFit.cover,
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${courier.name ?? ""} ${courier.surname ?? ""}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.phone,
                              color: primary,
                              size: 14,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              courier.phone.toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          txt("status_mrspeedy_driver"),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              const Divider(
                height: 1,
                thickness: 0.1,
                color: blackTrans,
              ),
              if (courier.phone != null && courier.phone!.isNotEmpty)
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () => launch("tel:${courier.phone}"),
                            child: const Icon(
                              Icons.phone,
                              color: primary,
                            ))),
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () => launch("sms:${courier.phone}"),
                            child: const Icon(
                              Icons.sms,
                              color: primary,
                            )))
                  ],
                )
              else
                Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget getLoadingImage(
      BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) {
      return child;
    } else {
      return Container(width: 70, height: 70, child: LoadingIndicatorOnly());
    }
  }

  Widget getErrorImage(
      BuildContext context, Object error, StackTrace? stackTrace) {
    return Image.network(
        "https://cohenwoodworking.com/wp-content/uploads/2016/09/image-placeholder-500x500.jpg");
  }

  void onRefresh() {
    _viewModel!.loadDataAPI();
  }

  @override
  void doneRefresh() {
    _refreshController.refreshCompleted();
  }

  Widget buildDisburseWidget() {
    if (_viewModel!.detailOrder!.canDisburse!) {
      return Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Text(
                txt("excess_payment"),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 12, color: primary),
              ),
              Expanded(
                child: Text(
                  FormatterNumber.getPriceDisplay(
                      double.parse(_viewModel!.detailOrder!.disburseAmount!)),
                  maxLines: 2,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: primary),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            txt("excess_payment_message"),
            style: const TextStyle(
                fontWeight: FontWeight.w400, fontSize: 9, color: primary),
          ),
          const SizedBox(
            height: 12,
          ),
          if (_viewModel!.detailOrder!.orderPayment!.paymentType !=
                  "credit_card" &&
              _viewModel!.detailOrder!.disburseData == null)
            DefaultButton.redButton(context, txt("do_refund"), navigateToRefund)
          else
            Column(
              children: [
                widgetStatusRefund(),
                if (_viewModel!.getStatusRefund() == 'PENDING')
                  Column(
                    children: [
                      const SizedBox(height: 12),
                      DefaultButton.redButton(
                        context,
                        txt('check_status'),
                        () => _viewModel!.loadDataAPI(),
                      ),
                    ],
                  ),
                if (_viewModel!.getStatusRefund() == 'FAILED')
                  Column(
                    children: [
                      widgetRefundFailure(),
                      const SizedBox(height: 15),
                      DefaultButton.redButton(
                        context,
                        txt("do_refund"),
                        navigateToRefund,
                      )
                    ],
                  ),
              ],
            ),
        ],
      );
    }
    return Container();
  }

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  TextEditingController controllerAccountBankName = TextEditingController();
  TextEditingController controllerAccountBankCode = TextEditingController();
  TextEditingController controllerAccountBankNumber = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  bool isAutoValidate = false;
  String? errorText = txt("field_required");

  void navigateToRefund() {
    controllerEmail.text = _viewModel!.profile.email!;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, modalState) {
            return Container(
              color: greysBackground,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        txt("fill_info_refund"),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: FormBuilder(
                          key: _formKey,
                          autovalidateMode: isAutoValidate
                              ? AutovalidateMode.always
                              : AutovalidateMode.disabled,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FormBuilderTextField(
                                name: "account_bank_name",
                                keyboardType: TextInputType.name,
                                style: const TextStyle(fontSize: 12),
                                controller: controllerAccountBankName,
                                decoration:
                                    StyleUtils.getDecorationTextFieldIcon(
                                        const Icon(
                                          Icons.account_box,
                                          color: primary,
                                          size: 18,
                                        ),
                                        txt("account_name")),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(context,
                                      errorText: errorText)
                                ]),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              FormBuilderTextField(
                                name: "account_bank_code",
                                style: const TextStyle(fontSize: 12),
                                controller: controllerAccountBankCode,
                                focusNode: AlwaysDisabledFocusNode(),
                                onTap: () =>
                                    openSelectPage(TypeSelect.xenditBank),
                                decoration:
                                    StyleUtils.getDecorationTextFieldIcon(
                                        const Icon(
                                          Icons.account_balance,
                                          color: primary,
                                          size: 18,
                                        ),
                                        txt("bank_name")),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(context,
                                      errorText: errorText)
                                ]),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              FormBuilderTextField(
                                name: "account_bank_number",
                                keyboardType: TextInputType.number,
                                style: const TextStyle(fontSize: 12),
                                controller: controllerAccountBankNumber,
                                decoration:
                                    StyleUtils.getDecorationTextFieldIcon(
                                        const Icon(
                                          Icons.money,
                                          color: primary,
                                          size: 18,
                                        ),
                                        txt("account_number")),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(context,
                                      errorText: errorText)
                                ]),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              FormBuilderTextField(
                                name: "email",
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(fontSize: 12),
                                controller: controllerEmail,
                                decoration:
                                    StyleUtils.getDecorationTextFieldIcon(
                                        const Icon(
                                          Icons.email_outlined,
                                          color: primary,
                                          size: 18,
                                        ),
                                        "Email"),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(context,
                                      errorText: errorText)
                                ]),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                txt("refund_warning"),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11,
                                    color: primary),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              DefaultButton.redButton(context, txt("send_data"),
                                  () {
                                processRefund(context, modalState);
                              }),
                              const SizedBox(
                                height: 50,
                              ),
                            ],
                          )),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  Future<void> openSelectPage(TypeSelect typeSelect) async {
    final data = await push(context,
        MaterialPageRoute(builder: (context) => SelectPageScreen(typeSelect)));
    if (data != null) {
      controllerAccountBankCode.text = (data as ListSelectGeneric).name!;
      _viewModel!.codeBankRefund = data.id.toString();
    }
  }

  void processRefund(BuildContext bottomSheetContext, StateSetter modalState) {
    if (_formKey.currentState!.saveAndValidate()) {
      Navigator.pop(bottomSheetContext);
      _viewModel!.postRefund(controllerAccountBankName.text,
          controllerAccountBankNumber.text, controllerEmail.text);
    } else {
      modalState(() {
        isAutoValidate = true;
      });
    }
  }

  @override
  void errorDisburse() {
    ScreenUtils.showToastMessage(txt("failed_refund"));
  }

  Widget widgetStatusRefund() {
    return _viewModel!.getStatusRefund().isNotEmpty
        ? Container(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              children: [
                Text(txt("status_refund"),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 12)),
                const Expanded(child: SizedBox()),
                Text(_viewModel!.getStatusRefund(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 12)),
              ],
            ))
        : Container();
  }

  Widget widgetRefundFailure() {
    return _viewModel!.getRefundFailure().isNotEmpty
        ? Container(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _viewModel!.getRefundFailure(),
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.w400, fontSize: 10),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          )
        : Container();
  }

  Widget buildVoucher() {
    return Column(
      children: [
        const SizedBox(
          height: 6,
        ),
        Row(
          children: [
            Text(
              txt("voucher_discount") +
                  " (" +
                  _viewModel!.detailOrder!.voucherCode +
                  ")",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 12, color: primary),
            ),
            Expanded(
              child: Text(
                "- ${FormatterNumber.getPriceDisplayRounded(double.parse(_viewModel!.detailOrder!.totalVoucherAmount!))}",
                maxLines: 2,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 12, color: primary),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void showHistories(List<ModifiedHistories>? modifiedHistories) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, modalState) {
            return Container(
              color: greysBackground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      txt("changes_quantity"),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            txt("change_number"),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            txt("old_quantity"),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            txt("new_quantity"),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: modifiedHistories!.length,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return renderItemHistories(
                          index, modifiedHistories[index]);
                    },
                  ),
                ],
              ),
            );
          });
        });
  }

  Widget renderItemHistories(int index, ModifiedHistories modifiedHistories) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  (index + 1).toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 16),
                ),
              ),
              Expanded(
                child: Text(
                  modifiedHistories.oldQty.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Expanded(
                child: Text(
                  modifiedHistories.newQty.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: primary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        const Divider(
          height: 1,
          thickness: 0.1,
          color: blackTrans,
        ),
      ],
    );
  }
}

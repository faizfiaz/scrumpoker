import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/formatter_date.dart';
import 'package:SuperNinja/domain/commons/formatter_number.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/ui/pages/home/home_screen.dart';
import 'package:SuperNinja/ui/pages/virtualAccountScreen/virtual_account_navigator.dart';
import 'package:SuperNinja/ui/pages/virtualAccountScreen/virtual_account_view_model.dart';
import 'package:SuperNinja/ui/widgets/app_bar_custom.dart';
import 'package:SuperNinja/ui/widgets/default_button.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// ignore: must_be_immutable
class VirtualAccountScreen extends StatefulWidget {
  int? orderId;
  String? redirectUrl;
  bool fromDetailOrder;

  // ignore: avoid_positional_boolean_parameters
  VirtualAccountScreen(this.orderId, this.redirectUrl, this.fromDetailOrder);

  @override
  State<StatefulWidget> createState() {
    return _VirtualAccountScreen();
  }
}

class _VirtualAccountScreen extends BaseStateWidget<VirtualAccountScreen>
    implements VirtualAccountNavigator {
  VirtualAccountViewModel? _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = VirtualAccountViewModel(widget.orderId).setView(this)
        as VirtualAccountViewModel?;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VirtualAccountViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<VirtualAccountViewModel>(
            builder: (context, viewModel, _) => Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: WillPopScope(
                    onWillPop: () => showAlert(),
                    child: Scaffold(
                      appBar: AppBarCustom.buildAppBarInverseWithActionBack(
                              context, txt("detail_payment"), showAlert)
                          as PreferredSizeWidget?,
                      body: Container(
                        width: double.infinity,
                        color: greysBackground,
                        height: double.infinity,
                        child: _viewModel!.isLoading
                            ? LoadingIndicator()
                            : SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      child: buildCardStatus(),
                                    ),
                                    buildGuide(),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 16, top: 24, right: 16),
                                      child: DefaultButton.redButton(
                                          context,
                                          widget.fromDetailOrder
                                              ? txt("back_to_order")
                                              : txt("see_detail_order"),
                                          () =>
                                              openDetailOrder(widget.orderId)),
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    )
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ),
                )));
  }

  Widget buildCardStatus() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      width: double.infinity,
      child: Card(
        elevation: 6,
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.only(left: 17, top: 5, bottom: 5, right: 17),
              color: primary,
              alignment: Alignment.center,
              child: Text(
                txt("please_do_payment"),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
            buildDetailPayment(),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailPayment() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 24,
          ),
          Text(
            txt("do_payment_before"),
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            FormatterDate.vaParseToReadableFull(
                _viewModel!.detailOrder!.createdAt!),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            txt("total_payment"),
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            FormatterNumber.getPriceDisplay(
                double.parse(_viewModel!.detailOrder!.totalAmount!)),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 12,
          ),
          InkWell(
            onTap: () {
              ScreenUtils.copyToClipBoard(_viewModel!.detailOrder!.totalAmount);
            },
            child: Text(
              txt("copy_amount"),
              style: const TextStyle(
                  fontSize: 12,
                  color: secondary,
                  decoration: TextDecoration.underline),
            ),
          ),
          buildPayment()
        ],
      ),
    );
  }

  Widget buildPayment() {
    if (widget.redirectUrl!.contains("BCAVA-")) {
      return Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 32,
            ),
            Image.asset(
              icLogoBCA,
              width: 120,
              height: 24,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              txt("bca_va_number"),
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              widget.redirectUrl!.replaceFirst("BCAVA-", ""),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 12,
            ),
            InkWell(
              onTap: () {
                ScreenUtils.copyToClipBoard(
                    widget.redirectUrl!.replaceFirst("BCAVA-", ""));
              },
              child: Text(
                txt("copy_number"),
                style: const TextStyle(
                    fontSize: 12,
                    color: secondary,
                    decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              txt("no_order"),
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              "#${_viewModel!.detailOrder!.receiptCode!}",
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600, color: primary),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Widget guideBcaVa() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      width: double.infinity,
      child: Card(
        elevation: 6,
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 12,
            ),
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.only(left: 17, top: 5, bottom: 5, right: 17),
              child: Text(
                txt("guide_bca_va"),
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Divider(
              height: 1,
              color: primaryTrans,
            ),
            Theme(
              data: Theme.of(context).copyWith(
                  colorScheme:
                      ColorScheme.fromSwatch().copyWith(secondary: primary)),
              child: ExpansionTile(
                title: Text(
                  txt("atm_bca"),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 12),
                ),
                children: [
                  buildRowGuide("1.", txt("atm_guide_1")),
                  const SizedBox(
                    height: 4,
                  ),
                  buildRowGuide("2.", txt("atm_guide_2")),
                  const SizedBox(
                    height: 4,
                  ),
                  buildRowGuide("3.", txt("atm_guide_3")),
                  const SizedBox(
                    height: 4,
                  ),
                  buildRowGuide("4.", txt("atm_guide_4")),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              color: primaryTrans,
            ),
            Theme(
              data: Theme.of(context).copyWith(
                  colorScheme:
                      ColorScheme.fromSwatch().copyWith(secondary: primary)),
              child: ExpansionTile(
                title: Text(
                  txt("internet_banking_bca"),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 12),
                ),
                children: [
                  buildRowGuide("1.", txt("ib_guide_1")),
                  const SizedBox(
                    height: 4,
                  ),
                  buildRowGuide("2.", txt("ib_guide_2")),
                  const SizedBox(
                    height: 4,
                  ),
                  buildRowGuide("3.", txt("atm_guide_3")),
                  const SizedBox(
                    height: 4,
                  ),
                  buildRowGuide("4.", txt("atm_guide_4")),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            Theme(
              data: Theme.of(context).copyWith(
                  colorScheme:
                      ColorScheme.fromSwatch().copyWith(secondary: primary)),
              child: ExpansionTile(
                title: Text(
                  txt("mobile_banking_bca"),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 12),
                ),
                children: [
                  buildRowGuide("1.", txt("mb_guide_1")),
                  const SizedBox(
                    height: 4,
                  ),
                  buildRowGuide("2.", txt("mb_guide_2")),
                  const SizedBox(
                    height: 4,
                  ),
                  buildRowGuide("3.", txt("atm_guide_3")),
                  const SizedBox(
                    height: 4,
                  ),
                  buildRowGuide("4.", txt("mb_guide_4")),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRowGuide(String number, String message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 8,
        ),
        Container(
            width: 20,
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(fontSize: 12),
            )),
        Flexible(child: Text(message, style: const TextStyle(fontSize: 12)))
      ],
    );
  }

  Widget buildGuide() {
    if (widget.redirectUrl!.contains("BCAVA-")) {
      return guideBcaVa();
    } else {
      return Container();
    }
  }

  void openDetailOrder(int? orderId) {
    _viewModel!.timer.cancel();
    if (widget.fromDetailOrder) {
      Navigator.pop(context);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    3,
                    orderId: _viewModel!.detailOrder!.id,
                  )),
          (r) => false);
    }
  }

  // ignore: always_declare_return_types, type_annotate_public_apis
  showAlert() {
    _viewModel!.timer.cancel();
    if (widget.fromDetailOrder) {
      Navigator.pop(context);
    } else {
      Alert(
        context: context,
        style: const AlertStyle(
            titleStyle: TextStyle(fontSize: 16),
            descStyle: TextStyle(fontSize: 14)),
        type: AlertType.info,
        title: txt("exit_payment"),
        desc: txt("message_exit_payment"),
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
              txt("yes"),
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ).show();
    }
  }

  @override
  void showComplete() {
    Alert(
      context: context,
      style: const AlertStyle(
          isOverlayTapDismiss: false,
          isCloseButton: false,
          titleStyle: TextStyle(fontSize: 16),
          descStyle: TextStyle(fontSize: 14)),
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
                          orderId: _viewModel!.detailOrder!.id,
                        )),
                (r) => false);
          },
          width: 120,
          child: Center(
            child: Text(
              txt("see_detail_order"),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        )
      ],
    ).show();
  }

  @override
  void showPaymentError() {
    Alert(
      context: context,
      style: const AlertStyle(isCloseButton: false, isOverlayTapDismiss: false),
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

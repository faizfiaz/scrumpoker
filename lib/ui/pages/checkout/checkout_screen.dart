import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/formatter_number.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/domain/models/response/response_checkout.dart';
import 'package:SuperNinja/ui/pages/address/list/list_address_screen.dart';
import 'package:SuperNinja/ui/pages/checkout/checkout_navigator.dart';
import 'package:SuperNinja/ui/pages/editProfile/edit_profile_screen.dart';
import 'package:SuperNinja/ui/pages/payment/payment_screen.dart';
import 'package:SuperNinja/ui/widgets/app_bar_custom.dart';
import 'package:SuperNinja/ui/widgets/default_button.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'checkout_view_model.dart';

// ignore: must_be_immutable
class CheckoutScreen extends StatefulWidget {
  Checkout? checkout;
  int? cartId;
  List<int?> products;

  CheckoutScreen(this.checkout, this.cartId, this.products);

  @override
  State<StatefulWidget> createState() {
    return _CheckoutScreen();
  }
}

class _CheckoutScreen extends BaseStateWidget<CheckoutScreen>
    implements CheckoutNavigator {
  CheckoutViewModel? _viewModel;

  int potentialDiscount = 0;
  int voucherDiscount = 0;

  @override
  void initState() {
    _viewModel =
        CheckoutViewModel(widget.checkout, widget.cartId, widget.products)
            .setView(this) as CheckoutViewModel?;
    getPotentialDiscount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CheckoutViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<CheckoutViewModel>(
            builder: (context, viewModel, _) => Scaffold(
                  appBar:
                      AppBarCustom.buildAppBarInverse(context, txt("checkout"))
                          as PreferredSizeWidget?,
                  body: Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: double.infinity,
                    child: _viewModel!.isLoading
                        ? LoadingIndicator()
                        : Stack(
                            children: [
                              Column(
                                children: [
                                  Expanded(
                                    child: CustomScrollView(
                                      slivers: <Widget>[
                                        SliverList(
                                          delegate: SliverChildListDelegate([
                                            buildCardOrderDeliver(),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            buildCardDetail(),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            buildCardVoucher(),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            buildCardNotes(),
                                            const SizedBox(
                                              height: 40,
                                            ),
                                          ]),
                                        )
                                      ],
                                    ),
                                  ),
                                  buildCardTotal()
                                ],
                              ),
                            ],
                          ),
                  ),
                )));
  }

  Widget buildCardOrderDeliver() {
    if (_viewModel!.checkout!.userCl == null) {
      return Container(
        margin: const EdgeInsets.only(left: 16, right: 16),
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
                padding: const EdgeInsets.only(
                    left: 17, top: 5, bottom: 5, right: 17),
                color: primary,
                child: Text(
                  txt("deliverd_message_to_customer"),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 17, top: 8, right: 17),
                child: Text(_viewModel!.checkout!.storeCheckout!.name!,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 17),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: primary,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: Text(
                        _viewModel!.checkout!.storeCheckout!.address ?? "-",
                        style: const TextStyle(fontSize: 12),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                    left: 17, top: 5, bottom: 5, right: 17),
                color: primary,
                child: Text(
                  txt("shipping_address"),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              if (_viewModel!.selectedAddress == null)
                buildEmptyAddress()
              else
                buildAddress()
            ],
          ),
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
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
              child: Text(
                txt("your_order_will_be_delivered_to"),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17, top: 8, right: 17),
              child: Text(_viewModel!.checkout!.userCl!.name!,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 17),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on,
                    color: primary,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text(
                      _viewModel!.checkout!.userCl!.address ?? "-",
                      style: const TextStyle(fontSize: 12),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
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
                itemCount: _viewModel!.checkout!.items!.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return renderItemProduct(
                      index, _viewModel!.checkout!.items![index]);
                },
              ),
              buildCalculationWidget(),
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
                FormatterNumber.getPriceDisplayRounded(calculateTotal()),
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
                    double.parse(_viewModel!.checkout!.deliveryFee!)),
                maxLines: 2,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
              ),
            ),
          ],
        ),
        if (_viewModel!.checkout!.voucherDetail!.voucher != null)
          buildVoucher()
        else
          Container(),
        if (potentialDiscount > 0) buildPotentialDiscount() else Container(),
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
                FormatterNumber.getPriceDisplayRounded(
                    calculateTotal(countVoucher: true)),
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

  Widget renderItemProduct(int index, ItemsCheckout items) {
    return Container(
        margin: EdgeInsets.only(top: index == 0 ? 0 : 12),
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
                              getPrice(items.product!, items.qty),
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
                              getTotalItemPrice(items.product!, items.qty),
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
            const SizedBox(
              height: 12,
            ),
            const Divider(
              height: 1,
              thickness: 0.1,
              color: blackTrans,
            ),
          ],
        ));
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
              const EdgeInsets.only(left: 17, right: 17, top: 12, bottom: 40),
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
                            calculateTotal(countVoucher: true)),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primary,
                            fontSize: 16),
                      )
                    ]),
              ),
              DefaultButton.redButtonSmallLongWidth(
                  context, txt("order"), displayPaymentPage)
            ],
          ),
        ),
      ),
    );
  }

  double totalPrice = 0;

  double calculateTotal({bool countVoucher = false}) {
    totalPrice = 0;
    for (final element in _viewModel!.checkout!.items!) {
      if (double.parse(element.product!.pricePerGram!) > 0) {
        var subTotalItem =
            element.qty! * double.parse(element.product!.pricePerGram!);
        subTotalItem = FormatterNumber.roundingPrice(subTotalItem);
        totalPrice += subTotalItem;
      } else {
        if (int.parse(element.product!.discountPrice!) > 0) {
          totalPrice +=
              element.qty! * int.parse(element.product!.discountPrice!);
        } else {
          totalPrice +=
              element.qty! * int.parse(element.product!.sellingPrice!);
        }
      }
    }
    if (countVoucher) {
      if (_viewModel!.checkout!.voucherDetail!.voucher != null) {
        totalPrice -=
            double.parse(_viewModel!.checkout!.voucherDetail!.amountOfVoucher!);
      }
    }
    return totalPrice;
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
                    child: TextField(
                      minLines: 4,
                      maxLines: 6,
                      controller: _viewModel!.controllerNotes,
                      maxLength: 240,
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: txt("notes_order"),
                        border: InputBorder.none,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCardVoucher() {
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
                txt("voucher_code"),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                padding: const EdgeInsets.only(left: 8),
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: greysBackgroundMedium,
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _viewModel!.controllerVoucher,
                        style: const TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                          hintText: txt("voucher_code"),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    DefaultButton.redButtonSmall(
                        context,
                        _viewModel!.checkout!.voucherDetail!.voucher != null
                            ? txt("delete_voucher")
                            : "Apply",
                        () => _viewModel!.applyVoucher(
                            _viewModel!.checkout!.voucherDetail!.voucher !=
                                null))
                  ],
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              if (_viewModel!.checkout!.voucherDetail!.voucher != null)
                Text(
                  txt("voucher_applied"),
                  style: const TextStyle(color: Colors.green),
                )
              else
                Container(),
              if (_viewModel!.voucherFailed && !_viewModel!.voucherRemoved)
                buildMessageErrorVoucher()
              else
                Container()
            ],
          ),
        ),
      ),
    );
  }

  void displayPaymentPage() {
    if (_viewModel!.checkAddress()) {
      push(
          context,
          MaterialPageRoute(
              builder: (context) => PaymentScreen(
                  _viewModel!.checkout,
                  totalPrice,
                  _viewModel!.checkout!.voucherDetail!.voucher,
                  _viewModel!.selectedAddress)));
    }
  }

  String getPrice(ProductCheckout product, int? qty) {
    if (double.parse(product.pricePerGram!) > 0) {
      return "${FormatterNumber.getPriceDisplayTwoZero(double.parse(product.pricePerGram!))} x $qty Gram";
    } else {
      if (int.parse(product.discountPrice!) > 0) {
        return "${FormatterNumber.getPriceDisplay(double.parse(product.discountPrice!))} x $qty";
      }
      return "${FormatterNumber.getPriceDisplay(double.parse(product.sellingPrice!))} x $qty";
    }
  }

  String getTotalItemPrice(ProductCheckout product, int? qty) {
    if (double.parse(product.pricePerGram!) > 0) {
      return FormatterNumber.getPriceDisplayRounded(
          double.parse(product.pricePerGram!) * qty!);
    } else {
      if (int.parse(product.discountPrice!) > 0) {
        return FormatterNumber.getPriceDisplay(
            double.parse(product.discountPrice!) * qty!);
      }
      return FormatterNumber.getPriceDisplay(
          double.parse(product.sellingPrice!) * qty!);
    }
  }

  @override
  void getPotentialDiscount() {
    potentialDiscount = 0;
    for (final element in _viewModel!.checkout!.items!) {
      if (int.parse(element.product!.discountPrice!) > 0) {
        if (double.parse(element.product!.pricePerGram!) > 0) {
          if (element.product!.weight == 0) {
            potentialDiscount += 0;
          } else {
            final realPerGram = int.parse(element.product!.sellingPrice!) /
                element.product!.weight!;
            final divideRealDiscountPerGram =
                (realPerGram - double.parse(element.product!.pricePerGram!))
                    .toInt();

            final discount = divideRealDiscountPerGram * element.qty!;
            potentialDiscount += discount;
          }
        } else {
          final discount = int.parse(element.product!.sellingPrice!) -
              int.parse(element.product!.discountPrice!);
          final discountAll = discount * element.qty!;
          potentialDiscount += discountAll;
        }
      }
    }
    if (_viewModel!.checkout!.voucherDetail!.voucher != null) {
      voucherDiscount =
          int.parse(_viewModel!.checkout!.voucherDetail!.amountOfVoucher!);
      setState(() {});
    } else {
      setState(() {
        voucherDiscount = 0;
      });
    }
  }

  Widget buildPotentialDiscount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 12,
        ),
        Row(
          children: [
            Text(
              txt("potential_discount"),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: primary),
            ),
            Text(
              FormatterNumber.getPriceDisplay(
                  potentialDiscount.toDouble() + voucherDiscount),
              maxLines: 2,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: primary),
            ),
          ],
        ),
      ],
    );
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
                  _viewModel!.checkout!.voucherDetail!.voucher!.code +
                  ")",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 12, color: primary),
            ),
            Expanded(
              child: Text(
                "- ${FormatterNumber.getPriceDisplayRounded(double.parse(_viewModel!.checkout!.voucherDetail!.amountOfVoucher!))}",
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

  Widget buildMessageErrorVoucher() {
    return Text(
      _viewModel!.getTextErrorVoucher()!,
      style: const TextStyle(color: Colors.red),
    );
  }

  Widget buildAddress() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 17, top: 8, right: 17),
        child: Text(
            "${txt("receiver_name")} : ${_viewModel!.selectedAddress?.receiverName ?? ""}",
            style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      ),
      const SizedBox(
        height: 8,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 12, right: 17),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.location_on,
              color: primary,
            ),
            const SizedBox(
              width: 8,
            ),
            Flexible(
              child: Text(
                _viewModel!.selectedAddress?.address ?? "",
                style: const TextStyle(fontSize: 12),
              ),
            )
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Center(
        child: DefaultButton.redButtonSmall(
            context, txt("choose_another_address"), selectAddress),
      ),
      const SizedBox(
        height: 10,
      ),
    ]);
  }

  Future<void> selectAddress() async {
    final data = await push(
        context,
        MaterialPageRoute(
            builder: (context) => const ListAddressScreen(isSelect: true)));
    if (data != null) {
      if (data is bool) {
        if (data) {
          await _viewModel!.loadDataAddress();
        }
      } else {
        _viewModel!.selectedAddress = data;
        setState(() {});
      }
    } else {
      await _viewModel!.loadDataAddress();
    }
  }

  @override
  void showNeedIdentity() {
    ScreenUtils.showConfirmDialog(
        context,
        AlertType.info,
        txt("identity_required"),
        txt("identity_required_message"),
        showEditProfile);
  }

  Future<void> showEditProfile() async {
    await push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfileScreen(_viewModel!.profile)));
    await _viewModel!.loadDataProfileAPI();
  }

  Widget buildEmptyAddress() {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 17, top: 8, right: 17),
            child: Text(txt("empty_address"))),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: DefaultButton.redButtonSmall(
              context, txt("add_address"), selectAddress),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  @override
  void showAddressNotComplete() {
    ScreenUtils.showConfirmDialog(
        context,
        AlertType.info,
        txt("address_not_complete"),
        txt("address_not_complete_message"),
        selectAddress);
  }
}

// ignore_for_file: deprecated_member_use

import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/formatter_number.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/domain/models/response/response_checkout.dart';
import 'package:SuperNinja/ui/pages/cart/cart_navigator.dart';
import 'package:SuperNinja/ui/pages/checkout/checkout_screen.dart';
import 'package:SuperNinja/ui/widgets/default_button.dart';
import 'package:SuperNinja/ui/widgets/list_cart_item_generic.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'cart_view_model.dart';

class CartScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CartScreen();
  }
}

class _CartScreen extends BaseStateWidget<CartScreen> implements CartNavigator {
  CartViewModel? _viewModel;

  final RefreshController _refreshController = RefreshController();

  double totalPrice = 0;
  List<int> products = [];
  bool? allChecked = false;

  double minimumCartAmount = 100000;
  bool checkMinimumPrice = true;

  @override
  void initState() {
    super.initState();
    _viewModel = CartViewModel().setView(this) as CartViewModel?;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CartViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<CartViewModel>(
            builder: (context, viewModel, _) => Scaffold(
                  appBar: buildAppBar(),
                  body: Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            if (_viewModel!.isLoading)
                              Expanded(child: LoadingIndicator())
                            else
                              _viewModel!.cart != null &&
                                      _viewModel!.cart!.items!.isNotEmpty
                                  ? Expanded(
                                      child: SmartRefresher(
                                          header: const ClassicHeader(),
                                          controller: _refreshController,
                                          onRefresh: _onRefresh,
                                          child: CustomScrollView(
                                            slivers: <Widget>[
                                              SliverList(
                                                delegate:
                                                    SliverChildListDelegate([
                                                  ListCartItemGeneric(
                                                      _viewModel!.cart!.items,
                                                      updateTotal,
                                                      editQtyItem,
                                                      removeItem),
                                                  const SizedBox(
                                                    height: 40,
                                                  ),
                                                ]),
                                              )
                                            ],
                                          )),
                                    )
                                  : buildEmptyData(),
                            buildCardTotal()
                          ],
                        ),
                        if (_viewModel!.loadingEditQty)
                          LoadingIndicator()
                        else
                          Container()
                      ],
                    ),
                  ),
                )));
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _viewModel!.loadDataAPI();
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      brightness: Brightness.light,
      titleSpacing: 0,
      elevation: 0,
      title: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          txt("cart"),
          textAlign: TextAlign.start,
          style: const TextStyle(
              color: primary, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      leading: IconButton(
        iconSize: 28,
        icon: const Icon(Feather.chevron_left, color: primary),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        if (_viewModel!.cart != null)
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: askingClearCart,
                child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      txt("clear_all"),
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    )),
              ))
        else
          Container(),
      ],
    );
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
              Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (value) {
                  setState(() {
                    allChecked = value;
                    checkAllData();
                  });
                },
                value: allChecked,
                activeColor: primary,
              ),
              Text(
                txt("check_all"),
                style:
                    const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        txt("total_price"),
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        _viewModel!.cart != null
                            ? FormatterNumber.getPriceDisplayRounded(
                                totalPrice.toDouble())
                            : "Rp0",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primary,
                            fontSize: 16),
                      )
                    ]),
              ),
              const SizedBox(
                width: 20,
              ),
              DefaultButton.redButtonSmall(context, txt("check_out"),
                  _viewModel!.cart != null ? displayCheckoutPage : null)
            ],
          ),
        ),
      ),
    );
  }

  void displayCheckoutPage() {
    if (checkMinimumPrice) {
      if (totalPrice < minimumCartAmount) {
        ScreenUtils.showDialog(context, AlertType.info,
            txt("title_minimum_purchase"), txt("message_minimum_purchase"));
        return;
      }
    }
    checkCartProductsValid();
  }

  void checkCartProductsValid() {
    if (products.isNotEmpty) {
      var allQtyValid = true;
      for (final element in _viewModel!.cart!.items!) {
        if (element.qty == 0) {
          allQtyValid = false;
          return;
        }
      }

      for (final element in _viewModel!.cart!.items!) {
        if (element.isNotValid) {
          allQtyValid = false;
          return;
        }
      }

      if (allQtyValid) {
        _viewModel!.doCheckout(products);
      } else {
        ScreenUtils.showToastMessage(txt("quantity_not_valid"));
      }
    }
  }

  Widget buildEmptyData() {
    return Expanded(
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              imgEmptyCart,
              width: 240,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Text(
                txt("empty_cart"),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: primary, fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateTotal(double totalPrice, List<int> products) {
    setState(() {
      this.products = products;
      this.totalPrice = totalPrice;
      if (_viewModel!.cart!.items!.length != products.length) {
        allChecked = false;
      } else {
        allChecked = true;
      }
    });
  }

  void askingClearCart() {
    Alert(
      context: context,
      type: AlertType.info,
      title: txt("clear_cart"),
      desc: txt("clear_cart_message"),
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
            Navigator.pop(context);
            _viewModel!.clearCart();
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

  @override
  void successClearCart() {
    ScreenUtils.showToastMessage(txt("success_clear_cart"));
  }

  @override
  void successCheckout(Checkout? checkout, int? cartId, List<int> products) {
    push(
        context,
        MaterialPageRoute(
            builder: (context) => CheckoutScreen(checkout, cartId, products)));
  }

  void editQtyItem(int itemId, int qty, TextEditingController controller,
      int minWeight, int lastQty) {
    _viewModel!.doEditQtyCard(itemId, qty, controller, minWeight, lastQty);
  }

  void checkAllData() {
    setState(() {
      if (allChecked!) {
        for (final element in _viewModel!.cart!.items!) {
          element.isChecked = true;
        }
      } else {
        for (final element in _viewModel!.cart!.items!) {
          element.isChecked = false;
        }
      }
    });
  }

  void removeItem(int itemId) {
    _viewModel!.doRemoveItem(itemId);
  }

  @override
  void doneRefresh() {
    _refreshController.refreshCompleted();
  }

  @override
  void showToastError(int itemId, String? errorMessage) {
    setState(() {
      for (final element in _viewModel!.cart!.items!) {
        if (element.id == itemId) {
          element.isNotValid = true;
        }
      }
    });
    ScreenUtils.showToastMessage(errorMessage!);
  }

  @override
  void successEdit(int itemId) {
    setState(() {
      for (final element in _viewModel!.cart!.items!) {
        if (element.id == itemId) {
          element.isNotValid = false;
        }
      }
    });
  }
}

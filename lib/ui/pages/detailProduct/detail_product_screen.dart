// ignore_for_file: deprecated_member_use

import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/formatter_number.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/domain/models/entity/product.dart';
import 'package:SuperNinja/domain/models/entity/product_detail.dart';
import 'package:SuperNinja/ui/pages/cart/cart_screen.dart';
import 'package:SuperNinja/ui/pages/dashboard/widgets/list_item_generic.dart';
import 'package:SuperNinja/ui/pages/detailProduct/widgets/image_banner_widget.dart';
import 'package:SuperNinja/ui/pages/home/home_screen.dart';
import 'package:SuperNinja/ui/pages/login/login_screen.dart';
import 'package:SuperNinja/ui/widgets/default_button.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator_only.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'detail_product_navigator.dart';
import 'detail_product_view_model.dart';

// ignore: must_be_immutable
class DetailProductScreen extends StatefulWidget {
  Product? product;
  String? productSKU;
  bool isScanBarcode = false;

  // ignore: avoid_positional_boolean_parameters
  DetailProductScreen(this.isScanBarcode, {this.product, this.productSKU});

  @override
  State<StatefulWidget> createState() {
    return _DetailProductScreen();
  }
}

class _DetailProductScreen extends BaseStateWidget<DetailProductScreen>
    implements DetailProductNavigator {
  DetailProductViewModel? _viewModel;

  bool needRefreshHome = false;

  TextEditingController controllerQuantity = TextEditingController(text: "1");

  @override
  void initState() {
    super.initState();
    _viewModel = DetailProductViewModel(widget.product,
            productSKU: widget.productSKU, isScanBarcode: widget.isScanBarcode)
        .setView(this) as DetailProductViewModel?;
    if (widget.product != null && widget.product!.minWeight != null) {
      if (widget.product!.minWeight! > 0) {
        controllerQuantity.text = widget.product!.minWeight!.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailProductViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<DetailProductViewModel>(
            builder: (context, viewModel, _) => WillPopScope(
                  onWillPop: () => checkBack(),
                  child: Scaffold(
                    body: Container(
                      child: !_viewModel!.isLoading &&
                              _viewModel!.productDetail != null
                          ? Container(
                              color: greysBackgroundMedium,
                              width: double.infinity,
                              height: double.infinity,
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: CustomScrollView(
                                      slivers: <Widget>[
                                        SliverList(
                                          delegate: SliverChildListDelegate([
                                            Stack(
                                              children: [
                                                ImageBannerWidget(
                                                    _viewModel!.imageList),
                                                buildCardDetail(
                                                    _viewModel!.productDetail!),
                                                AppBar(
                                                  brightness: Brightness.light,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  centerTitle: true,
                                                  elevation: 0,
                                                  leading: IconButton(
                                                    iconSize: 28,
                                                    icon: const Icon(
                                                        Feather.chevron_left,
                                                        color: primary),
                                                    onPressed: checkBack,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20, top: 10, bottom: 4),
                                              child: Text(
                                                txt("product_recommendation"),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: primary),
                                              ),
                                            ),
                                            if (_viewModel!.listProduct !=
                                                    null &&
                                                _viewModel!
                                                    .listProduct!.isNotEmpty)
                                              ListItemGeneric(
                                                _viewModel!.listProduct,
                                                zeroPadding: true,
                                                callbackAddProduct: addProduct,
                                                callbackWishlist: doWishlist,
                                                alreadyLogin:
                                                    _viewModel!.alreadyLogin,
                                              )
                                            else
                                              Container(
                                                  width: 100,
                                                  height: 100,
                                                  child:
                                                      LoadingIndicatorOnly()),
                                            const SizedBox(
                                              height: 40,
                                            ),
                                          ]),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          : LoadingIndicator(),
                    ),
                  ),
                )));
  }

  void favoritProduct(int index) {
    _viewModel!.favoriteProduct(index);
  }

  void displayCart() {
    push(context, MaterialPageRoute(builder: (context) => CartScreen()));
  }

  void seeDetailProduct(Product product) {
    push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DetailProductScreen(false, product: product)));
  }

  Widget buildCardDetail(ProductDetail data) {
    return Container(
      margin: EdgeInsets.only(
          left: 16,
          right: 16,
          top: ScreenUtils.getScreenHeight(context) / 3 +
              ScreenUtils.getScreenHeight(context) / 10 -
              30),
      width: double.infinity,
      child: Card(
        color: Colors.white,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 17, right: 17, top: 18, bottom: 18),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.name!,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      buildPrice(data),
                      const SizedBox(
                        height: 16,
                      ),
                      if (data.pricePerGram != "0")
                        buildPricePerGram(data)
                      else
                        Container(),
                      Text(txt("description_product"),
                          style: const TextStyle(
                              color: greysMediumText,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(data.description ?? "-",
                          style: const TextStyle(
                              color: greysMediumText, fontSize: 10)),
                      const SizedBox(
                        height: 10,
                      ),
                      // Text(txt("weight") + ": ${data.weight} Gram",
                      //     style: TextStyle(color: Colors.black, fontSize: 11)),
                      Text(txt("unit") + ": ${data.unit}",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 11)),
                    ],
                  )),
                  Column(
                    children: [
                      Row(
                        children: [
                          Material(
                            color: Colors.white,
                            child: InkWell(
                              child: SvgPicture.asset(
                                icMinus,
                                width: 16,
                                height: 16,
                                color: primary,
                              ),
                              onTap: () => changeQty(false),
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            height: 30,
                            child: TextField(
                                controller: controllerQuantity,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(5),
                                ]),
                          ),
                          Material(
                            color: Colors.white,
                            child: InkWell(
                              child: SvgPicture.asset(
                                icPlus,
                                width: 16,
                                height: 16,
                                color: primary,
                              ),
                              onTap: () => changeQty(true),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      if (data.pricePerGram != "0")
                        const Text(
                          "Gram",
                          style: TextStyle(fontSize: 12),
                        )
                      else
                        Container(),
                      const SizedBox(
                        height: 24,
                      ),
                      if (!_viewModel!.isLoadingAddToCart)
                        DefaultButton.redButtonVerySmall(
                            context, txt("add"), doBuy)
                      else
                        LoadingIndicatorOnly()
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: avoid_positional_boolean_parameters
  void changeQty(bool isAdd) {
    if (widget.product != null) {
      var currentQty = int.parse(controllerQuantity.text.toString());
      if (isAdd) {
        controllerQuantity.text = (++currentQty).toString();
      } else {
        if (currentQty <= widget.product!.minWeight!) {
          controllerQuantity.text = widget.product!.minWeight.toString();
        } else {
          if (currentQty > 1) {
            controllerQuantity.text = (--currentQty).toString();
          }
        }
      }
    }
  }

  void doBuy() {
    final currentQty = int.parse(controllerQuantity.text.toString());
    if (currentQty < 1) {
      ScreenUtils.showToastMessage(txt("error_minimum_qty"));
    } else {
      _viewModel!.addToCart(currentQty);
    }
  }

  @override
  void successAddToCart() {
    Alert(
      context: context,
      type: AlertType.success,
      title: txt("success_add_to_cart"),
      desc: "",
      buttons: [
        DialogButton(
          color: primary,
          onPressed: () => Navigator.pop(context),
          width: 120,
          child: Text(
            txt("continue_shopping"),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        DialogButton(
          color: Colors.red,
          onPressed: () {
            Navigator.pop(context);
            displayCart();
          },
          width: 120,
          child: Text(
            txt("go_to_cart"),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        )
      ],
    ).show();
  }

  @override
  void showNeedLogin() {
    Alert(
      context: context,
      type: AlertType.info,
      title: txt("title_need_login"),
      desc: txt("message_need_login"),
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
            showLoginPage();
          },
          width: 120,
          child: Text(
            txt("login"),
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }

  Future<void> showLoginPage() async {
    final data = await push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginScreen(
                  backToPreviousPage: true,
                )));
    if (data != null) {
      if (data as bool == true) {
        await _viewModel!.loadAPIData();
        _viewModel!.alreadyLogin = true;
        needRefreshHome = true;
      }
    }
  }

  // ignore: always_declare_return_types, type_annotate_public_apis
  checkBack() {
    if (needRefreshHome) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    0,
                    alreadyLogin: _viewModel!.alreadyLogin,
                  )),
          (r) => false);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void dismissPage() {
    checkBack();
  }

  void addProduct(Product product, int qty) {
    _viewModel!.addToCart(qty, product: product);
  }

  void doWishlist(Product product) {
    _viewModel!.doWishlist(product);
  }

  Widget buildPrice(ProductDetail data) {
    if (data.discount! > 0) {
      return Row(
        children: [
          Text(
              FormatterNumber.getPriceDisplay(
                  double.parse(data.discountPrice!)),
              style: const TextStyle(
                  color: primary, fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(
            width: 9,
          ),
          Text(
              FormatterNumber.getPriceDisplay(double.parse(data.sellingPrice!)),
              style: const TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.black,
                  fontSize: 12)),
        ],
      );
    } else {
      return Text(
          FormatterNumber.getPriceDisplay(double.parse(data.sellingPrice!)),
          style: const TextStyle(
              color: primary, fontSize: 15, fontWeight: FontWeight.w600));
    }
  }

  Widget buildPricePerGram(ProductDetail data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(txt("price_per_gram"),
        //     style: TextStyle(
        //         color: greysMediumText,
        //         fontSize: 12,
        //         fontWeight: FontWeight.bold)),
        // Text(FormatterNumber.getPriceDisplay(double.parse(data.pricePerGram)),
        //     style: TextStyle(
        //         color: primary, fontSize: 15, fontWeight: FontWeight.w600)),
        // SizedBox(
        //   height: 1,
        // ),
        Text(
            txt("minimum_purchase") + " " + data.minWeight.toString() + " Gram",
            style: const TextStyle(
                color: greysMediumText,
                fontSize: 11,
                fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  @override
  void showErrorMessage(String? text) {
    ScreenUtils.showToastMessage(text!);
  }

  @override
  BuildContext getContext() {
    return context;
  }

  @override
  void productNotFound(String text) {
    ScreenUtils.showDialog(context, AlertType.info, "", text,
        doSomething: dismissPage);
  }
}

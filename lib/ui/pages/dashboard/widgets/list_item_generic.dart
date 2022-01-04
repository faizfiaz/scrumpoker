// ignore_for_file: deprecated_member_use

import 'dart:typed_data';

import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/formatter_number.dart';
import 'package:SuperNinja/domain/commons/other_utils.dart';
import 'package:SuperNinja/domain/models/entity/product.dart';
import 'package:SuperNinja/ui/pages/detailProduct/detail_product_screen.dart';
import 'package:SuperNinja/ui/pages/login/login_screen.dart';
import 'package:SuperNinja/ui/widgets/keyboard_avoiding.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator_only.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// ignore: must_be_immutable
class ListItemGeneric extends StatefulWidget {
  List<Product>? products;
  bool scrollable;
  bool zeroPadding;
  Function(Product product)? callbackProduct;
  Function(Product product, int qty)? callbackAddProduct;
  Function(Product product)? callbackWishlist;
  Function(Product product)? callbackRoutineShop;
  ScrollController? scrollController;
  bool? alreadyLogin;

  ListItemGeneric(this.products,
      {this.scrollable = false,
      this.zeroPadding = false,
      this.callbackProduct,
      this.callbackAddProduct,
      this.callbackWishlist,
      this.callbackRoutineShop,
      this.scrollController,
      this.alreadyLogin});

  @override
  State<StatefulWidget> createState() {
    return _ListItemGeneric();
  }
}

class _ListItemGeneric extends BaseStateWidget<ListItemGeneric> {
  TextEditingController controllerQuantity = TextEditingController(text: "1");

  BuildContext? contextDialog;

  ByteData? imagePlaceHolder;
  late Uint8List placeholderBuffer;

  @override
  void initState() {
    super.initState();
    rootBundle.load(placeholderProduct).then((data) => setState(() {
          imagePlaceHolder = data;
          placeholderBuffer = imagePlaceHolder!.buffer.asUint8List();
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: greysBackgroundMedium,
      child: imagePlaceHolder == null
          ? LoadingIndicatorOnly()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (widget.scrollable) buildExpand() else buildWrap()
              ],
            ),
    );
  }

  Widget renderItemProduct(int index, Product product) {
    return Container(
        margin: EdgeInsets.only(
            left: index % 2 == 1 ? 6 : 0,
            right: index % 2 == 0 ? 6 : 0,
            top: 12),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Material(
            color: white,
            child: InkWell(
              onTap: () => seeDetailProduct(product),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          child: Stack(
                            children: <Widget>[
                              // LoadingIndicatorOnly(),
                              if (product.defaultImageUrl != null)
                                FadeInImage.memoryNetwork(
                                    width: double.infinity,
                                    height: 145,
                                    placeholder: placeholderBuffer,
                                    placeholderScale: 0.5,
                                    fit: BoxFit.cover,
                                    imageErrorBuilder: getErrorImage,
                                    placeholderErrorBuilder: getErrorImage,
                                    image: product.defaultImageUrl!)
                              else
                                Image.asset(
                                  placeholderProduct,
                                  height: 145,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                ),
                            ],
                          ),
                        ),
                        if (product.discount! > 0)
                          OtherUtils.buildDiscountBadge(
                              product.productDivision!.id, product.discount)
                        else
                          Container(),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.only(top: 2, bottom: 2),
                                  alignment: Alignment.center,
                                  width: 60,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(2)),
                                      color: pink),
                                  child: Text(
                                    product.productCategory!.name ?? "",
                                    style: const TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Column(
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () => doWishlist(product),
                                        child: Image.asset(
                                          product.isWishlist != null &&
                                                  product.isWishlist!
                                              ? icWishlistActive
                                              : icWishlist,
                                          width: 25,
                                          height: 25,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      margin: const EdgeInsets.only(left: 5),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () => doRoutineShope(product),
                                          child: Image.asset(
                                            product.isRoutineShop != null &&
                                                    product.isRoutineShop!
                                                ? icShopRoutineActive
                                                : icShopRoutine,
                                            width: 25,
                                            height: 25,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 11, right: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                product.name!,
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 11),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                  (product.minWeight! > 0
                                          ? "Per "
                                          : txt("unit") + " ") +
                                      product.unit,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 8,
                                      color: greys)),
                              const SizedBox(
                                height: 2,
                              ),
                              buildPriceWidget(product),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                      RawMaterialButton(
                        elevation: 0,
                        onPressed: () => addItemCart(product),
                        constraints: const BoxConstraints.tightFor(
                          width: 26,
                          height: 26,
                        ),
                        shape: const CircleBorder(),
                        fillColor: primary,
                        child: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 13,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget getErrorImage(
      BuildContext context, Object error, StackTrace? stackTrace) {
    return Container(
      color: greysPlaceholder,
      child: Center(
        child: Image.asset(
          placeholderProduct,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void seeDetailProduct(Product product) {
    if (widget.callbackProduct != null) {
      widget.callbackProduct!.call(product);
    } else {
      push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DetailProductScreen(false, product: product)));
    }
  }

  Widget buildExpand() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: GridView.count(
          cacheExtent: 0,
          addAutomaticKeepAlives: false,
          // ignore: avoid_bool_literals_in_conditional_expressions
          shrinkWrap: widget.scrollable ? false : true,
          controller: widget.scrollController,
          childAspectRatio: 0.72,
          physics:
              widget.scrollable ? null : const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          children: List.generate(widget.products!.length, (index) {
            return renderItemProduct(index, widget.products![index]);
          }),
        ),
      ),
    );
  }

  Widget buildWrap() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: GridView.count(
        cacheExtent: 0,
        addAutomaticKeepAlives: false,
        // ignore: avoid_bool_literals_in_conditional_expressions
        shrinkWrap: widget.scrollable ? false : true,
        childAspectRatio: 0.72,
        padding: widget.zeroPadding ? EdgeInsets.zero : null,
        physics:
            widget.scrollable ? null : const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        children: List.generate(widget.products!.length, (index) {
          return renderItemProduct(index, widget.products![index]);
        }),
      ),
    );
  }

  void addItemCart(Product product) {
    if (!widget.alreadyLogin!) {
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
            onPressed: () async {
              Navigator.pop(context);
              // ignore: unused_local_variable
              final data = await push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            width: 120,
            child: Text(
              txt("login"),
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ).show();
    } else {
      controllerQuantity.text = "1";
      if (product.minWeight! > 0) {
        controllerQuantity.text = product.minWeight.toString();
      }
      showDialog(
        context: context,
        builder: (context) {
          contextDialog = context;
          return KeyboardAvoiding(
            child: Container(
              margin: EdgeInsets.only(
                  top: (MediaQuery.of(context).size.height / 2) +
                      (MediaQuery.of(context).size.height / 5)),
              child: Center(
                child: Material(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  elevation: 16,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: product.pricePerGram != "0" ? 80 : 60,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                    onTap: () => changeQty(false, product),
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
                                    onTap: () => changeQty(true, product),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            if (product.pricePerGram != "0")
                              const Text(
                                "Gram",
                                style: TextStyle(fontSize: 10),
                              )
                            else
                              Container(),
                            const SizedBox(
                              height: 2,
                            ),
                            if (product.pricePerGram != "0")
                              Text(
                                txt("minimum_purchase") +
                                    " " +
                                    product.minWeight.toString() +
                                    " Gram",
                                style: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w600),
                              )
                            else
                              Container(),
                            const SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  product.name!,
                                  maxLines: 2,
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 11),
                                ),
                                Text(
                                  FormatterNumber.getPriceDisplay(double.parse(
                                      product.discountPrice != "0"
                                          ? product.discountPrice!
                                          : product.sellingPrice!)),
                                  style: const TextStyle(
                                      color: primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                // product.pricePerGram != "0"
                                //     ? Padding(
                                //         padding: EdgeInsets.only(top: 4),
                                //         child: Text(
                                //             FormatterNumber.getPriceDisplay(
                                //                     double.parse(
                                //                         product.pricePerGram)) +
                                //                 "/Gram",
                                //             style: TextStyle(
                                //                 color: primary,
                                //                 fontSize: 11,
                                //                 fontWeight: FontWeight.w600)),
                                //       )
                                //     : Container(),
                                const SizedBox(
                                  height: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: product.pricePerGram != "0" ? 80 : 60,
                          child: RaisedButton(
                              color: primary,
                              elevation: 0,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                  side: const BorderSide(color: Colors.red)),
                              disabledTextColor: white,
                              child: Text(
                                txt("add"),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                              onPressed: () => addProduct(product)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  // ignore: avoid_positional_boolean_parameters
  void changeQty(bool isAdd, Product product) {
    var currentQty = int.parse(controllerQuantity.text.isNotEmpty
        ? controllerQuantity.text.toString()
        : "0");
    if (isAdd) {
      controllerQuantity.text = (++currentQty).toString();
    } else {
      if (currentQty <= product.minWeight!) {
        controllerQuantity.text = product.minWeight.toString();
      } else {
        if (currentQty > 1) {
          controllerQuantity.text = (--currentQty).toString();
        }
      }
    }
  }

  Widget buildPriceWidget(Product product) {
    if (double.parse(product.discountPrice!) > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            FormatterNumber.getPriceDisplay(
                double.parse(product.discountPrice!)),
            style: const TextStyle(
                color: primary, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              FormatterNumber.getPriceDisplay(
                  double.parse(product.sellingPrice!)),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 8,
                  color: Colors.black,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.black),
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          FormatterNumber.getPriceDisplay(double.parse(product.sellingPrice!)),
          style: const TextStyle(
              color: primary, fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 24),
          child: Text(
            "",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 8,
                color: Colors.black,
                decoration: TextDecoration.lineThrough,
                decorationColor: Colors.black),
          ),
        ),
      ],
    );
  }

  void addProduct(Product product) {
    if (contextDialog != null) {
      Navigator.of(contextDialog!).pop();
    }
    if (widget.callbackAddProduct != null) {
      if (controllerQuantity.text.isNotEmpty) {
        widget.callbackAddProduct!
            .call(product, int.parse(controllerQuantity.text));
      }
    }
  }

  void doWishlist(Product product) {
    if (widget.callbackWishlist != null) {
      widget.callbackWishlist!.call(product);
      setState(() {
        if (product.isWishlist != null && product.isWishlist!) {
          product.isWishlist = false;
        } else {
          product.isWishlist = true;
        }
      });
    }
  }

  void doRoutineShope(Product product) {
    if (widget.callbackRoutineShop != null) {
      widget.callbackRoutineShop!.call(product);
      setState(() {
        if (product.isRoutineShop != null && product.isRoutineShop!) {
          product.isRoutineShop = false;
        } else {
          product.isRoutineShop = true;
        }
      });
    }
  }
}

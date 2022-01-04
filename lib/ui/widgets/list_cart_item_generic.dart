// ignore_for_file: avoid_positional_boolean_parameters

import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/formatter_number.dart';
import 'package:SuperNinja/domain/commons/other_utils.dart';
import 'package:SuperNinja/domain/models/entity/items.dart';
import 'package:SuperNinja/domain/models/entity/product.dart';
import 'package:SuperNinja/ui/pages/detailProduct/detail_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'multilanguage.dart';

// ignore: must_be_immutable
class ListCartItemGeneric extends StatefulWidget {
  List<Items>? itemProduct;
  Function(double totalPrice, List<int> productId) totalPrice;
  Function(int itemId, int qty, TextEditingController controller, int minWeight,
      int lastQty) editQty;
  Function(int itemId) removeItem;

  ListCartItemGeneric(
      this.itemProduct, this.totalPrice, this.editQty, this.removeItem);

  @override
  State<StatefulWidget> createState() {
    return _ListCartItemGeneric();
  }
}

class _ListCartItemGeneric extends BaseStateWidget<ListCartItemGeneric> {
  double totalPrice = 0;

  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => calculateTotal());
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Divider(
            height: 1,
            thickness: 0.1,
            color: blackTrans,
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.itemProduct!.length,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              _controllers.add(TextEditingController(
                  text: widget.itemProduct![index].qty.toString()));
              return renderItemProduct(index, widget.itemProduct![index]);
            },
          ),
        ],
      ),
    );
  }

  Widget renderItemProduct(int index, Items itemProduct) {
    return Container(
      margin: EdgeInsets.only(top: index == 0 ? 0 : 0),
      child: Material(
        color: itemProduct.isNotValid ? secondaryTrans : Colors.white,
        child: InkWell(
          onTap: () => seeDetailProduct(itemProduct.product!),
          child: Container(
            padding:
                EdgeInsets.only(left: 8, right: 10, top: index == 0 ? 24 : 12),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Checkbox(
                      onChanged: (value) {
                        setState(() {
                          itemProduct.isChecked = value;
                          calculateTotal();
                        });
                      },
                      value: itemProduct.isChecked,
                      activeColor: primary,
                    ),
                    Container(
                      width: 90,
                      height: 70,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 145,
                            child: Stack(
                              children: <Widget>[
                                // LoadingIndicatorOnly(),
                                Image.network(
                                  itemProduct.product!.defaultImageUrl!,
                                  width: double.infinity,
                                  errorBuilder:
                                      (context, exception, stackTrace) {
                                    return Image.asset(
                                      placeholderProduct,
                                      height: 145,
                                      width: double.infinity,
                                    );
                                  },
                                  height: 145,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),
                          if (itemProduct.product!.discount! > 0)
                            OtherUtils.buildDiscountBadge(
                                itemProduct.product!.productDivisionId,
                                itemProduct.product!.discount,
                                smallIcon: true)
                          else
                            Container(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            itemProduct.product!.name!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          buildPriceWidget(itemProduct.product!)
                        ],
                      ),
                    ),
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
                                onTap: () => changeQty(
                                    false, _controllers[index], itemProduct),
                              ),
                            ),
                            SizedBox(
                              width: 60,
                              height: 30,
                              child: TextField(
                                  controller: _controllers[index],
                                  onChanged: (value) => changeQtyDirect(
                                      _controllers[index], itemProduct),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: primary),
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
                                onTap: () => changeQty(
                                    true, _controllers[index], itemProduct),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Material(
                              color: Colors.white,
                              child: InkWell(
                                child: SvgPicture.asset(
                                  icDeleteItem,
                                  width: 16,
                                  height: 16,
                                  color: primary,
                                ),
                                onTap: () => showRemoveAlert(
                                    _controllers[index], itemProduct, true),
                              ),
                            ),
                          ],
                        ),
                        if (itemProduct.product!.pricePerGram != "0")
                          const Text(
                            "Gram",
                            style: TextStyle(fontSize: 10),
                          )
                        else
                          Container(),
                        const SizedBox(
                          height: 2,
                        ),
                        if (itemProduct.product!.pricePerGram != "0")
                          Text(
                            txt("minimum_purchase") +
                                " \n" +
                                itemProduct.product!.minWeight.toString() +
                                " Gram",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 9, fontWeight: FontWeight.w600),
                          )
                        else
                          Container(),
                      ],
                    )
                  ],
                ),
                if (itemProduct.isNotValid)
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: Text(
                      "*${txt("quantity_not_valid")}",
                      style: const TextStyle(fontSize: 9, color: primary),
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
      ),
    );
  }

  void changeQty(
      bool isAdd, TextEditingController controllerQuantity, Items itemProduct) {
    var currentQty = int.parse(controllerQuantity.text.toString());
    final lastQty = itemProduct.qty;
    if (isAdd) {
      controllerQuantity.text = (++currentQty).toString();
    } else {
      if (currentQty <= itemProduct.product!.minWeight!) {
        showRemoveAlert(controllerQuantity, itemProduct, false);
        return;
      } else {
        if (currentQty > 1) {
          controllerQuantity.text = (--currentQty).toString();
        } else {
          controllerQuantity.text = (--currentQty).toString();
          showRemoveAlert(controllerQuantity, itemProduct, true);
          return;
        }
      }
    }
    itemProduct.qty = currentQty;
    calculateTotal();
    widget.editQty.call(itemProduct.id!, itemProduct.qty!, controllerQuantity,
        itemProduct.product!.minWeight!, lastQty!);
  }

  void seeDetailProduct(Product product) {
    push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailProductScreen(
                  false,
                  product: product,
                )));
  }

  void calculateTotal() {
    totalPrice = 0;
    final listProduct = <int>[];
    for (final element in widget.itemProduct!) {
      if (element.isChecked!) {
        listProduct.add(element.id!);
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
    }
    widget.totalPrice.call(totalPrice, listProduct);
  }

  Widget buildPriceWidget(Product product) {
    if (int.parse(product.discountPrice!) > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              FormatterNumber.getPriceDisplay(
                  double.parse(product.discountPrice!)),
              style: const TextStyle(
                  color: primary, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(
            width: 9,
          ),
          Text(
              FormatterNumber.getPriceDisplay(
                  double.parse(product.sellingPrice!)),
              style: const TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.black,
                  fontSize: 10)),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            FormatterNumber.getPriceDisplay(
                double.parse(product.sellingPrice!)),
            style: const TextStyle(
                color: primary, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }

  void showRemoveAlert(TextEditingController controllerQuantity,
      Items itemProduct, bool addOne) {
    Alert(
      context: context,
      style: const AlertStyle(isCloseButton: false, isOverlayTapDismiss: false),
      type: AlertType.warning,
      title: txt("delete_product"),
      desc: txt("delete_product_desc"),
      buttons: [
        DialogButton(
          color: primary,
          onPressed: () {
            if (addOne) {
              changeQty(true, controllerQuantity, itemProduct);
            }
            Navigator.pop(context);
          },
          width: 120,
          child: Text(
            txt("cancel"),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        DialogButton(
          color: Colors.red,
          onPressed: () {
            Navigator.pop(context);
            widget.removeItem.call(itemProduct.id!);
          },
          width: 120,
          child: Text(
            txt("delete"),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        )
      ],
    ).show();
  }

  void changeQtyDirect(TextEditingController controller, Items itemProduct) {
    if (controller.text.toString().isEmpty) {
      // controller.text = "1";
      // controller.selection = TextSelection.fromPosition(
      //     TextPosition(offset: controller.text.length));

      itemProduct.qty = 0;
      calculateTotal();
      widget.editQty.call(
          itemProduct.id!, 0, controller, itemProduct.product!.minWeight!, 0);
      return;
    }
    final currentQty = int.parse(controller.text.toString());
    if (currentQty == 0) {
      controller.text = "0";
      setState(() {
        itemProduct.qty = currentQty;
      });
      calculateTotal();
      widget.editQty.call(itemProduct.id!, itemProduct.qty!, controller,
          itemProduct.product!.minWeight!, 0);
      return;
    }
    final lastQty = itemProduct.qty;
    setState(() {
      itemProduct.qty = currentQty;
    });

    calculateTotal();
    widget.editQty.call(itemProduct.id!, itemProduct.qty!, controller,
        itemProduct.product!.minWeight!, lastQty!);
  }
}

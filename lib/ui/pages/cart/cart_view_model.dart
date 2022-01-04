// ignore_for_file: invalid_return_type_for_catch_error

import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/commons/formatter_number.dart';
import 'package:SuperNinja/domain/commons/tracking_utils.dart';
import 'package:SuperNinja/domain/models/entity/cart.dart';
import 'package:SuperNinja/domain/models/entity/items.dart';
import 'package:SuperNinja/domain/models/response/response_checkout.dart';
import 'package:SuperNinja/domain/repositories/order_repository.dart';
import 'package:SuperNinja/domain/usecases/order/order_usecase.dart';
import 'package:SuperNinja/ui/pages/cart/cart_navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';

class CartViewModel extends BaseViewModel<CartNavigator> {
  List<Items> listProduct = [];
  Cart? cart;
  Checkout? checkout;

  late OrderUsecase _usecase;

  bool loadingEditQty = false;

  CartViewModel() {
    _usecase = OrderUsecase(OrderRepository(dioClient));
    loadDataAPI();
  }

  void doCheckout(List<int> products) {
    showLoading(true);
    _usecase
        .doCheckout(cartId: cart!.cartId, products: products, voucherCode: null)
        .then((value) {
      showLoading(false);
      if (value.values.first != null) {
      } else {
        checkout = value.keys.first!.data;
        var stringProductId = "";
        for (final element in products) {
          // ignore: use_string_buffers
          stringProductId += "$element, ";
        }
        final payload = {
          "cart_id": cart!.cartId.toString(),
          "product_cart_id": stringProductId
        };
        SmartechPlugin().trackEvent(TrackingUtils.CHECKOUT, payload);
        getView()!.successCheckout(checkout, cart!.cartId, products);
      }
    }).catchError(print);
  }

  void loadDataAPI() {
    showLoading(true);
    _usecase.getListCarts().then((value) {
      showLoading(false);
      if (value.values.first != null) {
      } else {
        cart = value.keys.first!.data;

        var totalPrice = 0.0;
        for (final element in cart!.items!) {
          if (element.product!.pricePerGram != "0") {
            totalPrice +=
                element.qty! * double.parse(element.product!.pricePerGram!);
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

        final payload = {
          "cart_value": FormatterNumber.getPriceDisplay(totalPrice),
          "number_of_items": cart!.items!.length.toString()
        };
        SmartechPlugin().trackEvent(
            TrackingUtils.CART_VALUE_NUMBER_OF_ITEMS_IN_CART, payload);

        getView()!.doneRefresh();
        notifyListeners();
      }
    }).catchError(print);
  }

  void clearCart() {
    showLoading(true);
    _usecase.clearAllCart(cartId: cart!.cartId).then((value) {
      showLoading(false);
      if (value.values.first != null) {
      } else {
        cart = null;
        getView()!.successClearCart();
        notifyListeners();
      }
    }).catchError(print);
  }

  void doEditQtyCard(int itemId, int qty, TextEditingController controller,
      int minWeight, int lastQty) {
    loadingEditQty = true;
    notifyListeners();
    _usecase.editQtyCard(itemId: itemId, qty: qty).then((value) {
      loadingEditQty = false;
      notifyListeners();
      if (value.values.first != null) {
        final errorMessage = value.values.first!.errors!.first.error;
        // if(errorMessage.contains("Less than the specified weight") || errorMessage.contains("Kurang dari weight yang ditentukan")){
        getView()!.showToastError(itemId, errorMessage);
        // }else{
        //   getView().showToastError(errorMessage);
        // }
        // print(value.values.first.errors.first.error);
        // getView().showError(value.values.first.errors, 0);
      } else {
        getView()!.successEdit(itemId);
      }
    }).catchError(print);
  }

  void doRemoveItem(int itemId) {
    loadingEditQty = true;
    notifyListeners();
    _usecase.removeItemCart(itemId: itemId).then((value) {
      loadingEditQty = false;
      notifyListeners();
      if (value.values.first != null) {
        getView()!.showError(value.values.first!.errors, 0);
      } else {
        deleteProduct(itemId);
      }
    }).catchError(print);
  }

  void deleteProduct(int itemId) {
    cart!.items!.removeWhere((element) => element.id == itemId);
    notifyListeners();
  }
}

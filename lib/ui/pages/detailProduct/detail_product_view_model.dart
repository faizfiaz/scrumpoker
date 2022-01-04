// ignore_for_file: invalid_return_type_for_catch_error

import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/domain/commons/tracking_utils.dart';
import 'package:SuperNinja/domain/models/entity/product.dart';
import 'package:SuperNinja/domain/models/entity/product_detail.dart';
import 'package:SuperNinja/domain/models/response/response_profile.dart';
import 'package:SuperNinja/domain/repositories/order_repository.dart';
import 'package:SuperNinja/domain/repositories/product_repository.dart';
import 'package:SuperNinja/domain/usecases/order/order_usecase.dart';
import 'package:SuperNinja/domain/usecases/product/product_usecase.dart';
import 'package:SuperNinja/domain/usecases/user/user_usecase.dart';
import 'package:SuperNinja/ui/pages/detailProduct/detail_product_navigator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/cupertino.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';

class DetailProductViewModel extends BaseViewModel<DetailProductNavigator> {
  TextEditingController controllerShippingAddress = TextEditingController();

  Product? product;
  ProductDetail? productDetail;
  List<String?> imageList = [];

  late ProductUsecase _usecase;
  late UserUsecase _userUsecase;
  late OrderUsecase _orderUsecase;
  List<Product>? listProduct = [];

  bool alreadyLogin = false;
  bool isLoadingAddToCart = false;
  bool? isScanBarcode = false;
  String? productSKU;
  Profile? profile;
  bool isEmptyClAndStore = true;

  DetailProductViewModel(this.product, {this.productSKU, this.isScanBarcode}) {
    isLoadingAddToCart = false;
    _usecase = ProductUsecase(ProductRepository(dioClient));
    _orderUsecase = OrderUsecase(OrderRepository(dioClient));
    _userUsecase = UserUsecase.empty();
    loadAPIData();
  }

  Future<void> loadAPIData() async {
    alreadyLogin = await _userUsecase.hasToken();
    await _userUsecase.fetchUserData().then((value) {
      if (value != null) {
        profile = value;
        if (profile!.userCl == null && profile!.store == null) {
          isEmptyClAndStore = true;
        } else {
          isEmptyClAndStore = false;
        }
      }
    }).catchError(print);
    getData();
  }

  void favoriteProduct(int index) {}

  void getData() {
    showLoading(true);
    _usecase
        .getDetailProduct(
            productId: isScanBarcode! ? productSKU : product!.id.toString(),
            alreadyLogin: alreadyLogin,
            isScanBarcode: isScanBarcode!)
        .then((value) {
      if (value.values.first != null) {
        showLoading(false);
        getView()!.dismissPage();
      } else {
        showLoading(false);
        productDetail = value.keys.first!.data;
        for (final element in productDetail!.productImages!) {
          imageList.add(element.imageUrl);
        }
        getRecommendationProduct(productDetail!.productCategory!.id);

        final payload = {
          "category_name": productDetail!.productCategory!.name,
          "plu_code": productDetail!.plu,
          "product_name": productDetail!.name
        };
        SmartechPlugin()
            .trackEvent(TrackingUtils.CATEGORYNAME_PLUCODE, payload);
        notifyListeners();
      }
    }).catchError((errorValue) {
      showLoading(false);
      getView()!.productNotFound(txt("product_barcode_not_found"));
    });
  }

  void getRecommendationProduct(int? id) {
    _usecase
        .getListProduct(
            page: 0,
            perPage: 6,
            name: "",
            productCategoryId: id.toString(),
            orderByNewest: "orderByNewest",
            orderByDiscount: "orderByDiscount",
            orderByExpenses: "orderByExpenses",
            isAlreadyLogin: alreadyLogin && !isEmptyClAndStore)
        .then((value) {
      if (value.values.first != null) {
      } else {
        listProduct = value.keys.first!.data!.data;
        notifyListeners();
      }
    }).catchError(print);
  }

  void addToCart(int currentQty, {Product? product}) {
    if (alreadyLogin) {
      if (profile!.userCl == null && profile!.store == null) {
        ScreenUtils.showDialog(
            getView()!.getContext(),
            AlertType.warning,
            txt("title_warning_empty_agent_store"),
            txt("message_warning_empty_agent_store"));
        return;
      }
      isLoadingAddToCart = true;
      notifyListeners();
      _orderUsecase
          .addToCart(
              productId: product != null ? product.id : productDetail!.id,
              qty: currentQty,
              storeId: product != null
                  ? product.storeId
                  : productDetail!.storeProduct!.storeId)
          .then((value) {
        if (value.values.first != null) {
          getView()!.showError(value.values.first!.errors, 0);
        } else {
          final payload = {
            "product_name": productDetail!.name,
            "quantity": currentQty.toString(),
            "plu_code": productDetail!.plu
          };

          SmartechPlugin().trackEvent(TrackingUtils.ADD_TO_CART, payload);
          getView()!.successAddToCart();
        }
        isLoadingAddToCart = false;
        notifyListeners();
      }).catchError((errorValue) {
        isLoadingAddToCart = false;
        getView()!.showErrorMessage(txt("empty_stock"));
        notifyListeners();
      });
    } else {
      getView()!.showNeedLogin();
    }
  }

  void doWishlist(Product product) {
    if (alreadyLogin) {
      notifyListeners();
      _usecase
          .actionProductWishlist(
              productId: product.id, storeId: product.storeId)
          .then((value) {
        showLoading(false);
        if (value.values.first != null) {
          getView()!.showError(value.values.first!.errors, 0);
        } else {
          listProduct!.removeWhere((element) => element.id == product.id);
          notifyListeners();
          // getView().successWishList();
        }
        notifyListeners();
      }).catchError(print);
    } else {
      getView()!.showNeedLogin();
    }
  }
}

import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/commons/tracking_utils.dart';
import 'package:SuperNinja/domain/models/entity/category.dart';
import 'package:SuperNinja/domain/models/entity/product.dart';
import 'package:SuperNinja/domain/repositories/order_repository.dart';
import 'package:SuperNinja/domain/repositories/product_repository.dart';
import 'package:SuperNinja/domain/usecases/order/order_usecase.dart';
import 'package:SuperNinja/domain/usecases/product/product_usecase.dart';
import 'package:SuperNinja/domain/usecases/user/user_usecase.dart';
import 'package:SuperNinja/ui/pages/allCategory/all_category_navigator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';

class AllCategoryViewModel extends BaseViewModel<AllCategoryNavigator> {
  late ProductUsecase _productUsecase;
  late UserUsecase _userUsecase;
  late OrderUsecase _orderUsecase;

  List<Category> listData = [];
  List<Category> listDataCopy = [];
  List<Product> listProduct = [];

  TextEditingController searchController = TextEditingController();

  int page = 1;
  int totalPage = 0;

  String sort = "";
  String categoryId = "";
  String perPageReal = "10";
  String orderByNewest = "";
  String orderByDiscount = "desc";
  String orderByExpenses = "";
  bool orderByName = false;
  bool isAlreadyLogin = false;

  AllCategoryViewModel(List<Category> listCategory,
      {this.isAlreadyLogin = false}) {
    _productUsecase = ProductUsecase(ProductRepository(dioClient));
    _orderUsecase = OrderUsecase(OrderRepository(dioClient));
    _userUsecase = UserUsecase.empty();

    searchController.addListener(filterData);
    listData.addAll(listCategory);
    listDataCopy.addAll(listCategory);
    notifyListeners();
  }

  void filterData() {
    listDataCopy.clear();
    if (searchController.text.isNotEmpty) {
      listDataCopy.addAll(listData);
    } else {
      for (final element in listData) {
        if (element.name!.toLowerCase().contains(searchController.text)) {
          listDataCopy.add(element);
          notifyListeners();
        }
      }
    }
  }

  Future<void> getProductByCategory(
      {bool isInit = true, bool isLoadMore = false}) async {
    if (isInit) {
      showLoading(true);
    }
    if (isLoadMore) {
      page++;
    }
    if (categoryId == "0") {
      categoryId = "";
    }
    isAlreadyLogin = await _userUsecase.hasToken();
    await _productUsecase
        .getListProduct(
            page: page,
            perPage: int.parse(perPageReal),
            name: "",
            productCategoryId: categoryId,
            orderByNewest: orderByNewest,
            orderByDiscount: orderByDiscount,
            orderByName: orderByName,
            orderByExpenses: orderByExpenses,
            isAlreadyLogin: isAlreadyLogin)
        .then((value) {
      if (value.values.first != null) {
      } else {
        showLoading(false);
        if (isLoadMore) {
          listProduct.addAll(value.keys.first!.data!.data!);
        } else {
          listProduct = value.keys.first!.data!.data!;
        }
        totalPage = value.keys.first!.data!.totalPage!;
        notifyListeners();
      }
      // ignore: invalid_return_type_for_catch_error
    }).catchError(print);
  }

  void doWishlist(Product product) {
    if (isAlreadyLogin) {
      notifyListeners();
      _productUsecase
          .actionProductWishlist(
              productId: product.id, storeId: product.storeId)
          .then((value) {
        showLoading(false);
        if (value.values.first != null) {
          getView()!.showError(value.values.first!.errors!, 0);
        } else {
          // getView().successWishList();
        }
        notifyListeners();
        // ignore: invalid_return_type_for_catch_error
      }).catchError(print);
    } else {
      getView()!.showNeedLogin();
    }
  }

  void addProduct(Product product, int qty) {
    if (isAlreadyLogin) {
      showLoading(true);
      notifyListeners();
      _orderUsecase
          .addToCart(productId: product.id, qty: qty, storeId: product.storeId)
          .then((value) {
        showLoading(false);
        if (value.values.first != null) {
          getView()!.showError(value.values.first!.errors, 0);
        } else {
          final payload = {
            "product_name": product.name,
            "quantity": qty.toString(),
            "plu_code": product.plu,
          };
          SmartechPlugin().trackEvent(TrackingUtils.ADD_TO_CART, payload);
          getView()!.successAddToCart();
        }
        notifyListeners();
      }).catchError((errorValue) {
        showLoading(false);
        getView()!.showErrorMessage(txt("empty_stock"));
      });
    } else {
      getView()!.showNeedLogin();
    }
  }

  void doRoutineShop(Product product) {
    if (!isAlreadyLogin) {
      getView()!.showNeedLogin();
      return;
    }
    notifyListeners();
    _productUsecase
        .actionProductShopRoutines(
            productId: product.id, storeId: product.storeId)
        .then((value) {
      showLoading(false);
      if (value.values.first != null) {
        getView()!.showError(value.values.first!.errors, 0);
      }
      notifyListeners();
      // ignore: invalid_return_type_for_catch_error
    }).catchError(print);
  }
}

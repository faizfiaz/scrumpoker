// ignore_for_file: invalid_return_type_for_catch_error

import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/domain/commons/tracking_utils.dart';
import 'package:SuperNinja/domain/models/entity/product.dart';
import 'package:SuperNinja/domain/models/response/response_profile.dart';
import 'package:SuperNinja/domain/repositories/order_repository.dart';
import 'package:SuperNinja/domain/repositories/product_repository.dart';
import 'package:SuperNinja/domain/usecases/order/order_usecase.dart';
import 'package:SuperNinja/domain/usecases/product/product_usecase.dart';
import 'package:SuperNinja/domain/usecases/user/user_usecase.dart';
import 'package:SuperNinja/ui/pages/search/search_navigator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/cupertino.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';

class SearchViewModel extends BaseViewModel<SearchNavigator> {
  TextEditingController searchController = TextEditingController();
  List<Product>? listProduct = [];
  int? totalProductFound = 0;
  late ProductUsecase _usecase;
  late OrderUsecase _orderUsecase;
  late UserUsecase _userUsecase;

  int currentPage = 1;
  bool isAlreadyLogin = false;
  int? totalPage = 0;

  String lastTextSearch = '';
  Profile? profile;

  bool isEmptyClAndStore = true;

  SearchViewModel() {
    _usecase = ProductUsecase(ProductRepository(dioClient));
    _orderUsecase = OrderUsecase(OrderRepository(dioClient));
    _userUsecase = UserUsecase.empty();
    initData();
    searchController.addListener(() {
      if (lastTextSearch != searchController.text.toString().toLowerCase()) {
        lastTextSearch = searchController.text.toString().toLowerCase();
        if (!isLoading) {
          loadProduct();
        }
      }
    });
  }

  void favoriteProduct(int index) {
    notifyListeners();
  }

  Future<void> loadProduct(
      {bool isInit = true, bool isLoadMore = false}) async {
    if (isInit) {
      currentPage = 1;
    }
    if (isLoadMore) {
      ++currentPage;
    } else {
      showLoading(true);
    }
    isAlreadyLogin = await _userUsecase.hasToken();
    if (searchController.text == "") {
      listProduct!.clear();
      showLoading(false);
      notifyListeners();
    } else if (searchController.text != "") {
      const categoryId = "";
      const orderByNewest = "";
      const orderByDiscount = "desc";
      const orderByExpenses = "";
      const perPageReal = "10";
      await _usecase
          .getListProduct(
              page: currentPage,
              perPage: int.parse(perPageReal),
              name: searchController.text,
              productCategoryId: categoryId,
              orderByNewest: orderByNewest,
              orderByDiscount: orderByDiscount,
              orderByExpenses: orderByExpenses,
              isAlreadyLogin: isAlreadyLogin && !isEmptyClAndStore)
          .then((value) {
        showLoading(false);
        if (value.values.first != null) {
        } else {
          if (!isLoadMore) {
            listProduct = value.keys.first!.data!.data;
          } else {
            listProduct!.addAll(value.keys.first!.data!.data!);
          }
          totalProductFound = value.keys.first!.data!.totalRecord;
          totalPage = value.keys.first!.data!.totalPage;
          if (searchController.text == "") {
            listProduct!.clear();
          }
          notifyListeners();
        }
      }).catchError(print);
    }
  }

  void addProduct(Product product, int qty) {
    if (isAlreadyLogin) {
      if (profile!.userCl == null && profile!.store == null) {
        ScreenUtils.showDialog(
            getView()!.getContext(),
            AlertType.warning,
            txt("title_warning_empty_agent_store"),
            txt("message_warning_empty_agent_store"));
        return;
      }
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

  void doWishlist(Product product) {
    if (isAlreadyLogin) {
      notifyListeners();
      _usecase
          .actionProductWishlist(
              productId: product.id, storeId: product.storeId)
          .then((value) {
        showLoading(false);
        if (value.values.first != null) {
          getView()!.showError(value.values.first!.errors, 0);
        } else {
          // getView().successWishList();
        }
        notifyListeners();
      }).catchError(print);
    } else {
      getView()!.showNeedLogin();
    }
  }

  Future<void> initData() async {
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
  }

  void doRoutineShop(Product product) {
    if (!isAlreadyLogin) {
      getView()!.showNeedLogin();
      return;
    }
    notifyListeners();
    _usecase
        .actionProductShopRoutines(
            productId: product.id, storeId: product.storeId)
        .then((value) {
      showLoading(false);
      if (value.values.first != null) {
        getView()!.showError(value.values.first!.errors, 0);
      }
      notifyListeners();
    }).catchError(print);
  }
}

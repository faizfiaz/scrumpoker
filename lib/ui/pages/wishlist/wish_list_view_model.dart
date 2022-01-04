// ignore_for_file: invalid_return_type_for_catch_error

import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/domain/commons/tracking_utils.dart';
import 'package:SuperNinja/domain/models/entity/product.dart';
import 'package:SuperNinja/domain/models/response/response_profile.dart';
import 'package:SuperNinja/domain/repositories/order_repository.dart';
import 'package:SuperNinja/domain/repositories/product_repository.dart';
import 'package:SuperNinja/domain/repositories/user_repository.dart';
import 'package:SuperNinja/domain/usecases/order/order_usecase.dart';
import 'package:SuperNinja/domain/usecases/product/product_usecase.dart';
import 'package:SuperNinja/domain/usecases/user/user_usecase.dart';
import 'package:SuperNinja/ui/pages/wishlist/wish_list_navigator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';

class WishListViewModel extends BaseViewModel<WishListNavigator> {
  late UserUsecase _usecase;
  late ProductUsecase _productUsecase;
  late OrderUsecase _orderUsecase;

  List<Product>? listProduct = [];
  bool isAlreadyLogin = false;
  int page = 1;
  int? totalPage = 0;

  Profile? profile;

  bool isEmptyClAndStore = true;

  WishListViewModel() {
    _usecase = UserUsecase(UserRepository(dioClient));
    _orderUsecase = OrderUsecase(OrderRepository(dioClient));
    _productUsecase = ProductUsecase(ProductRepository(dioClient));
    initData();
  }

  Future<void> initData() async {
    isAlreadyLogin = await _usecase.hasToken();
    showLoading(true);
    if (isAlreadyLogin) {
      await _usecase.fetchUserData().then((value) {
        if (value != null) {
          profile = value;
          if (profile!.userCl == null && profile!.store == null) {
            isEmptyClAndStore = true;
          } else {
            isEmptyClAndStore = false;
          }
        }
      }).catchError(print);
      await loadProduct();
    } else {
      showLoading(false);
    }
  }

  Future<void> loadProduct(
      {String? category,
      String? perPage,
      String? sort,
      bool isInit = true,
      bool isLoadMore = false}) async {
    if (isInit) {
      page = 1;
    }
    if (isLoadMore) {
      ++page;
    }
    var categoryId = "";
    var orderByNewest = "";
    var orderByDiscount = "desc";
    var orderByExpenses = "";
    var perPageReal = "10";

    if (category != null && category != "0") {
      categoryId = category;
    }

    if (perPage != null) {
      perPageReal = perPage.substring(0, 2);
    }

    if (sort != null) {
      if (txt("current_language") == "IND") {
        if (sort == "Diskon Terbesar") {
          orderByNewest = "";
          orderByDiscount = "desc";
          orderByExpenses = "";
        } else if (sort == "Termurah") {
          orderByNewest = "";
          orderByDiscount = "";
          orderByExpenses = "desc";
        } else if (sort == "Termahal") {
          orderByNewest = "";
          orderByDiscount = "";
          orderByExpenses = "asc";
        }
      } else {
        if (sort == "Biggest Discount") {
          orderByNewest = "";
          orderByDiscount = "desc";
          orderByExpenses = "";
        } else if (sort == "Cheapest") {
          orderByNewest = "";
          orderByDiscount = "";
          orderByExpenses = "asc";
        } else if (sort == "Most Expensive") {
          orderByNewest = "";
          orderByDiscount = "";
          orderByExpenses = "desc";
        }
      }
    }
    await _productUsecase
        .getListProduct(
            page: page,
            perPage: int.parse(perPageReal),
            name: "",
            productCategoryId: categoryId,
            orderByNewest: orderByNewest,
            orderByDiscount: orderByDiscount,
            orderByExpenses: orderByExpenses,
            isAlreadyLogin: isAlreadyLogin && !isEmptyClAndStore,
            isWishlist: true)
        .then((value) {
      showLoading(false);
      if (value.values.first != null) {
      } else {
        if (!isLoadMore) {
          listProduct = value.keys.first!.data!.data;
        } else {
          listProduct!.addAll(value.keys.first!.data!.data!);
        }
        totalPage = value.keys.first!.data!.totalPage;
        getView()!.doneGet();
        notifyListeners();
      }
    }).catchError(print);
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
    notifyListeners();
    _productUsecase
        .actionProductWishlist(productId: product.id, storeId: product.storeId)
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
    }).catchError(print);
  }
}

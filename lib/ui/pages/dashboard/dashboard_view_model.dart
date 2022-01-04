// ignore_for_file: invalid_return_type_for_catch_error

import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/domain/commons/tracking_utils.dart';
import 'package:SuperNinja/domain/models/entity/banners.dart';
import 'package:SuperNinja/domain/models/entity/category.dart';
import 'package:SuperNinja/domain/models/entity/product.dart';
import 'package:SuperNinja/domain/models/response/response_profile.dart';
import 'package:SuperNinja/domain/repositories/order_repository.dart';
import 'package:SuperNinja/domain/repositories/product_repository.dart';
import 'package:SuperNinja/domain/repositories/user_repository.dart';
import 'package:SuperNinja/domain/usecases/order/order_usecase.dart';
import 'package:SuperNinja/domain/usecases/product/product_usecase.dart';
import 'package:SuperNinja/domain/usecases/user/user_usecase.dart';
import 'package:SuperNinja/ui/pages/dashboard/dashboard_navigator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';

class DashboardViewModel extends BaseViewModel<DashboardNavigator> {
  late UserUsecase _usecase;
  late ProductUsecase _productUsecase;
  late OrderUsecase _orderUsecase;

  List<Category>? categoryList = [];
  List<Banners>? sliderBanners = [];
  List<Product>? listProduct = [];

  bool _isRefresh = false;
  bool isAlreadyLogin = false;
  bool isEmptyClAndStore = true;
  int allLoaded = 0;
  Profile? profile;

  int page = 1;
  int? totalPage = 0;

  String? sort;
  String categoryId = "";
  String perPageReal = "10";
  String orderByNewest = "";
  String orderByDiscount = "desc";
  String orderByExpenses = "";
  bool orderByName = false;

  DashboardViewModel() {
    _usecase = UserUsecase(UserRepository(dioClient));
    _productUsecase = ProductUsecase(ProductRepository(dioClient));
    _orderUsecase = OrderUsecase(OrderRepository(dioClient));
    initData();
  }

  Future<void> initData({bool isRefresh = false}) async {
    isAlreadyLogin = await _usecase.hasToken();
    _isRefresh = isRefresh;
    allLoaded = 0;
    showLoading(true);
    // ignore: unawaited_futures
    loadProfile();
  }

  void loadCategory() {
    _productUsecase.getListCategory().then((value) {
      if (value.values.first != null) {
      } else {
        categoryList = value.keys.first!.data;
        categoryList!.insert(0, Category(id: 0, name: txt("all"), iconUrl: ""));
        getView()!.updateListCategory(categoryList!.sublist(0, 10));
        checkIsRefresh();
        notifyListeners();
        loadDone();
      }
    }).catchError(print);
  }

  void checkIsRefresh() {
    if (_isRefresh) {
      getView()!.doneGet();
    }
  }

  Future<void> loadProduct(
      {String? category,
      String? perPage,
      String? sort,
      bool isInit = true,
      bool isLoadMore = false}) async {
    if (category != null) {
      if (category == "0") {
        categoryId = "";
      } else {
        categoryId = category;
      }
    }

    if (perPage != null) {
      perPageReal = perPage.substring(0, 2);
    }

    if (isInit) {
      page = 1;
    }
    if (isLoadMore) {
      ++page;
    } else {
      listProduct!.clear();
      showLoading(true);
      notifyListeners();
    }

    if (sort != null) {
      if (txt("current_language") == "IDN") {
        if (sort == "Diskon Terbesar") {
          orderByNewest = "";
          orderByDiscount = "desc";
          orderByExpenses = "";
          orderByName = false;
        } else if (sort == "Termurah") {
          orderByNewest = "";
          orderByDiscount = "";
          orderByExpenses = "asc";
          orderByName = false;
        } else if (sort == "Termahal") {
          orderByNewest = "";
          orderByDiscount = "";
          orderByExpenses = "desc";
          orderByName = false;
        } else if (sort == "Nama") {
          orderByNewest = "";
          orderByDiscount = "";
          orderByExpenses = "";
          orderByName = true;
        }
      } else {
        if (sort == "Biggest Discount") {
          orderByNewest = "";
          orderByDiscount = "desc";
          orderByExpenses = "";
          orderByName = false;
        } else if (sort == "Cheapest") {
          orderByNewest = "";
          orderByDiscount = "";
          orderByExpenses = "asc";
          orderByName = false;
        } else if (sort == "Most Expensive") {
          orderByNewest = "";
          orderByDiscount = "";
          orderByExpenses = "desc";
          orderByName = false;
        } else if (sort == "Name") {
          orderByNewest = "";
          orderByDiscount = "";
          orderByExpenses = "";
          orderByName = true;
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
            orderByName: orderByName,
            orderByExpenses: orderByExpenses,
            isAlreadyLogin: isAlreadyLogin && !isEmptyClAndStore)
        .then((value) {
      if (value.values.first != null) {
      } else {
        showLoading(false);
        if (isLoadMore) {
          listProduct!.addAll(value.keys.first!.data!.data!);
        } else {
          listProduct = value.keys.first!.data!.data;
        }
        totalPage = value.keys.first!.data!.totalPage;
        checkIsRefresh();
        notifyListeners();
        if (isInit) {
          loadDone();
        }
      }
    }).catchError(print);
  }

  void loadSliderBanner() {
    _productUsecase.getListBanners().then((value) {
      if (value.values.first != null) {
      } else {
        sliderBanners = value.keys.first!.data;
        checkIsRefresh();
        notifyListeners();
        loadDone();
      }
    }).catchError(print);
  }

  void loadDone() {
    ++allLoaded;
    if (allLoaded == 3) {
      showLoading(false);
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
      _productUsecase
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

  Future<void> loadProfile() async {
    if (isAlreadyLogin) {
      await _usecase.getProfile().then((value) async {
        if (value.values.first != null) {
          getView()!.showError(
              value.values.first!.errors, value.values.first!.httpCode);
        } else {
          profile = value.keys.first!.data;
          if (profile != null) {
            if (profile!.userCl == null && profile!.store == null) {
              isEmptyClAndStore = true;
            } else {
              isEmptyClAndStore = false;
            }
          }
          notifyListeners();
        }
      }).catchError(print);
    }
    loadCategory();
    await loadProduct();
    loadSliderBanner();
  }

  Future<void> changeStore(int id) async {
    showLoading(true);
    await _usecase.doChangeStore(id: id).then((value) {
      showLoading(false);
      if (value.values.first != null) {
        getView()!.showError(
            value.values.first!.errors, value.values.first!.httpCode);
      } else {
        initData(isRefresh: true);
        getView()!.refreshHome();
      }
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

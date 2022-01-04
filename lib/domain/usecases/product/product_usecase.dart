import 'package:SuperNinja/data/sharedpreference/user_preferences.dart';
import 'package:SuperNinja/domain/models/entity/no_content.dart';
import 'package:SuperNinja/domain/models/error/error_message.dart';
import 'package:SuperNinja/domain/models/response/response_detail_product.dart';
import 'package:SuperNinja/domain/models/response/response_list_banners.dart';
import 'package:SuperNinja/domain/models/response/response_list_category_product.dart';
import 'package:SuperNinja/domain/models/response/response_list_product.dart';
import 'package:SuperNinja/domain/repositories/product_repository.dart';

import 'i_product_usecase.dart';

class ProductUsecase extends IProductUsecase {
  final userSp = UserPreferences();

  ProductUsecase(ProductRepository repository) : super(repository);

  ProductUsecase.empty() : super(null);

  @override
  Future<Map<ResponseListCategory?, ErrorMessage?>> getListCategory() async {
    disposeVariable();
    ResponseListCategory? response;
    await repository?.getListCategory().then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<ResponseListBanners?, ErrorMessage?>> getListBanners() async {
    disposeVariable();
    ResponseListBanners? response;
    await repository?.getListBanners().then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<ResponseListProduct?, ErrorMessage?>> getListProduct(
      {int? page,
      int? perPage,
      String? name,
      String? productCategoryId,
      String? orderByNewest,
      String? orderByDiscount,
      bool? orderByName,
      String? orderByExpenses,
      bool isAlreadyLogin = false,
      bool isPromo = false,
      bool isWishlist = false,
      bool isShopRoutine = false}) async {
    disposeVariable();
    ResponseListProduct? response;
    await repository
        ?.getListProducts(
            page: page,
            perPage: perPage,
            name: name,
            productCategoryId: productCategoryId,
            orderByNewest: orderByNewest,
            orderByDiscount: orderByDiscount,
            orderByName: orderByName,
            orderByExpenses: orderByExpenses,
            isAlreadyLogin: isAlreadyLogin,
            isPromo: isPromo,
            isWishlist: isWishlist,
            isShopRoutine: isShopRoutine)
        .then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<ResponseDetailProduct?, ErrorMessage?>> getDetailProduct(
      {String? productId,
      bool? alreadyLogin = false,
      bool isScanBarcode = false}) async {
    disposeVariable();
    ResponseDetailProduct? response;
    await repository
        ?.getDetailProduct(
            productId: productId,
            alreadyLogin: alreadyLogin!,
            isScanBarcode: isScanBarcode)
        .then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<NoContent?, ErrorMessage?>> actionProductWishlist(
      {int? productId, int? storeId}) async {
    disposeVariable();
    NoContent? response;
    await repository
        ?.actionProductWishlist(productId: productId, storeId: storeId)
        .then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<NoContent?, ErrorMessage?>> actionProductShopRoutines(
      {int? productId, int? storeId}) async {
    disposeVariable();
    NoContent? response;
    await repository!
        .actionProductShopRoutines(productId: productId!, storeId: storeId!)
        .then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }
}

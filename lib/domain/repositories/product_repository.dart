import 'package:scrumpoker/data/remote/dio_client.dart';
import 'package:scrumpoker/data/remote/endpoints/product_endpoints.dart';
import 'package:scrumpoker/domain/models/entity/no_content.dart';
import 'package:scrumpoker/domain/models/response/response_detail_product.dart';
import 'package:scrumpoker/domain/models/response/response_list_banners.dart';
import 'package:scrumpoker/domain/models/response/response_list_category_product.dart';
import 'package:scrumpoker/domain/models/response/response_list_product.dart';
import 'package:scrumpoker/domain/repositories/base_repository.dart';

class ProductRepository extends BaseRepository {
  ProductRepository(DioClient? dioClient) : super(dioClient);

  dynamic data;

  Future<ResponseListCategory> getListCategory() async {
    await dioClient!.get(ProductEndpoints.urlListCategory).then((value) {
      data = value;
    });
    return ResponseListCategory.fromJson(data);
  }

  Future<ResponseDetailProduct> getDetailProduct(
      {String? productId,
      required bool alreadyLogin,
      bool isScanBarcode = false}) async {
    await dioClient!
        .get(ProductEndpoints.urlDetailProduct(
            productId: productId,
            alreadyLogin: alreadyLogin,
            isBarcode: isScanBarcode))
        .then((value) {
      data = value;
    });
    return ResponseDetailProduct.fromJson(data);
  }

  Future<ResponseListProduct> getListProducts(
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
    await dioClient!
        .get(ProductEndpoints.urlListProduct(
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
            isShoproutine: isShopRoutine))
        .then((value) {
      data = value;
    });
    return ResponseListProduct.fromJson(data);
  }

  Future<ResponseListBanners> getListBanners() async {
    await dioClient!.get(ProductEndpoints.urlListBanners).then((value) {
      data = value;
    });
    return ResponseListBanners.fromJson(data);
  }

  Future<NoContent> actionProductWishlist(
      {required int? productId, required int? storeId}) async {
    await dioClient!.post(ProductEndpoints.urlActionProductWishlist,
        data: {"product_id": productId, "store_id": storeId}).then((value) {
      data = value;
      // ignore: invalid_return_type_for_catch_error
    }).catchError(print);
    return NoContent();
  }

  Future<NoContent> actionProductShopRoutines(
      {required int productId, required int storeId}) async {
    await dioClient!.post(ProductEndpoints.urlActionProductShopRoutines,
        data: {"product_id": productId, "store_id": storeId}).then((value) {
      data = value;
      // ignore: invalid_return_type_for_catch_error
    }).catchError(print);
    return NoContent();
  }
}

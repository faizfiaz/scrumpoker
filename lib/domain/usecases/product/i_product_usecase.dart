import 'package:SuperNinja/domain/models/entity/no_content.dart';
import 'package:SuperNinja/domain/models/error/error_message.dart';
import 'package:SuperNinja/domain/models/response/response_detail_product.dart';
import 'package:SuperNinja/domain/models/response/response_list_banners.dart';
import 'package:SuperNinja/domain/models/response/response_list_category_product.dart';
import 'package:SuperNinja/domain/models/response/response_list_product.dart';
import 'package:SuperNinja/domain/repositories/product_repository.dart';

import '../base_usecase.dart';

abstract class IProductUsecase extends BaseUsecase<ProductRepository?> {
  IProductUsecase(ProductRepository? repository) : super(repository);

  Future<Map<ResponseListCategory?, ErrorMessage?>> getListCategory();

  Future<Map<ResponseDetailProduct?, ErrorMessage?>> getDetailProduct(
      {String? productId, bool? alreadyLogin});

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
      bool isWishlist = false});

  Future<Map<ResponseListBanners?, ErrorMessage?>> getListBanners();

  Future<Map<NoContent?, ErrorMessage?>> actionProductWishlist(
      {required int productId, required int storeId});

  Future<Map<NoContent?, ErrorMessage?>> actionProductShopRoutines(
      {required int productId, required int storeId});
}

import 'package:SuperNinja/data/remote/endpoints/endpoints.dart';

class ProductEndpoints {
  ProductEndpoints._();

  static String urlListCategory =
      '${Endpoints().baseUrl!}/v1/product-categories';
  static String urlListBanners = '${Endpoints().baseUrl!}/v1/banners';

  static String urlListProduct(
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
      bool isShoproutine = false}) {
    return "${Endpoints().baseUrl!}/v1/${isAlreadyLogin ? "products" : "base-products"}?page=$page&per_page=$perPage&name=$name&product_category_id=$productCategoryId&order_by_newest=$orderByNewest&order_by_discount=$orderByDiscount&order_by_name=$orderByName&order_by_expenses=$orderByExpenses&is_promo=$isPromo&is_wishlist=$isWishlist&is_routine_shopping_list=$isShoproutine";
  }

  static String urlDetailProduct(
      {String? productId, required bool alreadyLogin, bool isBarcode = false}) {
    return "${Endpoints().baseUrl!}/v1/${alreadyLogin ? "products" : "base-products"}/$productId${isBarcode ? "?is_barcode=1" : ""}";
  }

  static String urlActionProductWishlist =
      '${Endpoints().baseUrl!}/v1/products/wishlist';

  static String urlActionProductShopRoutines =
      '${Endpoints().baseUrl!}/v1/routine-shopping-list';
}

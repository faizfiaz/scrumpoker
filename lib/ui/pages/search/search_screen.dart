import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/domain/models/entity/product.dart';
import 'package:SuperNinja/ui/pages/dashboard/widgets/list_item_generic.dart';
import 'package:SuperNinja/ui/pages/detailProduct/detail_product_screen.dart';
import 'package:SuperNinja/ui/pages/login/login_screen.dart';
import 'package:SuperNinja/ui/pages/search/search_navigator.dart';
import 'package:SuperNinja/ui/pages/search/search_view_model.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchScreen();
  }
}

class _SearchScreen extends BaseStateWidget<SearchScreen>
    implements SearchNavigator {
  SearchViewModel? _viewModel;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _viewModel = SearchViewModel().setView(this) as SearchViewModel?;
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
        } else {
          if (_viewModel!.totalPage! >= _viewModel!.currentPage) {
            _viewModel!.loadProduct(isInit: false, isLoadMore: true);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<SearchViewModel>(
            builder: (context, viewModel, _) => Scaffold(
                  appBar: appBarSearch() as PreferredSizeWidget?,
                  body: Container(
                    color: greysBackgroundMedium,
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (_viewModel!.isLoading)
                          Expanded(child: LoadingIndicator())
                        else
                          _viewModel!.listProduct!.isNotEmpty
                              ? buildListData()
                              : buildEmptyData()
                      ],
                    ),
                  ),
                )));
  }

  Widget appBarSearch() {
    return AppBar(
      backgroundColor: primary,
      elevation: 4,
      titleSpacing: 0,
      title: Container(
        height: 44,
        margin: const EdgeInsets.only(right: 16),
        width: double.infinity,
        alignment: Alignment.centerLeft,
        child: Card(
          child: TextField(
            controller: _viewModel!.searchController,
            style: const TextStyle(fontSize: 12),
            decoration: InputDecoration(
                hintText: txt("find_product_here"),
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search)),
          ),
        ),
      ),
      leading: IconButton(
        iconSize: 28,
        padding: EdgeInsets.zero,
        icon: const Icon(Feather.chevron_left, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  void seeDetailProduct(Product product) {
    push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DetailProductScreen(false, product: product)));
  }

  void favoritProduct(int index) {
    _viewModel!.favoriteProduct(index);
  }

  Widget buildListData() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Text(
              txt("found_text")
                  .toString()
                  .replaceFirst(
                    "%s",
                    _viewModel!.totalProductFound.toString(),
                  )
                  .replaceFirst("%t", _viewModel!.searchController.text),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          Expanded(
              child: ListItemGeneric(
            _viewModel!.listProduct,
            scrollable: true,
            scrollController: _scrollController,
            callbackAddProduct: addProduct,
            callbackWishlist: doWishlist,
            callbackRoutineShop: doRoutineShop,
            alreadyLogin: _viewModel!.isAlreadyLogin,
          )),
        ],
      ),
    );
  }

  void addProduct(Product product, int qty) {
    _viewModel!.addProduct(product, qty);
  }

  void doWishlist(Product product) {
    _viewModel!.doWishlist(product);
  }

  void doRoutineShop(Product product) {
    _viewModel!.doRoutineShop(product);
  }

  @override
  Future<void> showNeedLogin() async {
    showLoginPage();
  }

  @override
  void successAddToCart() {
    ScreenUtils.showToastMessage(txt("success_add_to_cart"));
  }

  void showLoginPage() {
    push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void successWishList() {
    ScreenUtils.showToastMessage(txt("success_add_to_wishlist"));
  }

  Widget buildEmptyData() {
    return Expanded(
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              imgSearch,
              width: 240,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Text(
                txt("find_product"),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: primary, fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void showErrorMessage(String? message) {
    ScreenUtils.showToastMessage(message!);
  }

  @override
  BuildContext getContext() {
    return context;
  }
}

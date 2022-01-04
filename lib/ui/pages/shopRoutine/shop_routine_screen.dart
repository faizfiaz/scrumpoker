import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/other_utils.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/domain/models/entity/product.dart';
import 'package:SuperNinja/ui/pages/dashboard/widgets/list_item_generic.dart';
import 'package:SuperNinja/ui/pages/detailProduct/detail_product_screen.dart';
import 'package:SuperNinja/ui/pages/login/login_screen.dart';
import 'package:SuperNinja/ui/pages/shopRoutine/shop_routine_navigator.dart';
import 'package:SuperNinja/ui/pages/shopRoutine/shop_routine_view_model.dart';
import 'package:SuperNinja/ui/widgets/default_button.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// ignore: must_be_immutable
class ShopRoutineScreen extends StatefulWidget {
  Function()? callbackProduct;

  ShopRoutineScreen({this.callbackProduct});

  @override
  State<StatefulWidget> createState() {
    return _ShopRoutineScreenState();
  }
}

class _ShopRoutineScreenState extends BaseStateWidget<ShopRoutineScreen>
    with SingleTickerProviderStateMixin
    implements ShopRoutineNavigator, LoadMoreDelegate {
  late ShopRoutineViewModel? _viewModel;

  final RefreshController _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _viewModel = ShopRoutineViewModel().setView(this) as ShopRoutineViewModel?;
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
        } else {
          if (_viewModel!.totalPage >= _viewModel!.page) {
            _viewModel!.loadProduct(isInit: false, isLoadMore: true);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<ShopRoutineViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<ShopRoutineViewModel?>(
          builder: (context, viewModel, _) => Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: double.infinity,
                color: greysBackgroundMedium,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      alignment: Alignment.topRight,
                      child: Card(
                        child: InkWell(
                          onTap: checkCart,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              txt("add_all_to_cart"),
                              style: const TextStyle(color: primary),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (_viewModel!.isAlreadyLogin)
                      Expanded(
                        child: SmartRefresher(
                            header: const ClassicHeader(),
                            controller: _refreshController,
                            onRefresh: _onRefresh,
                            child: _viewModel!.listProduct.isNotEmpty
                                ? CustomScrollView(
                                    controller: _scrollController,
                                    slivers: <Widget>[
                                      SliverList(
                                        delegate: SliverChildListDelegate([
                                          ListItemGeneric(
                                            _viewModel!.listProduct,
                                            callbackProduct: showDetailProduct,
                                            callbackAddProduct: addProduct,
                                            callbackWishlist: doWishlist,
                                            callbackRoutineShop: doRoutineShop,
                                            alreadyLogin:
                                                _viewModel!.isAlreadyLogin,
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                        ]),
                                      )
                                    ],
                                  )
                                : buildEmptyData()),
                      )
                    else
                      buildNeedLogin()
                  ],
                ),
              ),
              if (viewModel!.isLoading) LoadingIndicator() else Container()
            ],
          ),
        ));
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    await _viewModel!.loadProduct();
  }

  @override
  void doneGet() {
    _refreshController.refreshCompleted();
  }

  void showDetailProduct(Product product) {
    push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DetailProductScreen(false, product: product)));
  }

  void addProduct(Product product, int qty) {
    _viewModel!.addProduct(product, qty);
  }

  @override
  void successAddToCart() {
    if (widget.callbackProduct != null) {
      ScreenUtils.showToastMessage(txt("success_add_to_cart"));
      widget.callbackProduct?.call();
    }
  }

  @override
  void showNeedLogin() {
    push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget buildChild(LoadMoreStatus status,
      {LoadMoreTextBuilder builder = DefaultLoadMoreTextBuilder.chinese}) {
    if (status != LoadMoreStatus.nomore) {
      return Container(
        color: Colors.transparent,
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircularProgressIndicator(
              backgroundColor: white,
              valueColor: AlwaysStoppedAnimation<Color>(primary),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(OtherUtils.buildLoadMoreText(status) ?? "")
          ],
        )),
      );
    } else {
      return Container();
    }
  }

  @override
  Duration loadMoreDelay() {
    return const DefaultLoadMoreDelegate().loadMoreDelay();
  }

  @override
  double widgetHeight(LoadMoreStatus status) {
    return const DefaultLoadMoreDelegate().widgetHeight(status);
  }

  void doWishlist(Product product) {
    _viewModel!.doWishlist(product);
  }

  Future<void> checkCart() async {
    await _viewModel!.checkCart().then((value) => {
          // ignore: unnecessary_null_comparison
          if (value != null) {handleClearCart()} else {doAddAllToCart()}
        });
  }

  void doAddAllToCart() {
    _viewModel!.doAddAllToCart();
  }

  void handleClearCart() {
    ScreenUtils.showAlertClearCartShopRoutine(context, (isClearCart) {
      if (isClearCart) {
        _viewModel!.clearCart();
      } else {
        doAddAllToCart();
      }
    });
  }

  Future<void> doRoutineShop(Product product) async {
    if (product.isRoutineShop!) {
      await ScreenUtils.showAlertRemoveShopRoutine(
              context, _viewModel!, product)
          .then((value) {
        if (value) {
          _viewModel!.loadProduct();
        }
      });
    } else {
      _viewModel!.doRoutineShop(product);
    }
  }

  Widget buildNeedLogin() {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              imgNeedLogin,
              width: 120,
              height: 240,
            ),
            const SizedBox(
              height: 24,
            ),
            const Text("You must login to access this page"),
            const SizedBox(
              height: 12,
            ),
            DefaultButton.redButtonSmall(context, "Login", () {
              push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            })
          ],
        ),
      ),
    );
  }

  Widget buildEmptyData() {
    return Expanded(
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              imgEmptyCart,
              width: 240,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Text(
                txt("empty_shop_routine"),
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
  void showErrorMessage(String message) {
    ScreenUtils.showToastMessage(message);
  }
}

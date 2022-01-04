import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/other_utils.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/domain/models/entity/product.dart';
import 'package:SuperNinja/ui/pages/dashboard/widgets/list_item_generic.dart';
import 'package:SuperNinja/ui/pages/detailProduct/detail_product_screen.dart';
import 'package:SuperNinja/ui/pages/login/login_screen.dart';
import 'package:SuperNinja/ui/pages/promo/promo_navigator.dart';
import 'package:SuperNinja/ui/pages/promo/promo_view_model.dart';
import 'package:SuperNinja/ui/pages/search/search_screen.dart';
import 'package:SuperNinja/ui/widgets/always_disabled_focus_node.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// ignore: must_be_immutable
class PromoScreen extends StatefulWidget {
  Function()? callbackProduct;

  PromoScreen({this.callbackProduct});

  @override
  State<StatefulWidget> createState() {
    return _PromoScreen();
  }
}

class _PromoScreen extends BaseStateWidget<PromoScreen>
    with SingleTickerProviderStateMixin
    implements PromoNavigator, LoadMoreDelegate {
  PromoViewModel? _viewModel;

  final RefreshController _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _viewModel = PromoViewModel().setView(this) as PromoViewModel?;
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
        } else {
          if (_viewModel!.totalPage! >= _viewModel!.page) {
            _viewModel!.loadProduct(isInit: false, isLoadMore: true);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<PromoViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<PromoViewModel>(
          builder: (context, viewModel, _) => Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: double.infinity,
                color: greysBackgroundMedium,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildSearchBox(),
                    Expanded(
                      child: SmartRefresher(
                        header: const ClassicHeader(),
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        child: _viewModel!.listProduct!.isEmpty
                            ? buildEmptyProductState()
                            : ListItemGeneric(
                                _viewModel!.listProduct,
                                scrollable: true,
                                scrollController: _scrollController,
                                callbackProduct: showDetailProduct,
                                callbackAddProduct: addProduct,
                                callbackWishlist: doWishlist,
                                callbackRoutineShop: doRoutineShop,
                                alreadyLogin: _viewModel!.isAlreadyLogin,
                              ),
                      ),
                    )
                  ],
                ),
              ),
              if (viewModel.isLoading) LoadingIndicator() else Container()
            ],
          ),
        ));
  }

  Widget buildEmptyProductState() {
    return Container(
      alignment: Alignment.center,
      color: greysBackgroundMedium,
      child: Column(
        children: [
          SvgPicture.asset(
            imgRelaxing,
            width: 300,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            txt("empty_product_message"),
            textAlign: TextAlign.center,
            style: const TextStyle(color: primary),
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    await _viewModel!.loadProduct();
  }

  @override
  void doneGet() {
    _refreshController.refreshCompleted();
  }

  void openSearchPage() {
    push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
  }

  Widget buildSearchBox() {
    return Container(
      color: Colors.white,
      height: 68,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      alignment: Alignment.center,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: TextField(
          style: const TextStyle(fontSize: 12),
          enableInteractiveSelection: false,
          focusNode: AlwaysDisabledFocusNode(),
          onTap: openSearchPage,
          decoration: InputDecoration(
              hintText: txt("find_thing"),
              filled: true,
              fillColor: greysMedium,
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search)),
        ),
      ),
    );
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
  void showNeedLogin() {
    push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  void successAddToCart() {
    if (widget.callbackProduct != null) {
      ScreenUtils.showToastMessage(txt("success_add_to_cart"));
      widget.callbackProduct!.call();
    }
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
            Text(OtherUtils.buildLoadMoreText(status)!)
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

  void doRoutineShop(Product product) {
    _viewModel!.doRoutineShop(product);
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

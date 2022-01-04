import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/other_utils.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/domain/models/entity/category.dart';
import 'package:SuperNinja/domain/models/entity/product.dart';
import 'package:SuperNinja/ui/pages/changeCL/change_cl_screen.dart';
import 'package:SuperNinja/ui/pages/dashboard/dashboard_navigator.dart';
import 'package:SuperNinja/ui/pages/dashboard/dashboard_view_model.dart';
import 'package:SuperNinja/ui/pages/dashboard/widgets/category_widget.dart';
import 'package:SuperNinja/ui/pages/detailProduct/detail_product_screen.dart';
import 'package:SuperNinja/ui/pages/login/login_screen.dart';
import 'package:SuperNinja/ui/pages/search/search_screen.dart';
import 'package:SuperNinja/ui/pages/selectPage/select_page_screen.dart';
import 'package:SuperNinja/ui/widgets/always_disabled_focus_node.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator_only.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'widgets/banner_dashboard_widget.dart';
import 'widgets/list_item_generic.dart';

// ignore: must_be_immutable
class DashboardScreen extends StatefulWidget {
  late _DashboardScreen stateDashboard;

  Function()? callbackProduct;

  DashboardScreen({this.callbackProduct});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    stateDashboard = _DashboardScreen();
    return stateDashboard;
  }
}

class _DashboardScreen extends BaseStateWidget<DashboardScreen>
    with SingleTickerProviderStateMixin
    implements DashboardNavigator, LoadMoreDelegate {
  DashboardViewModel? _viewModel;

  final RefreshController _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();
  late CategoryWidget categoryWidget;

  bool autoPlayBanner = true;

  @override
  void initState() {
    super.initState();
    // categoryWidget = CategoryWidget(const [], const [], changeParameter);
    // _viewModel = DashboardViewModel().setView(this) as DashboardViewModel?;

    _viewModel = DashboardViewModel().setView(this) as DashboardViewModel?;
    categoryWidget = CategoryWidget(
      const [],
      const [],
      changeParameter,
      isLogin: _viewModel!.isAlreadyLogin,
    );

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
          setState(() {
            autoPlayBanner = true;
          });
        } else {
          if (_viewModel!.totalPage! >= _viewModel!.page) {
            setState(() {
              autoPlayBanner = false;
            });
            _viewModel!.loadProduct(isInit: false, isLoadMore: true);
          }
        }
      }
    });
  }

  @override
  void onResume() {
    if (widget.callbackProduct != null) {
      widget.callbackProduct!.call();
    }
  }

  void changeParameter(String category, String perPage, String sort) {
    _viewModel!.loadProduct(category: category, perPage: perPage, sort: sort);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DashboardViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<DashboardViewModel>(
          builder: (context, viewModel, _) => Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(child: buildSearchBox()),
                            Container(
                                margin: const EdgeInsets.only(
                                    right: 15, bottom: 15),
                                child: GestureDetector(
                                  onTap: openScanner,
                                  child: const Icon(
                                    Icons.qr_code,
                                    size: 40,
                                  ),
                                ))
                          ],
                        ),
                        Expanded(
                          child: SmartRefresher(
                              header: const ClassicHeader(),
                              controller: _refreshController,
                              scrollController: _scrollController,
                              onRefresh: onRefresh,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    buildStoreOrAgent(),
                                    BannerDashboardWidget(
                                        _viewModel!.sliderBanners,
                                        autoPlayBanner: autoPlayBanner),
                                    categoryWidget,
                                    if (_viewModel!.listProduct!.isNotEmpty)
                                      ListItemGeneric(
                                        _viewModel!.listProduct,
                                        callbackProduct: showDetailProduct,
                                        callbackAddProduct: addProduct,
                                        callbackRoutineShop: doRoutineShop,
                                        callbackWishlist: doWishlist,
                                        alreadyLogin:
                                            _viewModel!.isAlreadyLogin,
                                      )
                                    else
                                      buildEmptyProductState(),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                  ],
                                ),
                              )),
                        )
                      ],
                    ),
                    if (_viewModel!.isLoading)
                      LoadingIndicator()
                    else
                      Container()
                  ],
                ),
              ),
              if (viewModel.isLoading) LoadingIndicator() else Container()
            ],
          ),
        ));
  }

  Future<void> onRefresh() async {
    await _refreshController.requestRefresh();
    categoryWidget.categoryState.currentPerPageShadow = null;
    categoryWidget.categoryState.currentSortShadow = null;
    await _viewModel!.initData(isRefresh: true);
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
              hintText: txt("search_product"),
              filled: true,
              fillColor: greysMedium,
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search)),
        ),
      ),
    );
  }

  @override
  void updateListCategory(List<Category> categoryList) {
    categoryWidget.categoryList = categoryList;
    categoryWidget.fullCategoryList = _viewModel!.categoryList;
    categoryWidget.categoryState.setState(() {});
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
  // ignore: avoid_void_async
  void showNeedLogin() async {
    showLoginPage();
  }

  @override
  void successAddToCart() {
    if (widget.callbackProduct != null) {
      ScreenUtils.showToastMessage(txt("success_add_to_cart"));
      widget.callbackProduct!.call();
    }
  }

  void showLoginPage() {
    push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void doWishlist(Product product) {
    _viewModel!.doWishlist(product);
  }

  void doRoutineShop(Product product) {
    _viewModel!.doRoutineShop(product);
  }

  @override
  void successWishList() {
    ScreenUtils.showToastMessage(txt("success_add_to_wishlist"));
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

  @override
  void showErrorMessage(String? message) {
    ScreenUtils.showToastMessage(message!);
  }

  Widget buildStoreOrAgent() {
    if (_viewModel!.profile != null) {
      if (_viewModel!.isEmptyClAndStore) {
        return buildInfoStoreAgent(
            null, txt("empty_store_and_agent_2"), Ionicons.warning_sharp);
      } else if (_viewModel!.profile!.userCl != null) {
        return buildInfoStoreAgent(
            txt("agent_choosed"),
            _viewModel!.profile!.userCl!.name ?? "",
            Ionicons.ios_person_circle_sharp);
      } else if (_viewModel!.profile!.store != null) {
        return buildInfoStoreAgent(txt("store_choosed"),
            _viewModel!.profile!.store!.name, FontAwesome.map_marker);
      } else {
        return Container();
      }
    } else {
      if (_viewModel!.isAlreadyLogin) {
        return Container(
            color: Colors.white,
            width: double.infinity,
            alignment: Alignment.center,
            child: LoadingIndicatorOnly());
      } else {
        return Container();
      }
    }
  }

  Widget buildInfoStoreAgent(String? title, String value, IconData icon) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 20, right: 20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              Text(title,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500))
            else
              Container(),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(icon, color: primary, size: 26),
                const SizedBox(
                  width: 6,
                ),
                Text(value,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold)),
                const Expanded(child: SizedBox()),
                Material(
                  child: InkWell(
                    onTap: openOptionStoreAgent,
                    child: Row(
                      children: [
                        Text(
                          title == null
                              ? txt("choose_store_or_agent")
                              : txt("change_store_or_agent"),
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: primary),
                        ),
                        const Icon(Ionicons.arrow_forward_sharp,
                            color: primary, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  void openOptionStoreAgent() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, modalState) {
            return Container(
              color: Colors.white,
              child: Wrap(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          txt("choose_store_or_agent"),
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                      ),
                      const Divider(
                        color: greys,
                        height: 0.5,
                      ),
                      buildOptionStoreAgent(txt("store"), txt("desc_store"),
                          FontAwesome.map_marker, () {
                        Navigator.pop(context);
                        openSelectPage(TypeSelect.store);
                      }),
                      const Divider(
                        color: greys,
                        height: 0.5,
                      ),
                      buildOptionStoreAgent(
                          txt("community_leader"),
                          txt("desc_agent"),
                          Ionicons.ios_person_circle_sharp, () {
                        Navigator.pop(context);
                        displayChangeCL();
                      }),
                      const Divider(
                        color: greys,
                        height: 0.5,
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  Widget buildOptionStoreAgent(
      String title, String value, IconData icon, Function() action) {
    return Material(
      color: white,
      child: InkWell(
        onTap: action,
        child: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Icon(icon, color: primary),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                          color: primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                value,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> openSelectPage(TypeSelect typeSelect) async {
    int? id;
    final data = await push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectPageScreen(
                  typeSelect,
                  id: id,
                )));
    if (data != null) {
      ScreenUtils.showConfirmDialog(
          context,
          AlertType.info,
          txt("title_change_store_or_agent"),
          txt("message_change_store_or_agent"), () {
        _viewModel!.changeStore(data.id);
      });
    }
  }

  Future<void> displayChangeCL() async {
    final data = await push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeCLScreen(_viewModel!.profile)));
    if (data != null && data == true) {
      await _viewModel!.initData(isRefresh: true);
      widget.callbackProduct?.call();
    }
  }

  @override
  void refreshHome() {
    widget.callbackProduct?.call();
  }

  @override
  BuildContext getContext() {
    return context;
  }

  Future<void> openScanner() async {
    final result = await FlutterBarcodeScanner.scanBarcode(
        "#FFE53535", txt("cancel"), false, ScanMode.DEFAULT);
    if (result != "-1") {
      await push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DetailProductScreen(true, productSKU: result)));
    } else {
      ScreenUtils.showToastMessage(txt("failed_scan_barcode"));
    }
  }
}

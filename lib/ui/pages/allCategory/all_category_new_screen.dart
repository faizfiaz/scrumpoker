// ignore_for_file: deprecated_member_use

import 'dart:typed_data';

import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/domain/commons/formatter_number.dart';
import 'package:SuperNinja/domain/commons/other_utils.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/domain/models/entity/product.dart';
import 'package:SuperNinja/ui/pages/login/login_screen.dart';
import 'package:SuperNinja/ui/pages/search/search_screen.dart';
import 'package:SuperNinja/ui/widgets/keyboard_avoiding.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/vertical_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../constant/color.dart';
import '../../../domain/commons/base_state_widget.dart';
import '../../../domain/models/entity/category.dart';
import '../../widgets/always_disabled_focus_node.dart';
import '../../widgets/multilanguage.dart';
import 'all_category_navigator.dart';
import 'all_category_view_model.dart';

// ignore: must_be_immutable
class AllCategoryNewScreenPage extends StatefulWidget {
  List<Category> listCategory = [];
  final bool isLogin;

  AllCategoryNewScreenPage(this.listCategory, {this.isLogin = false}) : super();

  @override
  State<StatefulWidget> createState() {
    return _AllCategoryNewScreeState();
  }
}

class _AllCategoryNewScreeState
    extends BaseStateWidget<AllCategoryNewScreenPage>
    implements AllCategoryNavigator {
  AllCategoryViewModel? _viewModel;
  TextEditingController controllerQuantity = TextEditingController(text: "1");
  ByteData? imagePlaceHolder;
  Uint8List? placeholderBuffer;
  BuildContext? contextDialog;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _viewModel = AllCategoryViewModel(widget.listCategory,
            isAlreadyLogin: widget.isLogin)
        .setView(this) as AllCategoryViewModel?;
    super.initState();
    rootBundle.load(placeholderProduct).then((data) => setState(() {
          imagePlaceHolder = data;
          placeholderBuffer = imagePlaceHolder?.buffer.asUint8List();
        }));
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
        } else {
          if (_viewModel!.totalPage >= _viewModel!.page) {
            _viewModel!.getProductByCategory(isInit: false, isLoadMore: true);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AllCategoryViewModel?>(
      create: (context) => _viewModel,
      child: Consumer<AllCategoryViewModel?>(
        builder: (context, viewModel, _) => Scaffold(
          appBar: buildSearchBar(),
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    buildSearchBox(),
                    Expanded(
                        child: VerticalTabs(
                      disabledChangePageFromContentView: true,
                      tabsWidth: 110,
                      selectedTabBackgroundColor: Colors.transparent,
                      indicatorColor: primary,
                      tabs: createTab(),
                      contents: createContents(),
                      onSelect: onSelect,
                    ))
                  ],
                ),
                if (_viewModel!.isLoading) LoadingIndicator() else Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildSearchBar() {
    return AppBar(
      elevation: 0,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                IconButton(
                  iconSize: 28,
                  icon: const Icon(Feather.chevron_left, color: primary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Text(
                  txt("all_category"),
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      color: primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchBox() {
    return Container(
      color: Colors.white,
      height: 68,
      padding: const EdgeInsets.only(left: 16, right: 16),
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

  List<Tab> createTab() {
    final tabs = <Tab>[];
    for (var i = 0; i < widget.listCategory.length; i++) {
      tabs.add(Tab(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Text(
              widget.listCategory[i].name ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      ));
    }
    return tabs;
  }

  List<Widget> createContents() {
    final widgets = <Widget>[];
    for (var i = 0; i < widget.listCategory.length; i++) {
      widgets.add(tabsContent(widget.listCategory[i].name ?? ""));
    }
    return widgets;
  }

  Widget tabsContent(String caption) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: ListView.builder(
          controller: _scrollController,
          itemCount: _viewModel!.listProduct.length,
          itemBuilder: (context, index) {
            return renderItemProduct(index, _viewModel!.listProduct[index]);
          }),
    );
  }

  Widget renderItemProduct(int index, Product product) {
    return Container(
      height: 150,
      width: double.infinity,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: white,
          child: InkWell(
            child: Container(
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Stack(
                      children: [
                        if (product.defaultImageUrl != null)
                          FadeInImage.memoryNetwork(
                              width: double.infinity,
                              height: 145,
                              placeholder: placeholderBuffer ?? Uint8List(0),
                              placeholderScale: 0.5,
                              fit: BoxFit.cover,
                              imageErrorBuilder: getErrorImage,
                              placeholderErrorBuilder: getErrorImage,
                              image: product.defaultImageUrl!)
                        else
                          Image.asset(
                            placeholderProduct,
                            height: 145,
                            fit: BoxFit.contain,
                            width: double.infinity,
                          ),
                        Container(
                          width: 45,
                          height: 45,
                          child: product.discount! > 0
                              ? OtherUtils.buildDiscountBadge(
                                  product.productDivision!.id, product.discount)
                              : Container(),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          product.name ?? "",
                          maxLines: 2,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 12),
                        ),
                        Text(
                            (product.minWeight! > 0
                                    ? "Per "
                                    : txt("unit") + " ") +
                                product.unit,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 8,
                                color: greys)),
                        const SizedBox(
                          height: 10,
                        ),
                        buildPriceWidget(product),
                        const Expanded(child: SizedBox()),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => doWishlist(product),
                                  child: Image.asset(
                                    product.isWishlist != null &&
                                            product.isWishlist!
                                        ? icWishlistActive
                                        : icWishlist,
                                    width: 25,
                                    height: 25,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => doRoutineShop(product),
                                  child: Image.asset(
                                    product.isRoutineShop != null &&
                                            product.isRoutineShop!
                                        ? icShopRoutineActive
                                        : icShopRoutine,
                                    width: 25,
                                    height: 25,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            RawMaterialButton(
                              elevation: 0,
                              onPressed: () => addItemCart(product),
                              constraints: const BoxConstraints.tightFor(
                                width: 25,
                                height: 25,
                              ),
                              shape: const CircleBorder(),
                              fillColor: primary,
                              child: const Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                                size: 13,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getErrorImage(
      BuildContext context, Object error, StackTrace? stackTrace) {
    return Container(
      color: greysPlaceholder,
      child: Center(
        child: Image.asset(
          placeholderProduct,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildPriceWidget(Product product) {
    if (double.parse(product.discountPrice!) > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            FormatterNumber.getPriceDisplay(
                double.parse(product.discountPrice!)),
            style: const TextStyle(
                color: primary, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              FormatterNumber.getPriceDisplay(
                  double.parse(product.sellingPrice!)),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 8,
                  color: Colors.black,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.black),
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          FormatterNumber.getPriceDisplay(double.parse(product.sellingPrice!)),
          style: const TextStyle(
              color: primary, fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 24),
          child: Text(
            "",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 8,
                color: Colors.black,
                decoration: TextDecoration.lineThrough,
                decorationColor: Colors.black),
          ),
        ),
      ],
    );
  }

  void onSelect(int? selectedIndex) {
    _viewModel!.categoryId = widget.listCategory[selectedIndex!].id.toString();
    _viewModel!.getProductByCategory();
  }

  @override
  // ignore: avoid_void_async
  void showNeedLogin() async {
    showLoginPage();
  }

  void showLoginPage() {
    push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void doWishlist(Product product) {
    setState(() {
      if (product.isWishlist != null && product.isWishlist!) {
        product.isWishlist = false;
      } else {
        product.isWishlist = true;
      }
    });
    _viewModel!.doWishlist(product);
  }

  void doRoutineShop(Product product) {
    setState(() {
      if (product.isRoutineShop != null && product.isRoutineShop!) {
        product.isRoutineShop = false;
      } else {
        product.isRoutineShop = true;
      }
    });
    _viewModel!.doRoutineShop(product);
  }

  void addItemCart(Product product) {
    if (!_viewModel!.isAlreadyLogin) {
      Alert(
        context: context,
        type: AlertType.info,
        title: txt("title_need_login"),
        desc: txt("message_need_login"),
        buttons: [
          DialogButton(
            color: primary,
            onPressed: () => Navigator.pop(context),
            width: 120,
            child: Text(
              txt("cancel"),
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          DialogButton(
            color: Colors.red,
            onPressed: () async {
              Navigator.pop(context);
              // ignore: unused_local_variable
              final data = await push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            width: 120,
            child: Text(
              txt("login"),
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ).show();
    } else {
      controllerQuantity.text = "1";
      if (product.minWeight! > 0) {
        controllerQuantity.text = product.minWeight.toString();
      }
      showDialog(
        context: context,
        builder: (context) {
          contextDialog = context;
          return KeyboardAvoiding(
            child: Container(
              margin: EdgeInsets.only(
                  top: (MediaQuery.of(context).size.height / 2) +
                      (MediaQuery.of(context).size.height / 5)),
              child: Center(
                child: Material(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  elevation: 16,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: product.pricePerGram != "0" ? 80 : 60,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Material(
                                  color: Colors.white,
                                  child: InkWell(
                                    child: SvgPicture.asset(
                                      icMinus,
                                      width: 16,
                                      height: 16,
                                      color: primary,
                                    ),
                                    onTap: () => changeQty(false, product),
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 30,
                                  child: TextField(
                                      controller: controllerQuantity,
                                      textAlign: TextAlign.center,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(5),
                                      ]),
                                ),
                                Material(
                                  color: Colors.white,
                                  child: InkWell(
                                    child: SvgPicture.asset(
                                      icPlus,
                                      width: 16,
                                      height: 16,
                                      color: primary,
                                    ),
                                    onTap: () => changeQty(true, product),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            if (product.pricePerGram != "0")
                              const Text(
                                "Gram",
                                style: TextStyle(fontSize: 10),
                              )
                            else
                              Container(),
                            const SizedBox(
                              height: 2,
                            ),
                            if (product.pricePerGram != "0")
                              Text(
                                txt("minimum_purchase") +
                                    " " +
                                    product.minWeight.toString() +
                                    " Gram",
                                style: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w600),
                              )
                            else
                              Container(),
                            const SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  product.name ?? "",
                                  maxLines: 2,
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 11),
                                ),
                                Text(
                                  FormatterNumber.getPriceDisplay(double.parse(
                                      product.discountPrice! != "0"
                                          ? product.discountPrice!
                                          : product.sellingPrice!)),
                                  style: const TextStyle(
                                      color: primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                // product.pricePerGram != "0"
                                //     ? Padding(
                                //         padding: EdgeInsets.only(top: 4),
                                //         child: Text(
                                //             FormatterNumber.getPriceDisplay(
                                //                     double.parse(
                                //                         product.pricePerGram)) +
                                //                 "/Gram",
                                //             style: TextStyle(
                                //                 color: primary,
                                //                 fontSize: 11,
                                //                 fontWeight: FontWeight.w600)),
                                //       )
                                //     : Container(),
                                const SizedBox(
                                  height: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: product.pricePerGram != "0" ? 80 : 60,
                          child: RaisedButton(
                              color: primary,
                              elevation: 0,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                  side: const BorderSide(color: Colors.red)),
                              disabledTextColor: white,
                              child: Text(
                                txt("add"),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                              onPressed: () => addProduct(product)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  // ignore: avoid_positional_boolean_parameters
  void changeQty(bool isAdd, Product product) {
    var currentQty = int.parse(controllerQuantity.text.isNotEmpty
        ? controllerQuantity.text.toString()
        : "0");
    if (isAdd) {
      controllerQuantity.text = (++currentQty).toString();
    } else {
      if (currentQty <= product.minWeight!) {
        controllerQuantity.text = product.minWeight.toString();
      } else {
        if (currentQty > 1) {
          controllerQuantity.text = (--currentQty).toString();
        }
      }
    }
  }

  void openSearchPage() {
    push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
  }

  void addProduct(Product product) {
    if (contextDialog != null) {
      Navigator.of(contextDialog!).pop();
    }
    if (controllerQuantity.text.isNotEmpty) {
      _viewModel!.addProduct(product, int.parse(controllerQuantity.text));
    }
  }

  @override
  void showErrorMessage(String txt) {
    ScreenUtils.showToastMessage(txt);
  }

  @override
  void successAddToCart() {
    ScreenUtils.showToastMessage(txt("success_add_to_cart"));
  }
}

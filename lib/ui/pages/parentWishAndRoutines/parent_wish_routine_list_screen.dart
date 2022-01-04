// ignore_for_file: unused_field

import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/ui/pages/search/search_screen.dart';
import 'package:SuperNinja/ui/pages/shopRoutine/shop_routine_screen.dart';
import 'package:SuperNinja/ui/pages/wishlist/wish_list_screen.dart';
import 'package:SuperNinja/ui/widgets/always_disabled_focus_node.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ParentWishRoutineListScreen extends StatefulWidget {
  Function()? callbackProduct;

  ParentWishRoutineListScreen({this.callbackProduct});

  @override
  _ParentWishRoutineListScreenState createState() =>
      _ParentWishRoutineListScreenState();
}

class _ParentWishRoutineListScreenState
    extends State<ParentWishRoutineListScreen>
    with SingleTickerProviderStateMixin {
  final List<Widget> listTab = [];
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    listTab.addAll([
      WishListScreen(callbackProduct: widget.callbackProduct),
      ShopRoutineScreen(callbackProduct: widget.callbackProduct)
    ]);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_tabListener);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _tabListener() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildSearchBox(),
        _buildTabWidget(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: listTab,
          ),
        )
      ],
    );
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
          decoration: const InputDecoration(
              hintText: "Cari barang",
              filled: true,
              fillColor: greysMedium,
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search)),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildTabWidget() {
    return TabBar(
      controller: _tabController,
      indicatorWeight: 3,
      labelColor: primary,
      indicatorColor: primary,
      unselectedLabelColor: const Color(disabledColorValue),
      tabs: [Tab(text: txt("wishlist")), Tab(text: txt("shop_routine"))],
    );
  }

  void openSearchPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SearchScreen()));
  }
}

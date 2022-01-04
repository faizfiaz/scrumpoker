import 'dart:developer';

import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/tracking_utils.dart';
import 'package:SuperNinja/domain/models/entity/category.dart';
import 'package:SuperNinja/ui/pages/allCategory/all_category_new_screen.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';

// ignore: must_be_immutable
class CategoryWidget extends StatefulWidget {
  List<Category>? categoryList = [];
  List<Category>? fullCategoryList = [];
  bool isLogin;
  Function(String category, String perPage, String sort) changeParameter;

  late _CategoryWidget categoryState;

  CategoryWidget(this.categoryList, this.fullCategoryList, this.changeParameter,
      {this.isLogin = false})
      : super();

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    categoryState = _CategoryWidget();
    return categoryState;
  }
}

class _CategoryWidget extends BaseStateWidget<CategoryWidget> {
  List _perPageIn = [
    "10 Produk",
    "20 Produk",
    "30 Produk",
    "50 Produk",
    "100 Produk"
  ];

  List _perPageEn = [
    "10 Product",
    "20 Product",
    "30 Product",
    "50 Product",
    "100 Product"
  ];

  List _sortIn = ["Diskon Terbesar", "Nama", "Termurah", "Termahal"];
  List _sortEn = ["Biggest Discount", "Name", "Cheapest", "Most Expensive"];

  String? _currentPerPage;
  String? _currentSort;
  String? currentPerPageShadow;
  String? currentSortShadow;
  Category? _selectedCategory;

  bool changeFromForm = false;

  @override
  void initState() {
    _perPageIn = getPerPageItems();
    _perPageEn = getPerPageItemsEn();
    _sortIn = getSortItems();
    _sortEn = getSortItemsEn();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!changeFromForm) {
      if (txt("current_language") == "IDN") {
        _currentPerPage = _perPageIn[0].value;
        _currentSort = _sortIn[0].value;
      } else {
        _currentPerPage = _perPageEn[0].value;
        _currentSort = _sortEn[0].value;
      }
    }
    if (currentPerPageShadow != null) {
      _currentPerPage = currentPerPageShadow;
    }

    if (currentSortShadow != null) {
      _currentSort = currentSortShadow;
    }
    changeFromForm = false;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Text(
                  txt("category"),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 20,
                ),
                DropdownButton(
                  value: _currentPerPage,
                  style: const TextStyle(fontSize: 10),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                  items: txt("current_language") == "IDN"
                      ? _perPageIn as List<DropdownMenuItem<String>>
                      : _perPageEn as List<DropdownMenuItem<String>>,
                  onChanged: changedPerPageItem,
                  underline: const SizedBox(),
                ),
                const Expanded(child: SizedBox()),
                Text(
                  txt("sort"),
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  width: 8,
                ),
                DropdownButton(
                  value: _currentSort,
                  style: const TextStyle(fontSize: 10),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                  items: txt("current_language") == "IDN"
                      ? _sortIn as List<DropdownMenuItem<String>>
                      : _sortEn as List<DropdownMenuItem<String>>,
                  onChanged: changedSortItem,
                  underline: const SizedBox(),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            child: SizedBox(
              width: double.infinity,
              child: GridView.count(
                shrinkWrap: true,
                childAspectRatio: 0.87,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 5,
                children: List.generate(widget.categoryList!.length, (index) {
                  return buildItemCategory(widget.categoryList![index]);
                }),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.centerRight,
              child: Material(
                child: InkWell(
                  onTap: () => displayAllCategories(widget.fullCategoryList),
                  child: Text(
                    txt("see_all_category"),
                    style: const TextStyle(fontSize: 10, color: primary),
                  ),
                ),
              ),
            ),
          ),
          Container(
              width: double.infinity,
              height: 0,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    blurRadius: 8,
                    offset: const Offset(0, 15),
                    color: Colors.black.withOpacity(.6),
                    spreadRadius: 10)
              ])),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> getPerPageItems() {
    final items = <DropdownMenuItem<String>>[];
    for (final String perPage in _perPageIn) {
      items.add(DropdownMenuItem(
          value: perPage,
          child: Text(
            perPage,
            style: const TextStyle(fontSize: 10, color: primary),
          )));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getPerPageItemsEn() {
    final items = <DropdownMenuItem<String>>[];
    for (final String perPage in _perPageEn) {
      items.add(DropdownMenuItem(
          value: perPage,
          child: Text(
            perPage,
            style: const TextStyle(fontSize: 10, color: primary),
          )));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getSortItems() {
    final items = <DropdownMenuItem<String>>[];
    for (final String sort in _sortIn) {
      items.add(DropdownMenuItem(
          value: sort,
          child: Text(
            sort,
            style: const TextStyle(fontSize: 10, color: primary),
          )));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getSortItemsEn() {
    final items = <DropdownMenuItem<String>>[];
    for (final String sort in _sortEn) {
      items.add(DropdownMenuItem(
          value: sort,
          child: Text(
            sort,
            style: const TextStyle(fontSize: 10, color: primary),
          )));
    }
    return items;
  }

  void changedPerPageItem(String? selectedPerPage) {
    setState(() {
      _currentPerPage = selectedPerPage;
      currentPerPageShadow = selectedPerPage;
      changeFromForm = true;
      changeParameterCategory(_selectedCategory);
    });
  }

  void changedSortItem(String? selectedSort) {
    setState(() {
      _currentSort = selectedSort;
      currentSortShadow = selectedSort;
      changeFromForm = true;
      changeParameterCategory(_selectedCategory);
    });
  }

  Widget buildItemCategory(Category category) {
    return InkWell(
      onTap: () => changeParameterCategory(category),
      child: Center(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: 40,
              height: 40,
              decoration:
                  const BoxDecoration(shape: BoxShape.circle, color: yellow),
              child: category.id == 0
                  ? const Text(
                      "ALL",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  : Image.network(
                      category.iconUrl!,
                      width: 40,
                      height: 40,
                    ),
            ),
            const SizedBox(
              height: 2,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
              child: Text(
                category.name!,
                style: const TextStyle(fontSize: 9),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> displayAllCategories(List<Category>? categoryList) async {
    // ignore: unawaited_futures
    SmartechPlugin().trackEvent(
        TrackingUtils.CATEGORY_ALL_CLICKED, TrackingUtils.getEmptyPayload());
    log("asd");
    final data = await push(
        context,
        MaterialPageRoute(
            builder: (context) => AllCategoryNewScreenPage(
                  categoryList!,
                  isLogin: widget.isLogin,
                )));
    if (data != null) {
      changeParameterCategory(data as Category);
    }
  }

  void changeParameterCategory(Category? category) {
    if (category != null && category != _selectedCategory) {
      final payloadCategoryName = {"category_name": category.name};
      SmartechPlugin()
          .trackEvent(TrackingUtils.CATEGORY_NAME_CLICKED, payloadCategoryName);

      final payloadCategoryNameListing = {
        "category_name_listing": category.name
      };
      SmartechPlugin().trackEvent(
          TrackingUtils.CATEGORYNAME_LISTING, payloadCategoryNameListing);
    }
    _selectedCategory = category;
    widget.changeParameter(category != null ? category.id.toString() : "0",
        _currentPerPage!, _currentSort!);
  }
}

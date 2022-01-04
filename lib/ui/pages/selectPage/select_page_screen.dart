import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/models/entity/list_select_generic.dart';
import 'package:SuperNinja/ui/pages/selectPage/select_page_view_model.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:provider/provider.dart';

import 'select_page_navigator.dart';

enum TypeSelect { cl, province, city, district, village, xenditBank, store }

// ignore: must_be_immutable
class SelectPageScreen extends StatefulWidget {
  TypeSelect typeSelect;
  Object? id;

  SelectPageScreen(this.typeSelect, {this.id});

  @override
  State<StatefulWidget> createState() {
    return _SelectPageScreen();
  }
}

class _SelectPageScreen extends BaseStateWidget<SelectPageScreen>
    implements SelectPageNavigator {
  SelectPageViewModel? _viewModel;

  _SelectPageScreen();

  String? titleList = "";

  @override
  void initState() {
    _viewModel = SelectPageViewModel(widget.typeSelect, widget.id).setView(this)
        as SelectPageViewModel?;
    if (widget.typeSelect == TypeSelect.province ||
        widget.typeSelect == TypeSelect.city) {
      titleList = txt("all_location");
    } else if (widget.typeSelect == TypeSelect.cl) {
      titleList = txt("all_community_leader");
    } else if (widget.typeSelect == TypeSelect.xenditBank) {
      titleList = txt("choose_bank");
    } else if (widget.typeSelect == TypeSelect.store) {
      titleList = txt("choose_store");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectPageViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<SelectPageViewModel>(
          builder: (context, viewModel, _) => Scaffold(
            appBar: buildSearchBar(),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  if (widget.typeSelect == TypeSelect.cl &&
                      _viewModel!.isEmptyCL &&
                      !_viewModel!.isLoading)
                    Container(
                      alignment: Alignment.center,
                      child: Text(txt("empty_cl")),
                    )
                  else
                    Column(
                      children: <Widget>[
                        Expanded(
                          child: CustomScrollView(
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildListDelegate([
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 20, bottom: 10),
                                    child: Text(
                                      titleList!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: greysMediumText),
                                    ),
                                  ),
                                  buildListAllData(),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                ]),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  if (_viewModel!.isLoading) LoadingIndicator() else Container()
                ],
              ),
            ),
          ),
        ));
  }

  Widget renderItemList(int index, ListSelectGeneric? data) {
    return Material(
      child: InkWell(
        onTap: () => selectData(index),
        child: Container(
          margin:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          width: double.infinity,
          child: Row(
            crossAxisAlignment: widget.typeSelect == TypeSelect.cl
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    shape: BoxShape.circle,
                    color: primary),
                child: const Icon(
                  FontAwesome.map_marker,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              if (widget.typeSelect != TypeSelect.cl)
                Flexible(
                    child: Text(
                  data!.name!,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ))
              else
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data!.name!,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        data.additional ?? "-",
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: greys),
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildSearchBar() {
    return AppBar(
      elevation: 0,
      // ignore: deprecated_member_use
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Container(
        color: Colors.white,
        height: 68,
        padding: const EdgeInsets.only(left: 20, right: 20),
        alignment: Alignment.centerLeft,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: TextField(
            style: const TextStyle(fontSize: 12),
            controller: _viewModel!.searchController,
            enableInteractiveSelection: false,
            cursorColor: primary,
            decoration: InputDecoration(
                hintText: txt("find_hint"),
                focusColor: primary,
                hoverColor: primary,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                filled: true,
                fillColor: greySearchBox,
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search)),
          ),
        ),
      ),
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    txt("cancel"),
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  )),
            )),
      ],
    );
  }

  Widget buildListLatestSearch() {
    return ListView.builder(
      itemCount: 2,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return renderItemList(index, null);
      },
    );
  }

  Widget buildListAllData() {
    return ListView.builder(
      itemCount: _viewModel!.listData.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return renderItemList(index, _viewModel!.listData[index]);
      },
    );
  }

  void selectData(int index) {
    if (widget.typeSelect == TypeSelect.province) {
      Navigator.pop(context, _viewModel!.provinceList[index]);
    } else if (widget.typeSelect == TypeSelect.city) {
      Navigator.pop(context, _viewModel!.cityList[index]);
    } else if (widget.typeSelect == TypeSelect.cl) {
      Navigator.pop(context, _viewModel!.communityLeaderList[index]);
    } else if (widget.typeSelect == TypeSelect.xenditBank) {
      Navigator.pop(context, _viewModel!.listData[index]);
    } else if (widget.typeSelect == TypeSelect.store) {
      Navigator.pop(context, _viewModel!.listData[index]);
    }
  }
}

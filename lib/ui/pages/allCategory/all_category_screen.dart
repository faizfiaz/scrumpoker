import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/tracking_utils.dart';
import 'package:SuperNinja/domain/models/entity/category.dart';
import 'package:SuperNinja/ui/pages/allCategory/all_category_view_model.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:provider/provider.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';

import 'all_category_navigator.dart';

// ignore: must_be_immutable
class AllCategoryScreen extends StatefulWidget {
  List<Category>? listCategory;

  AllCategoryScreen(this.listCategory);

  @override
  State<StatefulWidget> createState() {
    return _AllCategoryScreen();
  }
}

class _AllCategoryScreen extends BaseStateWidget<AllCategoryScreen>
    implements AllCategoryNavigator {
  AllCategoryViewModel? _viewModel;

  _AllCategoryScreen();

  @override
  void initState() {
    _viewModel = AllCategoryViewModel(widget.listCategory!).setView(this)
        as AllCategoryViewModel?;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AllCategoryViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<AllCategoryViewModel>(
          builder: (context, viewModel, _) => Scaffold(
            appBar: buildSearchBar(),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  buildListLatestSearch(),
                  if (_viewModel!.isLoading) LoadingIndicator() else Container()
                ],
              ),
            ),
          ),
        ));
  }

  Widget renderItemList(int index, Category data) {
    return Material(
      child: InkWell(
        onTap: () => chooseCategory(data),
        child: Center(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: 50,
                height: 50,
                decoration:
                    const BoxDecoration(shape: BoxShape.circle, color: yellow),
                child: data.id == 0
                    ? const Text(
                        "ALL",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    : Image.network(
                        data.iconUrl!,
                        width: 50,
                        height: 50,
                      ),
              ),
              const SizedBox(
                height: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
                child: Text(
                  data.name!,
                  style: const TextStyle(fontSize: 9),
                  textAlign: TextAlign.center,
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

  Widget buildListLatestSearch() {
    return GridView.count(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 20),
      crossAxisCount: 4,
      mainAxisSpacing: 20,
      children: List.generate(_viewModel!.listDataCopy.length, (index) {
        return renderItemList(index, _viewModel!.listDataCopy[index]);
      }),
    );
  }

  void chooseCategory(Category data) {
    final payloadCategoryName = {"category_name": data.name};
    SmartechPlugin()
        .trackEvent(TrackingUtils.CATEGORY_NAME_CLICKED, payloadCategoryName);

    final payloadCategoryNameListing = {"category_name_listing": data.name};
    SmartechPlugin().trackEvent(
        TrackingUtils.CATEGORYNAME_LISTING, payloadCategoryNameListing);

    Navigator.pop(context, data);
  }

  @override
  void showNeedLogin() {}

  @override
  void showErrorMessage(String txt) {}

  @override
  void successAddToCart() {}
}

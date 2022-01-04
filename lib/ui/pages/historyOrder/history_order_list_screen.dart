import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/formatter_date.dart';
import 'package:SuperNinja/domain/commons/formatter_number.dart';
import 'package:SuperNinja/domain/commons/other_utils.dart';
import 'package:SuperNinja/domain/models/response/response_list_order.dart';
import 'package:SuperNinja/ui/pages/detailOrder/detail_order_screen.dart';
import 'package:SuperNinja/ui/pages/historyOrder/history_order_list_view_model.dart';
import 'package:SuperNinja/ui/widgets/app_bar_custom.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'history_order_list_navigator.dart';

class HistoryOrderListScreen extends StatefulWidget {
  const HistoryOrderListScreen();

  @override
  State<StatefulWidget> createState() {
    return _HistoryListScreen();
  }
}

class _HistoryListScreen extends BaseStateWidget<HistoryOrderListScreen>
    implements HistoryOrderListNavigator, LoadMoreDelegate {
  HistoryOrderListViewModel? _viewModel;

  final RefreshController _refreshController = RefreshController();

  _HistoryListScreen();

  @override
  void initState() {
    _viewModel =
        HistoryOrderListViewModel().setView(this) as HistoryOrderListViewModel?;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HistoryOrderListViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<HistoryOrderListViewModel>(
          builder: (context, viewModel, _) => Scaffold(
            appBar: AppBarCustom.buildAppBar(context, txt("history_order"))
                as PreferredSizeWidget?,
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: greysBackgroundMedium,
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: Stack(
                          children: [
                            if (_viewModel!.orderList!.isNotEmpty)
                              Container(
                                height: 120,
                                color: primary,
                              )
                            else
                              Container(),
                            if (!_viewModel!.isLoading)
                              buildListData()
                            else
                              Container()
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_viewModel!.isLoading) LoadingIndicator() else Container()
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> _onRefresh() async {}

  Widget renderItemList(int index, Order data) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 10),
      width: double.infinity,
      child: Card(
        color: Colors.white,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 17, right: 17, top: 18, bottom: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: txt("order_no"),
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                            children: <TextSpan>[
                              TextSpan(
                                  text: data.receiptCode,
                                  style: const TextStyle(
                                      color: primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600))
                            ]),
                      ),
                      Text(
                        FormatterDate.parseToReadable(data.createdAt!),
                        style: const TextStyle(fontSize: 10),
                      )
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  Text(OtherUtils.translateStatusOrder(data.status)!,
                      style: const TextStyle(
                          color: primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Text(
                      FormatterNumber.getPriceDisplay(
                          double.parse(data.totalAmount!)),
                      style: const TextStyle(
                          color: primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                  const Expanded(child: SizedBox()),
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      child: Text(
                        txt("see_detail"),
                        style: const TextStyle(color: primary, fontSize: 10),
                      ),
                      onTap: () => displayDetailOrder(data.id),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListData() {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: _viewModel!.orderList!.isNotEmpty
            ? SmartRefresher(
                header: const ClassicHeader(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: LoadMore(
                  delegate: this,
                  isFinish: _viewModel!.page >= _viewModel!.totalPage!,
                  onLoadMore: _loadMore,
                  child: ListView.builder(
                    itemCount: _viewModel!.orderList!.length,
                    itemBuilder: (context, index) {
                      return renderItemList(
                          index, _viewModel!.orderList![index]);
                    },
                  ),
                ),
              )
            : buildEmptyOrder());
  }

  Future<bool> _loadMore() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _viewModel!.loadDataApi(false, true);
    return true;
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

  Widget buildEmptyOrder() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            imgEmptyOrder,
            height: 160,
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            txt("empty_order"),
            style: const TextStyle(fontWeight: FontWeight.w600, color: primary),
          )
        ],
      ),
    );
  }

  void displayDetailOrder(int? orderId) {
    push(context,
        MaterialPageRoute(builder: (context) => DetailOrderScreen(orderId)));
  }
}

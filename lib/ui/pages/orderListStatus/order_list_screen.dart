import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/formatter_date.dart';
import 'package:SuperNinja/domain/commons/formatter_number.dart';
import 'package:SuperNinja/domain/commons/other_utils.dart';
import 'package:SuperNinja/domain/models/response/response_count_order.dart';
import 'package:SuperNinja/domain/models/response/response_list_order.dart';
import 'package:SuperNinja/ui/pages/detailOrder/detail_order_screen.dart';
import 'package:SuperNinja/ui/pages/historyOrder/history_order_list_screen.dart';
import 'package:SuperNinja/ui/pages/orderListStatus/order_list_navigator.dart';
import 'package:SuperNinja/ui/pages/orderListStatus/order_list_view_model.dart';
import 'package:SuperNinja/ui/widgets/app_bar_custom.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// ignore: must_be_immutable
class OrderListScreen extends StatefulWidget {
  int position;
  CountOrder? countOrder;

  OrderListScreen(this.position, this.countOrder);

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return _OrderListScreen(position);
  }
}

class _OrderListScreen extends BaseStateWidget<OrderListScreen>
    implements OrderListNavigator, LoadMoreDelegate {
  OrderListViewModel? _viewModel;
  int position;

  final RefreshController _refreshController = RefreshController();
  bool needRefreshData = false;

  _OrderListScreen(this.position);

  @override
  void initState() {
    _viewModel = OrderListViewModel(position, widget.countOrder).setView(this)
        as OrderListViewModel?;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderListViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<OrderListViewModel>(
          builder: (context, viewModel, _) => Scaffold(
            appBar: AppBarCustom.buildAppBar(context, txt("orders"))
                as PreferredSizeWidget?,
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: greysBackgroundMedium,
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Stack(
                        children: [
                          Container(
                            height: 120,
                            color: primary,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: buildCardOrder(),
                          ),
                        ],
                      ),
                      if (!_viewModel!.isLoading)
                        buildListData()
                      else
                        Container()
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

  Widget buildCardOrder() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 1),
      width: double.infinity,
      child: Card(
        color: Colors.white,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 17, right: 17, top: 12, bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(txt("my_order"),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                  const Expanded(child: SizedBox()),
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      child: Text(
                        txt("see_all"),
                        style: const TextStyle(color: primary, fontSize: 10),
                      ),
                      onTap: () => loadOrderStatus(5),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  itemOrder(
                      0,
                      _viewModel!.countOrder != null
                          ? _viewModel!.countOrder!.totalWaitingPayment
                              .toString()
                          : "0"),
                  itemOrder(
                      1,
                      _viewModel!.countOrder != null
                          ? _viewModel!.countOrder!.totalInprogress.toString()
                          : "0"),
                  itemOrder(
                      2,
                      _viewModel!.countOrder != null
                          ? _viewModel!.countOrder!.totalDelivery.toString()
                          : "0"),
                  itemOrder(
                      3,
                      _viewModel!.countOrder != null
                          ? _viewModel!.countOrder!.totalArrived.toString()
                          : "0"),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: displayHistoryOrder,
                      child: Text(
                        txt("see_history"),
                        style: const TextStyle(color: primary, fontSize: 10),
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: refreshData,
                      child: Row(
                        children: const [
                          Icon(
                            Icons.refresh,
                            size: 14,
                            color: primary,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "Refresh Data",
                            style: TextStyle(color: primary, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemOrder(int position, String total) {
    var title = txt("waiting_payment") + "\n\\Expired";
    var image = icOrderPayment;
    if (position == 1) {
      title = txt("order_process");
      image = icOrderProccess;
    } else if (position == 2) {
      title = txt("order_delivery");
      image = icOrderDeliver;
    } else if (position == 3) {
      title = txt("order_arrived");
      image = icOrderReady;
    }

    return Expanded(
      child: Material(
        child: InkWell(
          onTap: () => loadOrderStatus(position),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  SvgPicture.asset(
                    image,
                    width: 40,
                    height: 40,
                    color: this.position == 5
                        ? primary
                        : position == this.position
                            ? primary
                            : greysLight,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        shape: BoxShape.circle,
                        color: orange),
                    child: Text(
                      total,
                      style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  title + "\n",
                  maxLines: 3,
                  style: const TextStyle(fontSize: 9, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void loadOrderStatus(int position) {
    setState(() {
      this.position = position;
      _viewModel!.position = position;
      _viewModel!.loadDataApi(true, false);
    });
  }

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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                              text: txt("order_no") + "\n",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500),
                              children: <TextSpan>[
                                TextSpan(
                                    text: data.receiptCode,
                                    style: const TextStyle(
                                        color: primary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700))
                              ]),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          FormatterDate.parseToReadable(data.createdAt!),
                          style: const TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(getStatus(data)!,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            color: primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  )
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
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                  const Expanded(child: SizedBox()),
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      child: Text(
                        txt("see_detail"),
                        style: const TextStyle(color: primary, fontSize: 10),
                      ),
                      onTap: () => displayDetailOrder(data),
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

  Future<void> displayDetailOrder(Order data) async {
    final dynamic result = await push(context,
        MaterialPageRoute(builder: (context) => DetailOrderScreen(data.id)));
    if (result != null) {
      needRefreshData = result;
      _viewModel!.loadDataApi(true, false);
      _viewModel!.loadCountData();
    } else {
      needRefreshData = false;
    }
  }

  void displayHistoryOrder() {
    push(
        context,
        MaterialPageRoute(
            builder: (context) => const HistoryOrderListScreen()));
  }

  @override
  void refreshDone() {
    _refreshController.refreshCompleted();
  }

  Widget buildEmptyOrder() {
    return Expanded(
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
    ));
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

  Widget buildListData() {
    return Container(
        child: _viewModel!.orderList!.isNotEmpty
            ? Expanded(
                child: SmartRefresher(
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
                    )),
              )
            : buildEmptyOrder());
  }

  String? getStatus(Order data) {
    if (data.paymentType == "bca_va") {
      if (data.status == OtherUtils.waitingPayment &&
          FormatterDate.divideOneHour(data.createdAt!)) {
        return txt("transaction_expired");
      }
    } else if (data.paymentType == "dana" ||
        data.paymentType == "linkaja" ||
        data.paymentType == "shopeepay") {
      if (data.status == OtherUtils.waitingPayment &&
          FormatterDate.divideThirtyMinutes(data.createdAt!)) {
        return txt("transaction_expired");
      } else {
        if (data.paymentLastStatus!.toLowerCase() ==
            "waiting_approval_xendit") {
          return txt("waiting_approval_xendit");
        }
      }
    } else {
      if (data.status == OtherUtils.waitingPayment &&
          FormatterDate.divideTwentyMinutes(data.createdAt!)) {
        return txt("transaction_expired");
      }
    }

    return OtherUtils.translateStatusOrder(data.status);
  }

  void refreshData() {
    _viewModel!.loadDataApi(true, false);
    _viewModel!.loadCountData();
  }
}

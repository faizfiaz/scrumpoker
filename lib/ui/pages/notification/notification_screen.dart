import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/formatter_date.dart';
import 'package:SuperNinja/domain/commons/other_utils.dart';
import 'package:SuperNinja/domain/models/entity/notifications.dart';
import 'package:SuperNinja/ui/pages/detailOrder/detail_order_screen.dart';
import 'package:SuperNinja/ui/pages/notification/notification_navigator.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'notification_view_model.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NotificationScreen();
  }
}

class _NotificationScreen extends BaseStateWidget<NotificationScreen>
    with SingleTickerProviderStateMixin
    implements NotificationNavigator, LoadMoreDelegate {
  NotificationViewModel? _viewModel;

  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _viewModel =
        NotificationViewModel().setView(this) as NotificationViewModel?;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<NotificationViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<NotificationViewModel>(
          builder: (context, viewModel, _) => Scaffold(
            appBar: buildAppBar(),
            body: Stack(
              children: <Widget>[
                Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    color: greysBackgroundMedium,
                    child:
                        !_viewModel!.isLoading ? buildListData() : Container()),
                if (viewModel.isLoading) LoadingIndicator() else Container()
              ],
            ),
          ),
        ));
  }

  Widget renderItemList(int index, Notifications data) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 10),
      width: double.infinity,
      child: Card(
        color: Colors.white,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => seeNotification(data),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 17, right: 12, top: 8, bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: Text(
                        FormatterDate.parseToReadableNotifications(
                            data.createdAt!),
                        style: const TextStyle(
                          color: greysMediumText,
                          fontSize: 10,
                        )),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  RichText(
                    text: TextSpan(
                        text: txt("notification_title") +
                            _viewModel!.getMessage(data.message!),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(
                              text: _viewModel!
                                  .translateStatus(data.notificationType!),
                              style: const TextStyle(
                                  color: primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600))
                        ]),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: Text(!data.isRead! ? txt("unread") : txt("read"),
                        style: const TextStyle(
                          color: primary,
                          fontSize: 10,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildListData() {
    return Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: _viewModel!.data.isNotEmpty
            ? SmartRefresher(
                header: const ClassicHeader(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: LoadMore(
                  delegate: this,
                  isFinish: _viewModel!.currentPage >= _viewModel!.totalPage!,
                  onLoadMore: _loadMore,
                  child: ListView.builder(
                    itemCount: _viewModel!.data.length,
                    itemBuilder: (context, index) {
                      return renderItemList(index, _viewModel!.data[index]);
                    },
                  ),
                ),
              )
            : buildEmptyNotification());
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      // ignore: deprecated_member_use
      brightness: Brightness.light,
      titleSpacing: 0,
      elevation: 0,
      title: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          txt("notification"),
          textAlign: TextAlign.start,
          style: const TextStyle(
              color: primary, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      leading: IconButton(
        iconSize: 28,
        icon: const Icon(Feather.chevron_left, color: primary),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => _viewModel!.markAllNotification(),
              child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    txt("mark_all_read"),
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                  )),
            )),
      ],
    );
  }

  Future<bool> _loadMore() async {
    await Future.delayed(const Duration(milliseconds: 100));
    await _viewModel!.getData(false, true);
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

  Widget buildEmptyNotification() {
    return Container(
      alignment: Alignment.center,
      height: double.infinity,
      color: greysBackgroundMedium,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            imgEmptyNotification,
            width: 300,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            txt("empty_notification"),
            textAlign: TextAlign.center,
            style: const TextStyle(color: primary),
          ),
        ],
      ),
    );
  }

  void seeNotification(Notifications data) {
    _viewModel!.readNotification(data);
  }

  @override
  void showOrderDetail(int? referenceId) {
    push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailOrderScreen(referenceId)));
  }
}

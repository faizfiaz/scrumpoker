import 'dart:async';

import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/domain/commons/base_state_widget.dart';
import 'package:SuperNinja/domain/commons/gps_utils.dart';
import 'package:SuperNinja/domain/commons/other_utils.dart';
import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/ui/pages/address/map/pinpoint_map_view_model.dart';
import 'package:SuperNinja/ui/widgets/loading_indicator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'pinpoint_map_navigator.dart';

// ignore: must_be_immutable
class PinpointMapScreen extends StatefulWidget {
  const PinpointMapScreen();

  @override
  State<StatefulWidget> createState() {
    return _PinpointMapScreen();
  }
}

class _PinpointMapScreen extends BaseStateWidget<PinpointMapScreen>
    implements PinpointMapNavigator {
  PinpointMapViewModel? _viewModel;

  final Completer<GoogleMapController> _controller = Completer();

  static CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(-6.1753871, 106.8249588),
    zoom: 14.4746,
  );

  String positionText = txt("empty_pinpoint");

  @override
  void initState() {
    _viewModel = PinpointMapViewModel().setView(this) as PinpointMapViewModel?;
    super.initState();
    GPSUtils.determinePosition().then((value) {
      if (value.isNotEmpty) {
        if (value.keys.first != null) {
          _viewModel!.setLatLong(
              value.keys.first!.latitude, value.keys.first!.longitude);
          positionText =
              "${txt("choosed_pinpoint")}: ${_viewModel!.latitude.toPrecision(5)}, ${_viewModel!.longitude.toPrecision(5)}";
          if (_controller.isCompleted) {
            _controller.future.then((value) {
              value.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                target: LatLng(_viewModel!.latitude, _viewModel!.longitude),
                zoom: 14.4746,
              )));
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_viewModel!.latitude != 0 && _viewModel!.longitude != 0) {
      _initialCameraPosition = CameraPosition(
        target: LatLng(_viewModel!.latitude, _viewModel!.longitude),
        zoom: 14.4746,
      );
    }
    return ChangeNotifierProvider<PinpointMapViewModel?>(
        create: (context) => _viewModel,
        child: Consumer<PinpointMapViewModel>(
          builder: (context, viewModel, _) => Scaffold(
            appBar: buildAppBar(),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  buildMap(),
                  buildPinpoint(),
                  buildInfoPointMap(),
                  if (_viewModel!.isLoading) LoadingIndicator() else Container()
                ],
              ),
            ),
          ),
        ));
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      backgroundColor: primary,
      centerTitle: true,
      titleSpacing: 0,
      elevation: 0,
      title: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          txt("pinpoint_location"),
          textAlign: TextAlign.start,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      leading: IconButton(
        iconSize: 28,
        icon: const Icon(Feather.chevron_left, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: onSavedClicked,
              child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    txt("save"),
                    style: const TextStyle(
                        color: white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  )),
            )),
      ],
    );
  }

  Widget buildMap() {
    return GoogleMap(
      myLocationEnabled: true,
      initialCameraPosition: _initialCameraPosition,
      onMapCreated: _controller.complete,
      onCameraMove: (position) {
        final latitude = position.target.latitude;
        final longitude = position.target.longitude;
        _viewModel!.setLatLong(latitude, longitude, isInit: false);
        setState(() {
          positionText =
              "${txt("choosed_pinpoint")}: ${latitude.toPrecision(5)}, ${longitude.toPrecision(5)}";
        });
      },
    );
  }

  Widget buildPinpoint() {
    return Center(
        child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            child:
                const Icon(FontAwesome.map_marker, color: primary, size: 40)));
  }

  Widget buildInfoPointMap() {
    return Container(
        alignment: Alignment.bottomCenter,
        margin: const EdgeInsets.only(bottom: 20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              positionText,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }

  void onSavedClicked() {
    if (_viewModel!.latitude != 0 && _viewModel!.longitude != 0) {
      final listLatLong = [_viewModel!.latitude, _viewModel!.longitude];
      Navigator.of(context).pop(listLatLong);
    } else {
      ScreenUtils.showToastMessage(txt("error_pinpoint"));
    }
  }
}

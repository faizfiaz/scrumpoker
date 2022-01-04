// ignore_for_file: invalid_return_type_for_catch_error

import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/ui/pages/address/map/pinpoint_map_navigator.dart';

class PinpointMapViewModel extends BaseViewModel<PinpointMapNavigator> {
  double latitude = 0;
  double longitude = 0;

  void setLatLong(double? latitude, double? longitude, {bool isInit = true}) {
    this.latitude = latitude ?? 0;
    this.longitude = longitude ?? 0;
    if (isInit) {
      notifyListeners();
    }
  }
}

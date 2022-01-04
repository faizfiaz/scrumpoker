// ignore_for_file: invalid_return_type_for_catch_error

import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/models/entity/city.dart';
import 'package:SuperNinja/domain/models/entity/province.dart';
import 'package:SuperNinja/domain/models/response/response_list_address.dart';
import 'package:SuperNinja/domain/repositories/user_repository.dart';
import 'package:SuperNinja/domain/usecases/user/user_usecase.dart';
import 'package:SuperNinja/ui/pages/address/form/form_address_navigator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';

class FormAddressViewModel extends BaseViewModel<FormAddressNavigator> {
  late UserUsecase _usecase;

  Province? provinceSelected;
  City? citySelected;

  List<UserAddress> addresses = [];

  double latitudeSelected = 0;
  double longitudeSelected = 0;

  int? addressId;

  FormAddressViewModel({UserAddress? address}) {
    _usecase = UserUsecase(UserRepository(dioClient));
    if (address != null) {
      if (address.provinceId != null) {
        provinceSelected = Province(
          id: address.provinceId,
          name: address.provinceName,
        );
      }

      if (address.cityId != null) {
        citySelected = City(
          id: address.cityId,
          name: address.cityName,
        );
      }

      latitudeSelected = address.latitude ?? 0;
      longitudeSelected = address.longitude ?? 0;
      addressId = address.id;
    }
  }

  Future<void> doAddAddress(Map<String, dynamic> value) async {
    final newMapValue = Map.of(value);
    if (isNotValidData()) {
      return;
    }
    showLoading(true);
    newMapValue['province_id'] = provinceSelected?.id;
    newMapValue['city_id'] = citySelected?.id;
    newMapValue['latitude'] = latitudeSelected;
    newMapValue['longitude'] = longitudeSelected;
    await _usecase
        .doActionAddress(newMapValue, addressId: addressId)
        .then((value) {
      showLoading(false);
      if (value.values.first != null) {
        getView()!.showError(
            value.values.first!.errors, value.values.first!.httpCode);
      } else {
        getView()!.showSuccess();
        notifyListeners();
      }
    }).catchError(print);
  }

  bool isNotValidData() {
    if (latitudeSelected == 0 || longitudeSelected == 0) {
      getView()!.showErrorMessage(txt("please_choose_pinpoint"));
      return true;
    }
    return false;
  }
}

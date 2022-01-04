// ignore_for_file: invalid_return_type_for_catch_error

import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/models/entity/city.dart';
import 'package:SuperNinja/domain/models/entity/community_leader.dart';
import 'package:SuperNinja/domain/models/entity/province.dart';
import 'package:SuperNinja/domain/repositories/user_repository.dart';
import 'package:SuperNinja/domain/usecases/user/user_usecase.dart';
import 'package:SuperNinja/ui/pages/changeCL/change_cl_navigator.dart';

class ChangeCLViewModel extends BaseViewModel<ChangeCLNavigator> {
  Province? provinceSelected;
  City? citySelected;
  late CommunityLeader communityLeaderSelected;
  late UserUsecase _usecase;

  ChangeCLViewModel() {
    _usecase = UserUsecase(UserRepository(dioClient));
  }

  Future<void> doChangeCL(Map<String, dynamic> value) async {
    showLoading(true);
    await _usecase
        .doChangeCL(userCLId: communityLeaderSelected.id)
        .then((value) {
      showLoading(false);
      if (value.values.first != null) {
        getView()!.showError(
            value.values.first!.errors, value.values.first!.httpCode);
      } else {
        getView()!.successChangeCL();
      }
    }).catchError(print);
  }
}

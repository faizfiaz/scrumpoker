import 'package:SuperNinja/data/sharedpreference/user_preferences.dart';
import 'package:SuperNinja/domain/models/entity/xendit_bank.dart';
import 'package:SuperNinja/domain/models/error/error_message.dart';
import 'package:SuperNinja/domain/models/response/response_list_city.dart';
import 'package:SuperNinja/domain/models/response/response_list_community_leader.dart';
import 'package:SuperNinja/domain/models/response/response_list_province.dart';
import 'package:SuperNinja/domain/models/response/response_list_store.dart';
import 'package:SuperNinja/domain/repositories/commons_repository.dart';
import 'package:SuperNinja/domain/usecases/common/i_commons_usecase.dart';

class CommonsUsecase extends ICommonUsecase {
  final userSp = UserPreferences();

  CommonsUsecase(CommonsRepository repository) : super(repository);

  CommonsUsecase.empty() : super(null);

  @override
  Future<Map<ResponseListProvince?, ErrorMessage?>> getListProvinces(
      {String keyword = ""}) async {
    disposeVariable();
    ResponseListProvince? response;
    await repository?.getListProvince(keyword: keyword).then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<ResponseListCity?, ErrorMessage?>> getListCity(int? provinceId,
      {String keyword = ""}) async {
    disposeVariable();
    ResponseListCity? response;
    await repository?.getListCity(provinceId, keyword: keyword).then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<ResponseListCommunityLeader?, ErrorMessage?>>
      getListCommunityLeader(int? cityId, int page,
          {String keyword = ""}) async {
    disposeVariable();
    ResponseListCommunityLeader? response;
    await repository
        ?.getListCommunityLeader(cityId, page, keyword: keyword)
        .then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<List<XenditBank>?, ErrorMessage?>> getListXenditBank() async {
    disposeVariable();
    List<XenditBank>? response;
    await repository?.getListXenditBank().then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<ResponseListStore?, ErrorMessage?>> getListStore() async {
    disposeVariable();
    ResponseListStore? response;
    await repository?.getListStore().then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }
}

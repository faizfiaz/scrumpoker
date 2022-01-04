import 'package:SuperNinja/domain/models/entity/xendit_bank.dart';
import 'package:SuperNinja/domain/models/error/error_message.dart';
import 'package:SuperNinja/domain/models/response/response_list_city.dart';
import 'package:SuperNinja/domain/models/response/response_list_community_leader.dart';
import 'package:SuperNinja/domain/models/response/response_list_province.dart';
import 'package:SuperNinja/domain/models/response/response_list_store.dart';
import 'package:SuperNinja/domain/repositories/commons_repository.dart';

import '../base_usecase.dart';

abstract class ICommonUsecase extends BaseUsecase<CommonsRepository?> {
  ICommonUsecase(CommonsRepository? repository) : super(repository);

  Future<Map<ResponseListProvince?, ErrorMessage?>> getListProvinces(
      {String keyword = ""});

  Future<Map<ResponseListCity?, ErrorMessage?>> getListCity(int provinceId,
      {String keyword = ""});

  Future<Map<ResponseListCommunityLeader?, ErrorMessage?>>
      getListCommunityLeader(int cityId, int page, {String keyword = ""});

  Future<Map<List<XenditBank>?, ErrorMessage?>> getListXenditBank();

  Future<Map<ResponseListStore?, ErrorMessage?>> getListStore();
}

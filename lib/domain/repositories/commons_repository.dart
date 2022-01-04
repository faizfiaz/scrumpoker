import 'dart:convert';

import 'package:encrypt/encrypt.dart' as enc;
import 'package:scrumpoker/data/remote/dio_client.dart';
import 'package:scrumpoker/data/remote/endpoints/commons_endpoints.dart';
import 'package:scrumpoker/data/remote/endpoints/endpoints.dart';
import 'package:scrumpoker/domain/models/entity/xendit_bank.dart';
import 'package:scrumpoker/domain/models/response/response_list_city.dart';
import 'package:scrumpoker/domain/models/response/response_list_community_leader.dart';
import 'package:scrumpoker/domain/models/response/response_list_province.dart';
import 'package:scrumpoker/domain/models/response/response_list_store.dart';
import 'package:scrumpoker/domain/repositories/base_repository.dart';

class CommonsRepository extends BaseRepository {
  CommonsRepository(DioClient? dioClient) : super(dioClient);

  dynamic data;

  Future<ResponseListProvince> getListProvince({String keyword = ""}) async {
    await dioClient!
        .get(CommonsEndpoints.urlListProvince(keyword: keyword))
        .then((value) {
      data = value;
    });
    return ResponseListProvince.fromJson(data);
  }

  Future<ResponseListCity> getListCity(int? provinceId,
      {String keyword = ""}) async {
    await dioClient!
        .get(CommonsEndpoints.urlListCity(provinceId, keyword: keyword))
        .then((value) {
      data = value;
    });
    return ResponseListCity.fromJson(data);
  }

  Future<ResponseListCommunityLeader> getListCommunityLeader(
      int? cityId, int page,
      {String keyword = ""}) async {
    await dioClient!
        .get(CommonsEndpoints.urlListCommunityLeader(cityId, page,
            keyword: keyword))
        .then((value) {
      data = value;
    });
    return ResponseListCommunityLeader.fromJson(data);
  }

  Future<List<XenditBank>> getListXenditBank() async {
    const _hk = "7smu@d}*?9eYRAs!";

    final plainText = Endpoints.xenditToken!;
    final key = enc.Key.fromUtf8(_hk);
    final iv = enc.IV.fromLength(16);
    final _e = enc.Encrypter(enc.AES(key));
    final _edr = _e.decrypt16(plainText, iv: iv);
    await dioClient!
        .get(CommonsEndpoints.urlListXenditBank(), token: _edr)
        .then((value) {
      data = value;
    });
    final datas = <XenditBank>[];
    final jsonEncode = json.encode(data);
    final jsonDecode = json.decode(jsonEncode);
    for (final element in jsonDecode as Iterable<dynamic>) {
      datas.add(XenditBank.fromJson(element));
    }

    return datas;
  }

  Future<ResponseListStore> getListStore() async {
    await dioClient!.get(CommonsEndpoints.urlListStore()).then((value) {
      data = value;
    });
    return ResponseListStore.fromJson(data);
  }
}

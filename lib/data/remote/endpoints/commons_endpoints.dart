import 'package:scrumpoker/data/remote/endpoints/endpoints.dart';

class CommonsEndpoints {
  CommonsEndpoints._();

  static String urlListProvince({String keyword = ""}) {
    return '${Endpoints().baseUrl!}/v1/provinces?keyword=$keyword';
  }

  static String urlListCity(int? provinceId, {String keyword = ""}) {
    return '${Endpoints().baseUrl!}/v1/provinces/$provinceId/cities?keyword=$keyword';
  }

  static String urlListCommunityLeader(int? cityId, int page,
      {String keyword = ""}) {
    return '${Endpoints().baseUrl!}/v1/community-leaders?page=$page&per_page=999999999&city_id=$cityId&keyword=$keyword';
  }

  static String urlDriverMrSpeedy(String deliveryReference) {
    return "https://robot.mrspeedy.co/api/business/1.1/courier?order_id=$deliveryReference";
  }

  static String urlListXenditBank() {
    return "https://api.xendit.co/available_disbursements_banks";
  }

  static String urlListStore() {
    return '${Endpoints().baseUrl!}/v1/stores';
  }
}

// ignore_for_file: invalid_return_type_for_catch_error

import 'dart:developer';

import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/models/entity/city.dart';
import 'package:SuperNinja/domain/models/entity/community_leader.dart';
import 'package:SuperNinja/domain/models/entity/list_select_generic.dart';
import 'package:SuperNinja/domain/models/entity/province.dart';
import 'package:SuperNinja/domain/models/entity/xendit_bank.dart';
import 'package:SuperNinja/domain/models/response/response_list_store.dart';
import 'package:SuperNinja/domain/repositories/commons_repository.dart';
import 'package:SuperNinja/domain/usecases/common/commons_usecase.dart';
import 'package:SuperNinja/ui/pages/selectPage/select_page_navigator.dart';
import 'package:SuperNinja/ui/pages/selectPage/select_page_screen.dart';
import 'package:flutter/cupertino.dart';

class SelectPageViewModel extends BaseViewModel<SelectPageNavigator> {
  List<ListSelectGeneric> listData = [];
  List<ListSelectGeneric> listDataCopy = [];
  List<Province> provinceList = [];
  List<City> cityList = [];
  List<CommunityLeader> communityLeaderList = [];
  List<XenditBank> xenditBanks = [];
  List<StoreData> storeDatas = [];

  TextEditingController searchController = TextEditingController();

  late CommonsUsecase _usecase;

  TypeSelect? _typeSelect;
  Object? id;
  int page = 0;

  bool isEmptyCL = true;

  SelectPageViewModel(TypeSelect typeSelect, this.id) {
    _typeSelect = typeSelect;
    _usecase = CommonsUsecase(CommonsRepository(dioClient));
    searchController.addListener(() {
      if (!isLoading) {
        if (_typeSelect == TypeSelect.xenditBank) {
          filterNameXenditBank(searchController.text);
        } else if (_typeSelect == TypeSelect.store) {
          filterNameStore(searchController.text);
        } else {
          getData(keyword: searchController.text);
        }
      }
    });
    getData();
  }

  Future<void> getData({String keyword = ""}) async {
    if (keyword.isEmpty) {
      showLoading(true);
    }
    if (_typeSelect == TypeSelect.province) {
      await _usecase.getListProvinces(keyword: keyword).then((value) {
        showLoading(false);
        if (value.values.first != null) {
          getView()!.showError(
              value.values.first!.errors, value.values.first!.httpCode);
        } else {
          listData.clear();
          provinceList.clear();
          provinceList.addAll(value.keys.first!.data!);
          for (final element in provinceList) {
            listData.add(ListSelectGeneric(element.id, element.name, ""));
          }
          notifyListeners();
        }
      }).catchError(print);
    } else if (_typeSelect == TypeSelect.city) {
      await _usecase.getListCity(id as int?, keyword: keyword).then((value) {
        showLoading(false);
        if (value.values.first != null) {
          getView()!.showError(
              value.values.first!.errors, value.values.first!.httpCode);
        } else {
          listData.clear();
          cityList.clear();
          cityList.addAll(value.keys.first!.data!);
          for (final element in cityList) {
            listData.add(ListSelectGeneric(element.id, element.name, ""));
          }
          notifyListeners();
        }
      }).catchError(print);
    } else if (_typeSelect == TypeSelect.cl) {
      await _usecase
          .getListCommunityLeader(id as int?, page, keyword: keyword)
          .then((value) {
        showLoading(false);
        if (value.values.first != null) {
          getView()!.showError(
              value.values.first!.errors, value.values.first!.httpCode);
        } else {
          if (value.keys.first!.data!.totalRecord == 0) {
            isEmptyCL = true;
          } else {
            isEmptyCL = false;
            listData.clear();
            communityLeaderList.clear();
            communityLeaderList.addAll(value.keys.first!.data!.data!);
            for (final element in communityLeaderList) {
              listData.add(ListSelectGeneric(element.id,
                  "${element.name} (${element.displayName})", element.address));
            }
          }

          notifyListeners();
        }
      }).catchError(print);
    } else if (_typeSelect == TypeSelect.xenditBank) {
      await _usecase.getListXenditBank().then((value) {
        showLoading(false);
        if (value.values.first != null) {
          getView()!.showError(
              value.values.first!.errors, value.values.first!.httpCode);
        } else {
          filterData(value.keys.first!);
        }
      }).catchError(print);
    } else if (_typeSelect == TypeSelect.store) {
      await _usecase.getListStore().then((value) {
        showLoading(false);
        if (value.values.first != null) {
          getView()!.showError(
              value.values.first!.errors, value.values.first!.httpCode);
        } else {
          listData.clear();
          storeDatas.clear();
          storeDatas.addAll(value.keys.first!.data);
          for (final element in storeDatas) {
            listData.add(ListSelectGeneric(element.id, element.name, ""));
          }
          listDataCopy.addAll(listData);
          log("DONE");
          notifyListeners();
        }
      }).catchError(print);
    }
  }

  void filterData(List<XenditBank> data) {
    xenditBanks = data
        .where((element) =>
            element.canDisburse == true &&
            !element.code!.contains("SHOPEEPAY") &&
            !element.code!.contains("LINKAJA") &&
            !element.code!.contains("MANDIRI_ECASH") &&
            !element.code!.contains("OVO") &&
            !element.code!.contains("DANA") &&
            !element.code!.contains("GOPAY"))
        .toList();
    for (final element in xenditBanks) {
      listData.add(ListSelectGeneric(element.code, "${element.name}", ""));
    }
    listDataCopy.addAll(listData);
    notifyListeners();
  }

  void filterNameXenditBank(String text) {
    if (text.isEmpty) {
      listData.addAll(listDataCopy);
    } else {
      listData.clear();
      listData.addAll(listDataCopy
          .where((element) => element.name!.toLowerCase().contains(text)));
    }
    notifyListeners();
  }

  void filterNameStore(String text) {
    if (text.isEmpty) {
      listData.addAll(listDataCopy);
    } else {
      listData.clear();
      listData.addAll(listDataCopy
          .where((element) => element.name!.toLowerCase().contains(text)));
    }
    notifyListeners();
  }
}

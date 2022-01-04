import 'dart:developer';
import 'dart:io';

import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';

// ignore: avoid_classes_with_only_static_members
class OtherUtils {
  static bool validatePhoneNumber(String value) {
    const pattern = r'(^(?:[+0]8)[0-9]{8,12}$)';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  static String removeJsonProp(String json) {
    return json
        .replaceAll("(", "")
        .replaceAll("[", "")
        .replaceAll("]", "")
        .replaceAll(")", "");
  }

  static List<String> splitName(String displayName) {
    final splitted = displayName.split(" ");
    return splitted;
  }

  static dynamic myEncode(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    if (item is File) {
      return "";
    }
    return item;
  }

  static void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => log(match.group(0)!));
  }

  static String? buildLoadMoreText(LoadMoreStatus status) {
    String? text = "";
    switch (status) {
      case LoadMoreStatus.fail:
        text = txt("load_more_failed");
        break;
      case LoadMoreStatus.idle:
        text = txt("load_more_idle");
        break;
      case LoadMoreStatus.loading:
        text = txt("load_more_load");
        break;
      case LoadMoreStatus.nomore:
        text = txt("load_more_finish");
        break;
      default:
        text = "";
    }
    return text;
  }

  static const String waitingPayment = "waiting_payment";
  static const String paid = "paid";
  static const String inProgress = "inprogress";
  static const String confirmByAdmin = "confirm_by_admin";
  static const String stockChecked = "stock_checked";
  static const String modified = "modified";
  static const String picked = "picked";
  static const String pickConfirmed = "pick_confirmed";
  static const String delivery = "delivery";
  static const String arrived = "arrived";
  static const String distributedToCustomer = "distributed_to_customer";
  static const String expired = "expired";
  static const String canceledByAdmin = "canceled_by_admin";

  static String? translateStatusOrder(String? status) {
    switch (status) {
      case waitingPayment:
        return txt("waiting_payment");
      case inProgress:
        return txt("order_process");
      case delivery:
        return txt("order_delivery");
      case arrived:
        return txt("order_arrived");
      case distributedToCustomer:
        return txt("order_distributed_to_customer");
      case expired:
        return txt("payment_decline");
      case canceledByAdmin:
        return txt("canceled_by_admin");
      default:
        return txt("order_process");
    }
  }

  static String? translateStatusOrderNotification(String status) {
    switch (status) {
      case waitingPayment:
        return txt("notif_waiting_payment");
      case paid:
        return txt("notif_paid");
      case inProgress:
        return txt("notif_order_process");
      case confirmByAdmin:
        return txt("notif_confirm_by_admin");
      case stockChecked:
        return txt("notif_stock_checked");
      case modified:
        return txt("notif_modified");
      case picked:
        return txt("notif_picked");
      case pickConfirmed:
        return txt("notif_pick_confirmed");
      case expired:
        return txt("notif_expired");
      case canceledByAdmin:
        return txt("notif_canceled_by_admin");
      case delivery:
        return txt("notif_order_delivery");
      case arrived:
        return txt("notif_order_arrived");
      case distributedToCustomer:
        return txt("notif_order_distributed_to_customer");
      default:
        return txt("notif_order_process");
    }
  }

  static Widget buildDiscountBadge(int? productDivision, double? discount,
      {bool smallIcon = false}) {
    String image;
    final isFreshProduct = productDivision == 1;
    if (!isFreshProduct) {
      if (discount! < 15) {
        image = dryDiskonSpecial;
      } else if (discount >= 15 && discount < 20) {
        image = dryDiskon15;
      } else if (discount >= 20 && discount < 25) {
        image = dryDiskon20;
      } else if (discount >= 25 && discount < 30) {
        image = dryDiskon25;
      } else if (discount >= 30 && discount < 35) {
        image = dryDiskon30;
      } else if (discount >= 30 && discount < 35) {
        image = dryDiskon30;
      } else if (discount >= 35 && discount < 40) {
        image = dryDiskon35;
      } else if (discount >= 40 && discount < 45) {
        image = dryDiskon40;
      } else if (discount >= 45 && discount < 50) {
        image = dryDiskon45;
      } else if (discount >= 50 && discount < 55) {
        image = dryDiskon50;
      } else if (discount >= 60 && discount < 70) {
        image = dryDiskon60;
      } else {
        image = dryDiskonSpecial;
      }
    } else {
      if (discount! < 15) {
        image = freshDiskonSpecial;
      } else if (discount >= 15 && discount < 20) {
        image = freshDiskon15;
      } else if (discount >= 20 && discount < 25) {
        image = freshDiskon20;
      } else if (discount >= 25 && discount < 30) {
        image = freshDiskon25;
      } else if (discount >= 30 && discount < 35) {
        image = freshDiskon30;
      } else if (discount >= 30 && discount < 35) {
        image = freshDiskon30;
      } else if (discount >= 35 && discount < 40) {
        image = freshDiskon35;
      } else if (discount >= 40 && discount < 45) {
        image = freshDiskon40;
      } else if (discount >= 45 && discount < 50) {
        image = freshDiskon45;
      } else if (discount >= 50 && discount < 55) {
        image = freshDiskon50;
      } else if (discount >= 60 && discount < 70) {
        image = freshDiskon60;
      } else {
        image = freshDiskonSpecial;
      }
    }

    return Padding(
      padding: smallIcon ? const EdgeInsets.all(0) : const EdgeInsets.all(8),
      child: Image.asset(
        image,
        width: smallIcon ? 36 : 60,
        height: smallIcon ? 36 : 60,
      ),
    );
  }

  static String getRegexPassword() {
    return r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!\#$%&\()*+,-./:;<=>?@[\]^_\`{|}~\"]).{6,}$';
  }

  static String nullReturnStripe(String? value) {
    if (value == null) {
      return "-";
    } else {
      if (value.isEmpty) {
        return "-";
      } else {
        return value;
      }
    }
  }
}

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

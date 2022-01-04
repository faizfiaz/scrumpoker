import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

// ignore: avoid_classes_with_only_static_members
class FormatterDate {
  static String parseToReadable(String dates) {
    final languages = txt("current_language") == "EN" ? "en_US" : "in_ID";
    initializeDateFormatting(languages);
    final parseTime = DateTime.parse(dates).toLocal();
    return DateFormat.yMMMMd(languages).format(parseTime).toString();
  }

  static String getDateTimeNow() {
    final languages = txt("current_language") == "EN" ? "en_US" : "in_ID";
    initializeDateFormatting(languages);
    final now = DateTime.now();
    return DateFormat("yyyy-MM-dd HH:mm:ss", languages).format(now).toString();
  }

  static String parseToReadableNotifications(String dates) {
    final languages = txt("current_language") == "EN" ? "en_US" : "in_ID";
    initializeDateFormatting(languages);
    final parseTime = DateTime.parse(dates).toLocal();
    return DateFormat.yMMMMd(languages).add_Hm().format(parseTime).toString();
  }

  static String parseToReadableFull(String dates) {
    final languages = txt("current_language") == "EN" ? "en_US" : "in_ID";
    initializeDateFormatting(languages);
    final parseTime = DateTime.parse(dates).toLocal();
    return DateFormat.d(languages)
        .add_MMMM()
        .add_y()
        .add_Hm()
        .format(parseTime)
        .toString();
  }

  static String vaParseToReadableFull(String dates) {
    final languages = txt("current_language") == "EN" ? "en_US" : "in_ID";
    initializeDateFormatting(languages);
    var parseTime = DateTime.parse(dates).toLocal();
    parseTime = parseTime.add(const Duration(hours: 1));
    return DateFormat.d(languages)
        .add_MMMM()
        .add_y()
        .add_Hm()
        .format(parseTime)
        .toString();
  }

  static int parseToLong(String dates) {
    final parseTime = DateTime.parse(dates).toLocal();
    return parseTime.millisecondsSinceEpoch;
  }

  ///  Method for checking if created at and status stay in waiting payment > 19 Minutes
  /// return false if < 19 minutes
  /// return true if > 19 minutes
  /// */
  static bool divideTwentyMinutes(String dates) {
    //19 Minutes
    const dividerInMs = 1140000;

    final parseTime = DateTime.parse(dates).toLocal();
    final timeNow = DateTime.now().millisecondsSinceEpoch;
    final dividedTime = timeNow - parseTime.millisecondsSinceEpoch;
    return dividedTime > dividerInMs;
  }

  ///  Method for checking if created at and status stay in waiting payment > 1 hour
  /// return false if < 1 hour
  /// return true if > 1 hour
  /// */
  static bool divideOneHour(String dates) {
    //1 Hours
    const dividerInMs = 3600000;

    final parseTime = DateTime.parse(dates).toLocal();
    final timeNow = DateTime.now().millisecondsSinceEpoch;
    final dividedTime = timeNow - parseTime.millisecondsSinceEpoch;
    return dividedTime >= dividerInMs;
  }

  ///  Method for checking if created at and status stay in waiting payment > 30 minutes
  /// return false if < 30 minutes
  /// return true if > 30 minutes
  /// */
  static bool divideThirtyMinutes(String dates) {
    //30 minutes
    const dividerInMs = 1800000;

    final parseTime = DateTime.parse(dates).toLocal();
    final timeNow = DateTime.now().millisecondsSinceEpoch;
    final dividedTime = timeNow - parseTime.millisecondsSinceEpoch;
    return dividedTime >= dividerInMs;
  }
}

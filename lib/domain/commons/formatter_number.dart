import 'package:currency_formatter/currency_formatter.dart';

// ignore: avoid_classes_with_only_static_members
class FormatterNumber {
  static String getPriceDisplay(double productPrice) {
    final idrFormatter = CurrencyFormatterSettings(
      symbol: 'Rp',
      thousandSeparator: '.',
      decimalSeparator: ',',
    );

    final cf = CurrencyFormatter();
    return cf.format(productPrice, idrFormatter, decimal: 0);
    // FlutterMoneyFormatter fmf = new FlutterMoneyFormatter(
    //     amount: productPrice,
    //     settings: MoneyFormatterSettings(
    //       symbol: 'Rp',
    //       thousandSeparator: '.',
    //       decimalSeparator: ',',
    //       symbolAndNumberSeparator: ' ',
    //       fractionDigits: 0,
    //     ));
    // return fmf.output.symbolOnLeft;
  }

  static String getPriceDisplayTwoZero(double productPrice) {
    final idrFormatter = CurrencyFormatterSettings(
      symbol: 'Rp',
      thousandSeparator: '.',
      decimalSeparator: ',',
    );

    final cf = CurrencyFormatter();
    return cf.format(productPrice, idrFormatter);
    // FlutterMoneyFormatter fmf = new FlutterMoneyFormatter(
    //     amount: productPrice,
    //     settings: MoneyFormatterSettings(
    //       symbol: 'Rp',
    //       thousandSeparator: '.',
    //       decimalSeparator: ',',
    //       symbolAndNumberSeparator: ' ',
    //       fractionDigits: 2,
    //     ));
    // return fmf.output.symbolOnLeft;
  }

  static String getPriceDisplayInteger(int productPrice) {
    final idrFormatter = CurrencyFormatterSettings(
      symbol: 'Rp',
      thousandSeparator: '.',
      decimalSeparator: ',',
    );

    final cf = CurrencyFormatter();
    return cf.format(productPrice, idrFormatter, decimal: 0);
    // FlutterMoneyFormatter fmf = new FlutterMoneyFormatter(
    //     amount: double.parse(productPrice.toString()),
    //     settings: MoneyFormatterSettings(
    //       symbol: 'Rp',
    //       thousandSeparator: '.',
    //       decimalSeparator: ',',
    //       symbolAndNumberSeparator: ' ',
    //       fractionDigits: 0,
    //     ));
    // return fmf.output.symbolOnLeft;
  }

  static String getPriceOnly(double productPrice) {
    final idrFormatter = CurrencyFormatterSettings(
      symbol: '',
      thousandSeparator: '.',
      decimalSeparator: ',',
    );

    final cf = CurrencyFormatter();
    return cf.format(productPrice, idrFormatter, decimal: 0);
    // FlutterMoneyFormatter fmf = new FlutterMoneyFormatter(
    //     amount: productPrice,
    //     settings: MoneyFormatterSettings(
    //       symbol: '',
    //       thousandSeparator: '.',
    //       decimalSeparator: ',',
    //       symbolAndNumberSeparator: ' ',
    //       fractionDigits: 0,
    //     ));
    // return fmf.output.symbolOnLeft;
  }

  static String getPriceDisplayRounded(double productPrice) {
    var priceRender = 0;
    final productPriceInt = productPrice.toInt();
    final productPriceDouble = productPrice;

    // print(productPriceInt);
    // print(productPriceDouble);

    final div = productPriceDouble - productPriceInt.toDouble();
    if (div == 0) {
      priceRender = productPrice.toInt();
    } else {
      final modPrice = productPriceInt % 10;
      final addPrice = 10 - modPrice;
      priceRender = (productPriceInt + addPrice).toInt();
    }

    final idrFormatter = CurrencyFormatterSettings(
      symbol: 'Rp',
      thousandSeparator: '.',
      decimalSeparator: ',',
    );

    final cf = CurrencyFormatter();
    return cf.format(priceRender, idrFormatter, decimal: 0);

    // FlutterMoneyFormatter fmf = new FlutterMoneyFormatter(
    //     amount: priceRender,
    //     settings: MoneyFormatterSettings(
    //       symbol: 'Rp',
    //       thousandSeparator: '.',
    //       decimalSeparator: ',',
    //       symbolAndNumberSeparator: ' ',
    //       fractionDigits: 0,
    //     ));
    // return fmf.output.symbolOnLeft;
  }

  static int haveRounded(double productPrice) {
    final productPriceInt = productPrice.toInt();
    final productPriceDouble = productPrice;

    final div = productPriceDouble - productPriceInt.toDouble();
    if (div == 0) {
      return 0;
    } else {
      final modPrice = productPriceInt % 10;
      final addPrice = 10 - modPrice;
      return addPrice - 1;
    }
  }

  static double roundingPrice(double productPrice) {
    final productPriceInt = productPrice.toInt();
    final productPriceDouble = productPrice;

    final div = productPriceDouble - productPriceInt.toDouble();
    if (div == 0) {
      return productPrice;
    } else {
      final modPrice = productPriceInt % 10;
      final addPrice = 10 - modPrice;
      return (productPriceInt + addPrice).toDouble();
    }
  }
}

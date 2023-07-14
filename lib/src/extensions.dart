import 'package:dynamic_paywalls/dynamic_paywalls.dart';

extension StringExtension on String {
  String replaceVariablesProduct({required QProduct? product}) {
    var result = this;

    if (product == null) {
      return result;
    }

    result = result.replaceAll('@period', product.durationString);
    result = result.replaceAll('@pricePerDay', product.pricePerDay);
    result = result.replaceAll('@pricePerWeek', product.pricePerWeek);
    result = result.replaceAll('@pricePerMonth', product.pricePerMonth);
    result = result.replaceAll('@pricePerYear', product.pricePerYear);
    result = result.replaceAll('@rawPrice', product.rawPrice);
    result = result.replaceAll('@periodInDays', product.periodInDays);
    result = result.replaceAll('@periodInWeeks', product.periodInWeeks);
    result = result.replaceAll('@periodInMonths', product.periodInMonths);
    result = result.replaceAll('@periodInYears', product.periodInYears);
    result = result.replaceAll('@periodInAlt', product.periodInAlt);
    result = result.replaceAll('@trialPeriodInDays', product.trialPeriodInDays);
    result = result.replaceAll('@trialPeriodInWeeks', product.trialPeriodInWeeks);
    result = result.replaceAll('@trialPeriodInMonths', product.trialPeriodInMonths);
    result = result.replaceAll('@trialPeriodInText', product.trialPeriodInText);
    result = result.replaceAll('@price', product.prettyPrice ?? '');

    result = result.replaceAll('@currencyCode', product.currencyCode ?? '');
    result = result.replaceAll('@currencySymbol', product.currencySymbol);

    return result;
  }
}

extension QProductExtension on QProduct {
  String get durationString {
    switch (duration) {
      case QProductDuration.monthly:
        return 'month';
      case QProductDuration.annual:
        return 'year';
      case QProductDuration.weekly:
        return 'week';
      case QProductDuration.threeMonths:
        return '3 months';
      case QProductDuration.sixMonths:
        return '6 months';
      case QProductDuration.lifetime:
        return 'lifetime';
      case QProductDuration.unknown:
        return 'lifetime';
      default:
        return 'lifetime';
    }
  }

  // create function return price per week
  String get pricePerWeek {
    final period = durationString;

    if (price == null) {
      return '';
    }

    if (period == 'week') {
      return "$price";
    }

    if (period == 'month') {
      return ((price ?? 0) / 4).toStringAsFixed(2);
    }

    if (period == '3 months') {
      return ((price ?? 0) / 12).toStringAsFixed(2);
    }

    if (period == '6 months') {
      return ((price ?? 0) / 24).toStringAsFixed(2);
    }

    if (period == 'year') {
      return (price ?? 0 / 52).toStringAsFixed(2);
    }

    return '$price';
  }

  // create function return price per month

  String get pricePerMonth {
    final period = durationString;

    if (price == null) {
      return '';
    }

    if (period == 'week') {
      return ((price ?? 0) * 4).toStringAsFixed(2);
    }

    if (period == 'month') {
      return "$price";
    }

    if (period == '3 months') {
      return ((price ?? 0) / 3).toStringAsFixed(2);
    }

    if (period == '6 months') {
      return ((price ?? 0) / 6).toStringAsFixed(2);
    }

    if (period == 'year') {
      return ((price ?? 0) / 12).toStringAsFixed(2);
    }

    return '$price';
  }

  // create function return price per year  (annual)
  String get pricePerYear {
    final period = durationString;

    if (price == null) {
      return '';
    }

    if (period == 'week') {
      return ((price ?? 0) * 52).toStringAsFixed(2);
    }

    if (period == 'month') {
      return ((price ?? 0) * 12).toStringAsFixed(2);
    }

    if (period == '3 months') {
      return ((price ?? 0) * 4).toStringAsFixed(2);
    }

    if (period == '6 months') {
      return ((price ?? 0) * 2).toStringAsFixed(2);
    }

    if (period == 'year') {
      return "$price";
    }

    return '$price';
  }

  // create function return price per day
  String get pricePerDay {
    final period = durationString;

    if (price == null) {
      return '';
    }

    if (period == 'week') {
      return ((price ?? 0) / 7).toStringAsFixed(2);
    }

    if (period == 'month') {
      return ((price ?? 0) / 30).toStringAsFixed(2);
    }

    if (period == '3 months') {
      return ((price ?? 0) / 90).toStringAsFixed(2);
    }

    if (period == '6 months') {
      return ((price ?? 0) / 180).toStringAsFixed(2);
    }

    if (period == 'year') {
      return ((price ?? 0) / 365).toStringAsFixed(2);
    }

    return '$price';
  }

  // create function return raw price
  String get rawPrice {
    if (price == null) {
      return '';
    }

    return '$price';
  }

  // create function return period in days
  String get periodInDays {
    final period = durationString;

    if (period == 'week') {
      return '7';
    }

    if (period == 'month') {
      return '30';
    }

    if (period == '3 months') {
      return '90';
    }

    if (period == '6 months') {
      return '180';
    }

    if (period == 'year') {
      return '365';
    }

    return '365';
  }

  // create function return period in weeks
  String get periodInWeeks {
    final period = durationString;

    if (period == 'week') {
      return '1';
    }

    if (period == 'month') {
      return '4';
    }

    if (period == '3 months') {
      return '12';
    }

    if (period == '6 months') {
      return '24';
    }

    if (period == 'year') {
      return '52';
    }

    return '52';
  }

  // create function return period in months
  String get periodInMonths {
    final period = durationString;

    if (period == 'week') {
      return '0.25';
    }

    if (period == 'month') {
      return '1';
    }

    if (period == '3 months') {
      return '3';
    }

    if (period == '6 months') {
      return '6';
    }

    if (period == 'year') {
      return '12';
    }

    return '12';
  }

  // create function return period in years
  String get periodInYears {
    final period = durationString;

    if (period == 'week') {
      return '0.0192308';
    }

    if (period == 'month') {
      return '0.0833333';
    }

    if (period == '3 months') {
      return '0.25';
    }

    if (period == '6 months') {
      return '0.5';
    }

    if (period == 'year') {
      return '1';
    }

    return '1';
  }

  // create function return period in alt
  String get periodInAlt {
    final period = durationString;

    if (period == 'week') {
      return 'week';
    }

    if (period == 'month') {
      return 'month';
    }

    if (period == '3 months') {
      return '3 months';
    }

    if (period == '6 months') {
      return '6 months';
    }

    if (period == 'year') {
      return 'year';
    }

    return 'year';
  }

  // create function return trial period in days
  String get trialPeriodInDays {
    switch (trialDuration) {
      case QTrialDuration.threeDays:
        return '3';
      case QTrialDuration.week:
        return '7';
      case QTrialDuration.twoWeeks:
        return '14';
      case QTrialDuration.month:
        return '30';
      case QTrialDuration.twoMonths:
        return '60';
      case QTrialDuration.threeMonths:
        return '90';
      case QTrialDuration.sixMonths:
        return '180';
      case QTrialDuration.year:
        return '365';
      case QTrialDuration.notAvailable:
        return '0';
      default:
        return '0';
    }
  }

  // create function return trial period in weeks
  String get trialPeriodInWeeks {
    switch (trialDuration) {
      case QTrialDuration.threeDays:
        return '0.42';
      case QTrialDuration.week:
        return '1';
      case QTrialDuration.twoWeeks:
        return '2';
      case QTrialDuration.month:
        return '4';
      case QTrialDuration.twoMonths:
        return '8';
      case QTrialDuration.threeMonths:
        return '12';
      case QTrialDuration.sixMonths:
        return '24';
      case QTrialDuration.year:
        return '52';
      case QTrialDuration.notAvailable:
        return '0';
      default:
        return '0';
    }
  }

  // create function return trial period in months
  String get trialPeriodInMonths {
    switch (trialDuration) {
      case QTrialDuration.threeDays:
        return '0.142857';
      case QTrialDuration.week:
        return '0.25';
      case QTrialDuration.twoWeeks:
        return '0.5';
      case QTrialDuration.month:
        return '1';
      case QTrialDuration.twoMonths:
        return '2';
      case QTrialDuration.threeMonths:
        return '3';
      case QTrialDuration.sixMonths:
        return '6';
      case QTrialDuration.year:
        return '12';
      case QTrialDuration.notAvailable:
        return '0';
      default:
        return '0';
    }
  }

  // create function return trial period in text
  String get trialPeriodInText {
    switch (trialDuration) {
      case QTrialDuration.threeDays:
        return '3-days';
      case QTrialDuration.week:
        return 'week';
      case QTrialDuration.twoWeeks:
        return '2-weeks';
      case QTrialDuration.month:
        return 'month';
      case QTrialDuration.twoMonths:
        return '2-months';
      case QTrialDuration.threeMonths:
        return '3-months';
      case QTrialDuration.sixMonths:
        return '6-months';
      case QTrialDuration.year:
        return 'year';
      case QTrialDuration.notAvailable:
        return '0';
      default:
        return '0';
    }
  }

  // create function return currency symbol by correncyCode if not found return correncyCode
  String get currencySymbol {
    switch (currencyCode) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'RUB':
        return '₽';
      case 'AUD':
        return '\$';
      case 'CAD':
        return '\$';
      case 'CHF':
        return 'CHF';
      case 'CNY':
        return '¥';
      case 'SEK':
        return 'kr';
      case 'MXN':
        return '\$';
      case 'NZD':
        return '\$';
      case 'SGD':
        return '\$';
      case 'HKD':
        return '\$';
      case 'NOK':
        return 'kr';
      case 'KRW':
        return '₩';
      case 'TRY':
        return '₺';
      case 'INR':
        return '₹';
      case 'BRL':
        return 'R\$';
      case 'ZAR':
        return 'R';
      case 'SAR':
        return '﷼';
      case 'AED':
        return 'د.إ';
      case 'DKK':
        return 'kr';
      case 'ILS':
        return '₪';
      case 'ARS':
        return '\$';
      case 'CLP':
        return '\$';
      case 'COP':
        return '\$';
      case 'IDR':
        return 'Rp';
      case 'MYR':
        return 'RM';
      case 'PHP':
        return '₱';
      case 'TWD':
        return 'NT\$';
      case 'THB':
        return '฿';
      case 'VND':
        return '₫';
      case 'EGP':
        return '£';
      case 'NGN':
        return '₦';
      case 'PLN':
        return 'zł';
      case 'CZK':
        return 'Kč';
      case 'HUF':
        return 'Ft';
      case 'BGN':
        return 'лв';
      case 'RON':
        return 'lei';
      case 'ISK':
        return 'kr';
      case 'HRK':
        return 'kn';
      case 'RSD':
        return 'Дин.';
      case 'PKR':
        return '₨';
      case 'UAH':
        return '₴';
      case 'BHD':
        return '.د.ب';
      case 'QAR':
        return '﷼';
      case 'KWD':
        return 'د.ك';
      case 'OMR':
        return '﷼';
      case 'JOD':
        return 'د.ا';
      case 'LBP':
        return 'ل.ل';
      case 'VUV':
        return 'Vt';
      case 'WST':
        return 'T';
      case 'TOP':
        return 'T\$';
      case 'SBD':
        return '\$';
      case 'PGK':
        return 'K';
      case 'LAK':
        return '₭';
      case 'BDT':
        return '৳';
      case 'MVR':
        return 'Rf';
      case 'NPR':
        return '₨';
      case 'MNT':
        return '₮';
      case 'KPW':
        return '₩';
      case 'KGS':
        return 'лв';
      case 'GEL':
        return '₾';
      case 'AMD':
        return '֏';
      case 'AFN':
        return '؋';
      case 'AZN':
        return '₼';
      case 'BND':
        return '\$';
      case 'BZD':
        return '\$';
      case 'BMD':
        return '\$';
      case 'SLL':
        return 'Le';
      default:
        return currencyCode ?? '';
    }
  }
}

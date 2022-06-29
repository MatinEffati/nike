import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

const defaultScrollPhysics = BouncingScrollPhysics();

const double productImageBorderRadius = 12;
const double defaultFontLineHeight = 1.4;
const String fontName = 'IranYekan';

// String rialFormatter(String number, {String separator = ","}) {
//   String str = "";
//   var numberSplit = number.split('.');
//   number = numberSplit[0].replaceAll(separator, '');
//   for (var i = number.length; i > 0;) {
//     if (i > 3) {
//       str = separator + number.substring(i - 3, i) + str;
//     } else {
//       str = number.substring(0, i) + str;
//     }
//     i = i - 3;
//   }
//   if (numberSplit.length > 1) {
//     str += '.' + numberSplit[1];
//   }
//   if(str == "0"){
//     return 'رایگان';
//   }else {
//     return str+' تومان';
//   }
//
// }

extension PriceLabel on int {
  String get withPriceLabel =>this > 0 ?'$separateByComma تومان' : 'رایگان';
  String get separateByComma {
    final numberFormat = NumberFormat.decimalPattern();
    return numberFormat.format(this);
  }
}

// String replaceFarsiNumber(String input) {
//   const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
//   const farsi = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
//
//   for (int i = 0; i < english.length; i++) {
//     input = input.replaceAll(english[i], farsi[i]);
//   }
//
//   return input;
// }
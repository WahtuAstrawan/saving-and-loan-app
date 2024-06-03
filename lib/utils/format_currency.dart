import 'package:intl/intl.dart';

String formatCurrency(int amount) {
  NumberFormat currency =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 2);
  return currency.format(amount).toString();
}

import 'package:intl/intl.dart';

String formatCurrency(double value) {
  final formatCurrency = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
  return formatCurrency.format(value);
}

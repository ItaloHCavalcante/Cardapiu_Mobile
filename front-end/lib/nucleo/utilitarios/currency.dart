import 'package:intl/intl.dart';

final _currencyFormatter = NumberFormat.currency(
  locale: 'pt_BR',
  symbol: 'R\$',
);

String money(num value) => _currencyFormatter.format(value);

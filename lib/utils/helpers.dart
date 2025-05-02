import 'package:intl/intl.dart';

/// A collection of helper methods for formatting dates and currency.
class Helpers {
  /// Formats a [DateTime] to a locale-sensitive date string, e.g. “Jan 1, 2025”.
  static String formatDate(DateTime date, {String locale = 'en_US'}) {
    return DateFormat.yMMMd(locale).format(date);
  }

  /// Formats a [DateTime] to include date and time, e.g. “Jan 1, 2025 5:30 PM”.
  static String formatDateTime(DateTime date, {String locale = 'en_US'}) {
    return DateFormat.yMMMd(locale).add_jm().format(date);
  }

  /// Formats a currency [amount] with symbol (default “\$”) and locale.
  /// Example: 1234.5 → “\$1,234.50”
  static String formatCurrency(
    double amount, {
    String locale = 'en_US',
    String symbol = '\$',
  }) {
    final format = NumberFormat.currency(locale: locale, symbol: symbol);
    return format.format(amount);
  }

  /// Formats a date range from [start] to [end], e.g. “Jan 1 – Jan 5, 2025”.
  static String formatDateRange(
    DateTime start,
    DateTime end, {
    String locale = 'en_US',
  }) {
    final startStr = formatDate(start, locale: locale);
    final endStr = DateFormat(end.year == start.year ? 'MMM d' : 'yMMMd', locale)
        .format(end);
    return '$startStr – $endStr';
  }
}

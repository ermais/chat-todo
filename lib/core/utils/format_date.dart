import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  DateTime now = DateTime.now();

  if (date.year == now.year && date.month == now.month && date.day == now.day) {
    return DateFormat('HH:mm').format(date);
  } else if (date.year == now.year) {
    return DateFormat('MMM d').format(date);
  } else {
    return DateFormat('MMM d, y').format(date);
  }
}

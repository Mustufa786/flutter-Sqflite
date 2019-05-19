import 'package:intl/intl.dart';

String DateFormatted() {
  var now = DateTime.now();
  var formatter = new DateFormat("EEE, MMM d ''yy");

  String formatted = formatter.format(now);

  return formatted;
}

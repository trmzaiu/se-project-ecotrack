import 'package:intl/intl.dart';
import 'package:wastesortapp/models/notification.dart';

String formatDate(DateTime time, {String type = 'default'}) {
  switch (type) {
    case 'fullText': // Monday, April 22, 2025
      return DateFormat("EEEE, MMMM dd, yyyy").format(time);
    case 'compactShort': // 22 Apr, 25
      return DateFormat("dd MMM, yy").format(time);
    case 'compactLong': // 22 Apr, 2025
      return DateFormat("dd MMM, yyyy").format(time);
    case 'usStyle': // 04/22/2025
      return DateFormat("MM/dd/yyyy").format(time);
    case 'euroStyle': // 22/04/2025
      return DateFormat("dd/MM/yyyy").format(time);
    case 'yearFirst': // 2025/04/23
      return DateFormat("yyyy/MM/dd").format(time);
    case 'dashed': // 23-04-2025
      return DateFormat("dd-MM-yyyy").format(time);
    case 'yearDashed':
      return DateFormat("yyyy-MM-dd").format(time);
    case 'dotted': // 23.04.2025
      return DateFormat("dd.MM.yyyy").format(time);
    case 'yearMonth': // 2025-04
      return DateFormat("yyyy-MM").format(time);
    case 'monthDay': // April 23
      return DateFormat("MMMM dd").format(time);
    case 'time': // 08:45 PM
      return DateFormat("hh:mm a").format(time);
    case 'iso': // 2025-04-23T20:45:00
      return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(time);
    default: // Apr 22, 2025
      return DateFormat("MMM dd, yyyy").format(time);
  }
}

DateTime parseDate(String dateStr, {String type = 'default'}) {
  switch (type) {
    case 'fullText':
      return DateFormat("EEEE, MMMM dd, yyyy").parse(dateStr);
    case 'compactShort':
      return DateFormat("dd MMM, yy").parse(dateStr);
    case 'compactLong':
      return DateFormat("dd MMM, yyyy").parse(dateStr);
    case 'usStyle':
      return DateFormat("MM/dd/yyyy").parse(dateStr);
    case 'euroStyle':
      return DateFormat("dd/MM/yyyy").parse(dateStr);
    case 'yearFirst':
      return DateFormat("yyyy/MM/dd").parse(dateStr);
    case 'dashed':
      return DateFormat("dd-MM-yyyy").parse(dateStr);
    case 'dashedYear':
      return DateFormat("yyyy-MM-dd").parse(dateStr);
    case 'dotted':
      return DateFormat("dd.MM.yyyy").parse(dateStr);
    case 'yearMonth':
      return DateFormat("yyyy-MM").parse(dateStr);
    case 'monthDay':
      return DateFormat("MMMM dd").parse(dateStr);
    case 'time':
      return DateFormat("hh:mm a").parse(dateStr);
    case 'iso':
      return DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(dateStr);
    default:
      return DateFormat("MMM dd, yyyy").parse(dateStr);
  }
}

String getMonthName(int month) {
  return DateFormat.MMMM().format(DateTime(0, month));
}

String formatDateTime(DateTime time) {
  final int hour = time.hour;
  final int minute = time.minute;
  final String period = hour >= 12 ? 'PM' : 'AM';
  final int formattedHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

  return '$formattedHour:${minute.toString().padLeft(2, '0')} $period';
}

List<Map<String, dynamic>> groupFromRawList(List<Notif> list) {
  final Map<String, List<Notif>> grouped = {};

  for (var item in list) {
    String date = formatDate(item.time, type: 'dashedYear');
    String now = formatDate(DateTime.now(), type: 'dashedYear');
    String yesterday = formatDate(DateTime.now().subtract(Duration(days: 1)), type: 'dashedYear');
    if (date == now) {
      date = 'Today';
    } else if (date == yesterday) {
      date = 'Yesterday';
    }

    if (!grouped.containsKey(date)) {
      grouped[date] = [];
    }

    grouped[date]!.add(item);
  }

  return grouped.entries.map((entry) {
    return {
      'date': entry.key,
      'items': entry.value,
    };
  }).toList();
}

String formatDuration(Duration d, String text) {
  if (d == Duration.zero) return text;
  if (d.inDays >= 1) return "${d.inDays} ${d.inDays == 1 ? 'day' : 'days'}";
  if (d.inHours >= 1) return "${d.inHours} ${d.inHours == 1 ? 'hour' : 'hours'}";
  if (d.inMinutes >= 1) return "${d.inMinutes} ${d.inMinutes == 1 ? 'minute' : 'minutes'}";
  return "${d.inSeconds} ${d.inSeconds == 1 ? 'second' : 'seconds'}";
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime time) {
  return DateFormat("MMM dd, yyyy").format(time);
}

String formatDateTime(DateTime time) {
  final int hour = time.hour;
  final int minute = time.minute;
  final String period = hour >= 12 ? 'PM' : 'AM';
  final int formattedHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

  return '$formattedHour:${minute.toString().padLeft(2, '0')} $period';
}

List<Map<String, dynamic>> groupFromRawList(List<Map<String, dynamic>> list) {
  final Map<String, List<Map<String, dynamic>>> grouped = {};

  for (var item in list) {
    String date = DateFormat('yyyy-MM-dd').format(item['time'].toDate());
    if (date == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
      date = 'Today';
    } else if (date == DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)))) {
      date = 'Yesterday';
    }
    if (!grouped.containsKey(date)) {
      grouped[date] = [];
    }
    grouped[date]!.add({
      ...item,
      'time': formatDateTime(item['time'].toDate()),
    });
  }

  return grouped.entries.map((entry) {
    return {
      'date': entry.key,
      'items': entry.value,
    };
  }).toList();
}

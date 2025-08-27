import 'package:intl/intl.dart';

String formatDuration(num minutes) {
  final hours = minutes ~/ 60;
  final mins = minutes % 60;
  if (mins == 0) {
    return "${hours.toInt()}h";
  } else {
    return "${hours.toInt()}h ${mins.toInt()}m";
  }
}

/// Input: UTC timestamp string (e.g. "2025-08-12 06:11:21.179677+00")
/// Output: Local time like "8:30 AM"
String formatUtcToLocalTime(String utcTimestamp) {
  if (utcTimestamp.isEmpty) return '--';
  try {
    // Parse the incoming UTC string to DateTime (respects the +00 offset)
    final dtUtc = DateTime.parse(
      utcTimestamp.replaceFirst(' ', 'T'), // make it ISO if needed
    );

    // Convert to local
    final dtLocal = dtUtc.toLocal();

    // Format as "8:30 AM" (12-hour, no leading zero)
    return DateFormat('h:mm a').format(dtLocal);
  } catch (_) {
    return '--';
  }
}
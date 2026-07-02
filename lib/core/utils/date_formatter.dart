import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  static String timeAgo(DateTime date) {
    final Duration diff = DateTime.now().difference(date);

    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} years ago";
    } else if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} months ago";
    } else if (diff.inDays > 0) {
      return "${diff.inDays} days ago";
    } else if (diff.inHours > 0) {
      return "${diff.inHours} hours ago";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes} minutes ago";
    } else {
      return "Just now";
    }
  }
}
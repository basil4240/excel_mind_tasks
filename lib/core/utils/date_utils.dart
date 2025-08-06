class DateUtils {
  static String toIsoString(DateTime dateTime) {
    return dateTime.toUtc().toIso8601String();
  }

  static DateTime? fromIsoString(String? isoString) {
    if (isoString == null) return null;
    try {
      return DateTime.parse(isoString);
    } catch (e) {
      return null;
    }
  }

  static bool isOverdue(DateTime? dueDate) {
    if (dueDate == null) return false;
    return DateTime.now().isAfter(dueDate);
  }
}
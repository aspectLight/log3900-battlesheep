class Format {
  Format._();

  static String selectGameLastModified(String raw) {
    final regex = RegExp(
      r'^(Mon|Tue|Wed|Thu|Fri|Sat|Sun)\s+'
      r'(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+'
      r'(\d{1,2})\s+'
      r'(\d{4})\s+'
      r'(\d{2}):(\d{2})',
    );
    final RegExpMatch? match = regex.firstMatch(raw);
    if (match == null) {
      return raw;
    }

    const months = <String, int>{
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12,
    };

    final String monthAbbr = match.group(2)!;
    final int? month = months[monthAbbr];
    if (month == null) {
      return raw;
    }

    final int day = int.parse(match.group(3)!);
    final int year = int.parse(match.group(4)!);
    final int hour = int.parse(match.group(5)!);
    final int minute = int.parse(match.group(6)!);

    final dateTime = DateTime(year, month, day, hour, minute);
    final int shortYear = dateTime.year % 100;
    final int hour12 = dateTime.hour == 0
        ? 12
        : dateTime.hour > 12
        ? dateTime.hour - 12
        : dateTime.hour;
    final amPm = dateTime.hour >= 12 ? 'PM' : 'AM';
    final String minuteStr = dateTime.minute.toString().padLeft(2, '0');

    return '${dateTime.month}/${dateTime.day}/$shortYear, $hour12:$minuteStr $amPm';
  }
}

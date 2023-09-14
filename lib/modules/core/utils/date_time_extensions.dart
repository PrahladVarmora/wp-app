extension DateTimeExtension on DateTime {
  DateTime addHoursAndMinutesString({required String duration}) {
    return add(Duration(
        hours: int.parse(duration.split(':').first),
        minutes: int.parse(duration.split(':')[1])));
  }

  ///[firstDayOfWeek] is used to get monday before the date
  DateTime firstDayOfWeek() {
    DateTime monday = DateTime.utc(year, month, day);
    monday = monday.subtract(Duration(days: monday.weekday - 1));
    return monday;
  }

  ///[firstDayOfMonth] is used to get first day of month of given date
  ///eg. given date is 10th Nov 2022 then return value will be 1st Nov 2022
  DateTime firstDayOfMonth() {
    return DateTime.utc(year, month, 1);
  }

  ///[firstDayOfYear] is used to get first day of month of given date
  ///eg. given date is 10th Nov 2022 then return value will be 1st Jan 2022
  DateTime firstDayOfYear() {
    return DateTime.utc(year, 1, 1);
  }
}

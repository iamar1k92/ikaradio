import 'package:base/generated/l10n.dart';

class TimeAgo {
  String format(DateTime date) {
    final _clock = DateTime.now();
    var elapsed = _clock.millisecondsSinceEpoch - date.millisecondsSinceEpoch;
    String suffix = S.current.suffix_ago;

    final num seconds = elapsed / 1000;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;
    final num days = hours / 24;
    final num months = days / 30;
    final num years = days / 365;

    String result;
    if (seconds < 45) {
      result = S.current.less_than_one_minute;
    } else if (seconds < 90) {
      result = S.current.about_a_minute;
    } else if (minutes < 45) {
      result = S.current.minutes(minutes.round().toString());
    } else if (minutes < 90) {
      result = S.current.about_an_hour;
    } else if (hours < 24) {
      result = S.current.hours(hours.round().toString());
    } else if (hours < 48) {
      result = S.current.a_day;
    } else if (days < 30) {
      result = S.current.days(days.round().toString());
    } else if (days < 60) {
      result = S.current.about_a_month;
    } else if (days < 365) {
      result = S.current.months(months.round().toString());
    } else if (years < 2) {
      result = S.current.about_a_year;
    } else {
      result = S.current.years(years.round().toString());
    }
    return result + " " + suffix;
  }
}

import 'num.dart';
extension DateTimeExtension on DateTime? {
  bool get isNull {
    return this == null;
  }

  String? toSqlString({bool keepMillisecond = false}) {
    if(isNull) return null;
    if(keepMillisecond){
      return '${this!.year.toFourDigits}-${this!.month.toTwoDigits}-${this!.day.toTwoDigits} ${this!.hour.toTwoDigits}:${this!.minute.toTwoDigits}:${this!.second.toTwoDigits}.${this!.millisecond.toThreeDigits}';
    }
    return '${this!.year.toFourDigits}-${this!.month.toTwoDigits}-${this!.day.toTwoDigits} ${this!.hour.toTwoDigits}:${this!.minute.toTwoDigits}:${this!.second.toTwoDigits}';
  }
  String? toDateString({String format = 'YYYY-MM-DD'}) {
    if(isNull) return null;
    format = format.replaceAll('YYYY', this!.year.toFourDigits!);
    format = format.replaceAll('YY', this!.year.toFourDigits!.substring(2,4));
    format = format.replaceAll('MM', this!.month.toTwoDigits!);
    format = format.replaceAll('DD', this!.day.toTwoDigits!);
    format = format.replaceAll('hh', this!.hour.toTwoDigits!);
    format = format.replaceAll('mm', this!.minute.toTwoDigits!);
    format = format.replaceAll('ss', this!.second.toTwoDigits!);
    return format;
  }

  //当前日期位于本月第几周
  int? get weekN {
    if(isNull) return null;
    var monthStart = DateTime(this!.year, this!.month, 1);
    var startDayWeekday = monthStart.weekday;
    var roundWeek = ((this!.day - 1) / 7).floor();
    return this!.weekday < startDayWeekday ? 1 + roundWeek + 1 : 1 + roundWeek;
  }

  String? get weekdayName {
    if(isNull) return null;
    var _map = <int, String>{
      1 : '星期一',
      2 : '星期二',
      3 : '星期三',
      4 : '星期四',
      5 : '星期五',
      6 : '星期六',
      7 : '星期日'
    };
    return _map[this!.weekday];
  }


  //是否闰年
  bool? get isLeapYear {
    if(isNull) return null;
    if(this!.year % 100 == 0){
      if(this!.year % 400 == 0){
        return true;
      }
    } else {
      if(this!.year % 4 == 0){
        return true;
      }
    }
    return false;
  }
  //本月天数
  int? get daysOfCurrentMonth {
    if(isNull) return null;
    if(this!.month == 2){
      if(this!.isLeapYear!){
        return 29;
      } else {
        return 28;
      }
    } else {
      if([1, 3, 5, 7, 8, 10, 12].contains(this!.month)){
        return 31;
      }
    }
    return 30;
  }
  bool? get isToday {
    if(isNull) return null;
    var now = DateTime.now();
    return (this!.year == now.year) &&
        (this!.month == now.month) &&
        (this!.day == now.day);
  }

}

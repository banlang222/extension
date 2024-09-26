extension StringExtension on String? {
  bool get isNull {
    return this == null;
  }

  bool get isNullOrEmpty {
    return this == null ? true : this!.isEmpty;
  }

  int? toInt() {
    return this == null ? null : int.tryParse(this!);
  }

  double? toDouble() {
    return this == null ? null : double.tryParse(this!);
  }

  num? toNum() {
    return this == null ? null : num.tryParse(this!);
  }

  DateTime? toDateTime() {
    if(this == null) return null;
    var re = RegExp(r'^([+-]?\d{4,6})[-|/|年]?(\d{1,2})[-|/|月]?(\d{1,2})日?' // Day part.
    r'(?:[ T](\d{1,2})(?::?(\d{1,2})(?::?(\d{1,2})(?:[.,](\d+))?)?)?' // Time part.
    r'( ?[zZ]| ?([-+])(\d\d)(?::?(\d\d))?)?)?$');
    if(re.hasMatch(this!)) {
      Match? match = re.firstMatch(this!);
      if (match != null) {
        int parseIntOrZero(String? matched) {
          if (matched == null) return 0;
          return int.parse(matched);
        }

        // Parses fractional second digits of '.(\d+)' into the combined
        // microseconds. We only use the first 6 digits because of DateTime
        // precision of 999 milliseconds and 999 microseconds.
        int parseMilliAndMicroseconds(String? matched) {
          if (matched == null) return 0;
          // var length = matched.length;
          var result = 0;
          for (var i = 0; i < 6; i++) {
            result *= 10;
            if (i < matched.length) {
              result += matched.codeUnitAt(i) ^ 0x30;
            }
          }
          return result;
        }

        var years = int.parse(match[1]!);
        var month = int.parse(match[2]!);
        var day = int.parse(match[3]!);
        var hour = parseIntOrZero(match[4]);
        var minute = parseIntOrZero(match[5]);
        var second = parseIntOrZero(match[6]);
        var milliAndMicroseconds = parseMilliAndMicroseconds(match[7]);
        var millisecond =
            milliAndMicroseconds ~/ Duration.microsecondsPerMillisecond;
        var microsecond = milliAndMicroseconds
            .remainder(Duration.microsecondsPerMillisecond);
        var isUtc = false;
        if (match[8] != null) {
          // timezone part
          isUtc = true;
          var tzSign = match[9];
          if (tzSign != null) {
            // timezone other than 'Z' and 'z'.
            var sign = (tzSign == '-') ? -1 : 1;
            var hourDifference = int.parse(match[10]!);
            var minuteDifference = parseIntOrZero(match[11]);
            minuteDifference += 60 * hourDifference;
            minute -= sign * minuteDifference;
          }
        }
        if(isUtc){
          return DateTime.utc(years, month, day, hour, minute,
              second, millisecond, microsecond);
        }
        return DateTime(years, month, day, hour, minute,
            second, millisecond, microsecond);
      }
    }
    return null;
  }

  String? supperTrim() {
    if(isNullOrEmpty) return this;
    return this!.replaceAll(RegExp(r'^(\s|&nbsp;|\r|\n)|(\s|&nbsp;|\r|\n)$'), '');
  }
}

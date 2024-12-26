import 'dart:math';

extension NumExtension on num? {
  bool get isNull {
    return this == null;
  }

  String? get toTwoDigits {
    if (isNull) return null;
    if (this! >= 10) return '${this}';
    return '0${this}';
  }

  String? get toThreeDigits {
    if (isNull) return null;
    if (this! >= 100) return '${this}';
    if (this! >= 10) return '0${this}';
    return '00${this}';
  }

  String? get toFourDigits {
    if (isNull) return null;
    var absN = this!.abs();
    var sign = this! < 0 ? '-' : '';
    if (absN >= 1000) return '$this';
    if (absN >= 100) return '${sign}0$absN';
    if (absN >= 10) return '${sign}00$absN';
    return '${sign}000$absN';
  }

  //保留小数点后n位，int原样返回，小数点后为0则取整
  num? decimal(int n) {
    if (this == null) return null;
    if (this is double &&
        !this!.isNaN &&
        !this!.isInfinite) {
      var result = (this! * pow(10, n)).round() / pow(10, n);
      return result.round() == result ? result.round() : result;
    } else if (this is int) {
      return this;
    }
    return null;
  }

  num? get tryToInt {
    return isNull
        ? this
        : this == this!.toInt()
            ? this!.toInt()
            : this;
  }

  String? get tryToIntString {
    return tryToInt?.toString();
  }

  String? addThousandSeparator() {
    if (this == null) return null;
    String _value = toString();
    int start = _value.indexOf('.');
    List<String> str = [];
    if (start > -1) {
      str.add(_value.substring(start));
    } else {
      start = _value.length;
    }
    while (start > 0) {
      if (start - 3 > 0) {
        str.add(_value.substring(start - 3, start));
      } else {
        str.add(_value.substring(0, start));
      }
      start -= 3;
    }
    return str.reversed.join(',').replaceAll(',.', '.');
  }
}

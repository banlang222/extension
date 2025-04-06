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

  //保留小数点后n位，省略小数点后没用的0
  num? decimal(int n) {
    if (this == null) return null;
    if (this is double && !this!.isNaN && !this!.isInfinite) {
      var result = (this! * pow(10, n)).round() / pow(10, n);
      return result.round() == result ? result.round() : result;
    } else if (this is int) {
      return this;
    }
    return null;
  }

  ///保留小数点后n位，并添加千位分隔符省，略小数点后没用的0
  String? decimalTS(int n) {
    if (this == null) return null;
    String _value = this!.decimal(n)!.toString();
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
    return str.reversed.join(',').replaceAll(',.', '.').replaceAll('-,', '-');
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

  String? toMoney() {
    if (this == null) return null;
    String _value = this!.toStringAsFixed(2);
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
    return str.reversed.join(',').replaceAll(',.', '.').replaceAll('-,', '-');
  }

  String toChineseMoney() {
    if (this == null) return '零';
    const List<String> chineseDigits = [
      '零',
      '壹',
      '贰',
      '叁',
      '肆',
      '伍',
      '陆',
      '柒',
      '捌',
      '玖'
    ];
    const List<String> chineseUnits = ['', '拾', '佰', '仟'];
    const List<String> chineseBigUnits = ['', '万', '亿'];

    String amountStr = this!.toStringAsFixed(2); // 保留两位小数
    List<String> parts = amountStr.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';

    String result = '';

    // 处理整数部分
    int length = integerPart.length;
    for (int i = 0; i < length; i++) {
      int digit = int.parse(integerPart[i]);
      int unitIndex = (length - i - 1) % 4;
      int bigUnitIndex = (length - i - 1) ~/ 4;

      if (digit != 0) {
        result += chineseDigits[digit] + chineseUnits[unitIndex];
      } else {
        // 处理连续的零
        if (result.isNotEmpty && !result.endsWith('零')) {
          result += '零';
        }
      }

      // 添加大单位（万、亿）
      if (unitIndex == 0 && bigUnitIndex > 0) {
        result += chineseBigUnits[bigUnitIndex];
      }
    }

    if (result.isNotEmpty) {
      // 处理末尾的零
      result = result.replaceAll(RegExp(r'零+$'), '');
      result = result.replaceAll(RegExp(r'零+'), '零');
      result += '元';
    }

    // 处理小数部分（角和分）
    if (decimalPart.isNotEmpty) {
      int jiao = int.parse(decimalPart[0]); // 角
      int fen = decimalPart.length > 1 ? int.parse(decimalPart[1]) : 0; // 分

      if (jiao != 0) {
        result += chineseDigits[jiao] + '角';
      }
      if (fen != 0) {
        result += (jiao == 0 ? '零' : '') + chineseDigits[fen] + '分';
      }

      // 如果没有小数部分，添加“整”
      if (jiao == 0 && fen == 0) {
        result += '整';
      }
    } else {
      result += '整';
    }

    return result.isEmpty ? '零元整' : result;
  }
}

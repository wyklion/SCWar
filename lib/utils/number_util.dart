class NumberUtil {
  static const List<String> normalUnits = ['K', 'M', 'B', 'T'];

  static String getUnit(int idx) {
    if (idx <= 4) {
      return normalUnits[idx - 1];
    } else if (idx <= 30) {
      return String.fromCharCode(idx - 5 + 97);
    } else if (idx <= 56) {
      var a = String.fromCharCode(idx - 31 + 97);
      return '$a$a';
    } else {
      return '';
    }
  }

  static int getUnitLevel(double v) {
    int x = 0;
    while (v >= 1000) {
      v /= 1000;
      x++;
    }
    return x;
  }

  static double getScale(double v) {
    if (v <= 16384) {
      return 1 + 0.05 * v.toInt().bitLength;
    }
    var x = getUnitLevel(v);
    return 1.7 + 0.05 * x;
  }

  static String convertValue(double v, int fix) {
    if (v < 1000) {
      return '$v';
    }
    int x = 0;
    while (v >= 1000) {
      v /= 1000;
      x++;
    }
    if (x > 56) {
      return 'TOOBIG';
    }
    var unit = getUnit(x);
    return '${v.toStringAsFixed(fix)}$unit';
  }

  static String getTowerString(double v) {
    if (v < 16384) {
      return '${v.toInt()}';
    }
    return NumberUtil.convertValue(v, 0);
  }

  static String getScoreString(double v) {
    if (v < 99999999) {
      return '$v';
    } else {
      return convertValue(v, 3);
    }
  }

  static bool nearlyEqual(double a, double b) {
    return (a - b).abs() < 0.5;
  }

  static const List<String> units = [
    'K',
    'M',
    'B',
    'T',
    'aa',
    'bb',
    'cc',
    'dd',
    'ee',
    'ff',
    'gg',
    'hh',
    'ii',
    'jj',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
  ];
}

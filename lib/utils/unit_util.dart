class UnitUtil {
  static String convertValue(int v, int fix) {
    if (v < 1000) {
      // less than a thousand
      return '$v';
    } else if (v >= 1000 && v < (1000 * 100 * 10)) {
      // less than a million
      double result = v / 1000;
      return '${result.toStringAsFixed(fix)}K';
    } else if (v >= 1000000 && v < (1000000 * 10 * 100)) {
      // less than 100 million
      double result = v / 1000000;
      return '${result.toStringAsFixed(fix)}M';
    } else if (v >= (1000000 * 10 * 100) && v < (1000000 * 10 * 100 * 100)) {
      // less than 100 billion
      double result = v / (1000000 * 10 * 100);
      return '${result.toStringAsFixed(fix)}B';
    } else if (v >= (1000000 * 10 * 100 * 100) &&
        v < (1000000 * 10 * 100 * 100 * 100)) {
      // less than 100 trillion
      double result = v / (1000000 * 10 * 100 * 100);
      return '${result.toStringAsFixed(fix)}T';
    } else {
      return 'BIG';
    }
  }
}

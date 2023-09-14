///[InterpolateString] This class use to Interpolate String via any string
class InterpolateString {
  static String interpolate(dynamic string, List params) {
    String result = string;
    for (int i = 1; i < params.length + 1; i++) {
      result = result.replaceFirst('{#}', params[i - 1]);
    }
    return result;
  }
}

import 'package:we_pro/modules/core/common/widgets/app_localizations.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';

/// This extension is use for Email Validator feature
extension Translator on String {
  String translate() {
    try {
      return AppLocalizations.of(getNavigatorKeyContext())!.translate(this) ??
          this;
    } catch (e) {
      return '-';
    }
  }
}

/// This extension is use for Email Validator feature
extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^[a-z0-9](\.?[a-z0-9_-]){0,}@[a-z0-9-]+\.([a-z]{2,6}\.)?[a-z]{2,6}$')
        .hasMatch(this);
  }
}

/// This extension is use for Mobile Number Validator feature
extension MobileNoValidator on String {
  bool isValidMobileNo(int? min, int? max) {
    if ((min != null && max != null) && min == max) {
      return (length == min);
    } else if (min != null && max != null) {
      return (length > min && length < max);
    } else if (min != null && max == null) {
      return (length > min && length < 13);
    } else if (min == null && max != null) {
      return (length > 5 && length < max);
    } else {
      return (length > 5 && length < 13);
    }
  }
}

/// This extension is use for Password Validator feature
extension PasswordValidator on String {
  bool isValidPassword() {
    return RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,25}$')
        .hasMatch(this);
  }
}

/// This extension is use for Password Validator feature
extension Pdf on String {
  bool isPdf() {
    return toLowerCase().endsWith('.pdf');
  }
}

/// This extension is use for Password Validator feature
extension SVG on String {
  bool isSVG() {
    return toLowerCase().endsWith('.svg');
  }
}

/// This extension is use for Password Validator feature
extension UTF on String {
  String utf8convert() {
    try {
      List<int> bytes = toString().codeUnits;
      return utf8.decode(bytes);
    } catch (e) {
      return this;
    }
  }
}

/// This extension is use for Password Validator feature
extension KeyToString on String {
  String keyToString() {
    try {
      return replaceAll('_', ' ').replaceFirst(this[0], this[0].toUpperCase());
    } catch (e) {
      return this;
    }
  }
}

extension Interpolate on String {
  String interpolate(List<String> params) {
    String result = this;
    for (int i = 1; i < params.length + 1; i++) {
      result = result.replaceFirst('{#}', params[i - 1]);
    }
    return result;
  }
}

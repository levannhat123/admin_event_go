typedef FormFieldValidator<T> = String Function(T value);

abstract class FieldValidator<T> {
  final String errorText;

  FieldValidator(this.errorText);

  bool isValid(T value);

  String? call(T value) {
    return isValid(value) ? null : errorText;
  }
}

abstract class TextFieldValidator extends FieldValidator<String> {
  TextFieldValidator(super.errorText);

  bool get ignoreEmptyValues => true;

  @override
  String? call(String value) {
    return (ignoreEmptyValues && value.isEmpty) ? null : super.call(value);
  }

  bool hasMatch(String pattern, String input, {bool caseSensitive = true}) =>
      RegExp(pattern, caseSensitive: caseSensitive).hasMatch(input);
}

class RequiredValidator extends TextFieldValidator {
  RequiredValidator({required String errorText}) : super(errorText);

  @override
  bool get ignoreEmptyValues => false;

  @override
  bool isValid(String? value) {
    return value!.trim().isNotEmpty;
  }

  @override
  String? call(String? value) {
    return isValid(value) ? null : errorText;
  }
}

class MinLengthValidator extends TextFieldValidator {
  final int min;

  MinLengthValidator(this.min, {required String errorText}) : super(errorText);

  @override
  bool get ignoreEmptyValues => false;

  @override
  bool isValid(String? value) {
    return value!.length >= min;
  }
}

class EmailValidator extends TextFieldValidator {
  /// regex pattern to validate email inputs.
  final Pattern _emailPattern =
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";

  EmailValidator({required String errorText}) : super(errorText);

  @override
  bool isValid(String? value) =>
      hasMatch(_emailPattern.toString(), value!, caseSensitive: false);
}

class PhoneValidator extends TextFieldValidator {
  /// Biểu thức chính quy kiểm tra số điện thoại hợp lệ
  final Pattern _phonePattern = r'^\+?[0-9]{9,15}$';

  PhoneValidator({required String errorText}) : super(errorText);

  @override
  bool isValid(String? value) =>
      hasMatch(_phonePattern.toString(), value!, caseSensitive: false);
}

class MatchValidator extends TextFieldValidator {
  final String? password;

  MatchValidator(this.password, {required String errorText}) : super(errorText);

  @override
  bool isValid(String? value) {
    return value == password;
  }
}

class NotMatchValidator extends TextFieldValidator {
  final String? password;

  NotMatchValidator(this.password, {required String errorText})
      : super(errorText);

  @override
  bool isValid(String? value) {
    return value != password;
  }
}

class MultiValidator extends FieldValidator<String> {
  final List<FieldValidator> validators;
  static String _errorText = '';

  MultiValidator(this.validators) : super(_errorText);

  @override
  bool isValid(value) {
    for (FieldValidator validator in validators) {
      if (validator.call(value) != null) {
        _errorText = validator.errorText;
        return false;
      }
    }
    return true;
  }

  @override
  String? call(dynamic value) {
    return isValid(value) ? null : _errorText;
  }
}

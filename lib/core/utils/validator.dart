import 'package:admin_event_go/core/constants/app_strings.dart';

import 'form_validator.dart';

class Validator {
  static final required = MultiValidator([
    RequiredValidator(errorText: AppStrings.validatorFieldRequired),
  ]).call;

  static final password = MultiValidator([
    RequiredValidator(errorText: AppStrings.validatorFieldRequired),
    MinLengthValidator(6, errorText: AppStrings.validatorPasswordMin6),
  ]).call;

  static final email = MultiValidator([
    RequiredValidator(errorText: AppStrings.validatorFieldRequired),
    EmailValidator(errorText: AppStrings.validatorEnterValidEmail),
  ]).call;
  static final phone = MultiValidator([
    RequiredValidator(errorText: AppStrings.validatorFieldRequired),
    PhoneValidator(errorText: AppStrings.validatorEnterValidPhone),
  ]).call;

  static String? Function(String?)? confirmPassword(String? password) {
    return MultiValidator([
      RequiredValidator(errorText: AppStrings.validatorFieldRequired),
      MatchValidator(password,
          errorText: AppStrings.validatorConfirmPasswordNotMatch),
    ]).call;
  }
}

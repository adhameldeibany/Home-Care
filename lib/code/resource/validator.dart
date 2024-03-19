import 'package:form_field_validator/form_field_validator.dart';

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'password is required'),
  MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
  PatternValidator(r'(?=.*?[#?!@$%^&*-])',
      errorText: 'passwords must have at least one special character')
]);
final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'Email is required'),
  EmailValidator(
    errorText: 'enter a valid email address',
  ),
]);
final phoneValidator = MultiValidator([
  RequiredValidator(errorText: 'phone is required'),
  PatternValidator(r'(^[0-9]{10}$)', errorText: 'phone Number is Not valid')
]);
// final numberValidator = MultiValidator([
//   RequiredValidator(errorText: 'age is required'),
//   PatternValidator(r'(^(?:[+0]9)?[0-9]{10,12}$)'
// , errorText: 'age must be number')
// ]);

String? validateNamber(String value) {
  RegExp regExp = RegExp(r"^[0-9]{2}$", caseSensitive: false);
  if (value.isEmpty) {
    return "age is required";
  } else if (regExp.hasMatch(value) == false) {
    return "number only";
  } else if (int.parse(value) < 0 && int.parse(value) < 100) {
    return "please enter valid age";
  }
}

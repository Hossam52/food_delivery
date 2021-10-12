import 'package:dartz/dartz.dart';
import 'package:food_delivery_app/core/validation_failure.dart';
import 'package:validators/validators.dart';

Either<ConfirmPasswordValidationFailure, String> validateConfirmPassword(
    String password, String confirmPassword) {
  if (confirmPassword.isEmpty) {
    return left(const ConfirmPasswordValidationFailure.empty());
  }
  if (confirmPassword != password) {
    return left(const ConfirmPasswordValidationFailure.passwordNotMatch());
  }
  return right(confirmPassword);
}

PasswordValidationFailure? validatePassword(String password) {
  if (password.isEmpty) {
    return const PasswordValidationFailure.empty();
  }
  if (password.length <= 6) {
    return const PasswordValidationFailure.shortPassword();
  }
}

EmailValidationFailure? validateEmail(String email) {
  if (email.isEmpty) {
    return const EmailValidationFailure.empty();
  }
  if (!isEmail(email)) {
    return const EmailValidationFailure.invalid();
  }
}

Either<UserNameValidationFailure, String> validateUserName(String userName) {
  if (userName.isEmpty) {
    return left(const UserNameValidationFailure.empty());
  }
  if (!isAlphanumeric(userName)) {
    return left(const UserNameValidationFailure.invalid());
  }

  if (userName.length < 4) {
    return left(const UserNameValidationFailure.tooShort());
  }
  return right(userName);
}

Either<PhoneNumberValidationFailure, String> validatephoneNumber(
    String phoneNumber) {
  if (phoneNumber.isEmpty) {
    return left(const PhoneNumberValidationFailure.empty());
  }
  if (!isNumeric(phoneNumber)) {
    return left(const PhoneNumberValidationFailure.invalid());
  }

  if (phoneNumber.length != 11) {
    return left(const PhoneNumberValidationFailure.invalid());
  }
  return right(phoneNumber);
}

Either<AddressFieldValidationFailure, String> validateAddressField(
    String addressField) {
  if (addressField.isEmpty) {
    return left(const AddressFieldValidationFailure.empty());
  }

  return right(addressField);
}

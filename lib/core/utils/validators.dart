
String? validate(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'This field cannot be empty';
  }
  return null;
}

String? fNameValidate(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter First Name';
  }
  return null;
}
String? lNameValidate(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Enter Last Name';
  }
  return null;
}
String? numberValidate(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'This field cannot be empty';
  }

  final trimmedValue = value.trim();
  if (!RegExp(r'^\d+$').hasMatch(trimmedValue)) {
    return 'Only numeric values are allowed';
  }
  if (trimmedValue.length < 10) {
    return 'The number must be at least 10 digits';
  }
  return null;
}

String? EmpValidate(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'This field cannot be empty';
  }

  final RegExp specialCharRegExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  if (specialCharRegExp.hasMatch(value)) {
    return 'Special characters are not allowed';
  }

  return null;
}

String? passwordValidation(value) {
  RegExp fullValue =
  RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  RegExp regex = RegExp(r'^.{8,}$');
  RegExp specialCharVal = RegExp(r'^(?=.*?[!@#\$&*~%^])');
  RegExp numberVal = RegExp(r'^(?=.*?[0-9])');
  RegExp upperCase = RegExp(r'^(?=.*?[A-Z])');
  RegExp lowerCase = RegExp(r'^(?=.*?[a-z])');

  if (value.isEmpty) {
    return 'Password is required';
  } else {
    if (!fullValue.hasMatch(value)) {
      return !fullValue.hasMatch(value)
          ? '${!regex.hasMatch(value) == true ? 'Password has to be at least 8 characters.' : ''} ${!numberVal.hasMatch(value) == true ? 'Password must contain at least one number.' : ''} ${!upperCase.hasMatch(value) == true ? 'Password must contain at least one lower-case letter & one upper-case letter.' : ''} ${!lowerCase.hasMatch(value) == true ? 'Password must contain at least one lower-case letter & one upper-case letter.' : ''} ${!specialCharVal.hasMatch(value) == true ? 'Password must contain at least one special character (! @ # \$ % ^ & *).' : ''}'
          : null;
    } else {
      return null;
    }
  }
}

String? dropdownValidator(String? value) {
  if (value == null || value == 'Select an option') {
    return 'Please select a valid option';
  }
  return null;
}

String? phoneNumberValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a phone number';
  }

  final pattern = RegExp(r'^[6-9][0-9]{9}$');

  if (!pattern.hasMatch(value)) {
    return 'Enter a valid 10-digit mobile number starting with 6-9';
  }

  return null;
}


String? dropdownValidate<T>(T? value) {
  if (value == null || value == 'Select an option') {
    return 'Please select a valid option';
  }
  return null;
}

String? panValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'PAN number is required';
  }

  String panNo = value.trim().toUpperCase();
  // PAN format: [A-Z]{5}[0-9]{4}[A-Z]{1}
  final panPattern = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');

  if (!panPattern.hasMatch(panNo)) {
    return 'Enter a valid PAN number (e.g., ABCDE1234F)';
  }

  return null;
}

String? emailValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email is required';
  }

  final emailPattern = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  if (!emailPattern.hasMatch(value.trim())) {
    return 'Enter a valid email address';
  }

  return null;
}
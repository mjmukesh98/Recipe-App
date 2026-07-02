abstract class AuthState {
  final bool obscurePassword;

  const AuthState({this.obscurePassword = true});
}

class AuthInitial extends AuthState {
  const AuthInitial({super.obscurePassword = true});

  AuthInitial copyWith({bool? obscurePassword}) {
    return AuthInitial(
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }
}

class AuthLoading extends AuthState {
  const AuthLoading({super.obscurePassword = true});
}

class AuthSuccess extends AuthState {
  final dynamic user;

  const AuthSuccess(this.user, {super.obscurePassword = true});
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message, {super.obscurePassword = true});
}

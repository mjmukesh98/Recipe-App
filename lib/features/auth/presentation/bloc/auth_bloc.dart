import 'package:demo/core/error/error_handler.dart';
import 'package:demo/core/services/secure_storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc(this.loginUseCase) : super(const AuthInitial()) {
    on<LoginRequested>(_onLogin);

    on<TogglePasswordVisibility>(_togglePassword);
  }

  void _togglePassword(
    TogglePasswordVisibility event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthInitial(obscurePassword: !state.obscurePassword));
  }

  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading(obscurePassword: state.obscurePassword));

    try {
      final user = await loginUseCase(event.username, event.password);
      emit(AuthSuccess(user, obscurePassword: state.obscurePassword));
    } catch (e) {
      final message = ErrorHandler.handle(e);

      emit(AuthFailure(message));
    }
  }
}

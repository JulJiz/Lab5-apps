import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab5/features/auth/domain/errors/auth_failure.dart';
import 'package:lab5/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:lab5/features/login/ui/bloc/login_event.dart';
import 'package:lab5/features/login/ui/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SignInUseCase _signIn;

  LoginBloc(this._signIn) : super(const LoginState()) {
    on<LoginSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      final (user, profile) = await _signIn(
        email: event.email,
        password: event.password,
      );
      emit(
        state.copyWith(
          status: LoginStatus.success,
          user: user,
          profile: profile,
        ),
      );
    } on AuthFailure catch (e) {
      emit(
        state.copyWith(status: LoginStatus.failure, errorMessage: e.message),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage:
              'Algo salió mal. Revisa tu conexión e intenta de nuevo.',
        ),
      );
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab5/features/auth/domain/errors/auth_failure.dart';
import 'package:lab5/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:lab5/features/register/ui/bloc/register_event.dart';
import 'package:lab5/features/register/ui/bloc/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final SignUpUseCase _signUp;

  RegisterBloc(this._signUp) : super(const RegisterState()) {
    on<RegisterSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: RegisterStatus.loading));
    try {
      final profile = await _signUp(
        username: event.username,
        fullName: event.fullName,
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(status: RegisterStatus.success, profile: profile));
    } on AuthFailure catch (e) {
      emit(
        state.copyWith(status: RegisterStatus.failure, errorMessage: e.message),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          errorMessage:
              'Algo salió mal. Revisa tu conexión e intenta de nuevo.',
        ),
      );
    }
  }
}

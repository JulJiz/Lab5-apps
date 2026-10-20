import 'package:lab5/features/auth/domain/repository/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _auth;

  SignOutUseCase(this._auth);

  Future<void> call() => _auth.signOut();
}

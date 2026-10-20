import 'package:lab5/features/auth/domain/entities/auth_user.dart';
import 'package:lab5/features/auth/domain/entities/profile.dart';
import 'package:lab5/features/auth/domain/repository/auth_repository.dart';
import 'package:lab5/features/auth/domain/repository/profile_repository.dart';

class SignInUseCase {
  final AuthRepository _auth;
  final ProfileRepository _profiles;

  SignInUseCase(this._auth, this._profiles);

  Future<(AuthUser, Profile)> call({
    required String email,
    required String password,
  }) async {
    final user = await _auth.signIn(email: email, password: password);
    final profile = await _profiles.getProfile(user.id);
    return (user, profile);
  }
}

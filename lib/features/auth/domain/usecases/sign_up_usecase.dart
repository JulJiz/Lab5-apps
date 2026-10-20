import 'package:lab5/features/auth/domain/entities/profile.dart';
import 'package:lab5/features/auth/domain/errors/auth_failure.dart';
import 'package:lab5/features/auth/domain/repository/auth_repository.dart';
import 'package:lab5/features/auth/domain/repository/profile_repository.dart';

class SignUpUseCase {
  final AuthRepository _auth;
  final ProfileRepository _profiles;

  SignUpUseCase(this._auth, this._profiles);

  Future<Profile> call({
    required String username,
    required String fullName,
    required String email,
    required String password,
  }) async {
    final user = await _auth.signUp(email: email, password: password);
    final profile = Profile(
      id: user.id,
      username: username,
      fullName: fullName,
    );

    try {
      await _profiles.createProfile(profile);
    } on AuthFailure catch (e) {
      throw AuthFailure(
        'Tu cuenta se creó, pero no se pudo guardar el perfil: ${e.message}',
      );
    }

    return profile;
  }
}

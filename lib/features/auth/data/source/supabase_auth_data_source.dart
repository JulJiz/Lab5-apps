import 'package:lab5/features/auth/domain/entities/auth_user.dart';
import 'package:lab5/features/auth/domain/errors/auth_failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

class SupabaseAuthDataSource {
  final SupabaseClient _client;

  SupabaseAuthDataSource(this._client);

  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async {
    final AuthResponse response;
    try {
      response = await _client.auth.signUp(email: email, password: password);
    } on AuthException catch (e) {
      throw AuthFailure(_messageFor(e));
    }

    final user = response.user;
    if (user == null) {
      throw const AuthFailure('No se pudo crear la cuenta. Intenta de nuevo.');
    }
    if (response.session == null) {
      throw const AuthFailure(
        'La cuenta quedó pendiente de confirmar por correo. '
        'Confírmala o desactiva "Confirm email" en Supabase.',
      );
    }

    return AuthUser(id: user.id, email: user.email ?? email);
  }

  String _messageFor(AuthException e) {
    switch (e.code) {
      case 'user_already_exists':
      case 'email_exists':
        return 'El correo ya está registrado.';
      case 'weak_password':
        return 'La contraseña es muy débil. Usa al menos 6 caracteres.';
      case 'email_address_invalid':
      case 'validation_failed':
        return 'El correo no es válido.';
      case 'over_email_send_rate_limit':
      case 'over_request_rate_limit':
        return 'Demasiados intentos. Espera un momento e intenta de nuevo.';
      default:
        return e.message;
    }
  }
}

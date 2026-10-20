import 'package:lab5/features/auth/domain/entities/profile.dart';
import 'package:lab5/features/auth/domain/errors/auth_failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProfileDataSource {
  final SupabaseClient _client;

  SupabaseProfileDataSource(this._client);

  Future<void> createProfile(Profile profile) async {
    try {
      await _client.from('profiles').insert({
        'id': profile.id,
        'username': profile.username,
        'full_name': profile.fullName,
      });
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw const AuthFailure('Ese nombre de usuario ya está en uso.');
      }
      throw AuthFailure(e.message);
    }
  }

  Future<Profile> getProfile(String id) async {
    try {
      final row = await _client.from('profiles').select().eq('id', id).single();
      return Profile(
        id: row['id'] as String,
        username: row['username'] as String,
        fullName: row['full_name'] as String,
      );
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw const AuthFailure('Tu cuenta no tiene perfil guardado.');
      }
      throw AuthFailure(e.message);
    }
  }
}

import 'package:lab5/features/auth/data/source/supabase_auth_data_source.dart';
import 'package:lab5/features/auth/domain/entities/auth_user.dart';
import 'package:lab5/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseAuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<AuthUser> signUp({required String email, required String password}) {
    return _dataSource.signUp(email: email, password: password);
  }
}

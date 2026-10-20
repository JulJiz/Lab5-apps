import 'package:lab5/features/auth/data/source/supabase_profile_data_source.dart';
import 'package:lab5/features/auth/domain/entities/profile.dart';
import 'package:lab5/features/auth/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final SupabaseProfileDataSource _dataSource;

  ProfileRepositoryImpl(this._dataSource);

  @override
  Future<void> createProfile(Profile profile) {
    return _dataSource.createProfile(profile);
  }

  @override
  Future<Profile> getProfile(String id) => _dataSource.getProfile(id);
}

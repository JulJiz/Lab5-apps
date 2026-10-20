import 'package:lab5/features/auth/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<void> createProfile(Profile profile);

  Future<Profile> getProfile(String id);
}

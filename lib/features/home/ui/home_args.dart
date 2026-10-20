import 'package:lab5/features/auth/domain/entities/profile.dart';

class HomeArgs {
  final Profile profile;
  final String email;

  const HomeArgs({required this.profile, required this.email});
}

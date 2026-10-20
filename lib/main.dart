import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lab5/features/auth/data/repository/auth_repository_impl.dart';
import 'package:lab5/features/auth/data/repository/profile_repository_impl.dart';
import 'package:lab5/features/auth/data/source/supabase_auth_data_source.dart';
import 'package:lab5/features/auth/data/source/supabase_profile_data_source.dart';
import 'package:lab5/features/auth/domain/repository/auth_repository.dart';
import 'package:lab5/features/auth/domain/repository/profile_repository.dart';
import 'package:lab5/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:lab5/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:lab5/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:lab5/features/home/ui/home_args.dart';
import 'package:lab5/features/home/ui/screens/home_screen.dart';
import 'package:lab5/features/login/ui/bloc/login_bloc.dart';
import 'package:lab5/features/login/ui/screens/login_screen.dart';
import 'package:lab5/features/register/ui/bloc/register_bloc.dart';
import 'package:lab5/features/register/ui/screens/register_screen.dart';
import 'package:lab5/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ptlwjdaolgcaqhysrnkb.supabase.co',
    publishableKey: 'sb_publishable_cFOzGzL7zY8NckBxLN6YYQ_qmQctSbP',
  );

  runApp(const App());
}

AuthRepository _authRepository() =>
    AuthRepositoryImpl(SupabaseAuthDataSource(Supabase.instance.client));

ProfileRepository _profileRepository() =>
    ProfileRepositoryImpl(SupabaseProfileDataSource(Supabase.instance.client));

/// Root widget that declares the theme and the named routes.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 5',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      initialRoute: '/login',
      routes: {
        '/login': (_) => BlocProvider(
          create: (_) =>
              LoginBloc(SignInUseCase(_authRepository(), _profileRepository())),
          child: const LoginScreen(),
        ),
        '/register': (_) => BlocProvider(
          create: (_) => RegisterBloc(
            SignUpUseCase(_authRepository(), _profileRepository()),
          ),
          child: const RegisterScreen(),
        ),
        '/home': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as HomeArgs;
          return HomeScreen(
            username: args.profile.username,
            fullName: args.profile.fullName,
            email: args.email,
            onSignOut: SignOutUseCase(_authRepository()).call,
          );
        },
      },
    );
  }
}

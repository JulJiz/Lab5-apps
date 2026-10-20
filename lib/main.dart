import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lab5/features/auth/data/repository/auth_repository_impl.dart';
import 'package:lab5/features/auth/data/repository/profile_repository_impl.dart';
import 'package:lab5/features/auth/data/source/supabase_auth_data_source.dart';
import 'package:lab5/features/auth/data/source/supabase_profile_data_source.dart';
import 'package:lab5/features/auth/domain/entities/profile.dart';
import 'package:lab5/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:lab5/features/home/ui/screens/home_screen.dart';
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

/// Root widget that declares the theme and the named routes.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moviles Auth',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => BlocProvider(
          create: (_) => RegisterBloc(
            SignUpUseCase(
              AuthRepositoryImpl(
                SupabaseAuthDataSource(Supabase.instance.client),
              ),
              ProfileRepositoryImpl(
                SupabaseProfileDataSource(Supabase.instance.client),
              ),
            ),
          ),
          child: const RegisterScreen(),
        ),
        '/home': (context) {
          final profile = ModalRoute.of(context)!.settings.arguments;
          if (profile is! Profile) return const HomeScreen();
          return HomeScreen(
            username: profile.username,
            fullName: profile.fullName,
          );
        },
      },
    );
  }
}

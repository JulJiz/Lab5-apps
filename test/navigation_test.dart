import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab5/features/auth/domain/entities/auth_user.dart';
import 'package:lab5/features/auth/domain/entities/profile.dart';
import 'package:lab5/features/auth/domain/errors/auth_failure.dart';
import 'package:lab5/features/auth/domain/repository/auth_repository.dart';
import 'package:lab5/features/auth/domain/repository/profile_repository.dart';
import 'package:lab5/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:lab5/features/home/ui/screens/home_screen.dart';
import 'package:lab5/features/register/ui/bloc/register_bloc.dart';
import 'package:lab5/features/register/ui/screens/register_screen.dart';
import 'package:lab5/main.dart';

void main() {
  testWidgets('sign in goes to profile and sign out comes back', (
    tester,
  ) async {
    await tester.pumpWidget(const App());
    expect(find.text('Bienvenido de nuevo'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Iniciar sesión'));
    await tester.pump();
    expect(find.text('Escribe tu correo y tu contraseña'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'ana@icesi.edu.co');
    await tester.enterText(find.byType(TextField).at(1), '123456');
    await tester.tap(find.widgetWithText(FilledButton, 'Iniciar sesión'));
    await tester.pumpAndSettle();
    expect(find.text('Perfil'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Cerrar sesión'));
    await tester.pumpAndSettle();
    expect(find.text('Bienvenido de nuevo'), findsOneWidget);
  });

  testWidgets('sign up rejects passwords that do not match', (tester) async {
    final profiles = FakeProfileRepository();
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          '/': (_) => BlocProvider(
            create: (_) =>
                RegisterBloc(SignUpUseCase(FakeAuthRepository(), profiles)),
            child: const RegisterScreen(),
          ),
          '/home': (context) {
            final profile =
                ModalRoute.of(context)!.settings.arguments as Profile;
            return HomeScreen(
              username: profile.username,
              fullName: profile.fullName,
            );
          },
        },
      ),
    );
    expect(find.text('Crea tu cuenta'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'ana');
    await tester.enterText(find.byType(TextField).at(1), 'Ana Gómez');
    await tester.enterText(find.byType(TextField).at(2), 'ana@icesi.edu.co');
    await tester.enterText(find.byType(TextField).at(3), '123456');
    await tester.enterText(find.byType(TextField).at(4), '654321');
    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'Registrarme'),
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Registrarme'));
    await tester.pump();
    expect(find.text('Las contraseñas no coinciden'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(4), '123456');
    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'Registrarme'),
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Registrarme'));
    await tester.pumpAndSettle();
    expect(find.text('Perfil'), findsOneWidget);
    expect(find.text('Ana Gómez'), findsWidgets);
    expect(profiles.saved?.id, 'abc-123');
  });

  test('SignUpUseCase avisa si la cuenta quedó sin perfil', () async {
    final signUp = SignUpUseCase(
      FakeAuthRepository(),
      FakeProfileRepository(fail: true),
    );

    expect(
      () => signUp(
        username: 'ana',
        fullName: 'Ana Gómez',
        email: 'ana@icesi.edu.co',
        password: '123456',
      ),
      throwsA(isA<AuthFailure>()),
    );
  });
}

class FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async {
    return AuthUser(id: 'abc-123', email: email);
  }
}

class FakeProfileRepository implements ProfileRepository {
  final bool fail;
  Profile? saved;

  FakeProfileRepository({this.fail = false});

  @override
  Future<void> createProfile(Profile profile) async {
    if (fail) throw const AuthFailure('permission denied');
    saved = profile;
  }
}

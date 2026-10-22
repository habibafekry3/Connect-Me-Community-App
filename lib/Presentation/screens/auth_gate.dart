import 'package:connectme_app/Presentation/blocs/auth_cubit.dart';
import 'package:connectme_app/Presentation/blocs/auth_state.dart';
import 'package:connectme_app/Presentation/blocs/post_cubit.dart';
import 'package:connectme_app/Presentation/screens/home_screen.dart';
import 'package:connectme_app/Presentation/screens/login_screen.dart';
import 'package:connectme_app/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is Authenticated) {
          return BlocProvider(
            create: (_) => getIt<PostCubit>()..loadPosts(),
            child: const HomeScreen(),
          );
        }

        return const LoginScreen();
      },
    );
  }
}

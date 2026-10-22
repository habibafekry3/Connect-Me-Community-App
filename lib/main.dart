import 'package:connectme_app/core/theme/app_theme.dart';
import 'package:connectme_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectme_app/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Presentation/blocs/auth_cubit.dart';

import 'Presentation/screens/auth_gate.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  setupDependencies();
  debugPrint('GetIt hash: ${getIt.hashCode}');
  debugPrint('Registered types: ${getIt.isRegistered<AuthService>()}');
  debugPrint('All ready: ${getIt.allReady().toString()}');

  runApp(const ConnectMeApp());
}

class ConnectMeApp extends StatelessWidget {
  const ConnectMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Connect Me',
      theme: AppTheme.lightTheme,
      home: BlocProvider(
        create: (_) => AuthCubit(getIt())..checkAuthStatus(),
        child: const AuthGate(),
      ),
    );
  }
}

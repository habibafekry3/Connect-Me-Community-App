import 'package:connectme_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectme_app/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Presentation/blocs/auth_cubit.dart';
import 'Presentation/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  setupDependencies();

  runApp(const ConnectMeApp());
}

class ConnectMeApp extends StatelessWidget {
  const ConnectMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Connect Me',
      home: BlocProvider(
        create: (_) => AuthCubit(getIt()),
        child: const LoginScreen(),
      ),
    );
  }
}

import 'package:connectme_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectme_app/injection.dart';
import 'package:flutter/material.dart';

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
      home: Scaffold(
        appBar: AppBar(title: const Text('ConnectMe')),
        body: const Center(child: Text('Welcome to ConnectMe')),
      ),
    );
  }
}

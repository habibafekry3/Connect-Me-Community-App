import 'package:connectme_app/injection.dart';
import 'package:flutter/material.dart';

void main() {
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

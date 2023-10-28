import 'package:flutter/material.dart';

import '../styles/styles.dart';
import 'login_screen.dart';
import 'registration_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  ///
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(decoration: pinkBackGround),
          title: const Text(
            'iShop',
            style: TextStyle(fontSize: 30, letterSpacing: 3, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white54,
            indicatorWeight: 6,
            tabs: [
              Tab(
                text: 'Login',
                icon: Icon(Icons.lock, color: Colors.white),
              ),
              Tab(
                text: 'Registration',
                icon: Icon(Icons.person, color: Colors.white),
              ),
            ],
          ),
        ),
        body: const DecoratedBox(
          decoration: pinkBackGround,
          child: TabBarView(
            children: [
              LoginScreen(),
              RegistrationScreen(),
            ],
          ),
        ),
      ),
    );
  }
}

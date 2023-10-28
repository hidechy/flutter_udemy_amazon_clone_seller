import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../styles/styles.dart';
import 'auth_screen.dart';
import 'home_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  ///
  void splashScreenTimer() {
    Timer(const Duration(seconds: 4), () async {
      if (FirebaseAuth.instance.currentUser != null) {
        await Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      } else {
        await Navigator.push(context, MaterialPageRoute(builder: (c) => const AuthScreen()));
      }
    });
  }

  ///
  @override
  void initState() {
    super.initState();

    splashScreenTimer();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Material(
      child: DecoratedBox(
        decoration: pinkBackGround,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset('assets/images/splash.png'),
              ),
              const SizedBox(height: 10),
              const Text(
                'iShop Sellers App',
                style: TextStyle(
                  fontSize: 30,
                  letterSpacing: 3,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

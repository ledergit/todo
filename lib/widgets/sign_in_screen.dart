import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  final void Function() onSignon;

  const SignInScreen({required this.onSignon, super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signUp() async {
    try {
      // final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      widget.onSignon();
    } on FirebaseAuthException catch (e) {
      print('Sign up failed: ${e.message}');
    }
  }

  Future<void> _signIn() async {
    try {
      // final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      widget.onSignon();
    } on FirebaseAuthException catch (e) {
      print('Sign in failed: ${e.message}');
    }
  }

  @override
  void initState() {
    _emailController.text = 'matthew.leder@gmail.com';
    _passwordController.text = 'Todo4LL!';
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome!')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //email field:
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _signUp, // to replace with _signUp,
                  child: const Text('Sign up'),
                ),
                const SizedBox(width: 24),
                ElevatedButton(
                  onPressed: _signIn, // to replace with _signIn
                  child: const Text('Sign in'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

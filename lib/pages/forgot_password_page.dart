import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  bool _isLoading = false;
  String? _message;

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _email.text.trim(),
      );
      setState(() {
        _message = "Reset link sent! Check your inbox.";
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _message = e.message;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                "Enter your email to receive a password reset link.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (val) =>
                    val != null && val.contains("@") ? null : "Enter a valid email",
              ),
              const SizedBox(height: 30),
              if (_message != null)
                Text(
                  _message!,
                  style: TextStyle(
                    color: _message!.startsWith("Reset") ? Colors.green : Colors.red,
                  ),
                ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _isLoading ? null : _sendResetLink,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text("Send Reset Link"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  String errorMsg = "";

  void login() {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();

    final user = usersList.firstWhere(
      (u) => u["email"] == email && u["password"] == pass,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      context.go('/home');
    } else {
      setState(() => errorMsg = "Email ou mot de passe incorrect");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Connexion",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              TextField(controller: emailCtrl, decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "Email")),
              const SizedBox(height: 12),

              TextField(controller: passCtrl, obscureText: true, decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "Mot de passe")),
              const SizedBox(height: 12),

              if (errorMsg.isNotEmpty)
                Text(errorMsg, style: const TextStyle(color: Colors.red)),

              const SizedBox(height: 12),
              ElevatedButton(onPressed: login, child: const Text("Se connecter")),

              TextButton(
                onPressed: () => context.go('/signup'),
                child: const Text("Créer un compte"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

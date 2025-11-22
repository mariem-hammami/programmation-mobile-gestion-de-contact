import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../main.dart'; // contient usersList

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  String errorMsg = "";

  void register() {
    if (!_formKey.currentState!.validate()) return;

    final email = emailCtrl.text.trim();
    final exists = usersList.any((u) => u["email"] == email);

    if (exists) {
      setState(() => errorMsg = "Cet utilisateur existe déjà");
      return;
    }

    usersList.add({
      "firstName": firstNameCtrl.text.trim(),
      "lastName": lastNameCtrl.text.trim(),
      "phone": phoneCtrl.text.trim(),
      "email": email,
      "password": passCtrl.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Compte créé avec succès !")),
    );

    context.go('/');  // 🔥 Retour à la page login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Créer un compte")),
      body: Center(
        child: SizedBox(
          width: 350,
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                TextFormField(
                  controller: firstNameCtrl,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Nom"),
                  validator: (v) => v!.isEmpty ? "Nom obligatoire" : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: lastNameCtrl,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Prénom"),
                  validator: (v) => v!.isEmpty ? "Prénom obligatoire" : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Téléphone"),
                  validator: (v) => v!.isEmpty ? "Téléphone obligatoire" : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Email"),
                  validator: (v) => v!.isEmpty ? "Email obligatoire" : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Mot de passe"),
                  validator: (v) => v!.isEmpty ? "Mot de passe obligatoire" : null,
                ),
                const SizedBox(height: 12),

                if (errorMsg.isNotEmpty)
                  Text(errorMsg, style: const TextStyle(color: Colors.red)),

                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: register,
                  child: const Text("Créer un compte"),
                ),

                TextButton(
                  onPressed: () => context.go('/'),
                  child: const Text("Déjà un compte ? Se connecter"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

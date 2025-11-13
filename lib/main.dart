import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// 💾 Liste globale d'utilisateurs
List<Map<String, String>> usersList = [];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application Authentification',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

/// 🔐 PAGE DE CONNEXION
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Veuillez remplir tous les champs.');
      return;
    }

    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isLoading = false);

      bool userExists = usersList.any(
          (user) => user['email'] == email && user['password'] == password);

      if (userExists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ContactHomePage()),
        );
      } else {
        _showErrorDialog('Email ou mot de passe incorrect.');
      }
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline, color: Colors.blue, size: 100),
                const SizedBox(height: 20),
                const Text(
                  'Connexion',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          'Se connecter',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupPage()),
                    );
                  },
                  child: const Text(
                    'Créer un compte',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 🧾 PAGE D’INSCRIPTION
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleSignup() {
    String nom = _nomController.text.trim();
    String prenom = _prenomController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (nom.isEmpty || prenom.isEmpty || email.isEmpty || password.isEmpty) {
      _showError('Veuillez remplir tous les champs.');
      return;
    }

    if (!email.contains('@')) {
      _showError('Veuillez entrer un email valide.');
      return;
    }

    bool emailExiste = usersList.any((user) => user['email'] == email);
    if (emailExiste) {
      _showError('Cet email est déjà utilisé.');
      return;
    }

    usersList.add({
      'email': email,
      'password': password,
      'nom': nom,
      'prenom': prenom,
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Inscription réussie 🎉'),
        content: Text('Bienvenue, $prenom $nom !'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text('Se connecter'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inscription'), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Créer un compte',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 30),
              TextField(controller: _nomController, decoration: const InputDecoration(labelText: 'Nom', prefixIcon: Icon(Icons.person), border: OutlineInputBorder())),
              const SizedBox(height: 20),
              TextField(controller: _prenomController, decoration: const InputDecoration(labelText: 'Prénom', prefixIcon: Icon(Icons.person_outline), border: OutlineInputBorder())),
              const SizedBox(height: 20),
              TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email), border: OutlineInputBorder())),
              const SizedBox(height: 20),
              TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Mot de passe', prefixIcon: Icon(Icons.lock), border: OutlineInputBorder()), obscureText: true),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _handleSignup,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                child: const Text('S\'inscrire', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 📇 CONTACTS + RECHERCHE
class Contact {
  String nom;
  String numero;
  Contact({required this.nom, required this.numero});
}

class ContactHomePage extends StatefulWidget {
  const ContactHomePage({super.key});

  @override
  State<ContactHomePage> createState() => _ContactHomePageState();
}

class _ContactHomePageState extends State<ContactHomePage> {
  final List<Contact> _contacts = [];
  List<Contact> _filteredContacts = []; // pour la recherche
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredContacts = _contacts;
    _searchController.addListener(_filtrerContacts);
  }

  @override
  void dispose() {
    _nomController.dispose();
    _numeroController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filtrerContacts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _contacts.where((contact) {
        return contact.nom.toLowerCase().contains(query) ||
            contact.numero.contains(query);
      }).toList();
    });
  }

  void _ajouterContact() {
    if (_nomController.text.isNotEmpty && _numeroController.text.isNotEmpty) {
      setState(() {
        _contacts.add(Contact(nom: _nomController.text, numero: _numeroController.text));
        _filteredContacts = _contacts;
      });
      _nomController.clear();
      _numeroController.clear();
      Navigator.pop(context);
    }
  }

  void _modifierContact(int index) {
    Contact contact = _filteredContacts[index];
    _nomController.text = contact.nom;
    _numeroController.text = contact.numero;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Modifier contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nomController, decoration: const InputDecoration(labelText: 'Nom')),
            TextField(controller: _numeroController, decoration: const InputDecoration(labelText: 'Numéro')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                contact.nom = _nomController.text;
                contact.numero = _numeroController.text;
                _filteredContacts = _contacts;
              });
              _nomController.clear();
              _numeroController.clear();
              Navigator.pop(context);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _supprimerContact(int index) {
    setState(() {
      Contact contact = _filteredContacts[index];
      _contacts.remove(contact);
      _filteredContacts = _contacts;
    });
  }

  void _ouvrirFormulaireAjout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nouveau contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nomController, decoration: const InputDecoration(labelText: 'Nom')),
            TextField(controller: _numeroController, decoration: const InputDecoration(labelText: 'Numéro')),
          ],
        ),
        actions: [
          TextButton(onPressed: _ajouterContact, child: const Text('Ajouter')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Contacts'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Rechercher contact',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _filteredContacts.isEmpty
                ? const Center(child: Text('Aucun contact trouvé.'))
                : ListView.builder(
                    itemCount: _filteredContacts.length,
                    itemBuilder: (context, index) {
                      Contact contact = _filteredContacts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.person)),
                          title: Text(contact.nom),
                          subtitle: Text(contact.numero),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(icon: const Icon(Icons.edit), onPressed: () => _modifierContact(index)),
                              IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _supprimerContact(index)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _ouvrirFormulaireAjout,
        child: const Icon(Icons.add),
      ),
    );
  }
}

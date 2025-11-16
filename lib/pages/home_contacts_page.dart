import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // <-- important pour context.go
import '../models/contact.dart';

class HomeContactsPage extends StatefulWidget {
  const HomeContactsPage({super.key});

  @override
  State<HomeContactsPage> createState() => _HomeContactsPageState();
}

class _HomeContactsPageState extends State<HomeContactsPage> {
  final contacts = <Contact>[];
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final searchCtrl = TextEditingController();

  String searchText = "";

  void addContact() {
    if (nameCtrl.text.isEmpty || phoneCtrl.text.isEmpty) return;
    setState(() {
      contacts.add(Contact(name: nameCtrl.text, phone: phoneCtrl.text));
      nameCtrl.clear();
      phoneCtrl.clear();
    });
  }

  void editContact(int index) {
    nameCtrl.text = contacts[index].name;
    phoneCtrl.text = contacts[index].phone;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Modifier Contact"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Nom"),
            ),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: "Téléphone"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                contacts[index] = Contact(name: nameCtrl.text, phone: phoneCtrl.text);
                nameCtrl.clear();
                phoneCtrl.clear();
              });
              Navigator.pop(ctx);
            },
            child: const Text("Modifier"),
          ),
        ],
      ),
    );
  }

  void deleteContact(int index) {
    setState(() {
      contacts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredContacts = contacts.where((c) {
      final q = searchText.toLowerCase();
      return c.name.toLowerCase().contains(q) ||
             c.phone.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Contacts"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.go('/'), // 🔥 Déconnexion GoRouter
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            TextField(
              controller: searchCtrl,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                labelText: "Rechercher contact...",
              ),
              onChanged: (value) => setState(() => searchText = value),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "Nom"),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "Téléphone"),
            ),
            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: addContact,
              child: const Text("Ajouter Contact"),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: filteredContacts.length,
                itemBuilder: (context, i) {
                  final c = filteredContacts[i];
                  final originalIndex = contacts.indexOf(c);

                  return ListTile(
                    title: Text(c.name),
                    subtitle: Text(c.phone),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => editContact(originalIndex),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteContact(originalIndex),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
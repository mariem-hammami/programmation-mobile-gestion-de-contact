// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';  // ⭐ IMPORT NECESSAIRE POUR DÉCONNEXION
import '../services/db_helper.dart';
import '../models/contact.dart';

class HomeContactsPage extends StatefulWidget {
  const HomeContactsPage({super.key});

  @override
  State<HomeContactsPage> createState() => _HomeContactsPageState();
}

class _HomeContactsPageState extends State<HomeContactsPage> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController searchCtrl = TextEditingController();

  String searchQuery = "";
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    searchCtrl.dispose();
    super.dispose();
  }

  Future<void> loadContacts() async {
    contacts = await DBHelper.instance.getContacts();
    if (mounted) setState(() {});
  }

  Future<void> addContact() async {
    if (nameCtrl.text.isEmpty || phoneCtrl.text.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Remplissez le nom et le téléphone")),
      );
      return;
    }

    final newContact = Contact(
      name: nameCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
    );

    await DBHelper.instance.insertContact(newContact);

    nameCtrl.clear();
    phoneCtrl.clear();
    await loadContacts();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Contact ajouté")),
    );
  }

  void editContact(Contact c) {
    final editName = TextEditingController(text: c.name);
    final editPhone = TextEditingController(text: c.phone);

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text("Modifier Contact"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editName,
                decoration: const InputDecoration(labelText: "Nom"),
              ),
              TextField(
                controller: editPhone,
                decoration: const InputDecoration(labelText: "Téléphone"),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
                editName.dispose();
                editPhone.dispose();
              },
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () async {
                final updated = Contact(
                  id: c.id,
                  name: editName.text.trim(),
                  phone: editPhone.text.trim(),
                );

                await DBHelper.instance.updateContact(updated);
                await loadContacts();

                if (!mounted) return;
                Navigator.pop(dialogCtx);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Contact modifié")),
                );

                editName.dispose();
                editPhone.dispose();
              },
              child: const Text("Enregistrer"),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteContact(int id) async {
    await DBHelper.instance.deleteContact(id);
    await loadContacts();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Contact supprimé")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Déconnexion"),
                  content: const Text("Voulez-vous vraiment vous déconnecter ?"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text("Annuler")),
                    ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text("Se déconnecter")),
                  ],
                ),
              );

              if (confirm == true) {
                context.go('/'); // ⭐ Utilisation correcte GoRouter
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: "Nom"),
                ),
                TextField(
                  controller: phoneCtrl,
                  decoration: const InputDecoration(labelText: "Téléphone"),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: addContact,
                  child: const Text("Ajouter Contact"),
                ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: searchCtrl,
                    decoration: const InputDecoration(
                      labelText: "Rechercher...",
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() => searchQuery = value.trim().toLowerCase());
                    },
                  ),
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: contacts.isEmpty
                      ? const Center(child: Text("Aucun contact"))
                      : ListView.builder(
                          itemCount: contacts.length,
                          itemBuilder: (ctx, i) {
                            final c = contacts[i];

                            if (searchQuery.isNotEmpty &&
                                !c.name.toLowerCase().contains(searchQuery) &&
                                !c.phone.toLowerCase().contains(searchQuery)) {
                              return const SizedBox.shrink();
                            }

                            return ListTile(
                              title: Text(c.name),
                              subtitle: Text(c.phone),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => editContact(c),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => deleteContact(c.id!),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

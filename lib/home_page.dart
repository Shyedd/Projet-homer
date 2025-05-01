import 'package:flutter/material.dart';
import 'settings_page.dart';  // Ajouter cet import
import 'message_page.dart';  // Import MessagePage

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('WhatsApp'),
        ),
        body: TabBarView(
          children: [
            const ChatsTab(),
            const SettingsPage(),  // Remplacer SettingsTab par SettingsPage
          ],
        ),
        bottomNavigationBar: TabBar(
          labelColor: Theme.of(context).primaryColor,
          tabs: const [
            Tab(icon: Icon(Icons.chat), text: 'CHATS'),
            Tab(icon: Icon(Icons.settings), text: 'Paramètres'),
          ],
        ),
      ),
    );
  }
}

class ChatsTab extends StatefulWidget {
  const ChatsTab({super.key});

  // j'adore la pratique du docking
  @override
  _ChatsTabState createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  final Map<String, String> _contacts = {
    'Contact 1': 'https://via.placeholder.com/150',
    'Contact 2': 'https://via.placeholder.com/150',
  };

  void _editContactName(String oldName) {
    final TextEditingController _nameController = TextEditingController(text: oldName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier le nom du contact'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Entrez le nouveau nom'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  final newName = _nameController.text.trim();
                  if (newName.isNotEmpty) {
                    _contacts[newName] = _contacts.remove(oldName)!;
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  void _addContact() {
    final TextEditingController _nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter un contact'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Entrez le nom du contact'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  final newName = _nameController.text.trim();
                  if (newName.isNotEmpty) {
                    final middleIndex = (_contacts.length / 2).floor();
                    final entries = _contacts.entries.toList();
                    entries.insert(
                      middleIndex,
                      MapEntry(newName, 'https://via.placeholder.com/150'),
                    );
                    _contacts
                      ..clear()
                      ..addEntries(entries);
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: _contacts.entries.map((entry) {
          final contactName = entry.key;
          final contactImage = entry.value;
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(contactImage),
            ),
            title: Text(contactName),
            subtitle: const Text(''),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert), // Icône des trois petits points
              onSelected: (value) {
                if (value == 'edit') {
                  _editContactName(contactName);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Modifier le nom'),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessagePage(
                    contactName: contactName,
                    contactImage: contactImage,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContact,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Settings'),
    );
  }
}

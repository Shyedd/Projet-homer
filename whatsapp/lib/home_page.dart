// Importation des packages et dépendances nécessaires
import 'package:flutter/material.dart';
import 'settings_page.dart';  
import 'message_page.dart';  
import 'dart:io';

// Page d'accueil principale
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Construction de l'interface principale
  @override
  Widget build(BuildContext context) {
    // Configuration du contrôleur d'onglets avec 2 sections
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // Configuration de la barre d'application
        appBar: AppBar(
          automaticallyImplyLeading: false, // Désactive le bouton retour
          title: const Text('WhatsApp'),
        ),
        // Configuration de la vue des onglets
        body: TabBarView(
          children: [
            const ChatsTab(),
            const SettingsPage(),  // Remplacer SettingsTab par SettingsPage
          ],
        ),
        // Barre de navigation en bas avec les onglets
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

// Onglet des conversations
class ChatsTab extends StatefulWidget {
  const ChatsTab({super.key});

  @override
  ChatsTabState createState() => ChatsTabState();
}

// État de l'onglet des conversations
class ChatsTabState extends State<ChatsTab> {
  // Liste des contacts
  final Map<String, String> _contacts = {
    'Brenan': 'https://via.placeholder.com/150',
    'Mattéo': 'https://via.placeholder.com/150',
  };

  // Méthodes de gestion des contacts
  // Méthode pour modifier le nom d'un contact
  void _editContactName(String oldName) {
    final TextEditingController nameController = TextEditingController(text: oldName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier le nom du contact'),
          content: TextField(
            controller: nameController,
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
                  final newName = nameController.text.trim();
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

  // Méthode pour modifier l'image d'un contact
  void _editContactImage(String contactName) {
    final TextEditingController imageController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier l\'image du contact'),
          content: TextField(
            controller: imageController,
            decoration: const InputDecoration(hintText: 'Entrez l\'URL de l\'image'),
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
                  final newImage = imageController.text.trim();
                  if (newImage.isNotEmpty) {
                    _contacts[contactName] = newImage;
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

  // Méthode pour ajouter un nouveau contact
  void _addContact() {
    final TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter un contact'),
          content: TextField(
            controller: nameController,
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
                  final newName = nameController.text.trim();
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
      // Construction de la liste des contacts
      body: ListView(
        children: _contacts.entries.map((entry) {
          final contactName = entry.key;
          final contactImage = entry.value;
          // Configuration de chaque élément de la liste
          return ListTile(
            // Avatar du contact
            leading: CircleAvatar(
              backgroundImage: contactImage.startsWith('http')
                  ? NetworkImage(contactImage)
                  : FileImage(File(contactImage)) as ImageProvider,
            ),
            // Nom du contact
            title: Text(contactName),
            subtitle: const Text(''), // Retour à un subtitle vide
            // Menu contextuel pour les actions sur le contact
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert), // Icône des trois petits points
              onSelected: (value) {
                if (value == 'edit') {
                  _editContactName(contactName);
                } else if (value == 'edit_image') {
                  _editContactImage(contactName);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Modifier le nom'),
                ),
                const PopupMenuItem(
                  value: 'edit_image',
                  child: Text('Modifier l\'image'),
                ),
              ],
            ),
            // Gestion du tap sur un contact
            onTap: () {
              // Navigation vers la page de message
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
      // Bouton d'ajout de contact
      floatingActionButton: FloatingActionButton(
        onPressed: _addContact,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Widget de l'onglet des paramètres (déprécié, remplacé par SettingsPage)
class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Settings'),
    );
  }
}

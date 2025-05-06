import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'auth_service.dart';

// Page des paramètres
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Construction de l'interface des paramètres
  @override
  Widget build(BuildContext context) {
    // Accès au provider de thème
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return ListView(
      children: [
        // En-tête avec avatar
        const ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
          title: Text('Mon Profil', style: TextStyle(fontSize: 20)),
          subtitle: Text('En ligne'),
        ),
        const Divider(),
        
        // Switch pour le thème
        ListTile(
          leading: Icon(
            themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            color: Theme.of(context).primaryColor,
            size: 28,
          ),
          title: Text(
            themeProvider.isDarkMode ? 'Thème sombre' : 'Thème clair',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          subtitle: const Text('Changer l\'apparence de l\'application'),
          trailing: Switch(
            value: themeProvider.isDarkMode,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (bool value) => themeProvider.toggleTheme(),
          ),
        ),
        const Divider(height: 32),
        
        // Section Compte
        const ListTile(
          leading: Icon(Icons.key),
          title: Text('Compte'),
          subtitle: Text('Sécurité, changement de numéro'),
        ),
        const Divider(height: 32),
        
        // Section Chat
        const ListTile(
          leading: Icon(Icons.chat),
          title: Text('Discussions'),
          subtitle: Text('Thème, wallpapers, historique'),
        ),
        const Divider(height: 32),

        // Section Notifications
        const ListTile(
          leading: Icon(Icons.notifications),
          title: Text('Notifications'),
          subtitle: Text('Messages, groupes, appels'),
        ),
        const Divider(height: 32),

        // Section Stockage
        const ListTile(
          leading: Icon(Icons.storage),
          title: Text('Stockage et données'),
          subtitle: Text('Utilisation du réseau, téléchargement auto'),
        ),
        const Divider(height: 32),

        // Section Aide
        const ListTile(
          leading: Icon(Icons.help_outline),
          title: Text('Aide'),
          subtitle: Text('FAQ, nous contacter'),
        ),
        const Divider(height: 32),

        // Section Inviter un ami
        const ListTile(
          leading: Icon(Icons.people_outline),
          title: Text('Inviter un ami'),
        ),
        const Divider(height: 32),

        // Bouton de déconnexion
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Déconnexion', 
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          onTap: () {
            AuthService.logout();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
      ],
    );
  }
}


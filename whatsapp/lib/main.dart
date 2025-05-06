import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'design.dart';
import 'home_page.dart';
import 'auth_service.dart';

// Point d'entrée de l'application
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MainApp(),
    ),
  );
}

// Gestionnaire de thème
class ThemeProvider with ChangeNotifier {
  // État du thème sombre
  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

// Widget principal de l'application
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.isDarkMode ? 
        ThemeData.dark().copyWith(
          primaryColor: const Color.fromARGB(255, 13, 255, 0),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 13, 255, 0),
            elevation: 0,
          ),
          scaffoldBackgroundColor: const Color(0xFF121B22),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 13, 255, 0),
            ),
          ),
        ) : 
        ThemeData.light().copyWith(
          primaryColor: const Color.fromARGB(255, 13, 255, 0),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 13, 255, 0),
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 13, 255, 0),
            ),
          ),
        ),
      home: const LoginPage(),
    );
  }
}

// Page de connexion
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

// État de la page de connexion
class _LoginPageState extends State<LoginPage> {
  // Contrôleurs pour les champs de saisie
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isCreatingAccount = false;

  void _login() {
    final username = _usernameController.text;
    final password = _passwordController.text;
    
    if (_isCreatingAccount) {
      if (AuthService.createAccount(username, password)) {
        AuthService.login(username, password);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nom d\'utilisateur déjà pris')),
        );
      }
    } else {
      if (AuthService.login(username, password)) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Identifiants incorrects')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _isCreatingAccount ? 'Créer un compte' : 'Connexion',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: Design.inputDecoration('Identifiant'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: Design.inputDecoration('Mot de passe'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: Design.buttonStyle(),
              child: Text(_isCreatingAccount ? 'Créer' : 'Se connecter'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isCreatingAccount = !_isCreatingAccount;
                });
              },
              child: Text(_isCreatingAccount
                  ? 'Déjà un compte ? Se connecter'
                  : 'Créer un compte'),
            ),
          ],
        ),
      ),
    );
  }
}
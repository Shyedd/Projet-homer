import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'design.dart';
import 'home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MainApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.isDarkMode
          ? ThemeData.dark().copyWith(
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
            )
          : ThemeData.light().copyWith(
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
      routes: {
        '/apiIntegration': (context) => const ApiIntegrationPage(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String _token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6Iktvc3R1bHNraSBNYXR0w6lvIiwiaWF0IjoxNTE2MjM5MDIyfQ.4SxXMwf4xGnYnDZU-xXnl8oE7q6XHoZvKa7Lwd26amE';

  void _login() {
    setState(() {
      if (_usernameController.text == '' &&
          _passwordController.text == '' &&
          _token ==
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6Iktvc3R1bHNraSBNYXR0w6lvIiwiaWF0IjoxNTE2MjM5MDIyfQ.4SxXMwf4xGnYnDZU-xXnl8oE7q6XHoZvKa7Lwd26amE') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: Design.inputDecoration('Enter Username'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: Design.inputDecoration('Enter Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: Design.buttonStyle(),
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/apiIntegration');
              },
              child: const Text('Go to API Integration'),
            ),
          ],
        ),
      ),
    );
  }
}

class ApiIntegrationPage extends StatelessWidget {
  const ApiIntegrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("API Integration")),
      body: const Center(child: ApiCallWidget()),
    );
  }
}

class ApiCallWidget extends StatefulWidget {
  const ApiCallWidget({super.key});

  @override
  _ApiCallWidgetState createState() => _ApiCallWidgetState();
}

class _ApiCallWidgetState extends State<ApiCallWidget> {
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/messages'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        messages = List<String>.from(data['messages']);
      });
    } else {
      throw Exception('Failed to load messages');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: messages.map((message) => Text(message)).toList(),
    );
  }
}
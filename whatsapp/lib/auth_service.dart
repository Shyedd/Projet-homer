// Service de gestion de l'authentification
class AuthService {
  // Map stockant les comptes (username -> password)
  static final Map<String, String> _accounts = {
    'admin': 'admin'  // Ajout du compte admin par défaut
  };
  // Utilisateur actuellement connecté
  static String? _currentUser;

  // Création d'un nouveau compte
  static bool createAccount(String username, String password) {
    if (_accounts.containsKey(username)) return false;
    _accounts[username] = password;
    return true;
  }

  // Connexion d'un utilisateur
  static bool login(String username, String password) {
    if (_accounts[username] == password) {
      _currentUser = username;
      return true;
    }
    return false;
  }

  // Déconnexion de l'utilisateur
  static void logout() {
    _currentUser = null;
  }

  // Obtenir l'utilisateur actuel
  static String? getCurrentUser() {
    return _currentUser;
  }

  // Obtenir le nom d'utilisateur actuel
  static String? getCurrentUsername() {
    return _currentUser;
  }
}

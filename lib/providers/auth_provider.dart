import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _role;
  String? _name;
  bool _isLoading = false;

  User? get user => _user;
  String? get role => _role;
  String? get name => _name;
  bool get isLoading => _isLoading;
  bool get isAdmin => _role == 'admin';

  AuthProvider() {
    _init();
  }

  void _init() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      _user = user;
      if (user != null) {
        await fetchUserRole();
      } else {
        _role = null;
      }
      notifyListeners();
    });
  }

  Future<void> fetchUserRole() async {
    if (_user == null) return;
    
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();
          
      if (doc.exists) {
        final data = doc.data();
        _role = data?['role'] ?? 'user';
        _name = data?['name'];
      } else {
        _role = 'user';
      }
    } catch (e) {
      _role = 'user';
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    _user = null;
    _role = null;
    _name = null;
    notifyListeners();
  }
}

import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../database/database_helper.dart';

class UserService {
  static const String _currentUserIdKey = 'current_user_id';
  static UserModel? _currentUser;

  // Singleton instance
  UserService._privateConstructor();
  static final UserService instance = UserService._privateConstructor();

  // Get current logged-in user
  UserModel? get currentUser => _currentUser;

  // Check if user is logged in
  bool get isLoggedIn => _currentUser != null;

  // Initialize the service (call this on app startup)
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(_currentUserIdKey);
    
    if (userId != null) {
      _currentUser = await DatabaseHelper.instance.getUserById(userId);
    }
  }

  // Register a new user
  Future<UserModel> registerUser({
    required String username,
    required String email,
    required String phone,
    required String name,
    required String gender,
    required DateTime dateOfBirth,
    required String ethnicity,
    required double height,
    required String location,
    String? instagramHandle,
    String? tiktokHandle,
    String? snapchatHandle,
    String? bio,
  }) async {
    // Check if user already exists
    if (await DatabaseHelper.instance.usernameExists(username)) {
      throw Exception('Username already exists');
    }
    if (await DatabaseHelper.instance.emailExists(email)) {
      throw Exception('Email already exists');
    }
    if (await DatabaseHelper.instance.phoneExists(phone)) {
      throw Exception('Phone number already exists');
    }

    // Create new user
    final user = UserModel(
      username: username,
      email: email,
      phone: phone,
      name: name,
      gender: gender,
      dateOfBirth: dateOfBirth,
      ethnicity: ethnicity,
      height: height,
      location: location,
      instagramHandle: instagramHandle,
      tiktokHandle: tiktokHandle,
      snapchatHandle: snapchatHandle,
      bio: bio,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Insert user into database
    final userId = await DatabaseHelper.instance.insertUser(user);
    final createdUser = await DatabaseHelper.instance.getUserById(userId);
    
    if (createdUser != null) {
      // Set as current user and save to preferences
      await _setCurrentUser(createdUser);
      return createdUser;
    } else {
      throw Exception('Failed to create user');
    }
  }

  // Login user
  Future<UserModel> loginUser(String usernameOrPhoneOrEmail) async {
    final user = await DatabaseHelper.instance.authenticateUser(usernameOrPhoneOrEmail, '');
    
    if (user != null) {
      await _setCurrentUser(user);
      return user;
    } else {
      throw Exception('User not found');
    }
  }

  // Update current user
  Future<UserModel> updateCurrentUser({
    String? name,
    String? profileImagePath,
    String? profileVideoPath,
    String? ethnicity,
    double? height,
    String? location,
    String? instagramHandle,
    String? tiktokHandle,
    String? bio,
  }) async {
    if (_currentUser == null) {
      throw Exception('No user logged in');
    }

    final updatedUser = _currentUser!.copyWith(
      name: name,
      profileImagePath: profileImagePath,
      profileVideoPath: profileVideoPath,
      ethnicity: ethnicity,
      height: height,
      location: location,
      instagramHandle: instagramHandle,
      tiktokHandle: tiktokHandle,
      bio: bio,
      updatedAt: DateTime.now(),
    );

    await DatabaseHelper.instance.updateUser(updatedUser);
    _currentUser = updatedUser;
    
    return updatedUser;
  }

  // Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserIdKey);
    _currentUser = null;
  }

  // Search users
  Future<List<UserModel>> searchUsers(String query) async {
    return await DatabaseHelper.instance.searchUsers(query);
  }

  // Get all users (for discovery/search)
  Future<List<UserModel>> getAllUsers() async {
    return await DatabaseHelper.instance.getAllUsers();
  }

  // Private method to set current user and save to preferences
  Future<void> _setCurrentUser(UserModel user) async {
    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_currentUserIdKey, user.id!);
  }

  // Refresh current user data from database
  Future<void> refreshCurrentUser() async {
    if (_currentUser?.id != null) {
      _currentUser = await DatabaseHelper.instance.getUserById(_currentUser!.id!);
    }
  }
}

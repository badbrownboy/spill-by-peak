class UserModel {
  final int? id;
  final String username;
  final String email;
  final String phone;
  final String name;
  final String gender;
  final DateTime dateOfBirth;
  final String? profileImagePath;
  final String? profileVideoPath;
  final String ethnicity;
  final double height; // in cm
  final String location;
  final String? instagramHandle;
  final String? tiktokHandle;
  final String? snapchatHandle;
  final String? bio;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    this.profileImagePath,
    this.profileVideoPath,
    required this.ethnicity,
    required this.height,
    required this.location,
    this.instagramHandle,
    this.tiktokHandle,
    this.snapchatHandle,
    this.bio,
    required this.createdAt,
    required this.updatedAt,
  });

  // Calculate age from date of birth
  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  // Convert height from cm to feet and inches
  String get heightInFeetAndInches {
    final totalInches = height / 2.54;
    final feet = totalInches ~/ 12;
    final inches = (totalInches % 12).round();
    return "$feet'$inches\"";
  }

  // Convert UserModel to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'name': name,
      'gender': gender,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'profileImagePath': profileImagePath,
      'profileVideoPath': profileVideoPath,
      'ethnicity': ethnicity,
      'height': height,
      'location': location,
      'instagramHandle': instagramHandle,
      'tiktokHandle': tiktokHandle,
      'snapchatHandle': snapchatHandle,
      'bio': bio,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create UserModel from Map (database retrieval)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      phone: map['phone'],
      name: map['name'],
      gender: map['gender'],
      dateOfBirth: DateTime.parse(map['dateOfBirth']),
      profileImagePath: map['profileImagePath'],
      profileVideoPath: map['profileVideoPath'],
      ethnicity: map['ethnicity'],
      height: map['height'].toDouble(),
      location: map['location'],
      instagramHandle: map['instagramHandle'],
      tiktokHandle: map['tiktokHandle'],
      snapchatHandle: map['snapchatHandle'],
      bio: map['bio'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  // Create a copy of UserModel with updated fields
  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? phone,
    String? name,
    String? gender,
    DateTime? dateOfBirth,
    String? profileImagePath,
    String? profileVideoPath,
    String? ethnicity,
    double? height,
    String? location,
    String? instagramHandle,
    String? tiktokHandle,
    String? snapchatHandle,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      profileVideoPath: profileVideoPath ?? this.profileVideoPath,
      ethnicity: ethnicity ?? this.ethnicity,
      height: height ?? this.height,
      location: location ?? this.location,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      tiktokHandle: tiktokHandle ?? this.tiktokHandle,
      snapchatHandle: snapchatHandle ?? this.snapchatHandle,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'UserModel{id: $id, username: $username, name: $name, age: $age}';
  }
}

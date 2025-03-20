class Users {
  final String userId;
  final String name;
  final String email;
  final DateTime? dob;
  final String? photoUrl;
  final String? region;

  Users({
    required this.userId,
    required this.name,
    required this.email,
    this.dob,
    this.photoUrl,
    this.region,
  });

  // Convert User object to a Map for Firestore
  // Use to store date to Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'dob': dob?.toIso8601String(),
      'photoUrl': photoUrl,
      'region': region,
    };
  }

  // Create a User object from Firestore data
  // Retrieve data from Firestore
  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      dob: map['dob'] != null ? DateTime.parse(map['dob']) : null,
      photoUrl: map['photoUrl'],
      region: map['region'],
    );
  }
}
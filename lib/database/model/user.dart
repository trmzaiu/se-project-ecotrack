class Users {
  final String uid;
  final String name;
  final String email;
  final DateTime? dob;
  final String? photoUrl;
  final String? region;
  final int? water;
  final int? tree;

  Users({
    required this.uid,
    required this.name,
    required this.email,
    this.dob,
    this.photoUrl,
    this.region,
    this.water,
    this.tree
  });

  // Convert User object to a Map for Firestore
  // Use to store date to Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'dob': dob?.toIso8601String(),
      'photoUrl': photoUrl,
      'region': region,
      'water': water,
      'tree': tree
    };
  }

  // Create a User object from Firestore data
  // Retrieve data from Firestore
  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      dob: map['dob'] != null ? DateTime.parse(map['dob']) : null,
      photoUrl: map['photoUrl'],
      region: map['region'],
      water: map['water'],
      tree: map['tree'],
    );
  }
}
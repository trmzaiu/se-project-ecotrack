class Evidence {
  final String uid;
  final String evid;
  final String cateid;
  final String url;

  Evidence({
    required this.uid,
    required this.evid,
    required this.cateid,
    required this.url
  });

  // Convert User object to a Map for Firestore
  // Use to store date to Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'evid': evid,
      'cateid': cateid,
      'url': url
    };
  }
}
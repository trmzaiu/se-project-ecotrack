class Leaderboard {
  final String userId;
  final String name;
  final String photoUrl;
  final int trees;
  final int rank;

  Leaderboard({
    required this.userId,
    required this.name,
    required this.photoUrl,
    required this.trees,
    required this.rank,
  });

  Leaderboard copyWith({
    String? userId,
    String? name,
    String? photoUrl,
    int? trees,
    int? rank,
  }) {
    return Leaderboard(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      trees: trees ?? this.trees,
      rank: rank ?? this.rank,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'photoUrl': photoUrl,
      'trees': trees,
      'rank': rank,
    };
  }
}

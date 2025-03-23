class Trees {
  final String treeId;
  final String userId;
  final int? drops;
  final int? trees;
  final int? levelOfTree;
  final double? progress;

  Trees({
    required this.treeId,
    required this.userId,
    this.drops,
    this.trees,
    this.levelOfTree,
    this.progress
  });

  // Convert User object to a Map for Firestore
  // Use to store date to Firestore
  Map<String, dynamic> toMap() {
    return {
      'treeId': treeId,
      'userId': userId,
      'drops': drops,
      'trees': trees,
      'levelOfTree': levelOfTree,
      'progress': progress
    };
  }

  factory Trees.fromMap(Map<String, dynamic> map) {
    return Trees(
      treeId: map['treeId'] ?? '',
      userId: map['userId'] ?? '',
      drops: map['drops'],
      trees: map['trees'],
      levelOfTree: map['levelOfTree'],
      progress: map['progress']
    );
  }
}
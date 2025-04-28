class Tree {
  final String treeId;
  final String userId;
  final int? drops;
  final int? trees;
  final int? levelOfTree;
  final double? progress;

  Tree({
    required this.treeId,
    required this.userId,
    this.drops,
    this.trees,
    this.levelOfTree,
    this.progress
  });

  // Convert to Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'drops': drops,
      'trees': trees,
      'levelOfTree': levelOfTree,
      'progress': progress
    };
  }

  // Create a Tree instance from Firestore data + document ID
  factory Tree.fromMap(Map<String, dynamic> map, String documentId) {
    return Tree(
      treeId: documentId,
      userId: map['userId'] ?? '',
      drops: map['drops'],
      trees: map['trees'],
      levelOfTree: map['levelOfTree'],
      progress: map['progress']
    );
  }
}
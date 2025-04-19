class UserChallengeProgress {
  final String id; // ID của document progress
  final String userId;
  final String challengeId;
  final int currentProgress;
  final bool completed;

  UserChallengeProgress({
    required this.id,
    required this.userId,
    required this.challengeId,
    required this.currentProgress,
    required this.completed,
  });

  // 🔄 From Firestore
  factory UserChallengeProgress.fromMap(String id, Map<String, dynamic> map) {
    return UserChallengeProgress(
      id: id,
      userId: map['userId'] ?? '',
      challengeId: map['challengeId'] ?? '',
      currentProgress: map['currentProgress'] ?? 0,
      completed: map['completed'] ?? false,
    );
  }

  // 🔄 To Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'challengeId': challengeId,
      'currentProgress': currentProgress,
      'completed': completed,
    };
  }
}

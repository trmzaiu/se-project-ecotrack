import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge {
  final String id;
  final String type;

  Challenge({
    required this.id,
    required this.type,
  });

  factory Challenge.fromMap(Map<String, dynamic> data, String id) {
    return Challenge(
      id: id,
      type: data['type'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
    };
  }
}

// Model for Community Challenge (extends Challenge)
class CommunityChallenge extends Challenge {
  final String title;
  final String description;
  final Timestamp startDate;
  final Timestamp endDate;
  final String subtype;
  final List<String> participants;
  final List<Map<String, dynamic>> submittedUsers;
  final int progress;
  final int rewardPoints;
  final List<String> rewardedUsers;
  final String image;
  final int targetValue;
  final String? question;

  CommunityChallenge({
    required super.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.subtype,
    required this.participants,
    required this.submittedUsers,
    required this.progress,
    required this.rewardPoints,
    required this.rewardedUsers,
    required this.image,
    required this.targetValue,
    this.question,
  }) : super(type: 'community');

  factory CommunityChallenge.fromMap(Map<String, dynamic> data, String id) {
    String? question = data['question'];

    return CommunityChallenge(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      startDate: data['startDate'] ?? Timestamp.now(),
      endDate: data['endDate'] ?? Timestamp.now(),
      subtype: data['subtype'] ?? '',
      participants: List<String>.from(data['participants'] ?? []),
      submittedUsers: List<Map<String, dynamic>>.from(data['submittedUsers'] ?? {}),
      progress: data['progress'] ?? 0,
      rewardPoints: data['rewardPoints'] ?? 0,
      rewardedUsers: List<String>.from(data['rewardedUsers'] ?? []),
      image: data['image'] ?? '',
      targetValue: data['targetValue'] ?? 0,
      question: question,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'title': title,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'subtype': subtype,
      'participants': participants,
      'submittedUsers': submittedUsers,
      'progress': progress,
      'rewardPoints': rewardPoints,
      'rewardedUsers': rewardedUsers,
      'image': image,
      'targetValue': targetValue,
      'question': question,
    });
    return map;
  }
}

// Model for Weekly Challenge (extends Challenge)
class WeeklyChallenge extends Challenge {
  final int rewardPoints;
  final int target;
  final List<Map<String, dynamic>> tasks;
  final String weekLog;

  WeeklyChallenge({
    required super.id,
    required this.rewardPoints,
    required this.target,
    required this.tasks,
    required this.weekLog,
  }) : super(type: 'weekly');

  factory WeeklyChallenge.fromMap(Map<String, dynamic> data, String id) {
    return WeeklyChallenge(
      id: id,
      rewardPoints: data['rewardPoints'] ?? 0,
      target: data['target'] ?? '',
      tasks: List<Map<String, dynamic>>.from(data['tasks'] ?? []),
      weekLog: data['weekLog'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'rewardPoints': rewardPoints,
      'target': target,
      'tasks': tasks,
      'weekLog': weekLog,
    });
    return map;
  }
}

// Model for Daily Challenge (extends Challenge)
class DailyChallenge extends Challenge {
  final String dateLog;
  final String subtype;

  DailyChallenge({
    required super.id,
    required this.dateLog,
    required this.subtype,
  }) : super(type: 'daily');

  factory DailyChallenge.fromMap(Map<String, dynamic> data, String id) {
    return DailyChallenge(
      id: id,
      dateLog: data['dateLog'] ?? '',
      subtype: data['subtype'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'dateLog': dateLog,
      'subtype': subtype,
    });
    return map;
  }
}

// Model for Daily Quiz (extends DailyChallenge)
class DailyQuizChallenge extends DailyChallenge {
  final String question;
  final List<String> options;
  final int correct;

  DailyQuizChallenge({
    required super.id,
    required super.dateLog,
    required this.question,
    required this.options,
    required this.correct,
  }) : super(subtype: 'quiz');

  factory DailyQuizChallenge.fromMap(Map<String, dynamic> data, String id) {
    return DailyQuizChallenge(
      id: id,
      dateLog: data['dateLog'] ?? '',
      question: data['question'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correct: data['correct'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'question': question,
      'options': options,
      'correct': correct,
    });
    return map;
  }
}

// Model for Daily Drag-and-Drop (extends DailyChallenge)
class DailyDragDropChallenge extends DailyChallenge {
  final List<Map<String, dynamic>> items;
  final String question;

  DailyDragDropChallenge({
    required super.id,
    required super.dateLog,
    required this.items,
    required this.question,
  }) : super(subtype: 'dragdrop');

  factory DailyDragDropChallenge.fromMap(Map<String, dynamic> data, String id) {
    return DailyDragDropChallenge(
      id: id,
      dateLog: data['dateLog'] ?? '',
      items: List<Map<String, dynamic>>.from(data['items'] ?? []),
      question: data['question'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'items': items,
      'question': question,
    });
    return map;
  }
}

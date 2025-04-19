import 'package:flutter/material.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenges'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '🔥 Your Active Challenges',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ChallengeCard(
            title: 'Daily Recycler',
            progress: 0.5,
            endText: 'Ends in 2 days',
          ),
          ChallengeCard(
            title: 'Weekly Green Hero',
            progress: 0.7,
            endText: 'Ends in 4 days',
          ),
          const SizedBox(height: 24),
          const Text(
            '🧭 Explore More',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ExploreCard(title: 'Plastic-Free Week'),
          ExploreCard(title: 'Eco Sorting Master'),
        ],
      ),
    );
  }
}

class ChallengeCard extends StatelessWidget {
  final String title;
  final double progress;
  final String endText;

  const ChallengeCard({
    super.key,
    required this.title,
    required this.progress,
    required this.endText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              color: Colors.green,
              backgroundColor: Colors.grey[300],
              minHeight: 10,
            ),
            const SizedBox(height: 8),
            Text(endText, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class ExploreCard extends StatelessWidget {
  final String title;

  const ExploreCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.add_circle_outline, color: Colors.blue),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Mở chi tiết challenge hoặc join
        },
      ),
    );
  }
}

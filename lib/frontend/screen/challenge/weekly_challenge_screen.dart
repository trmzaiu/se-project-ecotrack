import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeeklyChallengeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> dailyChallenges = [
    {'day': 'Monday', 'task': 'Complete Daily Challenge', 'completed': false},
    {'day': 'Tuesday', 'task': 'Upload Evidence', 'completed': false},
    {'day': 'Wednesday', 'task': 'Complete Environment Quiz', 'completed': false},
    {'day': 'Thursday', 'task': 'Join Community Challenge', 'completed': false},
    {'day': 'Friday', 'task': 'Maintain Streak', 'completed': false},
    {'day': 'Saturday', 'task': 'Play Trash Sorting Game', 'completed': false},
    {'day': 'Sunday', 'task': 'Submit Reflection Form', 'completed': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weekly Challenge',
          style: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress this Week:',
              style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.5, // Set dynamic progress based on completion
              backgroundColor: Colors.grey[300],
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Your Weekly Tasks:',
              style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: dailyChallenges.length,
                itemBuilder: (context, index) {
                  var task = dailyChallenges[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: task['completed'] ? Colors.green : Colors.grey,
                        child: Icon(
                          task['completed'] ? Icons.check : Icons.pending,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        '${task['day']} - ${task['task']}',
                        style: GoogleFonts.urbanist(fontSize: 14),
                      ),
                      trailing: Icon(
                        task['completed'] ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: task['completed'] ? Colors.green : Colors.grey,
                      ),
                      onTap: () {
                        // Handle task completion logic
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle "Claim Rewards" action
              },
              child: Text('Claim Your Rewards'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

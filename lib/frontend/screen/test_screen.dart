import 'package:flutter/material.dart';
import 'package:wastesortapp/theme/colors.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late ScrollController _scrollController;
  double _topContainer = 0;
  bool _isFirstFilterSelected = true;

  final List<Map<String, dynamic>> _users = [
    {'name': 'Alice', 'image': 'lib/assets/images/avatar_default.png', 'trees': 120, 'rank': 1},
    {'name': 'Bob', 'image': 'lib/assets/images/avatar_default.png', 'trees': 100, 'rank': 2},
    {'name': 'Charlie', 'image': 'lib/assets/images/avatar_default.png', 'trees': 80, 'rank': 3},
    {'name': 'David', 'image': 'lib/assets/images/avatar_default.png', 'trees': 70, 'rank': 4},
    {'name': 'Emma', 'image': 'lib/assets/images/avatar_default.png', 'trees': 60, 'rank': 5},
    {'name': 'Frank', 'image': 'lib/assets/images/avatar_default.png', 'trees': 55, 'rank': 6},
    {'name': 'Grace', 'image': 'lib/assets/images/avatar_default.png', 'trees': 50, 'rank': 7},
    {'name': 'Hannah', 'image': 'lib/assets/images/avatar_default.png', 'trees': 45, 'rank': 8},
    {'name': 'Isaac', 'image': 'lib/assets/images/avatar_default.png', 'trees': 40, 'rank': 9},
    {'name': 'Jack', 'image': 'lib/assets/images/avatar_default.png', 'trees': 35, 'rank': 10},
    {'name': 'Kevin', 'image': 'lib/assets/images/avatar_default.png', 'trees': 30, 'rank': 11},
    {'name': 'Liam', 'image': 'lib/assets/images/avatar_default.png', 'trees': 25, 'rank': 12},
    {'name': 'Mia', 'image': 'lib/assets/images/avatar_default.png', 'trees': 20, 'rank': 13},
    {'name': 'Noah', 'image': 'lib/assets/images/avatar_default.png', 'trees': 15, 'rank': 14},
    {'name': 'Olivia', 'image': 'lib/assets/images/avatar_default.png', 'trees': 10, 'rank': 15},
    {'name': 'Peter', 'image': 'lib/assets/images/avatar_default.png', 'trees': 5, 'rank': 16},
  ];


  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      double value = (_scrollController.offset ?? 0) / 200;
      setState(() {
        _topContainer = value.clamp(0.0, 1.0);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onFilterTap(bool isFirst) {
    setState(() {
      _isFirstFilterSelected = isFirst;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double _radius = 20;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Animated Section
            AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: (1 - _topContainer * 2).clamp(0.0, 1.0),
              child: AnimatedContainer(
                padding: EdgeInsets.symmetric(vertical: 16),
                duration: Duration(milliseconds: 200),
                height: (1 - _topContainer * 2).clamp(0.0, 1.0) * (height / 3),
                width: width,
                child: FittedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      if (_users.length > 1) _topRankedUser(_radius, 2, _users[1]),
                      if (_users.isNotEmpty) _topRankedUser(_radius, 1, _users.first),
                      if (_users.length > 2) _topRankedUser(_radius, 3, _users[2]),
                    ],
                  ),
                ),
              ),
            ),

            // Sticky Filter Buttons
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: List.generate(
                  2,
                      (index) => Expanded(
                    child: GestureDetector(
                      onTap: () => _onFilterTap(index == 0),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (index == 0 && _isFirstFilterSelected) ||
                              (index == 1 && !_isFirstFilterSelected)
                              ? Colors.green
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(_radius),
                        ),
                        child: Text(
                          index == 0 ? "Top Trees" : "Recent Activity",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: (index == 0 && _isFirstFilterSelected) ||
                                (index == 1 && !_isFirstFilterSelected)
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ListView for leaderboard
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(_radius * 2),
                    topRight: Radius.circular(_radius * 2),
                  ),
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _users.length > 3 ? _users.length - 3 : _users.length,
                  itemBuilder: (context, index) {
                    int actualIndex = _users.length > 3 ? index + 3 : index;
                    if (actualIndex >= _users.length) return SizedBox();
                    return _leaderboardCard(_radius, actualIndex + 1, _users[actualIndex]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topRankedUser(double radius, int rank, Map<String, dynamic> user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: (user['image'] != null && user['image'].isNotEmpty)
              ? AssetImage(user['image'])
              : AssetImage('lib/assets/images/avatar_default.png'),
        ),
        SizedBox(height: 5),
        Text(
          user['name'] ?? 'Unknown',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          "#$rank - ${user['trees'] ?? 0} Trees",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _leaderboardCard(double radius, int rank, Map<String, dynamic> user) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: (user['image'] != null && user['image'].isNotEmpty)
              ? AssetImage(user['image'])
              : AssetImage('lib/assets/images/avatar_default.png'),
        ),
        title: Text(user['name'] ?? 'Unknown', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${user['trees'] ?? 0} Trees"),
        trailing: Text("#$rank", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

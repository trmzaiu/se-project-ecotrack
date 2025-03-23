import 'package:animated_leaderboard/animated_leaderboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  final ScrollController _scrollController = ScrollController();
  double _topContainer = 0;

  final List<User> _users = List.generate(
    10,
        (index) => User(
      index,
      'user$index',
      '',
      'https://shorturl.at/Jl6mL',
      (10 - index) * 10,
      (10 - index) * 50,
    ),
  );

  final int _myId = 5;
  bool _isWeeklyFiltered = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final double value = _scrollController.offset / 119;
    setState(() {
      _topContainer = value;
    });
  }

  void _filter(bool isFirstFilterSelected) {
    setState(() {
      _isWeeklyFiltered = isFirstFilterSelected;
    });
    // TODO: Sort the users based on the selected filter
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
        scrolledUnderElevation: 0,
      ),
      body: AnimatedLeaderboard(
        scrollController: _scrollController,
        topContainer: _topContainer,
        filterLabel1: 'Weekly',
        filterLabel2: 'All-time',
        users: _users,
        myId: _myId,
        isFirstFilterSelected: _isWeeklyFiltered,
        onFilterTap: _filter,
      ),
    );
  }
}

class User {
  final int id;
  final String photo;
  final String firstName;
  final String lastName;
  final int weeklyPoints;
  final int allTimePoints;

  User(this.id, this.firstName, this.lastName, this.photo, this.weeklyPoints, this.allTimePoints);

  int get firstFilterPoints => weeklyPoints;
  int get secondFilterPoints => allTimePoints;
}
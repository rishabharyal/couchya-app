import 'package:couchya/api/team.dart';
import 'package:couchya/models/team.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MatchesPageBloc extends ChangeNotifier {
  static List<Team> _teams = [];

  setTeams(List<Team> teams) {
    MatchesPageBloc._teams = teams;
    notifyListeners();
  }

  getTeams() async {
    List<Team> teams = await TeamApi.getAll();
    setTeams(teams);
  }

  List<Team> get teams => _teams;
}

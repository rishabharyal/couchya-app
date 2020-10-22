import 'package:couchya/api/team.dart';
import 'package:couchya/models/team.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TeamsBloc extends ChangeNotifier {
  static List<Team> _teams = [];
  static List<Team> _invitations = [];

  setTeams(List<Team> teams) {
    TeamsBloc._teams = teams;
    notifyListeners();
  }

  setInvitations(List<Team> teams) {
    TeamsBloc._invitations = teams;
    notifyListeners();
  }

  getTeams() async {
    List<Team> teams = await TeamApi.getAll();
    setTeams(teams);
  }

  getInvitations() async {
    List<Team> teams = await TeamApi.getAll();
    setInvitations(teams);
  }

  List<Team> get teams => _teams;
  List<Team> get invitations => _invitations;
}

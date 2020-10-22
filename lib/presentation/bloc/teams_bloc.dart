import 'package:couchya/api/invitation.dart';
import 'package:couchya/api/team.dart';
import 'package:couchya/models/invitation.dart';
import 'package:couchya/models/team.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TeamsBloc extends ChangeNotifier {
  static List<Team> _teams = [];
  static List<Invitation> _invitations = [];

  setTeams(List<Team> teams) {
    TeamsBloc._teams = teams;
    notifyListeners();
  }

  setInvitations(List<Invitation> teams) {
    TeamsBloc._invitations = teams;
    notifyListeners();
  }

  refreshData() {
    getTeams();
    getInvitations();
  }

  getTeams() async {
    List<Team> teams = await TeamApi.getAll();
    setTeams(teams);
  }

  getInvitations() async {
    List<Invitation> teams = await InvitationApi.getAll();
    print(teams);
    setInvitations(teams);
  }

  List<Team> get teams => _teams;
  List<Invitation> get invitations => _invitations;
}

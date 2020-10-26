import 'package:couchya/models/team.dart';
import 'package:couchya/models/user.dart';

class Invitation {
  final int id;
  final Team team;
  final User invitedBy;

  Invitation({this.id, this.team, this.invitedBy});

  static Invitation fromJson(json) {
    return Invitation(
      id: json['id'],
      team: Team(
          id: json['team_id'],
          title: json['team_name'],
          members: [User.fromJson(json['invitation_from'])]),
      invitedBy: User.fromJson(json['invitation_from']),
    );
  }
}

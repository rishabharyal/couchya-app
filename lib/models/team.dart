import 'package:couchya/models/user.dart';

class Team {
  final int id;
  final String title;
  final String code;
  final List<User> members;

  Team({this.id, this.title, this.code, this.members});

  static Team fromJson(json) {
    return Team(
      id: json['id'],
      title: json['title'],
      code: json['code'],
      members: json['members'] == []
          ? []
          : List<User>.from(
              json['members'].map<User>((topic) {
                return User.fromJson(topic);
              }).toList(),
            ),
    );
  }
}

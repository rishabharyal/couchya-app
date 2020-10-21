import 'package:couchya/models/team.dart';
import 'package:couchya/utilities/api.dart';
import 'package:couchya/utilities/api_response.dart';

class TeamApi {
  static Future<List<Team>> getAll() async {
    ApiResponse response = await CallApi.get('team');
    if (response.hasErrors()) return null;
    return List<Team>.from(response.getData()['data'].map<Team>((team) {
      return Team.fromJson(team);
    }).toList());
  }

  static Future<ApiResponse> create(data) async {
    ApiResponse response = await CallApi.post('team', data);
    return response;
  }

  static Future<ApiResponse> join(id) async {
    ApiResponse response = await CallApi.get('team/join' + id.toString());
    return response;
  }

  static Future<ApiResponse> sendInvitation(data) async {
    ApiResponse response = await CallApi.post('team/invite', data);
    return response;
  }
}

import 'package:couchya/models/match.dart';
import 'package:couchya/utilities/api.dart';
import 'package:couchya/utilities/api_response.dart';

class MatchesApi {
  static Future<List<Match>> get(int id) async {
    ApiResponse response = await CallApi.post('matches/team', {'team_id': id});
    if (response.hasErrors()) return null;
    return List<Match>.from(response.getData()['data'].map<Match>((m) {
      return Match.fromJson(m);
    }).toList());
  }
}

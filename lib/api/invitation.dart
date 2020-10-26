import 'package:couchya/models/invitation.dart';
import 'package:couchya/utilities/api.dart';
import 'package:couchya/utilities/api_response.dart';

class InvitationApi {
  static Future<List<Invitation>> getAll() async {
    ApiResponse response = await CallApi.get('invitations');
    if (response.hasErrors()) return [];
    return List<Invitation>.from(
        response.getData()['data'].map<Invitation>((invitation) {
      return Invitation.fromJson(invitation);
    }).toList());
  }

  static Future<ApiResponse> reject(id) async {
    ApiResponse response =
        await CallApi.post('invitations/' + id.toString() + '/reject/', null);
    return response;
  }
}

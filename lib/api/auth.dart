import 'package:couchya/utilities/api.dart';
import 'package:couchya/utilities/api_response.dart';
import 'package:couchya/utilities/local_storage.dart';

class Auth {
  static register(data) async {
    ApiResponse response = await CallApi.post('register', data);
    if (!response.hasErrors()) {
      response.printData();
      LocalStorage.setToken(response.getData()['token']);
      await me();
    }
    return response;
  }

  static reset(data) async {
    ApiResponse response = await CallApi.post('reset', data);
    return response;
  }

  static login(data) async {
    ApiResponse res = await CallApi.post('login', data);
    if (!res.hasErrors()) {
      LocalStorage.setToken(res.getData()['token']);
      await me();
    }
    return res;
  }

  static me() async {
    ApiResponse userResponse = await CallApi.get('user');
    print(userResponse.getData());
    if (!userResponse.hasErrors()) {
      LocalStorage.setUser({
        'name': userResponse.getData()['data']['name'],
        'email': userResponse.getData()['data']['email'],
        'image': userResponse.getData()['data']['image'] ?? ''
      });
    } else
      logout();
    return userResponse;
  }

  static logout() async {
    LocalStorage.destroyToken();
    LocalStorage.destroyUser();
  }

  static isAuthenticated() async {
    var token = await LocalStorage.getToken();
    print('token ' + token);
    if (token != null && token != '') return true;
    return false;
  }
}

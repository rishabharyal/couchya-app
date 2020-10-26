import 'package:couchya/models/movie.dart';
import 'package:couchya/utilities/api.dart';
import 'package:couchya/utilities/api_response.dart';

class MovieApi {
  static Future<List<Movie>> getAll(Map<String, String> queryParams) async {
    ApiResponse response = await CallApi.get('movies', queryParams);
    if (response.hasErrors()) return [];
    print(response.getData());
    return List<Movie>.from(response.getData()['data'].map<Movie>((movie) {
      return Movie.fromJson(movie);
    }).toList());
  }

  static Future<ApiResponse> like(id) async {
    ApiResponse response = await CallApi.post('movie/like', {'movie_id': id});
    return response;
  }
}

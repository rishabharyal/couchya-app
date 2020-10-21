import 'package:couchya/models/movie.dart';
import 'package:couchya/models/user.dart';

class Match {
  final Movie movie;
  final List<User> likers;

  Match({this.movie, this.likers});

  static Match fromJson(json) {
    return Match(
      movie: Movie(
        id: json['id'],
        genre: json['genre'],
        title: json['title'],
        releaseYear: json['release_year'].toString(),
        poster: json['image'],
      ),
      likers: List<User>.from(
        json['likers'].map<User>((topic) {
          return User.fromJson(topic);
        }).toList(),
      ),
    );
  }
}

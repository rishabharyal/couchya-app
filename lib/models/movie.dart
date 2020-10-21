class Movie {
  final int id;
  final String title;
  final String genre;
  final String releaseYear;
  final String poster;

  Movie({this.title, this.id, this.genre, this.releaseYear, this.poster});

  static Movie fromJson(json) {
    return Movie(
        id: json['id'],
        title: json['title'],
        genre: json['vtype'],
        releaseYear: json['release_year'].toString() ?? '',
        poster: json['image']);
  }
}

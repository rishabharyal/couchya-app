import 'package:couchya/api/movie.dart';
import 'package:couchya/models/movie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePageBloc extends ChangeNotifier {
  static List<Movie> _movies = [];
  static int _page = -1;
  static String _genre = "";
  static RangeValues _range =
      new RangeValues(1900, DateTime.now().year.toDouble());

  setMovies(List<Movie> movies) {
    HomePageBloc._movies = movies;
    notifyListeners();
  }

  resetMovies() {
    HomePageBloc._movies = [];
    notifyListeners();
    HomePageBloc._page = -1;
  }

  setRange(RangeValues range) {
    HomePageBloc._range = range;
  }

  setGenre(String g) {
    HomePageBloc._genre = g;
  }

  loadMovies() async {
    _page++;
    List<Movie> movies = await MovieApi.getAll({
      'page': _page,
      'genre': _genre,
      'range_start': _range.start.round().toInt(),
      'range_end': _range.end.round().toInt(),
    });
    setMovies(movies);
  }

  likeMovie(int id) async {
    await MovieApi.like(id);
  }

  List<Movie> get movies => _movies;
}

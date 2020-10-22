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
  static int _currentlyVisibleCard = 0;
  static bool _isCurrentMovieLiked = false;

  setMovies(List<Movie> movies) {
    HomePageBloc._movies = movies;
    _currentlyVisibleCard = 0;
    notifyListeners();
  }

  resetMovies() {
    HomePageBloc._movies = [];
    notifyListeners();
    HomePageBloc._page = -1;
  }

  setIsMovieLiked(bool b) {
    _isCurrentMovieLiked = b;
    notifyListeners();
  }

  increamentCurrentlyVisibleCard() {
    _currentlyVisibleCard++;
    notifyListeners();
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
      'page': _page.toString(),
      'genre': _genre,
      'range_start': _range.start.round().toInt().toString(),
      'range_end': _range.end.round().toInt().toString(),
    });
    print(movies.length);
    setMovies(movies);
  }

  likeMovie(int id) async {
    await MovieApi.like(id);
  }

  List<Movie> get movies => _movies;
  int get currentlyVisibleCard => _currentlyVisibleCard;
  bool get isMovieLiked => _isCurrentMovieLiked;
}

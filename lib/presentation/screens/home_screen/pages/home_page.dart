import 'package:couchya/models/movie.dart';
import 'package:couchya/presentation/bloc/home_page_bloc.dart';
import 'package:couchya/utilities/app_theme.dart';
import 'package:couchya/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CardController controller = new CardController();
  bool _isMovieLiked = false;
  final int _moviesInOneRequest = 16;
  int _currentlyVisibleCard = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomePageBloc>(builder: (context, homePageBloc, child) {
      List<Movie> movies = homePageBloc.movies;
      return movies.length > 0
          ? _buildSwipeCards(movies)
          : _buildLoadingWidget();
    });
  }

  Widget _buildSwipeCards(List<Movie> movies) {
    return Container(
      padding: EdgeInsets.all(12),
      height: SizeConfig.screenHeight,
      child: new TinderSwapCard(
        swipeUp: false,
        swipeDown: false,
        orientation: AmassOrientation.BOTTOM,
        totalNum: movies.length,
        stackNum: 3,
        swipeEdge: 0.001,
        maxWidth: SizeConfig.screenWidth * 0.9,
        maxHeight: SizeConfig.screenHeight * 0.9,
        minWidth: SizeConfig.screenWidth * 0.89,
        minHeight: SizeConfig.screenHeight * 0.89,
        cardBuilder: (context, index) => Card(
          child: new Container(
            child: _buildTextOverlay(index, movies),
            decoration: new BoxDecoration(
              color: AppTheme.successColor,
              image: new DecorationImage(
                fit: BoxFit.cover,
                colorFilter: _getColorOverlay(index),
                image: new NetworkImage(
                  '${movies[index].poster}',
                ),
              ),
            ),
          ),
        ),
        cardController: controller,
        swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
          /// Get swiping card's alignment
          if (align.x > 0) {
            if (_isMovieLiked != true)
              setState(() {
                _isMovieLiked = true;
              });
          } else {
            if (_isMovieLiked != false)
              setState(() {
                _isMovieLiked = false;
              });
          }
        },
        swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
          if (_isMovieLiked)
            Provider.of<HomePageBloc>(context, listen: false)
              ..likeMovie(movies[_currentlyVisibleCard].id);
          setState(() {
            _isMovieLiked = false;
            _currentlyVisibleCard = index + 1;
          });
          if (index == _moviesInOneRequest) {
            setState(() {
              _currentlyVisibleCard = 0;
            });
            Provider.of<HomePageBloc>(context, listen: false).resetMovies();
            Provider.of<HomePageBloc>(context, listen: false).loadMovies();
          }
        },
      ),
    );
  }

  Widget _buildTextOverlay(int index, List<Movie> movies) {
    if (index == _currentlyVisibleCard && _isMovieLiked)
      return Center(
        child: Text(
          'LIKE',
          style: Theme.of(context).textTheme.headline1.copyWith(
                fontSize: 50,
                color: Colors.white,
              ),
        ),
      );
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              movies[index].title.length > 20
                  ? movies[index].title.substring(0, 19) + "..."
                  : movies[index].title,
              style: Theme.of(context).textTheme.headline2.copyWith(
                    color: Colors.white,
                    fontSize: 28,
                  ),
            ),
            Row(
              children: [
                Text(
                  movies[index].releaseYear + " - " + movies[index].genre,
                  style: Theme.of(context).textTheme.headline2.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  ColorFilter _getColorOverlay(int index) {
    if (index == _currentlyVisibleCard && _isMovieLiked)
      return ColorFilter.mode(
        AppTheme.successColor.withOpacity(0.08),
        BlendMode.dstATop,
      );
    return ColorFilter.mode(
      AppTheme.successColor.withOpacity(1),
      BlendMode.dstATop,
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Loading Movies For You!',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
      ],
    ));
  }
}

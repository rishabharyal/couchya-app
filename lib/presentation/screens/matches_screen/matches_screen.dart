import 'package:couchya/api/matches.dart';
import 'package:couchya/models/match.dart';
import 'package:couchya/models/movie.dart';
import 'package:couchya/models/user.dart';
import 'package:couchya/presentation/common/user_avatar.dart';
import 'package:couchya/utilities/app_theme.dart';
import 'package:couchya/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MatchesScreen extends StatefulWidget {
  final int id;
  const MatchesScreen(this.id);
  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  List<Match> _matches = [];
  bool _isLoading = false;

  _getMatches() async {
    setState(() {
      _isLoading = true;
    });
    List<Match> m = await MatchesApi.get(widget.id);
    setState(() {
      _isLoading = false;
    });
    if (m == null) {
      Fluttertoast.showToast(
        msg: 'Something went wrong. Please try again!',
        backgroundColor: Theme.of(context).accentColor,
      );
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _matches = m;
    });
  }

  @override
  void initState() {
    super.initState();
    _getMatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildContextualAppbar(),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              child: _matches.length > 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: _matches.length,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        return _buildMatchCard(_matches[index]);
                      },
                    )
                  : Center(
                      child: Text(
                        'No Match Made Yet!',
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            .copyWith(color: AppTheme.inactiveGreyColor),
                      ),
                    ),
            ),
    );
  }

  Widget _buildMatchCard(Match match) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 16),
              height: SizeConfig.heightMultiplier * 70,
              child: Image.network(
                match.movie.poster,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: _buildTextOverlay(
                Movie(
                  id: 1,
                  title: match.movie.title,
                  genre: match.movie.genre,
                  releaseYear: match.movie.releaseYear,
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          width: SizeConfig.screenWidth,
          child: new Stack(
            children: _buildUserList(match.likers),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildUserList(List<User> likers) {
    List<Widget> widgets = [];

    likers.asMap().forEach((index, user) {
      if (index == 0) {
        widgets.add(
          userAvatar(url: user.image, name: user.name),
        );
      } else {
        widgets.add(
          Positioned(
            left: SizeConfig.widthMultiplier * 10 * index,
            child: userAvatar(
              url: user.image,
              name: user.name,
            ),
          ),
        );
      }
    });
    return widgets;
  }

  Widget _buildTextOverlay(Movie movie) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              movie.title.length > 20
                  ? movie.title.substring(0, 19) + "..."
                  : movie.title,
              style: Theme.of(context).textTheme.headline2.copyWith(
                    color: Colors.white,
                    fontSize: 28,
                  ),
            ),
            Row(
              children: [
                Text(
                  movie.releaseYear + " - " + movie.genre,
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

  AppBar _buildContextualAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Center(
        child: Text(
          'MATCHES',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      leading: GestureDetector(
        child: Icon(
          Icons.chevron_left,
          color: Colors.black,
          size: 38,
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          iconSize: 22,
          color: Colors.black,
          onPressed: () {
            Navigator.pushNamed(context, 'team/invite-members',
                arguments: widget.id);
          },
        ),
      ],
    );
  }
}

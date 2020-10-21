import 'package:couchya/models/movie.dart';
import 'package:couchya/models/user.dart';
import 'package:couchya/presentation/common/user_avatar.dart';
import 'package:couchya/utilities/size_config.dart';
import 'package:flutter/material.dart';

class MatchesScreen extends StatefulWidget {
  final int id;

  const MatchesScreen(this.id);
  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildContextualAppbar(),
      body: Container(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 2,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            return _buildMatchCard();
          },
        ),
      ),
    );
  }

  Widget _buildMatchCard() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 12),
              height: SizeConfig.heightMultiplier * 70,
              child: Image.network(
                'https://images.unsplash.com/photo-1496602910407-bacda74a0fe4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1300&q=80',
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
                  title: "Apni jjindafas",
                  genre: "ROCK",
                  releaseYear: '2000',
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          width: SizeConfig.screenWidth,
          child: new Stack(
            children: _buildUserList([
              User(id: 1, name: 'Ashok Pahadi'),
              User(id: 1, name: 'Ashok Pahadi'),
              User(id: 1, name: 'Ashok Pahadi'),
              User(id: 1, name: 'Ashok Pahadi'),
              User(id: 1, name: 'Ashok Pahadi'),
              User(id: 1, name: 'Ashok Pahadi'),
              User(id: 1, name: 'Ashok Pahadi'),
            ]),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildUserList(List<User> members) {
    List<Widget> widgets = [];

    members.asMap().forEach((index, member) {
      if (index == 0) {
        widgets.add(
          userAvatar(
              url:
                  "https://images.unsplash.com/photo-1496602910407-bacda74a0fe4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1300&q=80",
              name: member.name),
        );
      } else {
        widgets.add(
          Positioned(
            left: SizeConfig.widthMultiplier * 10 * index,
            child: userAvatar(
              url:
                  "https://images.unsplash.com/photo-1496602910407-bacda74a0fe4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1300&q=80",
              name: member.name,
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

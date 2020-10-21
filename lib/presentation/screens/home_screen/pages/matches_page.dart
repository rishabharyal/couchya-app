import 'dart:async';

import 'package:couchya/models/team.dart';
import 'package:couchya/models/user.dart';
import 'package:couchya/presentation/bloc/matches_page_bloc.dart';
import 'package:couchya/utilities/app_theme.dart';
import 'package:couchya/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class MatchesPage extends StatefulWidget {
  @override
  _MatchesPageState createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MatchesPageBloc>(
        builder: (context, matchesPageBloc, child) {
      List<Team> teams = matchesPageBloc.teams ?? [];
      return RefreshIndicator(
        onRefresh: () async {
          Provider.of<MatchesPageBloc>(context, listen: false).getTeams();
        },
        child: Stack(children: [
          ListView(children: [
            Container(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTeamsText(),
                  _buildTeams(teams),
                  teams.length > 0 ? Container() : _buildAddTeamButton(),
                ],
              ),
            ),
          ])
        ]),
      );
    });
  }

  Widget _buildTeamsText() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        'TEAMS',
        style: Theme.of(context).textTheme.headline2.copyWith(
              color: AppTheme.inactiveGreyColor,
            ),
      ),
    );
  }

  Widget _buildTeams(List<Team> teams) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: teams.length > 0
          ? ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: teams.length,
              itemBuilder: (team, index) {
                return _buildTeamRow(teams[index]);
              },
            )
          : Text(
              'No Teams Availavle',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: AppTheme.inactiveGreyColor,
                  ),
            ),
    );
  }

  Widget _buildTeamRow(Team team) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                team.title,
                style: Theme.of(context).textTheme.headline2.copyWith(),
              ),
            ),
            Container(
              height: 22,
              width: 22,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  '2',
                  style: Theme.of(context).textTheme.headline2.copyWith(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ],
        ),
        Container(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            width: SizeConfig.screenWidth,
            child: new Stack(
              children: _buildUserList(team.members),
            ),
          ),
        )
      ],
    );
  }

  List<Widget> _buildUserList(List<User> members) {
    List<Widget> widgets = [];

    members.asMap().forEach((index, member) {
      if (index == 0) {
        widgets.add(
          Column(
            children: [
              Container(
                height: SizeConfig.widthMultiplier * 12.5,
                width: SizeConfig.widthMultiplier * 12.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1496602910407-bacda74a0fe4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1300&q=80',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  member.name.substring(0, 3) + "..",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: AppTheme.inactiveGreyColor),
                ),
              ),
            ],
          ),
        );
      } else if (index < 3) {
        widgets.add(
          Positioned(
            left: SizeConfig.widthMultiplier * 10 * index,
            child: Column(
              children: [
                Container(
                  height: SizeConfig.widthMultiplier * 12.5,
                  width: SizeConfig.widthMultiplier * 12.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1496602910407-bacda74a0fe4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1300&q=80',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    member.name.substring(0, 3) + "..",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: AppTheme.inactiveGreyColor),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
    if (members.length > 3) {
      widgets.add(Positioned(
        left: SizeConfig.widthMultiplier * 36,
        child: Container(
            height: SizeConfig.widthMultiplier * 13,
            child: Center(
              child: Text(
                " + " + ((members.length - 3).toString()),
                style: Theme.of(context).textTheme.headline2.copyWith(
                      color: AppTheme.inactiveGreyColor,
                      fontSize: 24,
                    ),
              ),
            )),
      ));
    }
    return widgets;
  }

  Widget _buildAddTeamButton() {
    return Center(
      child: Container(
        height: SizeConfig.heightMultiplier * 6,
        width: SizeConfig.widthMultiplier * 50,
        child: RaisedButton(
          onPressed: () {
            Navigator.pushNamed(context, 'team/create');
          },
          child: Text(
            'ADD A TEAM',
            style: TextStyle(
              color: Colors.white,
              fontSize: SizeConfig.textMultiplier * 2.4,
            ),
          ),
          elevation: 0,
          color: Theme.of(context).primaryColor.withOpacity(0.9),
        ),
      ),
    );
  }
}

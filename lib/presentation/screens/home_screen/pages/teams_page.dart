import 'package:couchya/models/team.dart';
import 'package:couchya/models/user.dart';
import 'package:couchya/presentation/bloc/teams_bloc.dart';
import 'package:couchya/presentation/common/user_avatar.dart';
import 'package:couchya/utilities/app_theme.dart';
import 'package:couchya/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeamsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TeamsBloc>(builder: (context, teamsBloc, child) {
      List<Team> teams = teamsBloc.teams ?? [];
      List<Team> invitations = teamsBloc.invitations ?? [];
      return RefreshIndicator(
        onRefresh: () async {
          Provider.of<TeamsBloc>(context, listen: false).getInvitations();
          Provider.of<TeamsBloc>(context, listen: false).getTeams();
        },
        child: Stack(children: [
          ListView(children: [
            Container(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  invitations.length > 0
                      ? _buildInvitations(invitations, context)
                      : Container(),
                  _buildHeader("TEAMS", context),
                  _buildTeams(teams, false, context),
                  teams.length > 0 ? Container() : _buildAddTeamButton(context),
                ],
              ),
            ),
          ])
        ]),
      );
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Reject"),
      onPressed: () {},
    );
    Widget continueButton = FlatButton(
      child: Text("Accept"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Join Team"),
      content: Text("Do you want to accept this invitation?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _buildInvitations(List<Team> teams, BuildContext context) {
    return ExpansionTile(
      expandedAlignment: Alignment.topLeft,
      childrenPadding: EdgeInsets.all(0),
      tilePadding: EdgeInsets.all(0),
      maintainState: true,
      title: _buildHeader("INVITATIONS", context),
      children: <Widget>[
        _buildTeams(teams, true, context),
      ],
    );
  }

  Widget _buildHeader(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline2.copyWith(
              color: AppTheme.inactiveGreyColor,
            ),
      ),
    );
  }

  Widget _buildTeams(
      List<Team> teams, bool isInvitation, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: teams.length > 0
          ? ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: teams.length,
              itemBuilder: (context, index) {
                return _buildTeamRow(teams[index], isInvitation, context);
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

  Widget _buildTeamRow(Team team, bool isInvitation, BuildContext context) {
    return Container(
      child: ListTile(
        onTap: () {
          !isInvitation
              ? Navigator.pushNamed(context, 'team/show', arguments: team.id)
              : showAlertDialog(context);
        },
        contentPadding: EdgeInsets.all(0),
        title: Text(
          team.title,
          style: Theme.of(context).textTheme.headline2.copyWith(),
        ),
        trailing: Container(
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
        subtitle: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          width: SizeConfig.screenWidth,
          child: new Stack(
            children: _buildUserList(team.members, context),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildUserList(List<User> members, BuildContext context) {
    List<Widget> widgets = [];

    members.asMap().forEach((index, member) {
      if (index == 0) {
        widgets.add(userAvatar(url: member.image, name: member.name));
      } else if (index < 3) {
        widgets.add(
          Positioned(
            left: SizeConfig.widthMultiplier * 10 * index,
            child: userAvatar(
              url: member.image,
              name: member.name,
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

  Widget _buildAddTeamButton(context) {
    return Center(
      child: Container(
        height: SizeConfig.heightMultiplier * 7,
        width: SizeConfig.widthMultiplier * 50,
        margin: EdgeInsets.only(top: 16),
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

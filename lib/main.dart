import 'dart:ffi';

import 'package:couchya/api/auth.dart';
import 'package:couchya/api/team.dart';
import 'package:couchya/presentation/bloc/home_page_bloc.dart';
import 'package:couchya/presentation/bloc/matches_page_bloc.dart';
import 'package:couchya/presentation/common/logo.dart';
import 'package:couchya/presentation/screens/home_screen/home_screen.dart';
import 'package:couchya/presentation/screens/login_screen/login_screen.dart';
import 'package:couchya/presentation/screens/matches_screen/matches_screen.dart';
import 'package:couchya/presentation/screens/register_screen/register_screen.dart';
import 'package:couchya/presentation/screens/team_screen/invite_team_members_screen.dart';
import 'package:couchya/presentation/screens/team_screen/add_team_name_screen.dart';
import 'package:couchya/presentation/screens/welcome_screen/welcome_screen.dart';
import 'package:couchya/utilities/api_response.dart';
import 'package:couchya/utilities/app_theme.dart';
import 'package:couchya/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  bool _isAuthChecked = false;
  bool _joinTeamLater = false;
  int _joinTeamId;

  _checkAuth() async {
    bool auth = await Auth.isAuthenticated();

    setState(() {
      _isAuthChecked = true;
      _isLoggedIn = auth;
    });
  }

  Future<Void> _joinTeam(id) async {
    Fluttertoast.showToast(
      msg: "Joining Team!",
      backgroundColor: AppTheme.accentColor,
    );
    ApiResponse r = await TeamApi.join(id);
    if (r.hasErrors()) {
      Fluttertoast.showToast(
        msg: r.getMessage() != ""
            ? r.getMessage()
            : 'Something went wrong. Please try again!',
        backgroundColor: AppTheme.accentColor,
      );
      return null;
    }
    Fluttertoast.showToast(
      msg: r.getMessage() != ""
          ? r.getMessage()
          : 'You have joined the team successfully!',
      backgroundColor: Theme.of(context).primaryColor,
    );
    return null;
  }

  @override
  void initState() {
    this._checkAuth();
    super.initState();
  }

  final Map<String, WidgetBuilder> _routes = {
    'login': (context) =>
        LoginScreen(ModalRoute.of(context).settings.arguments),
    'register': (context) =>
        RegisterScreen(ModalRoute.of(context).settings.arguments),
    'home': (context) => HomeScreen(),
    'welcome': (context) =>
        WelcomeScreen(ModalRoute.of(context).settings.arguments),
    'team/create': (context) => CreateTeamScreen(),
    'team/invite-members': (context) =>
        InviteTeamMembersScreen(ModalRoute.of(context).settings.arguments),
    'team/show': (context) =>
        MatchesScreen(ModalRoute.of(context).settings.arguments),
  };

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomePageBloc>(create: (_) => HomePageBloc()),
        ChangeNotifierProvider<TeamsBloc>(create: (_) => TeamsBloc()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          return OrientationBuilder(
            builder: (context, orientation) {
              SizeConfig().init(constraints, orientation);
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Couchya',
                routes: this._routes,
                theme: AppTheme.lightTheme,
                home: StreamBuilder(
                  stream: getLinksStream(),
                  builder: (context, snapshot) {
                    if ((snapshot.hasData)) {
                      var uri = Uri.parse(snapshot.data);
                      var list = uri.queryParametersAll;
                      int id = int.parse(list['id'][0]);
                      String path = uri.path;

                      if (path == "/team/join" && id != null) {
                        if (_isLoggedIn) _joinTeam(id);
                      }
                    }
                    if (!_isAuthChecked) return buildLoadingPage();
                    if (_isAuthChecked && _isLoggedIn) return HomeScreen();
                    return WelcomeScreen(snapshot);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildLoadingPage() {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Logo.make(),
                CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

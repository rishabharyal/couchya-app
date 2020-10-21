import 'package:couchya/presentation/bloc/home_page_bloc.dart';
import 'package:couchya/presentation/bloc/matches_page_bloc.dart';
import 'package:couchya/presentation/screens/home_screen/home_screen.dart';
import 'package:couchya/presentation/screens/loading_screen/loading_screen.dart';
import 'package:couchya/presentation/screens/login_screen/login_screen.dart';
import 'package:couchya/presentation/screens/register_screen/register_screen.dart';
import 'package:couchya/presentation/screens/team_screen/invite_team_members_screen.dart';
import 'package:couchya/presentation/screens/team_screen/add_team_name_screen.dart';
import 'package:couchya/presentation/screens/welcome_screen/welcome_screen.dart';
import 'package:couchya/utilities/app_theme.dart';
import 'package:couchya/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // app routes here
  final Map<String, WidgetBuilder> _routes = {
    'login': (context) => LoginScreen(),
    'register': (context) => RegisterScreen(),
    'home': (context) => HomeScreen(),
    'welcome': (context) => WelcomeScreen(),
    'team/create': (context) => CreateTeamScreen(),
    'team/invite-members': (context) =>
        InviteTeamMembersScreen(ModalRoute.of(context).settings.arguments),
  };
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomePageBloc>(create: (_) => HomePageBloc()),
        ChangeNotifierProvider<MatchesPageBloc>(
            create: (_) => MatchesPageBloc()),
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
                home: LoadingScreen(),
              );
            },
          );
        },
      ),
    );
  }
}

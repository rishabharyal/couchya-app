import 'package:couchya/presentation/bloc/home_page_bloc.dart';
import 'package:couchya/presentation/bloc/teams_bloc.dart';
import 'package:couchya/presentation/screens/home_screen/home_screen.dart';
import 'package:couchya/presentation/screens/loading_screen/loading_screen.dart';
import 'package:couchya/presentation/screens/login_screen/login_screen.dart';
import 'package:couchya/presentation/screens/matches_screen/matches_screen.dart';
import 'package:couchya/presentation/screens/register_screen/register_screen.dart';
import 'package:couchya/presentation/screens/team_screen/invite_team_members_screen.dart';
import 'package:couchya/presentation/screens/team_screen/add_team_name_screen.dart';
import 'package:couchya/presentation/screens/welcome_screen/welcome_screen.dart';
import 'package:couchya/utilities/app_theme.dart';
import 'package:couchya/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final Map<String, WidgetBuilder> _routes = {
  //   'login': (context) => LoginScreen(),
  //   'register': (context) => RegisterScreen(),
  //   'home': (context) => HomeScreen(),
  //   'welcome': (context) => WelcomeScreen(),
  //   'team/create': (context) => CreateTeamScreen(),
  //   'team/invite-members': (context) =>
  //       InviteTeamMembersScreen(ModalRoute.of(context).settings.arguments),
  //   'team/show': (context) =>
  //       MatchesScreen(ModalRoute.of(context).settings.arguments),
  // };

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
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]);
              return MaterialApp(
                onGenerateRoute: (settings) {
                  switch (settings.name) {
                    case 'login':
                      return PageTransition(
                        child: LoginScreen(),
                        type: PageTransitionType.rightToLeft,
                        settings: settings,
                      );
                      break;
                    case 'register':
                      return PageTransition(
                        child: RegisterScreen(),
                        type: PageTransitionType.rightToLeft,
                        settings: settings,
                      );
                      break;
                    case 'home':
                      return PageTransition(
                        child: HomeScreen(),
                        type: PageTransitionType.rightToLeft,
                        settings: settings,
                      );
                      break;
                    case 'welcome':
                      return PageTransition(
                        child: WelcomeScreen(),
                        type: PageTransitionType.fade,
                        settings: settings,
                      );
                      break;
                    case 'team/create':
                      return PageTransition(
                        child: CreateTeamScreen(),
                        type: PageTransitionType.rightToLeft,
                        settings: settings,
                      );
                      break;
                    case 'team/invite-members':
                      return PageTransition(
                        child: InviteTeamMembersScreen(settings.arguments),
                        type: PageTransitionType.rightToLeft,
                        settings: settings,
                      );
                      break;
                    case 'team/show':
                      return PageTransition(
                        child: MatchesScreen(settings.arguments),
                        type: PageTransitionType.rightToLeft,
                        settings: settings,
                      );
                      break;
                    default:
                      return PageTransition(
                        child: WelcomeScreen(),
                        type: PageTransitionType.fade,
                        settings: settings,
                      );
                      ;
                  }
                },
                debugShowCheckedModeBanner: false,
                title: 'Couchya',
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

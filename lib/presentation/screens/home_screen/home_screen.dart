import 'package:couchya/api/auth.dart';
import 'package:couchya/models/user.dart';
import 'package:couchya/presentation/bloc/home_page_bloc.dart';
import 'package:couchya/presentation/bloc/matches_page_bloc.dart';
import 'package:couchya/presentation/common/dropdown.dart';
import 'package:couchya/presentation/common/logo.dart';
import 'package:couchya/presentation/common/range.dart';
import 'package:couchya/presentation/screens/home_screen/pages/home_page.dart';
import 'package:couchya/presentation/screens/home_screen/pages/liked_page.dart';
import 'package:couchya/presentation/screens/home_screen/pages/teams_page.dart';
import 'package:couchya/utilities/app_theme.dart';
import 'package:couchya/utilities/local_storage.dart';
import 'package:couchya/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // for double back press exit functionality
  DateTime currentBackPressTime;
  int _activePageIndex = 0;
  bool _isFilterVisible = false;
  RangeValues _rangeValue = RangeValues(1900.0, DateTime.now().year.toDouble());
  User _loggedInUser;

  List<BottomNavigationBarItem> _navigationBarItems = [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.local_movies,
        size: 32,
      ),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.tonality,
        size: 32,
      ),
      label: 'Matches',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.thumb_up,
        size: 32,
      ),
      label: 'Liked',
    ),
  ];

  List<Widget> _navigationPages = [
    HomePage(),
    TeamsPage(),
    LikedPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _activePageIndex = index;
    });
  }

  @override
  void initState() {
    Provider.of<HomePageBloc>(context, listen: false).loadMovies();
    Provider.of<TeamsBloc>(context, listen: false).getTeams();
    _getUserDetails();
    super.initState();
  }

  _getUserDetails() async {
    User u = await LocalStorage.getUser();
    setState(() {
      _loggedInUser = u;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await onWillPop();
      },
      child: Scaffold(
        appBar: _buildContextualAppbar(),
        bottomNavigationBar: _buildBottomNavigationBar(),
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isFilterVisible = false;
                });
              },
              child: IndexedStack(
                children: _navigationPages,
                index: _activePageIndex,
              ),
            ),
            _buildFilterWidget(),
          ],
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Press again to exit!');
      return Future.value(false);
    }
    return Future.value(true);
  }

  AppBar _buildContextualAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Center(
        child: Logo.make(color: Colors.black),
      ),
      leading: GestureDetector(
        onTap: () async {
          await Auth.logout();
          Navigator.of(context).pushNamedAndRemoveUntil(
              'welcome', (Route<dynamic> route) => false);
        },
        child: Container(
          padding: EdgeInsets.all(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: _loggedInUser != null
                ? Image.network(
                    _loggedInUser.image,
                    fit: BoxFit.cover,
                  )
                : Container(),
          ),
        ),
      ),
      actions: [
        _activePageIndex == 0
            ? IconButton(
                icon: Icon(Icons.settings_input_component),
                iconSize: 22,
                color: Colors.black,
                onPressed: () {
                  setState(() {
                    _isFilterVisible = !_isFilterVisible;
                  });
                },
              )
            : IconButton(
                icon: Icon(Icons.add),
                iconSize: 22,
                color: Colors.black,
                onPressed: () {
                  Navigator.pushNamed(context, 'team/create');
                },
              ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      elevation: 0,
      items: _navigationBarItems,
      currentIndex: _activePageIndex,
      onTap: _onItemTapped,
    );
  }

  Widget _buildFilterWidget() {
    return AnimatedPositioned(
      top: _isFilterVisible ? 0 : -1000,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 600),
      child: Container(
        padding: EdgeInsets.all(12),
        width: SizeConfig.screenWidth,
        color: Colors.white,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(children: [
                  DropDownField(
                    placeholder: 'GENRE',
                    onChange: (id) {
                      Provider.of<HomePageBloc>(context, listen: false)
                          .setGenre(id);
                    },
                    items: [
                      {'text': 'Comedy', 'value': 'Comedy'},
                      {'text': 'Action', 'value': 'Action'},
                    ],
                  ),
                  CustomRange(
                    placeholder: 'YEAR',
                    onChange: (range) {
                      Provider.of<HomePageBloc>(context, listen: false)
                          .setRange(range);
                    },
                    range: _rangeValue,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        this._isFilterVisible = false;
                      });
                      Provider.of<HomePageBloc>(context, listen: false)
                          .resetMovies();
                      Provider.of<HomePageBloc>(context, listen: false)
                          .loadMovies();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.inactiveGreyColor,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Apply Filters',
                          style: Theme.of(context).textTheme.headline2.copyWith(
                                color: AppTheme.inactiveGreyColor,
                              ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

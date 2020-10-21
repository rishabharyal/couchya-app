import 'package:couchya/api/auth.dart';
import 'package:couchya/presentation/common/logo.dart';
import 'package:couchya/utilities/size_config.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  _checkAuth() async {
    if (await Auth.isAuthenticated()) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('welcome', (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    this._checkAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

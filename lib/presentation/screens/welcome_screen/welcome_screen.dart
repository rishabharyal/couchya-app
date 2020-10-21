import 'package:couchya/presentation/common/logo.dart';
import 'package:couchya/utilities/size_config.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  final AsyncSnapshot snapshot;

  const WelcomeScreen(this.snapshot);
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final String _title = 'Match Movies';
  final String _subtitle = "Watch movies with someone you love.";
  final double _buttonsTopMargin = 60;
  final double _screenPadding = 32;
  final String _imageUrl =
      "https://images.unsplash.com/photo-1496602910407-bacda74a0fe4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1300&q=80";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.all(this._screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Logo.make(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildTitleText(),
                _buildSubtitleText(),
                _buildImage(),
                _buildActionButtons(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleText() {
    return Container(
      child: Text(
        this._title,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }

  Widget _buildSubtitleText() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      child: Text(
        this._subtitle,
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      child: Image.network(
        this._imageUrl,
        fit: BoxFit.cover,
        height: SizeConfig.heightMultiplier * 35,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: EdgeInsets.only(top: this._buttonsTopMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'login', arguments: widget.snapshot);
            },
            child: Container(
              child: Text(
                'Log in',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'register',
                  arguments: widget.snapshot);
            },
            child: Container(
              child: Text(
                'Register',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

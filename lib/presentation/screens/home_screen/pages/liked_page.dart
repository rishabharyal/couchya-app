import 'package:couchya/utilities/app_theme.dart';
import 'package:flutter/material.dart';

class LikedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Coming Soon!',
          style: Theme.of(context).textTheme.headline2.copyWith(
                color: AppTheme.inactiveGreyColor,
              ),
        ),
      ),
    );
  }
}

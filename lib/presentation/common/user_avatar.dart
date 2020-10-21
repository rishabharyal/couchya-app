import 'package:couchya/utilities/app_theme.dart';
import 'package:couchya/utilities/size_config.dart';
import 'package:flutter/material.dart';

Widget userAvatar({@required String url, @required String name}) {
  return Column(
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
          name.substring(0, 3) + "..",
          style: TextStyle(
            color: AppTheme.inactiveGreyColor,
            fontWeight: FontWeight.w300,
            fontSize: 1.8 * SizeConfig.textMultiplier,
          ),
        ),
      ),
    ],
  );
}

import 'package:couchya/utilities/app_theme.dart';
import 'package:couchya/utilities/size_config.dart';
import 'package:flutter/material.dart';

Widget userAvatar({@required String url, @required String name}) {
  return Column(
    children: [
      Container(
        height: SizeConfig.widthMultiplier * 14,
        width: SizeConfig.widthMultiplier * 14,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child: Image.network(
            url,
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
            fontSize: 2 * SizeConfig.textMultiplier,
          ),
        ),
      ),
    ],
  );
}

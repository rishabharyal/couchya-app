import 'package:couchya/presentation/common/logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildAppHeader({String imageUrl}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          height: 30,
          width: 30,
        ),
      ),
      Logo.make(),
      IconButton(
        icon: Icon(Icons.ballot_outlined),
        onPressed: () {},
      )
    ],
  );
}

import 'package:couchya/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Logo {
  static Widget make({Color color = Colors.black}) {
    return Container(
      child: Text(
        'couchya',
        style: GoogleFonts.sofia().copyWith(
          color: color,
          fontSize: SizeConfig.textMultiplier * 5,
        ),
      ),
    );
  }
}

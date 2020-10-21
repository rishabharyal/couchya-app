import 'package:couchya/utilities/app_theme.dart';
import 'package:couchya/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormField extends StatefulWidget {
  final bool isPassword;
  final TextEditingController controller;
  final dynamic validator;
  final String hint;
  final bool isWhiteSpaceAllowed;
  final bool isCenterAligned;

  CustomFormField({
    this.isPassword = false,
    this.controller,
    this.validator,
    this.hint,
    this.isWhiteSpaceAllowed = false,
    this.isCenterAligned = false,
  });
  @override
  _CustomFormFieldState createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier * 1),
      child: TextFormField(
        textAlign: widget.isCenterAligned ? TextAlign.center : TextAlign.left,
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(fontSize: SizeConfig.textMultiplier * 3),
        inputFormatters: !widget.isWhiteSpaceAllowed
            ? [WhitelistingTextInputFormatter(RegExp(r'[a-zA-Z0-9._@]'))]
            : [],
        controller: widget.controller,
        validator: widget.validator,
        maxLines: 1,
        obscureText: widget.isPassword && !isPasswordVisible,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8),
          isDense: true,
          hintText: widget.hint != '' ? widget.hint : '',
          hintStyle: Theme.of(context).textTheme.headline2.copyWith(
                color: AppTheme.inactiveGreyColor,
              ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
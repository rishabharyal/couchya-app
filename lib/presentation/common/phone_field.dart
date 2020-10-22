//library international_phone_input;

import 'dart:async';
import 'dart:convert';

import 'package:couchya/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:international_phone_input/international_phone_input.dart';

class InternationalPhoneInput extends StatefulWidget {
  final void Function(String code, String country) onCodeChanged;
  final String initialPhoneNumber;
  final String initialSelection;
  final String errorText;
  final String hintText;
  final String labelText;
  final TextStyle errorStyle;
  final TextStyle hintStyle;
  final TextStyle labelStyle;
  final int errorMaxLines;
  final List<String> enabledCountries;
  final InputDecoration decoration;
  final dynamic validator;
  final bool showCountryCodes;
  final bool showCountryFlags;
  final Widget dropdownIcon;
  final InputBorder border;
  final TextStyle formStyle;
  final TextEditingController controller;

  InternationalPhoneInput(
      {this.onCodeChanged,
      this.initialPhoneNumber,
      this.formStyle,
      this.initialSelection,
      this.errorText,
      this.hintText,
      this.labelText,
      this.errorStyle,
      this.hintStyle,
      this.labelStyle,
      this.enabledCountries = const [],
      this.errorMaxLines,
      this.decoration,
      this.showCountryCodes = true,
      this.showCountryFlags = true,
      @required this.controller,
      this.validator,
      this.dropdownIcon,
      this.border});

  static Future<String> internationalizeNumber(String number, String iso) {
    return PhoneService.getNormalizedPhoneNumber(number, iso);
  }

  @override
  _InternationalPhoneInputState createState() =>
      _InternationalPhoneInputState();
}

class _InternationalPhoneInputState extends State<InternationalPhoneInput> {
  Country selectedItem;
  List<Country> itemList = [];

  String errorText;
  String hintText;
  String labelText;

  TextStyle errorStyle;
  TextStyle hintStyle;
  TextStyle labelStyle;

  int errorMaxLines;

  bool hasError = false;
  bool showCountryCodes;
  bool showCountryFlags;

  InputDecoration decoration;
  Widget dropdownIcon;
  InputBorder border;

  _InternationalPhoneInputState();

  @override
  void initState() {
    errorText = widget.errorText ?? 'Please enter a valid phone number';
    hintText = widget.hintText;
    labelText = widget.labelText;
    errorStyle = widget.errorStyle;
    hintStyle = widget.hintStyle;
    labelStyle = widget.labelStyle;
    errorMaxLines = widget.errorMaxLines;
    decoration = widget.decoration;
    showCountryCodes = widget.showCountryCodes;
    showCountryFlags = widget.showCountryFlags;
    dropdownIcon = widget.dropdownIcon;

    _fetchCountryData().then((list) {
      Country preSelectedItem;

      if (widget.initialSelection != null) {
        preSelectedItem = list.firstWhere(
            (e) =>
                (e.code.toUpperCase() ==
                    widget.initialSelection.toUpperCase()) ||
                (e.dialCode == widget.initialSelection.toString()),
            orElse: () => list[0]);
      } else {
        preSelectedItem = list[0];
      }

      setState(() {
        itemList = list;
        selectedItem = preSelectedItem;
      });
    });

    super.initState();
  }

  Future<List<Country>> _fetchCountryData() async {
    var list = await DefaultAssetBundle.of(context)
        .loadString('packages/international_phone_input/assets/countries.json');
    List<dynamic> jsonList = json.decode(list);

    List<Country> countries = List<Country>.generate(jsonList.length, (index) {
      Map<String, String> elem = Map<String, String>.from(jsonList[index]);
      if (widget.enabledCountries.isEmpty) {
        return Country(
            name: elem['en_short_name'],
            code: elem['alpha_2_code'],
            dialCode: elem['dial_code'],
            flagUri: 'assets/flags/${elem['alpha_2_code'].toLowerCase()}.png');
      } else if (widget.enabledCountries.contains(elem['alpha_2_code']) ||
          widget.enabledCountries.contains(elem['dial_code'])) {
        return Country(
            name: elem['en_short_name'],
            code: elem['alpha_2_code'],
            dialCode: elem['dial_code'],
            flagUri: 'assets/flags/${elem['alpha_2_code'].toLowerCase()}.png');
      } else {
        return null;
      }
    });

    countries.removeWhere((value) => value == null);

    return countries;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier * 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          DropdownButtonHideUnderline(
            child: Padding(
              padding: EdgeInsets.only(top: 8),
              child: DropdownButton<Country>(
                value: selectedItem,
                icon: Padding(
                  padding:
                      EdgeInsets.only(bottom: (decoration != null) ? 6 : 0),
                  child: dropdownIcon ?? Icon(Icons.arrow_drop_down),
                ),
                onChanged: (Country newValue) {
                  setState(() {
                    selectedItem = newValue;
                  });
                  widget.onCodeChanged(newValue.dialCode, newValue.code);
                },
                items: itemList.map<DropdownMenuItem<Country>>((Country value) {
                  return DropdownMenuItem<Country>(
                    value: value,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          if (showCountryFlags) ...[
                            Image.asset(
                              value.flagUri,
                              width: 32.0,
                              package: 'international_phone_input',
                            )
                          ],
                          if (showCountryCodes) ...[
                            SizedBox(width: 4),
                            Text(value.dialCode)
                          ]
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Flexible(
              child: TextFormField(
            style: widget.formStyle ?? null,
            validator: widget.validator ?? null,
            keyboardType: TextInputType.phone,
            controller: widget.controller,
            decoration: decoration ??
                InputDecoration(
                  isDense: true,
                  hintText: hintText,
                  errorText: hasError ? errorText : null,
                  hintStyle: hintStyle ?? null,
                  errorStyle: errorStyle ?? null,
                  errorMaxLines: errorMaxLines ?? 3,
                  border: border ?? null,
                ),
          ))
        ],
      ),
    );
  }
}
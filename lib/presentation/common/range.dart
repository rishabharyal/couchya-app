import 'package:flutter/material.dart';

class CustomRange extends StatefulWidget {
  final String placeholder;
  final RangeValues range;
  final Function(RangeValues) onChange;
  // final List<Map<String, dynamic>> items;
  // final Function(String) onChange;

  CustomRange({this.placeholder, this.range, this.onChange});
  @override
  _CustomRangeState createState() => _CustomRangeState();
}

class _CustomRangeState extends State<CustomRange> {
  RangeValues _currentRangeValues;
  @override
  void initState() {
    _currentRangeValues = widget.range;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "${widget.placeholder} (${_currentRangeValues.start.toInt()} - ${_currentRangeValues.end.toInt()})",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          RangeSlider(
            values: _currentRangeValues,
            min: widget.range.start,
            max: widget.range.end,
            divisions:
                ((widget.range.end - widget.range.start)).round().toInt(),
            labels: RangeLabels(
              _currentRangeValues.start.toInt().toString(),
              _currentRangeValues.end.toInt().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
              });
              if (widget.onChange != null)
                widget.onChange(this._currentRangeValues);
            },
          )
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropDownField extends StatefulWidget {
  final String placeholder;
  final List<Map<String, dynamic>> items;
  final Function(String) onChange;

  DropDownField({this.placeholder, this.items, this.onChange});

  @override
  _DropDownFieldState createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {
  TextEditingController _controller = new TextEditingController();
  String _selectedValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this._controller.text = widget.items != null && widget.items.length > 0
        ? widget.items[0]['text'].toString()
        : '';

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.placeholder,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          new DropdownButton<String>(
            isExpanded: true,
            items: widget.items.map((Map<String, dynamic> item) {
              return new DropdownMenuItem<String>(
                value: item['text'],
                child: new Text(
                  item['text'].toString().toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(fontSize: 16),
                ),
              );
            }).toList(),
            hint: Text(widget.placeholder),
            value: _selectedValue,
            onChanged: (String val) {
              this._controller.text = val.toString();
              setState(() {
                _selectedValue = val.toString();
              });
              if (widget.onChange != null) {
                String returnVal;
                widget.items.forEach((element) {
                  if (element['text'] == val) {
                    returnVal = element['value'] != null
                        ? element['value'].toString()
                        : element['text'];
                  }
                });
                print(returnVal);
                widget.onChange(returnVal);
              }
            },
          ),
        ],
      ),
    );
  }
}

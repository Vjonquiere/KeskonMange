import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/filters.dart';

class MenuFilterChip extends StatefulWidget {
  final Filters filterType;
  Function(Filters, Filter?) addFilterCallback;

  MenuFilterChip({required this.filterType, required this.addFilterCallback});

  @override
  State<StatefulWidget> createState() {
    return _MenuFilterChip();
  }
}

class _MenuFilterChip extends State<MenuFilterChip> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: _selected,
      label: Text(widget.filterType.toString()),
      deleteIcon: Icon(Icons.expand_more_sharp),
      onSelected: (bool value) {
        setState(() {
          _selected = !_selected;
        });
      },
      onDeleted: () async {
        final res = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                elevation: 1,
                child: widget.filterType.widget,
              );
            });
        if ((res != null) && (res is Filter)) {
          widget.addFilterCallback(widget.filterType, res);
          setState(() {
            _selected = true;
          });
        }
      },
    );
  }
}

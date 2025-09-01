import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class RotaryNumberPicker extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int initialValue;
  final ValueChanged<int>? onChanged;

  const RotaryNumberPicker({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    this.onChanged,
  });

  @override
  State<RotaryNumberPicker> createState() => _RotaryNumberPickerState();
}

class _RotaryNumberPickerState extends State<RotaryNumberPicker> {
  late FixedExtentScrollController _controller;
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _controller = FixedExtentScrollController(
      initialItem: _currentValue - widget.minValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    final int itemCount = widget.maxValue - widget.minValue + 1;

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.green, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          height: 150,
          width: 80,
          child: ListWheelScrollView.useDelegate(
            controller: _controller,
            physics: const FixedExtentScrollPhysics(),
            itemExtent: 40,
            onSelectedItemChanged: (int index) {
              _currentValue = widget.minValue + index;
              widget.onChanged?.call(_currentValue);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (BuildContext context, int index) {
                if (index < 0 || index >= itemCount) {
                  return null;
                }
                final int value = widget.minValue + index;
                return Center(
                  child: Text(
                    value.toString(),
                    style: const TextStyle(fontSize: 24),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.blue, width: 3),
            ),
            height: 35,
            //color: Colors.black,
          ),
        ),
      ],
    );
  }
}

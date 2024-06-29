import 'package:flutter/material.dart';

class CircleDay extends StatefulWidget {
  final String day;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  CircleDay({
    required this.day,
    this.isSelected = false,
    required this.onSelected,
  });

  @override
  _CircleDayState createState() => _CircleDayState();
}

class _CircleDayState extends State<CircleDay> {
  bool _isSelected;

  _CircleDayState() : _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  void _toggleSelection() {
    setState(() {
      _isSelected = !_isSelected;
    });
    widget.onSelected(_isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleSelection,
      child: CircleAvatar(
        backgroundColor: _isSelected ? Colors.blue : Colors.grey,
        child: Text(
          widget.day,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

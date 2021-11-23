import 'package:flutter/material.dart';

class ColorRadioButton extends StatefulWidget {
  final Color color;
  final int value;
  final int groupValue;
  final VoidCallback onPressed;

  ColorRadioButton(
      {@required this.color,
      @required this.value,
      @required this.groupValue,
      this.onPressed});
  @override
  _ColorRadioButtonState createState() => _ColorRadioButtonState();
}

class _ColorRadioButtonState extends State<ColorRadioButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 18.0,
      icon: CircleAvatar(
        backgroundColor: widget.value == widget.groupValue
            ? widget.color.withOpacity(0.3)
            : Colors.white,
        radius: 16.0,
        child: CircleAvatar(
          backgroundColor: widget.color,
          radius: 10.0,
        ),
      ),
      onPressed: widget.onPressed,
    );
  }
}

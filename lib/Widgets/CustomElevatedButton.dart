import 'package:flutter/material.dart';
import 'package:queuing_system/Methods/Style.dart';

class CustomElevatedButton extends StatefulWidget {
  const CustomElevatedButton({
    @required this.title,
    @required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  _CustomElevatedButtonState createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.0,
      child: ElevatedButton(
        onPressed: widget.onTap,
        style: ElevatedButton.styleFrom(
            shape: (RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80.0))),
            padding: EdgeInsets.all(0.0)),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  hexColor("76abdf").withOpacity(0.8),
                  hexColor("5c85b0").withOpacity(0.1),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            // constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

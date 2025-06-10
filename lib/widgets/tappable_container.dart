import 'package:flutter/material.dart';

class TappableContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const TappableContainer({
    required this.child,
    required this.onTap,
    super.key,
  });

  @override
  State<TappableContainer> createState() => _TappableContainerState();
}

class _TappableContainerState extends State<TappableContainer> {
  bool _isPressed = false;

  void _setPressed(bool pressed) {
    setState(() {
      _isPressed = pressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        //padding: EdgeInsets.symmetric(vertical: 16),
        //height: 40,
        decoration: BoxDecoration(
          color: _isPressed ? Colors.grey[400] : Colors.white,
        ),
        child: widget.child,
      ),
    );
  }
}

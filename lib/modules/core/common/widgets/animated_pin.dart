import 'package:flutter/material.dart';

/// [AnimatedPin] This class is used to Animated Pin
class AnimatedPin extends StatefulWidget {
  const AnimatedPin({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  AnimatedPinState createState() => AnimatedPinState();
}

class AnimatedPinState extends State<AnimatedPin>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return JumpingContainer(controller: _controller, child: widget.child);
  }
}

/// [JumpingContainer] This class is used to Jumping Container
class JumpingContainer extends AnimatedWidget {
  const JumpingContainer({
    Key? key,
    required AnimationController controller,
    this.child,
  }) : super(key: key, listenable: controller);

  final Widget? child;

  Animation<double> get _progress => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -10 + _progress.value * 10),
      child: child,
    );
  }
}

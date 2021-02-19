import 'package:flutter/material.dart';

class GestureDetectorWithPreview extends StatelessWidget {
  final GestureTapCallback onTap;
  final Widget child;
  final Widget preview;

  OverlayEntry _overlayEntry;

  GestureDetectorWithPreview({
    @required this.child,
    @required this.preview,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _overlayEntry = OverlayEntry(builder: (context) => AnimatedDialog(
          child: this.preview,
        ));
        Overlay.of(context).insert(_overlayEntry);
      },
      onLongPressEnd: (details) {
        _overlayEntry?.remove();
      },
      onTap: this.onTap,
      child: this.child,
    );
  }
}

// This a widget to implement the image scale animation, and background grey out effect.
class AnimatedDialog extends StatefulWidget {
  const AnimatedDialog({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() => AnimatedDialogState();
}

class AnimatedDialogState extends State<AnimatedDialog> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> opacityAnimation;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.easeOutExpo);
    opacityAnimation =
        Tween<double>(begin: 0.0, end: 0.6).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutExpo));

    controller.addListener(() => setState(() {}));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(opacityAnimation.value),
      child: Center(
        child: FadeTransition(
          opacity: scaleAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

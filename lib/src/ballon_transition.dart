part of tooltip;

class _BalloonTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final TooltipDirection tooltipDirection;
  final bool hide;
  final Function(AnimationStatus)? animationEnd;
  final Function(AnimationStatus)? animationStart;

  _BalloonTransition({
    Key? key,
    required this.child,
    required this.duration,
    required this.tooltipDirection,
    this.hide = false,
    this.animationEnd,
    this.animationStart,
  }) : super(key: key);

  @override
  _BalloonTransitionState createState() => _BalloonTransitionState();
}

class _BalloonTransitionState extends State<_BalloonTransition> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    if (!widget.hide) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    _animationController.addStatusListener((status) {
      if ((status == AnimationStatus.completed || status == AnimationStatus.dismissed) && widget.animationEnd != null) {
        widget.animationEnd!(status);
      }
      if (status == AnimationStatus.reverse) {
        widget.animationStart?.call(status);
      }
    });
  }

  @override
  void didUpdateWidget(_BalloonTransition oldWidget) {
    if (widget.hide) {
      _animationController.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return _OpacityAnimationWrapper(
      duration: widget.duration,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class _OpacityAnimationWrapper extends StatefulWidget {
  final Duration duration;
  const _OpacityAnimationWrapper({
    Key? key,
    required this.child,
    required this.duration,
  }) : super(key: key);

  final Widget child;

  @override
  __OpacityAnimationWrapperState createState() => __OpacityAnimationWrapperState();
}

class __OpacityAnimationWrapperState extends State<_OpacityAnimationWrapper> {
  double _opacity = 0.38;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        setState(() {
          _opacity = 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: widget.duration,
      opacity: _opacity,
      child: widget.child,
    );
  }
}

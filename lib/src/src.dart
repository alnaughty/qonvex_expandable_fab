import 'package:flutter/material.dart';
import 'package:qonvex_expandable_fab/assets/action_button.dart';
import 'package:qonvex_expandable_fab/assets/expanding_action_button.dart';

class QonvExpandableFab extends StatefulWidget {
  final bool? initialOpen;
  final double distance;
  final List<ActionButton> children;
  final Color color;
  final Color? closeIconColor;
  final Color? closeButtonColor;
  // final Color
  final IconData activeIcon;
  final Color actionColor;
  const QonvExpandableFab(
      {Key? key,
      this.initialOpen,
      this.closeButtonColor,
      this.closeIconColor,
      required this.distance,
      required this.children,
      required this.color,
      required this.actionColor,
      required this.activeIcon})
      : super(key: key);
  @override
  _QonvExpandableFabState createState() => _QonvExpandableFabState();
}

class _QonvExpandableFabState extends State<QonvExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;
  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          color: widget.closeButtonColor ?? Colors.white,
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: widget.closeIconColor ?? Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: ActionButton(
            color: widget.actionColor,
            icon: widget.children[i].icon,
            message: widget.children[i].message,
            onPressed: () {
              _toggle();
              widget.children[i].onPressed!();
            },
          ),
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            backgroundColor: widget.color,
            onPressed: _toggle,
            child: Icon(widget.activeIcon),
          ),
        ),
      ),
    );
  }
}

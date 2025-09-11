import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/scheduler.dart';

class FluidCard extends StatefulWidget {
  final String color;
  final Color altColor;
  final String title;
  final String subtitle;
  final Widget? button; // Add optional button parameter

  const FluidCard({
    super.key,
    required this.color,
    this.title = "",
    required this.subtitle,
    required this.altColor,
    this.button, // Add button parameter
  });

  @override
  State<FluidCard> createState() => _FluidCardState();
}

class _FluidCardState extends State<FluidCard> {
  late Ticker _ticker;

  @override
  void initState() {
    _ticker = Ticker((d) {
      setState(() {});
    })..start();
    super.initState();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        var time = DateTime.now().millisecondsSinceEpoch / 2000;
        var scaleX = 1.2 + sin(time) * .05;
        var scaleY = 1.2 + cos(time) * .07;
        var offsetY = 20 + cos(time) * 20;
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        return Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: <Widget>[
            Transform.translate(
              offset: Offset(
                -(scaleX - 1) / 2 * width,
                -(scaleY - 1) / 2 * height + offsetY,
              ),
              child: Transform(
                transform: Matrix4.diagonal3Values(scaleX, scaleY, 1),
                child: Image.asset(
                  'assets/images/Bg-${widget.color}.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 75.0, bottom: 25.0),
                child: Column(
                  children: <Widget>[
                    //Top Image
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Image.asset(
                          'assets/images/Illustration-${widget.color}.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    //Bottom content
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: _buildBottomContent(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              height: 1.2,
              fontSize: 30.0,
              fontFamily: 'MarcellusSC',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Flexible(
          child: Text(
            widget.subtitle,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w300,
              fontFamily: 'Lexend',
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ),
        if (widget.button != null) ...[
          const SizedBox(height: 16),
          widget.button!,
        ],
      ],
    );
  }
}

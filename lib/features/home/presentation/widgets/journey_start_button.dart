import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_constants.dart';

class JourneyStartButton extends StatefulWidget {
  const JourneyStartButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<JourneyStartButton> createState() => _JourneyStartButtonState();
}

class _JourneyStartButtonState extends State<JourneyStartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              height: sy(context, 70),
              margin: EdgeInsets.symmetric(horizontal: sx(context, 8)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sx(context, 20)),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4FB3B7),
                    Color(0xFF84D9D7),
                    Color(0xFF4FB3B7),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.teal.withOpacity(_glowAnimation.value * 0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(sx(context, 20)),
                  onTap: widget.onTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: sx(context, 24)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.rocket_launch_rounded,
                          color: AppColors.bgDarkText,
                          size: sx(context, 28),
                        ),
                        SizedBox(width: sx(context, 12)),
                        Expanded(
                          child: Text(
                            'Click Two Taps To Start Your Journey',
                            style: GoogleFonts.judson(
                              color: AppColors.bgDarkText,
                              fontWeight: FontWeight.w700,
                              fontSize: sx(context, 18),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.bgDarkText,
                          size: sx(context, 24),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

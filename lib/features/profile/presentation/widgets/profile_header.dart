// features/profile/presentation/widgets/profile_header.dart
import 'package:flutter/material.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';


class ProfileHeader extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String profileImageUrl;
  final bool isPro;

  const ProfileHeader({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.profileImageUrl,
    required this.isPro,
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Glow pulsing animation
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.6,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Glow effect (only for Pro)
            if (widget.isPro)
              AnimatedBuilder(
                animation: _glowController,
                builder: (context, child) {
                  return Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD700).withValues(alpha: _glowAnimation.value),
                          blurRadius: 40,
                          spreadRadius: 15,
                        ),
                        BoxShadow(
                          color: const Color(0xFFFFA500).withValues(alpha: _glowAnimation.value * 0.5),
                          blurRadius: 60,
                          spreadRadius: 25,
                        ),
                      ],
                    ),
                  );
                },
              ),

            // Profile Image with border
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: widget.isPro
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFFFD700),
                          const Color(0xFFFFA500),
                          const Color(0xFFFFD700),
                        ],
                      )
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF5AC7C7),
                          const Color(0xFF4A9E9E),
                          const Color(0xFF5AC7C7),
                        ],
                      ),
                boxShadow: [
                  // Outer glow
                  BoxShadow(
                    color: widget.isPro
                        ? const Color(0xFFFFD700).withValues(alpha: 0.4)
                        : const Color(0xFF5AC7C7).withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 3,
                    offset: const Offset(0, 4),
                  ),
                  // Inner shadow effect
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 15,
                    spreadRadius: -2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment.topLeft,
                    radius: 1.2,
                    colors: [
                      const Color(0xFF2A2D3E).withValues(alpha: 0.8),
                      AppColors.cardBackground,
                      const Color(0xFF0D0E17),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  boxShadow: [
                    // Inner shadow for depth
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 10,
                      spreadRadius: -5,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage: AssetImage(widget.profileImageUrl),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),

            // Pro Badge with animation
            if (widget.isPro)
              Positioned(
                bottom: -5,
                child: AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.lerp(
                              const Color(0xFFFFD700),
                              const Color(0xFFFFA500),
                              _glowAnimation.value,
                            )!,
                            Color.lerp(
                              const Color(0xFFFFA500),
                              const Color(0xFFFFD700),
                              _glowAnimation.value,
                            )!,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primaryBackground, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFD700).withValues(alpha: 0.6),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.workspace_premium,
                            color: Colors.white,
                            size: 16,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "PRO",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.userName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                shadows: widget.isPro
                    ? [
                        Shadow(
                          color: const Color(0xFFFFD700).withValues(alpha: 0.5),
                          blurRadius: 10,
                        ),
                      ]
                    : [],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          widget.userEmail,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:math';
import '../theme/glassmorphism_theme.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  @override
  void initState() {
    super.initState();
    
    _controller1 = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _controller2 = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _controller3 = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F0F23),
            Color(0xFF1A1A3A),
            Color(0xFF2D1B69),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Floating blobs
          AnimatedBuilder(
            animation: _controller1,
            builder: (context, child) {
              return Positioned(
                left: 50 + sin(_controller1.value * 2 * pi) * 30,
                top: 100 + cos(_controller1.value * 2 * pi) * 50,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        GlassmorphismTheme.primaryPurple.withValues(alpha: 0.4),
                        GlassmorphismTheme.primaryPurple.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _controller2,
            builder: (context, child) {
              return Positioned(
                right: 30 + sin(_controller2.value * 2 * pi + 1) * 40,
                top: 200 + cos(_controller2.value * 2 * pi + 1) * 30,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        GlassmorphismTheme.primaryPink.withValues(alpha: 0.5),
                        GlassmorphismTheme.primaryPink.withValues(alpha: 0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _controller3,
            builder: (context, child) {
              return Positioned(
                left: MediaQuery.of(context).size.width * 0.6 + 
                      sin(_controller3.value * 2 * pi + 2) * 25,
                bottom: 150 + cos(_controller3.value * 2 * pi + 2) * 40,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        GlassmorphismTheme.primaryBlue.withValues(alpha: 0.3),
                        GlassmorphismTheme.primaryBlue.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // Static background blobs
          Positioned(
            right: -50,
            top: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    GlassmorphismTheme.primaryPurple.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    GlassmorphismTheme.primaryPink.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Content
          widget.child,
        ],
      ),
    );
  }
}
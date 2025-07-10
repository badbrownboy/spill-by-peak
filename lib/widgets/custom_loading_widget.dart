import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomLoadingWidget extends StatefulWidget {
  final String? text;
  final double size;
  final Color primaryColor;
  final Color secondaryColor;
  final bool hasError;
  final String? errorText;
  final VoidCallback? onRetry;

  const CustomLoadingWidget({
    super.key,
    this.text,
    this.size = 120.0,
    this.primaryColor = const Color(0xFF6366f1),
    this.secondaryColor = const Color(0xFF8b5cf6),
    this.hasError = false,
    this.errorText,
    this.onRetry,
  });

  @override
  State<CustomLoadingWidget> createState() => _CustomLoadingWidgetState();
}

class _CustomLoadingWidgetState extends State<CustomLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _flagController;
  late AnimationController _waveController;
  late AnimationController _pulseController;
  
  late Animation<double> _flagRotation;
  late Animation<double> _flagWave;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Flag spinning animation
    _flagController = AnimationController(
      duration: Duration(milliseconds: widget.hasError ? 0 : 2000),
      vsync: this,
    );
    
    if (!widget.hasError) {
      _flagController.repeat();
    }
    
    _flagRotation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _flagController,
      curve: Curves.linear,
    ));
    
    // Flag wave animation
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _flagWave = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));
    
    // Pulse animation for error state
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    if (widget.hasError) {
      _pulseController.repeat(reverse: true);
    }
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _flagController.dispose();
    _waveController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Flag Animation
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background glow effect
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.hasError 
                          ? Colors.red.withOpacity(0.3)
                          : Colors.green.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
              
              // Flag pole
              Container(
                width: 4,
                height: widget.size * 0.8,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Animated Flag
              widget.hasError
                  ? AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: CustomPaint(
                            size: Size(widget.size * 0.6, widget.size * 0.4),
                            painter: FlagPainter(
                              color: Colors.red,
                              waveValue: 0,
                            ),
                          ),
                        );
                      },
                    )
                  : AnimatedBuilder(
                      animation: Listenable.merge([_flagRotation, _flagWave]),
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _flagRotation.value,
                          child: CustomPaint(
                            size: Size(widget.size * 0.6, widget.size * 0.4),
                            painter: FlagPainter(
                              color: Colors.green,
                              waveValue: _flagWave.value,
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Status text
        if (widget.hasError) ...[
          Icon(
            Icons.wifi_off,
            color: Colors.red,
            size: 32,
          ),
          const SizedBox(height: 16),
          Text(
            widget.errorText ?? 'No Internet Connection',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your connection and try again',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.onRetry != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: widget.onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ] else ...[
          Icon(
            Icons.wifi,
            color: Colors.green,
            size: 32,
          ),
          const SizedBox(height: 16),
          Text(
            widget.text ?? 'Loading...',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Please wait while we load your content',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

// Flag painter for spinning flag animation
class FlagPainter extends CustomPainter {
  final Color color;
  final double waveValue;

  FlagPainter({
    required this.color,
    required this.waveValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Flag dimensions
    final flagWidth = size.width * 0.7;
    final flagHeight = size.height * 0.8;
    final startX = size.width * 0.1;
    final startY = size.height * 0.1;
    
    // Create waving flag shape
    path.moveTo(startX, startY);
    
    // Top edge with wave
    for (double i = 0; i <= flagWidth; i += 5) {
      final waveOffset = math.sin((i / flagWidth) * 2 * math.pi + waveValue * 2 * math.pi) * 3;
      path.lineTo(startX + i, startY + waveOffset);
    }
    
    // Right edge
    path.lineTo(startX + flagWidth, startY + flagHeight);
    
    // Bottom edge with wave
    for (double i = flagWidth; i >= 0; i -= 5) {
      final waveOffset = math.sin((i / flagWidth) * 2 * math.pi + waveValue * 2 * math.pi) * 3;
      path.lineTo(startX + i, startY + flagHeight + waveOffset);
    }
    
    // Left edge (attached to pole)
    path.lineTo(startX, startY);
    
    canvas.drawPath(path, paint);
    
    // Add shadow effect
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    final shadowPath = Path.from(path);
    shadowPath.transform(Matrix4.translationValues(2, 2, 0).storage);
    canvas.drawPath(shadowPath, shadowPaint);
    
    // Add highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(
      Rect.fromLTWH(startX, startY, flagWidth * 0.3, flagHeight * 0.2),
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom painter for wave effects
class WavePainter extends CustomPainter {
  final double animationValue;
  final Color color;

  WavePainter({
    required this.animationValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw multiple expanding circles for wave effect
    for (int i = 0; i < 3; i++) {
      final radius = (size.width / 2) * (animationValue + (i * 0.3)) % 1.0;
      final opacity = 1.0 - ((animationValue + (i * 0.3)) % 1.0);
      
      paint.color = color.withOpacity(opacity * 0.5);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Custom painter for splash effects
class SplashPainter extends CustomPainter {
  final double animationValue;
  final Color primaryColor;
  final Color secondaryColor;

  SplashPainter({
    required this.animationValue,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Create splash droplets around the circle
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi * 2 / 8) + (animationValue * math.pi * 2);
      final distance = radius * 0.8 * animationValue;
      final dropletSize = 6.0 * (1 - animationValue);
      
      if (dropletSize > 1.0) {
        final x = center.dx + math.cos(angle) * distance;
        final y = center.dy + math.sin(angle) * distance;
        
        final paint = Paint()
          ..color = primaryColor.withOpacity(1 - animationValue)
          ..style = PaintingStyle.fill;
        
        canvas.drawCircle(Offset(x, y), dropletSize, paint);
      }
    }
    
    // Create smaller splash particles
    for (int i = 0; i < 12; i++) {
      final angle = (i * math.pi * 2 / 12) + (animationValue * math.pi * 4);
      final distance = radius * 0.6 * animationValue;
      final particleSize = 3.0 * (1 - animationValue);
      
      if (particleSize > 0.5) {
        final x = center.dx + math.cos(angle) * distance;
        final y = center.dy + math.sin(angle) * distance;
        
        final paint = Paint()
          ..color = secondaryColor.withOpacity((1 - animationValue) * 0.7)
          ..style = PaintingStyle.fill;
        
        canvas.drawCircle(Offset(x, y), particleSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Custom painter for water droplet
class DropletPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  DropletPainter({
    required this.animationValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final path = Path();
    
    // Create water droplet shape that oscillates
    final oscillation = math.sin(animationValue * math.pi * 4) * 0.1;
    final dropletHeight = size.height * 0.6 * (1 + oscillation);
    final dropletWidth = size.width * 0.4 * (1 - oscillation * 0.5);
    
    // Top curve of droplet
    path.moveTo(center.dx, center.dy - dropletHeight / 2);
    
    // Right side
    path.quadraticBezierTo(
      center.dx + dropletWidth / 2,
      center.dy - dropletHeight / 4,
      center.dx + dropletWidth / 3,
      center.dy + dropletHeight / 4,
    );
    
    // Bottom point
    path.quadraticBezierTo(
      center.dx,
      center.dy + dropletHeight / 2,
      center.dx - dropletWidth / 3,
      center.dy + dropletHeight / 4,
    );
    
    // Left side
    path.quadraticBezierTo(
      center.dx - dropletWidth / 2,
      center.dy - dropletHeight / 4,
      center.dx,
      center.dy - dropletHeight / 2,
    );
    
    canvas.drawPath(path, paint);
    
    // Add highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(center.dx - dropletWidth * 0.1, center.dy - dropletHeight * 0.2),
      dropletWidth * 0.15,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Full screen loading overlay
class LoadingOverlay extends StatelessWidget {
  final String? text;
  final bool isVisible;

  const LoadingOverlay({
    super.key,
    this.text,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();
    
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: CustomLoadingWidget(
          text: text,
          size: 150,
        ),
      ),
    );
  }
}

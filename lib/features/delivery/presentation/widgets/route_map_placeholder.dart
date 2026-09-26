import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Dotted-grid map stand-in with a drawn route; replace with the live map SDK.
class RouteMapPlaceholder extends StatelessWidget {
  const RouteMapPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(child: CustomPaint(painter: _RoutePainter()));
  }
}

class _RoutePainter extends CustomPainter {
  const _RoutePainter();

  static const Size _design = Size(390, 470);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFECEAE7),
    );

    final dot = Paint()..color = const Color(0x121A1A1A);
    for (double x = 0; x < size.width; x += 22) {
      for (double y = 0; y < size.height; y += 22) {
        canvas.drawCircle(Offset(x, y), 1, dot);
      }
    }

    // The route was drawn on a 390x470 canvas and stretched to fit.
    canvas.scale(size.width / _design.width, size.height / _design.height);
    final route = Path()
      ..moveTo(70, 410)
      ..cubicTo(120, 380, 130, 330, 150, 270)
      ..cubicTo(168, 218, 240, 216, 272, 170)
      ..cubicTo(292, 140, 296, 116, 300, 96);

    Paint stroke(Color c, double w) => Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(
      route,
      stroke(AppColors.primary.withValues(alpha: 0.2), 14),
    );
    canvas.drawPath(route, stroke(AppColors.primary, 5));
    canvas.drawCircle(const Offset(70, 410), 9, Paint()..color = AppColors.ink);
    canvas.drawCircle(
      const Offset(300, 96),
      20,
      Paint()..color = AppColors.primary.withValues(alpha: 0.18),
    );
    canvas.drawCircle(
      const Offset(300, 96),
      11,
      Paint()..color = AppColors.primary,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

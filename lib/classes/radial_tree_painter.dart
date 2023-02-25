import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:radial_diagram/classes/radial_point.dart';
import 'package:radial_diagram/classes/radial_tree_calculator.dart';
import 'package:radial_diagram/classes/tree_node.dart';

class RadialTreePainter extends CustomPainter {
  final TreeNode rootNode;
  final double circleRadius;
  final double deltaDistance;
  final  double distanceMultiplier;

  RadialTreePainter({
    required this.rootNode,
    required this.circleRadius,
    required this.deltaDistance,
    required this.distanceMultiplier,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate positions of each node in radial layout
    List<RadialPoint> positions = [];
    RadialTreeCalculator.radialPositions(
      rootNode,
      0,
      2 * pi,
      circleRadius,
      deltaDistance,
      distanceMultiplier,
      positions,
    );

    // Calculate center of the canvas
    final center = Offset(size.width / 2, size.height / 2);

    // Draw connections between nodes
    Paint linePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    for (RadialPoint point in positions) {
      if (point.parentPoint != null) {
        final p2 = point.parentPoint != null
            ? Offset(point.parentPoint!.x, point.parentPoint!.y)
            : Offset(point.point.x, point.point.y);

        canvas.drawLine(
          Offset(point.point.x, point.point.y) + center,
          p2 + center,
          linePaint,
        );
      }
    }

    // Draw circles for nodes and text inside them
    Paint circlePaint = Paint()..color = Colors.blue;
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (RadialPoint point in positions) {
      canvas.drawCircle(
        Offset(point.point.x, point.point.y) + center,
        12,
        circlePaint,
      );

      String text = "${point.node?.data.toString()}";
      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 6,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
              point.point.x - (textPainter.width / 2),
              point.point.y - (textPainter.height / 2),
            ) +
            center,
      );
    }
  }

  @override
  bool shouldRepaint(RadialTreePainter oldDelegate) {
    return true;
  }
}

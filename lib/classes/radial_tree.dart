import 'dart:collection';
import 'dart:math';

import 'package:radial_diagram/classes/point.dart';
import 'package:radial_diagram/classes/radial_point.dart';
import 'package:radial_diagram/classes/tree_node.dart';

class RadialTreeCalculator {
  static void radialPositions<T>(
    TreeNode<T> node,
    double alfa,
    double beta,
    double circleRadius,
    double deltaDistance,
    double distanceMultiplier,
    List<RadialPoint<T>> outputGraph,
  ) {
    if (node.isRoot) {
      node.point = Point(x: 0, y: 0);
      outputGraph.add(
          RadialPoint(node: node, point: Point(x: 0, y: 0), parentPoint: null));
    }

    int depthOfVertex = node.level;
    double theta = alfa;
    double radius =
        circleRadius + (deltaDistance * depthOfVertex * distanceMultiplier);

    int leavesNumber = breadthFirstSearch(node);
    for (var child in node.children) {
      int lambda = breadthFirstSearch(child);
      double mi = theta + (lambda / leavesNumber * (beta - alfa));

      double x = radius * cos((theta + mi) / 2);
      double y = radius * sin((theta + mi) / 2);

      child.point = Point(x: x, y: y);
      outputGraph.add(
        RadialPoint(
          node: child,
          point: Point(x: x, y: y, radius: radius),
          parentPoint: node.point,
        ),
      );

      if (child.children.isNotEmpty) {
        child.point = Point(x: x, y: y);
        radialPositions(child, theta, mi, circleRadius, deltaDistance*distanceMultiplier,
            distanceMultiplier, outputGraph);
      }
      theta = mi;
    }
  }

  static int breadthFirstSearch<T>(TreeNode<T> root) {
    List<TreeNode<T>> visited = [];
    Queue<TreeNode<T>> queue = Queue();
    int leaves = 0;

    visited.add(root);
    queue.add(root);

    while (queue.isNotEmpty) {
      var current = queue.removeFirst();
      if (current.children.isEmpty) leaves++;
      for (var node in current.children) {
        if (!visited.contains(node)) {
          visited.add(node);
          queue.add(node);
        }
      }
    }
    return leaves;
  }
}

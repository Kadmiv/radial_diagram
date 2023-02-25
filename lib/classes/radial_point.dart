
import 'package:radial_diagram/classes/point.dart';
import 'package:radial_diagram/classes/tree_node.dart';

class RadialPoint<T> {
  TreeNode<T>? node;
  Point point;
  Point? parentPoint;

  RadialPoint(
      {required this.node, required this.point, required this.parentPoint});
}
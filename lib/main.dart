import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:radial_diagram/classes/radial_tree_painter.dart';
import 'package:radial_diagram/classes/tree_node.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Radial Tree Example', home: MyPage());
  }
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rootNode = generateTree(4, 8);

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: InteractiveViewer(
            boundaryMargin: EdgeInsets.all(20),
            minScale: 0.1,
            maxScale: 6.0,
            child: CustomPaint(
              painter: RadialTreePainter(
                rootNode: rootNode,
                circleRadius: 30,
                deltaDistance: 60,
                distanceMultiplier: 1.1,
              ),
              size: Size(1200, 1200),
            ),
          ),
        ),
      ),
    );
  }
}


TreeNode generateTree(int depth, int maxChildren) {
  final random = Random();
  final rootNode = TreeNode('A');

  void addChildren(TreeNode parent, int depth) {
    if (depth == 0) {
      return;
    }

    final numChildren = random.nextInt(maxChildren) + 1;
    for (int i = 0; i < numChildren; i++) {
      final childData = String.fromCharCode('B'.codeUnitAt(0) + i);
      final child = parent.addChild(childData);
      addChildren(child, depth - 1);
    }
  }

  addChildren(rootNode, depth);
  return rootNode;
}

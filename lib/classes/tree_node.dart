
import 'package:radial_diagram/classes/point.dart';

typedef TraversalDataDelegate = bool Function(dynamic data);

typedef TraversalNodeDelegate = bool Function(TreeNode<dynamic> node);


class TreeNode<T> {
  final T _data;
  final int _level;
  final List<TreeNode<T>> _children;
  TreeNode<T>? _parent;
  Point? _point;

  TreeNode(T data)
      : _data = data,
        _level = 0,
        _children = [];

  TreeNode.withParent(T data, TreeNode<T>? parent)
      : _data = data,
        _parent = parent,
        _level = parent != null ? parent._level + 1 : 0,
        _children = [];

  int get level => _level;

  int get count => _children.length;

  bool get isRoot => _parent == null;

  bool get isLeaf => _children.isEmpty;

  List<TreeNode<T>> get children => _children;

  T get data => _data;

  TreeNode<T>? get parent => _parent;

  set parent(TreeNode<T>? value) => _parent = value;

  Point? get point => _point;

  set point(Point? value) => _point = value;

  TreeNode<T>? findTreeNode(bool Function(TreeNode<T> node) predicate) {
    TreeNode<T>? node = _children.firstWhere(
          (element) => predicate(element),
      orElse: null,
    );

    if (node != null) return node;

    for (var checkNode in _children) {
      node = checkNode.findTreeNode(predicate);
      if (node != null) return node;
    }

    return null;
  }

  List<TreeNode<T>> findTreeNodes(bool Function(TreeNode<T> node) predicate) {
    var nodes = _children.where((element) => predicate(element)).toList();
    for (var checkNode in _children) {
      nodes.addAll(checkNode.findTreeNodes(predicate));
    }

    return nodes;
  }

  TreeNode<T>? findInChildren(T data) {
    for (var i = 0; i < _children.length; i++) {
      var child = _children[i];
      if (child.data == data) return child;
    }

    return null;
  }

  TreeNode<T> addChild(T value) {
    final node = TreeNode<T>.withParent(value, this);
    _children.add(node);

    return node;
  }

  bool removeChild(TreeNode<T> node) {
    return _children.remove(node);
  }

  void traverse(TraversalDataDelegate handler) {
    if (handler(_data)) {
      for (var i = 0; i < _children.length; i++) {
        _children[i].traverse(handler);
      }
    }
  }

  void traverseNode(TraversalNodeDelegate handler) {
    if (handler(this)) {
      for (var i = 0; i < _children.length; i++) {
        _children[i].traverseNode(handler);
      }
    }
  }

  bool hasChild(T data) {
    return findInChildren(data) != null;
  }

  TreeNode<T> operator [](int key) {
    return _children[key];
  }

  void clear() {
    _children.clear();
  }
}
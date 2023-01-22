import 'package:arbor/arbor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arbor/src/inherited_node_scope.dart';

/// A Callback that retrieves a [Lifecycle] object from the [BuildContext] using
/// the shortcut [NodeScope.of] method.
typedef CreateNestedScope<C extends Lifecycle> = ObjectFactory<C> Function(
  BuildContext context,
  P Function<P extends Lifecycle>() find,
);

/// A [StatefulWidget] that creates a [Lifecycle] object and propagates it down
/// the [Element] tree using an [InheritedWidget].
class NodeScope<N extends Lifecycle> extends StatefulWidget {
  final N Function(BuildContext context) create;
  final Widget child;

  /// Creates a [NodeScope] widget that creates a [Lifecycle] object and
  /// propagates it down the [Element] tree using an [InheritedWidget].
  const NodeScope({
    required this.create,
    required this.child,
    super.key,
  });

  /// Creates a [NodeScope] widget that creates a [Lifecycle] object and
  /// propagates it down the [Element] tree using an [InheritedWidget] and
  /// provides a shortcut method for retrieving a [Lifecycle] object from the
  /// [BuildContext] using the [NodeScope.of].
  factory NodeScope.child({
    required CreateNestedScope<N> create,
    required Widget child,
    Key? key,
  }) =>
      NodeScope(
        key: key,
        create: (context) => create(
          context,
          <P extends Lifecycle>() => of<P>(context, listen: true),
        )(),
        child: child,
      );

  /// Retrieves the [Lifecycle] object from the [BuildContext] using the
  /// [BuildContext.dependOnInheritedWidgetOfExactType] method.
  static N of<N extends Lifecycle>(
    BuildContext context, {
    bool listen = false,
  }) {
    final node = InheritedNodeScope.of<N>(context, listen: listen);
    assert(
      node != null,
      'Unable to find InheritedNodeScope<$N> in the element tree. '
      'It is likely that there is no NodeScope<$N> in the context.',
    );

    return node!;
  }

  @override
  State<NodeScope<N>> createState() => _NodeScopeState<N>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<N Function(BuildContext context)>(
          'create',
          create,
          description: 'A function that returns an '
              'ObjectFactory<$N> of the desired Node',
        ),
      )
      ..add(
        DiagnosticsProperty('child', child),
      );
  }
}

class _NodeScopeState<N extends Lifecycle> extends State<NodeScope<N>> {
  N? node;

  N get currentNode => node!;

  void tryDisposeNode() {
    node?.dispose();
  }

  void createNode() {
    node = widget.create(context)..init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tryDisposeNode();
    createNode();
  }

  @override
  void dispose() {
    tryDisposeNode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => InheritedNodeScope<N>(
        node: currentNode,
        child: widget.child,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty(
        'node',
        node,
        ifNull: 'not yet created',
      ),
    );
  }
}

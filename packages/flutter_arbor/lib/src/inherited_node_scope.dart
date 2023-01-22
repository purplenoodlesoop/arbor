import 'package:arbor/arbor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class InheritedNodeScope<C extends Lifecycle> extends InheritedWidget {
  final C node;

  const InheritedNodeScope({
    required this.node,
    required super.child,
    super.key,
  });

  static C? of<C extends Lifecycle>(
    BuildContext context, {
    required bool listen,
  }) =>
      (listen
              ? context
                  .dependOnInheritedWidgetOfExactType<InheritedNodeScope<C>>()
              : (context
                  .getElementForInheritedWidgetOfExactType<
                      InheritedNodeScope<C>>()
                  ?.widget as InheritedNodeScope<C>?))
          ?.node;

  @override
  bool updateShouldNotify(InheritedNodeScope oldWidget) =>
      node != oldWidget.node;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<C>(
        'node',
        node,
        description: 'A node that is being propagated down the Element tree',
      ),
    );
  }
}

import 'package:arbor/src/shared/interfaces.dart';
import 'package:meta/meta.dart';

/// ArborObserver is an abstract class that defines methods for observing events
/// related to disposable objects, lifecycle objects, and nodes.
abstract class ArborObserver {
  /// Called when a disposable object is disposed.
  @mustCallSuper
  void onDisposed<A extends Disposable>() {}

  /// Called when a lifecycle object is initialized.
  @mustCallSuper
  void onInit<A extends Lifecycle>() {}

  /// Called when an instance is created within a [Node].
  @mustCallSuper
  void onCreatedInstance<A extends Node<A>>(Object? object) {}

  /// Called when a shared instance is created within a [Node].
  @mustCallSuper
  void onCreatedShared<A extends Node<A>>(Object? object) {}

  /// Called when a child node is created within a [Node].
  @mustCallSuper
  void onCreatedChild<A extends Node<A>>(ChildNode node) {}

  /// Called when a module node is created within a [Node].
  @mustCallSuper
  void onCreatedModule<A extends Node<A>>(ModuleNode module) {}
}

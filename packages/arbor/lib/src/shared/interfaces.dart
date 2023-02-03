import 'package:arbor/src/shared/observer.dart';
import 'package:arbor/src/shared/typedef.dart';

/// Disposable is an abstract class that defines a `dispose` method.
abstract class Disposable {
  void dispose();
}

/// Lifecycle is an abstract class that implements the Disposable interface and
/// adds an `init` method.
abstract class Lifecycle implements Disposable {
  void init();
}

/// HasParent is a generic abstract class that defines a `parent` getter.
abstract class HasParent<P> {
  P get parent;
}

/// HasObserver is an abstract class that defines an optional `observer` getter.
abstract class HasObserver {
  ArborObserver? get observer;
}

/// ObjectFactories is a generic abstract class that defines methods for
/// creating instances, shared instances, child nodes,
/// and modules.
abstract class ObjectFactories<N extends Node<N>> {
  /// Creates a new instance using the provided factory function.
  ObjectFactory<T> instance<T>(
    ObjectFactory<T> create,
  );

  /// Creates a shared instance using the provided factory function.
  /// Optionally, a disposer function can be provided to dispose
  /// of the instance.
  T shared<T>(
    ObjectFactory<T> create, {
    Disposer<T>? dispose,
  });

  /// Creates a child node using the provided factory function.
  ///
  /// Child nodes are stateful and manage their own state.
  ObjectFactory<C> child<C extends ChildNode<C, N>>(
    DescendantNodeFactory<C, N> create,
  );

  /// Creates a module node using the provided factory function.
  ///
  /// Module nodes are stateless and rely on the nearest node's state.
  M module<M extends ModuleNode<M, N>>(
    DescendantNodeFactory<M, N> create,
  );
}

/// InstanceManager is an abstract class that defines a method for creating
/// a cached instance using a factory function. Optionally, a disposer function
/// can be provided to dispose of the instance.
abstract class InstanceManager {
  T createCaching<T>(
    InstanceManager source,
    ObjectFactory<T> create, {
    Disposer<T>? dispose,
  });
}

/// Node is a generic abstract class that implements the ObjectFactories,
/// Lifecycle, HasObserver, and InstanceManager interfaces.
abstract class Node<N extends Node<N>>
    implements ObjectFactories<N>, Lifecycle, HasObserver, InstanceManager {}

/// ParentedNode is a generic abstract class that implements
/// the Node and HasParent interface, without stating its strategy for managing
/// state.
abstract class ParentedNode<N extends ParentedNode<N, P>, P extends Node<P>>
    implements Node<N>, HasParent<P> {}

/// ChildNode is a generic abstract class that implements the ParentedNode and
/// manages its own state.
abstract class ChildNode<C extends ChildNode<C, P>, P extends Node<P>>
    implements ParentedNode<C, P> {}

/// ModuleNode is a generic abstract class that implements the ParentedNode
/// and relies on the nearest child/tree's state.
abstract class ModuleNode<M extends ModuleNode<M, P>, P extends Node<P>>
    implements ParentedNode<M, P> {}

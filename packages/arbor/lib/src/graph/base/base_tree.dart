import 'package:arbor/src/graph/base/base_observer_source.dart';
import 'package:arbor/src/graph/mixin/abstract_node_implementation_mixin.dart';
import 'package:arbor/src/graph/mixin/observer_lifecycle_mixin.dart';
import 'package:arbor/src/graph/mixin/stateful_instance_manager_mixin.dart';
import 'package:arbor/src/shared/interfaces.dart';
import 'package:arbor/src/shared/observer.dart';

/// Base implementation of a stateful root [Node] in a tree that provides the
/// [ArborObserver].
abstract class BaseTree<C extends Node<C>> = BaseObserverSource
    with
        ObserverLifecycleMixin<C>,
        StatefulInstanceManagerMixin,
        AbstractNodeImplementationMixin<C>
    implements Node<C>;

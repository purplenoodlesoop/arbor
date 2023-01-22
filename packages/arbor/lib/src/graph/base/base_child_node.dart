import 'package:arbor/src/graph/base/base_has_parent.dart';
import 'package:arbor/src/graph/mixin/abstract_node_implementation_mixin.dart';
import 'package:arbor/src/graph/mixin/observer_lifecycle_mixin.dart';
import 'package:arbor/src/graph/mixin/parent_observer_locator_mixin.dart';
import 'package:arbor/src/graph/mixin/stateful_instance_manager_mixin.dart';
import 'package:arbor/src/shared/interfaces.dart';

/// Base implementation of a [ModuleNode] that is a child of another [Node] and
/// is stateful.
abstract class BaseChildNode<C extends ChildNode<C, P>,
        P extends Node<P>> = BaseHasParent<P>
    with
        ParentObserverLocatorMixin<P>,
        ObserverLifecycleMixin<C>,
        StatefulInstanceManagerMixin,
        AbstractNodeImplementationMixin<C>
    implements ChildNode<C, P>;

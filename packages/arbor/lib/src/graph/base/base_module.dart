import 'package:arbor/src/graph/base/base_has_parent.dart';
import 'package:arbor/src/graph/mixin/abstract_node_implementation_mixin.dart';
import 'package:arbor/src/graph/mixin/observer_lifecycle_mixin.dart';
import 'package:arbor/src/graph/mixin/parent_delegating_instance_manager_mixin.dart';
import 'package:arbor/src/graph/mixin/parent_observer_locator_mixin.dart';
import 'package:arbor/src/shared/interfaces.dart';

/// Base implementation of a [ModuleNode] that is a child of another [Node] and
/// is stateless.
abstract class BaseModule<C extends ModuleNode<C, P>,
        P extends Node<P>> = BaseHasParent<P>
    with
        ParentObserverLocatorMixin<P>,
        ObserverLifecycleMixin<C>,
        ParentDelegatingInstanceManagerMixin<P>,
        AbstractNodeImplementationMixin<C>
    implements ModuleNode<C, P>;

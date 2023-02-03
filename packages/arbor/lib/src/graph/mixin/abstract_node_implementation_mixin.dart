import 'package:arbor/src/shared/interfaces.dart';
import 'package:arbor/src/shared/typedef.dart';
import 'package:meta/meta.dart';

mixin AbstractNodeImplementationMixin<N extends Node<N>>
    on HasObserver, InstanceManager
    implements ObjectFactories<N>, Lifecycle {
  @override
  @protected
  @nonVirtual
  ObjectFactory<T> instance<T>(ObjectFactory<T> create) => () {
        final object = create();
        observer?.onCreatedInstance<N>(object);

        return object;
      };

  @override
  @protected
  @nonVirtual
  ObjectFactory<T> child<T extends ChildNode<T, N>>(
    DescendantNodeFactory<T, N> create,
  ) =>
      () {
        final object = create(this as N);
        observer?.onCreatedChild<N>(object);
        return object;
      };

  @override
  @protected
  @nonVirtual
  T module<T extends ModuleNode<T, N>>(
    DescendantNodeFactory<T, N> create,
  ) =>
      createCaching<T>(
        this,
        () {
          final object = create(this as N);
          observer?.onCreatedModule<N>(object);
          object.init();

          return object;
        },
        dispose: (module) => module.dispose(),
      );

  @override
  @protected
  @nonVirtual
  T shared<T>(ObjectFactory<T> create, {Disposer<T>? dispose}) => createCaching(
        this,
        () {
          final instance = create();
          observer?.onCreatedShared<N>(instance);

          return instance;
        },
        dispose: dispose,
      );
}

import 'package:arbor/src/shared/interfaces.dart';
import 'package:arbor/src/shared/typedef.dart';
import 'package:meta/meta.dart';

mixin ParentDelegatingInstanceManagerMixin<P extends InstanceManager>
    on HasParent<P> implements InstanceManager {
  @override
  @nonVirtual
  @internal
  @protected
  T createCaching<T>(ObjectFactory<T> create, {Disposer<T>? dispose}) =>
      parent.createCaching(create, dispose: dispose);
}

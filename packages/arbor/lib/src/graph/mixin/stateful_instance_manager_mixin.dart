import 'package:arbor/src/shared/interfaces.dart';
import 'package:arbor/src/shared/typedef.dart';
import 'package:meta/meta.dart';

typedef _Disposer = void Function();

mixin StatefulInstanceManagerMixin on Disposable implements InstanceManager {
  late final Map<Type, Object?> _cache = {};
  late final List<_Disposer> _disposers = [];

  void _addDisposer(_Disposer disposer) {
    _disposers.add(disposer);
  }

  @override
  void dispose() {
    for (final disposer in _disposers) {
      disposer();
    }
    super.dispose();
  }

  @override
  @nonVirtual
  @internal
  @protected
  T createCaching<T>(
    ObjectFactory<T> create, {
    Disposer<T>? dispose,
  }) =>
      _cache.putIfAbsent(T, () {
        final instance = create();

        if (instance is Disposable) _addDisposer(instance.dispose);
        if (dispose != null) _addDisposer(() => dispose(instance));

        return instance;
      }) as T;
}

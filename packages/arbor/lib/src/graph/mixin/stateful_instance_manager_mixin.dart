import 'package:arbor/src/shared/interfaces.dart';
import 'package:arbor/src/shared/typedef.dart';
import 'package:meta/meta.dart';

typedef _Disposer = void Function();

@immutable
class _TypeSourceKey {
  final Type type;
  final Type sourceType;

  const _TypeSourceKey({
    required this.type,
    required this.sourceType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _TypeSourceKey &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          sourceType == other.sourceType;

  @override
  int get hashCode => Object.hash(type, sourceType);
}

mixin StatefulInstanceManagerMixin on Disposable implements InstanceManager {
  late final Map<_TypeSourceKey, Object?> _cache = {};
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
    InstanceManager source,
    ObjectFactory<T> create, {
    Disposer<T>? dispose,
  }) =>
      _cache.putIfAbsent(
          _TypeSourceKey(
            type: T,
            sourceType: source.runtimeType,
          ), () {
        final instance = create();

        if (instance is Disposable) _addDisposer(instance.dispose);
        if (dispose != null) _addDisposer(() => dispose(instance));

        return instance;
      }) as T;
}

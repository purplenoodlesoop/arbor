import 'package:arbor/src/shared/interfaces.dart';
import 'package:meta/meta.dart';

mixin ObserverLifecycleMixin<N extends Lifecycle> on HasObserver
    implements Lifecycle {
  @override
  @mustCallSuper
  @protected
  void init() {
    observer?.onInit<N>();
  }

  @override
  @mustCallSuper
  void dispose() {
    observer?.onDisposed<N>();
  }
}

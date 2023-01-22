import 'package:arbor/src/shared/interfaces.dart';
import 'package:arbor/src/shared/observer.dart';
import 'package:meta/meta.dart';

mixin ParentObserverLocatorMixin<P extends HasObserver> on HasParent<P>
    implements HasObserver {
  @override
  @internal
  @protected
  ArborObserver? get observer => parent.observer;
}

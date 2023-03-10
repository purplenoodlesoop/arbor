import 'package:arbor/src/shared/interfaces.dart';
import 'package:arbor/src/shared/observer.dart';
import 'package:meta/meta.dart';

abstract class BaseObserverSource implements HasObserver {
  @override
  @protected
  ArborObserver? get observer => null;

  BaseObserverSource();
}

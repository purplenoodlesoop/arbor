import 'package:arbor/src/shared/interfaces.dart';
import 'package:meta/meta.dart';

abstract class BaseHasParent<P> implements HasParent<P> {
  @override
  @internal
  @protected
  final P parent;

  BaseHasParent(this.parent);
}

import 'package:arbor/src/shared/interfaces.dart';
import 'package:meta/meta.dart';

abstract class BaseHasParent<P> implements HasParent<P> {
  @override
  @protected
  final P parent;

  BaseHasParent(this.parent);
}

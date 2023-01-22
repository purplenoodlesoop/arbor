import 'package:arbor/src/shared/interfaces.dart';

typedef ObjectFactory<T> = T Function();

typedef DescendantNodeFactory<N extends ParentedNode<N, P>, P extends Node<P>>
    = N Function(P parent);

typedef Disposer<T> = void Function(T instance);

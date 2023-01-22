// ignore_for_file: avoid_print
import 'package:arbor/arbor.dart';

abstract class ImportantStringDependency {
  String get veryImportantString;
}

abstract class AnotherImportantStringDependency {
  String get anotherImportantString;
}

abstract class StringConsumerDependencies
    implements ImportantStringDependency, AnotherImportantStringDependency {
  String get yetAnotherImportantString;
}

abstract class SharedParent<N extends SharedParent<N>>
    implements
        Node<N>,
        AnotherImportantStringDependency,
        ImportantStringDependency {}

mixin SharedParentMixin<C extends SharedParentMixin<C, P>,
    P extends SharedParent<P>> on HasParent<P> implements SharedParent<C> {
  @override
  String get veryImportantString => parent.veryImportantString;

  @override
  String get anotherImportantString => parent.anotherImportantString;
}

abstract class IDependencies {
  IExampleModule get exampleModule;
}

abstract class IExampleModule {
  ObjectFactory<IExampleChild> get exampleChild;
}

abstract class IExampleChild implements StringConsumerDependencies {}

class PrintObserver extends ArborObserver {
  @override
  void onInit<A extends Lifecycle>() {
    super.onInit();
    print('Init $A');
  }

  @override
  void onDisposed<A extends Disposable>() {
    super.onDisposed();
    print('Disposed $A');
  }
}

class AppDependencies extends BaseTree<AppDependencies>
    implements SharedParent<AppDependencies>, IDependencies {
  AppDependencies({super.observer});

  @override
  String get veryImportantString => shared(() => 'hello');

  @override
  String get anotherImportantString => exampleModule.anotherImportantString;

  @override
  ExampleChildModule<AppDependencies> get exampleModule => module(
        ExampleChildModule.new,
      );
}

class ExampleChildModule<P extends SharedParent<P>>
    extends BaseModule<ExampleChildModule<P>, P>
    with SharedParentMixin<ExampleChildModule<P>, P>
    implements IExampleModule {
  ExampleChildModule(super.parent);

  @override
  String get anotherImportantString => shared(() => 'world');

  @override
  ObjectFactory<IExampleChild> get exampleChild =>
      child<ExampleChild<ExampleChildModule<P>>>(
        ExampleChild.new,
      );
}

class ExampleChild<P extends SharedParent<P>>
    extends BaseChildNode<ExampleChild<P>, P>
    with SharedParentMixin<ExampleChild<P>, P>
    implements IExampleChild {
  ExampleChild(super.parent);

  @override
  String get yetAnotherImportantString => shared(() => '!');
}

class StringConsumer {
  final StringConsumerDependencies _dependencies;

  StringConsumer(this._dependencies);

  void printStrings() {
    print(
      '${_dependencies.veryImportantString} '
      '${_dependencies.anotherImportantString} '
      '${_dependencies.yetAnotherImportantString}',
    );
  }
}

void main() {
  final dependencies = AppDependencies(
    observer: PrintObserver(),
  );
  final child = dependencies.exampleModule.exampleChild();
  StringConsumer(child).printStrings();
}

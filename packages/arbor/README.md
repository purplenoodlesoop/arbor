# arbor

[![Pub](https://img.shields.io/pub/v/arbor.svg)](https://pub.dev/packages/arbor)
[![GitHub Stars](https://img.shields.io/github/stars/purplenoodlesoop/arbor.svg)](https://github.com/purplenoodlesoop/arbor)
[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg)](https://en.wikipedia.org/wiki/MIT_License)
[![Linter](https://img.shields.io/badge/style-custom-brightgreen)](https://github.com/purplenoodlesoop/arbor/blob/master/packages/arbor/analysis_options.yaml)

---

Modular and compile-time safe DI for Dart without fragility and magic.

For Flutter integration, see [flutter_arbor](https://pub.dev/packages/flutter_arbor).

## Index

- [Index](#index)
- [About](#about)
- [Motivation](#motivation)
- [Install](#install)
- [Usage](#usage)
  * [Starting point](#starting-point)
  * [Dependency nodes](#dependency-nodes)
    + [Module](#module)
    + [Child](#child)
    + [Lifecycle](#lifecycle)
    + [Dependency injection](#dependency-injection)
  * [Observer](#observer)
  * [Modularity](#modularity)
    + [Simpler](#simpler)
    + [More modular](#more-modular)

## About

`arbor` offers a dependency injection solution for Dart that is compile-time safe and does not rely on magic – no code generation, no runtime type checking, no singletons, and no dynamic mutable `Maps`. `arbor` abstracts out a tree-like structure of dependencies, which can be resolved at compile-time. This allows for a more flexible and modular approach to dependency injection.

`arbor` is partially inspired by [Needle](https://github.com/uber/needle) and common Dart approach for dependency storages.

## Motivation

Currently, there are two main approaches to dependency injection in Dart: constructor injection and singleton injection. Both approaches have their pros and cons. Constructor injection is a good fit for small projects, but it quickly becomes cumbersome to manage dependencies in larger projects. Singleton injection relieves the burden of managing dependencies, but it is not compile-time safe and relies on magic.

`arbor` is a middle ground between the two approaches. It is compile-time safe and does not rely on magic, but it is not as cumbersome as constructor injection to manually manage dependencies. `arbor` is also more flexible than singleton injection, as it allows for a more modular approach to dependency injection.

## Install

Add `arbor` to your `pubspec.yaml` file:

```yaml
dependencies:
  arbor: "current version"
```

Or do it via CLI.

For Flutter projects:

```bash
$ flutter pub add arbor
```

For Dart projects:

```bash
$ dart pub add arbor
```

## Usage

`arbor` can be accustomed to both small projects that require a simple dependency injection solution and large projects that require a more modular approach to dependency injection. The following examples will demonstrate how to use `arbor` in both scenarios.

### Starting point

Every `arbor` project requires a `Tree` to be created. A `Tree` is a tree-like structure of dependencies that can be resolved at compile-time. A `Tree` can be created by using the `BaseTree` class:

```dart
class Tree extends BaseTree<Tree> {
  Tree({super.observer});
}
```

Every other `Tree` class should extend the `BaseTree` class. The `Tree` class should also be passed as a type parameter to the `BaseTree` class. The `Tree` class should also have a named constructor that takes in an optional `ArborObserver` as a parameter. The `Tree` class should also have a named constructor that takes in an optional `ArborObserver` as a parameter. The `ArborObserver` is used to observe the state of the `Tree` and can be used for debugging purposes.

### Dependency nodes

The created `Tree` class is a shared starting point for every node of dependencies, which can be created by using either `module` or `child` methods that accept a factory of `ModuleNode` or `ChildNode` respectively.

Both dependency nodes can have their descendants and can create a shared object that is bound to a specific lifecycle point which differs between the two dependency nodes via the `shared` method and creates new instances of objects via the `instance` method.

Both node types have the same set of lifecycle methods that can be overridden to perform actions at specific lifecycle points and both have their parent, passed as a type parameter. 

#### Module

A module is a stateless node that acts as a namespace for dependencies and descendant dependency nodes.

Its lifecycle and any stateful operations, such as creating shared dependencies, are strictly bound and are delegated to the nearest stateful parent, which can be either a `ChildNode` or a `BaseTree`. 

Usually, a module is used to group dependencies that are related to a specific feature or a specific part of the application, or a module can represent a set of features as a whole. Modules are lightweight and are cached in memory for the duration of the application's lifecycle in the root `Tree` node, so they can be used as needed.

#### Child

On the other hand, the child is a stateful node that acts as a container for dependencies and descendant dependency nodes. The `child` method returns an `ObjectFactory<Child>`, which essentially is a thunk – `Child Function()`, which must be called to create a new instance of the `Child` class.

Child nodes are used to describe a node with some ephemeral state bound to it which must be recreated several times through the lifecycle of the application.

#### Lifecycle

All nodes implement a set of lifecycle methods that can be overridden to perform actions at specific lifecycle points. The lifecycle methods are `init` and `dispose`, which are represented by the `Lifecycle` interface.

Nodes are created lazily, which means that the `init` method is called only when the node is resolved for the first time. The `dispose` method can be called from the outside, either by hand or by integrations, such as `flutter_arbor`.

#### Dependency injection

To actually perform dependency injection, a dependency node implements consumers dependency interfaces, utilizing the dependency inversion.

```dart
// consumer.dart

abstract class ConsumerDependencies {
  StreamController<String> get messagesController;
}

class Consumer {
  final ConsumerDependencies _dependencies;

  Consumer(this._dependencies);
}
```

```dart
// di.dart

class SomeFeatureNode 
    extends BaseChildNode<SomeFeatureNode, SomeFeatureParent> 
    implements ConsumerDependencies {
  SomeFeatureNode(super.parent);

  @override
  StreamController<String> get messagesController => shared(
      StreamController.broadcast,
      dispose: (controller) => controller.close(),
    );
}
```

```dart
// main.dart

void main() {
  final appDependencies = AppDependencies();
  final node = appDependencies.features.feature();
  final consumer = Consumer(node);
}
```

Three things are happening here:
  1. The `Consumer` class depends on the `ConsumerDependencies` interface. It declares the dependencies it needs to function itself, utilizing the dependency inversion, and does not care about how the dependencies are resolved.
  2. The `SomeFeatureNode` class implements the `ConsumerDependencies` interface. It provides the dependencies that the `Consumer` class needs to function itself.
  3. The `Consumer` class is created by passing the `SomeFeatureNode` instance to its constructor. The `Consumer` class does not care about how the dependencies are resolved, it only cares that they are resolved, and depends only on the dependencies that it needs to function itself.

### Observer

The `Tree` class can be observed by passing an `ArborObserver` to its constructor. The `ArborObserver` is a base class that can be extended to override specific methods that are called in specific lifecycle points of the `Tree` and its nodes.

An example that logs the lifecycle of the `Tree` and its nodes:

```dart
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
```

To view the full list of methods that can be overridden, see the `ArborObserver` class.

### Modularity 

As discussed previously, `arbor` can be used in both small and large projects with consideration to tradeoffs between modularity and simplicity.

#### Simpler

A simple approach could look something like that - concrete parents and concrete children:


```dart

abstract class StringConsumerDependencies {
  String get veryImportantString;
  String get anotherImportantString;
  String get yetAnotherImportantString;
}

class AppDependencies extends BaseTree<AppDependencies> {
  String get veryImportantString => shared(() => 'hello');

  ExampleChildModule get exampleModule => module(ExampleChildModule.new);
}

class ExampleChildModule
    extends BaseChildNode<ExampleChildModule, AppDependencies> {
  ExampleChildModule(super.parent);

  String get anotherImportantString => shared(() => 'world');

  ObjectFactory<ExampleChildNode> get exampleChild => child(ExampleChildNode.new);
}

class ExampleChildNode
    extends BaseChildNode<ExampleChildNode, ExampleChildModule>
    implements StringConsumerDependencies {
  ExampleChildNode(super.parent);

  @override
  String get veryImportantString => parent.parent.veryImportantString;

  @override
  String get anotherImportantString => parent.anotherImportantString;

  @override
  String get yetAnotherImportantString => shared(() => '!');
}
```

This approach is pretty straightforward – each node declares its parent as a Type parameter, and each node has access to the whole tree since parents are concrete classes that are connected.

It relieves the developer from having to think about the structure of the tree, since the tree is a concrete class that is connected, and the developer can just focus on the dependencies themselves. The most common use case for this approach is a small project with a small number of dependencies.

#### More modular

One could spot that this approach has some drawbacks. The most obvious one is that the `ExampleChildModule` has access to the whole tree, which is not always desirable and breaks a few rules of "good code". Secondly, the children are hard-attached to their position in the tree, which makes it hard to reuse them in different parts of the tree. A more modular approach could look something like that - abstract parents and interfaces for children.

Firstly, to abstract the parents, an interface for said parents should be created. The interfaces will implement a set of common dependencies that are shared across all children:

```dart
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
```

The `SharedParent` interface is a common interface for all parents, and it implements the `Node` interface that makes it eligible as a parent for a child node. 

After that, the children that previously declared their concrete parents as Type parameters, now declare their parents as vague implementers of the `SharedParent` interface:

```dart
class AppDependencies extends BaseTree<AppDependencies>
    implements SharedParent<AppDependencies> {
  @override
  String get veryImportantString => shared(() => 'hello');

  @override
  String get anotherImportantString => exampleModule.anotherImportantString;

  ExampleChildModule<AppDependencies> get exampleModule => module(
        ExampleChildModule.new,
      );
}

class ExampleChildModule<P extends SharedParent<P>>
    extends BaseModule<ExampleChildModule<P>, P>
    implements SharedParent<ExampleChildModule<P>> {
  ExampleChildModule(super.parent);

  @override
  String get veryImportantString => parent.veryImportantString;

  @override
  String get anotherImportantString => shared(() => 'world');

  ObjectFactory<ExampleChildNode<ExampleChildModule<P>>>
      get exampleModule => child(ExampleChildNode.new);
}

class ExampleChildNode<P extends SharedParent<P>>
    extends BaseChildNode<ExampleChildNode<P>, P>
    implements
        SharedParent<ExampleChildNode<P>>,
        StringConsumerDependencies {
  ExampleChildNode(super.parent);

  @override
  String get veryImportantString => parent.veryImportantString;

  @override
  String get anotherImportantString => parent.anotherImportantString;

  @override
  String get yetAnotherImportantString => shared(() => '!');
}
```

The naïve usage of SharedParent has resolved the main issues, now the children are not hard-attached to their position in the tree, and they have access only to the dependencies that they need. It may take some squinting to fight through type parameters, as this approach uses recursive generics.

But two new problems have emerged. Firstly, the code is not DRY anymore, since the `SharedParent` interface is implemented by both the `AppDependencies` and the `ExampleChildModule` classes, and secondly, new type parameter info leaked even more implementation details. 

To solve the first problem, a mixin can be created that will retrieve the dependencies from the parent, and implement the `SharedParent` interface:

```dart
mixin SharedParentMixin<C extends SharedParentMixin<C, P>,
    P extends SharedParent<P>> on HasParent<P> implements SharedParent<C> {
  @override
  String get veryImportantString => parent.veryImportantString;

  @override
  String get anotherImportantString => parent.anotherImportantString;
}

class AppDependencies extends BaseTree<AppDependencies>
    implements SharedParent<AppDependencies> {
  @override
  String get veryImportantString => shared(() => 'hello');

  @override
  String get anotherImportantString => exampleModule.anotherImportantString;

  ExampleChildModule<AppDependencies> get exampleModule => module(
        ExampleChildModule.new,
      );
}

class ExampleChildModule<P extends SharedParent<P>>
    extends BaseModule<ExampleChildModule<P>, P>
    with SharedParentMixin<ExampleChildModule<P>, P> {
  ExampleChildModule(super.parent);

  @override
  String get anotherImportantString => shared(() => 'world');

  ObjectFactory<ExampleChildNode<ExampleChildModule<P>>>
      get exampleChild => child(ExampleChildNode.new);
}

class ExampleChildNode<P extends SharedParent<P>>
    extends BaseChildNode<ExampleChildNode<P>, P>
    with SharedParentMixin<ExampleChildNode<P>, P>
    implements StringConsumerDependencies {
  ExampleChildNode(super.parent);

  @override
  String get yetAnotherImportantString => shared(() => '!');
}
```

The mixin works as intended, retrieving the dependencies from the parent for us and implementing the `SharedParent` interface.

The second problem can also be easily solved by using good old interfaces that will describe the tree of dependencies:

```dart
abstract class IDependencies {
  IExampleModule get exampleModule;
}

abstract class IExampleModule {
  ObjectFactory<IExampleChild> get exampleChild;
}

abstract class IExampleChild implements StringConsumerDependencies {}

class AppDependencies extends BaseTree<AppDependencies>
    implements SharedParent<AppDependencies>, IDependencies {
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
      child<ExampleChildNode<ExampleChildModule<P>>>(
        ExampleChildNode.new,
      );
}

class ExampleChildNode<P extends SharedParent<P>>
    extends BaseChildNode<ExampleChildNode<P>, P>
    with SharedParentMixin<ExampleChildNode<P>, P>
    implements IExampleChild {
  ExampleChildNode(super.parent);

  @override
  String get yetAnotherImportantString => shared(() => '!');
}
```

For a complete example, see the [example project](LINK)
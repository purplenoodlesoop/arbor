# flutter_arbor

[![Pub](https://img.shields.io/pub/v/flutter_arbor.svg)](https://pub.dev/packages/flutter_arbor)
[![GitHub Stars](https://img.shields.io/github/stars/purplenoodlesoop/flutter_arbor.svg)](https://github.com/purplenoodlesoop/arbor)
[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg)](https://en.wikipedia.org/wiki/MIT_License)
[![Linter](https://img.shields.io/badge/style-custom-brightgreen)](https://github.com/purplenoodlesoop/arbor/blob/master/packages/flutter_arbor/analysis_options.yaml)

---

Flutter integration for [arbor](https://pub.dev/packages/arbor) – a modular and compile-time safe DI for Flutter without fragility and magic.

## Index

- [Index](#index)
- [About](#about)
- [Motivation](#motivation)
- [Install](#install)
- [Usage](#usage)
  * [Root node](#root-node)
  * [Child node](#child-node)

## About

Read more about [arbor](https://pub.dev/packages/arbor) before using this package. This package is a Flutter integration for [arbor](https://pub.dev/packages/arbor) and should be used in pair.

`flutter_arbor` provides a widget that effectively propagates dependency nodes using `InheritedWidget`s to the `Element` tree.

## Motivation

As [arbor](https://pub.dev/packages/arbor) is a pure Dart package, it can be used in any Dart project. 

However, it is not a Flutter package and does not provide any Flutter-specific features – this is where `flutter_arbor` comes in, providing a way to effectively propagate dependency nodes using `InheritedWidget`s to the `Element` tree, integrating the package with Flutter.

## Install

Add `flutter_arbor` to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_arbor: "current version"
```

Or do it via CLI:

```bash
$ flutter pub add flutter_arbor
```

## Usage

`flutter_arbor` can be used in two ways: to provide an initial root `Tree` instance or to provide a `Tree` instance for a stateful subtree, that is, a `ChildNode` created through a `child` method.

An example dependencies structure can be described as follows:

```dart
class AppDependencies extends BaseTree<AppDependencies> {
  ObjectFactory<ExampleChild> get exampleChild => child(ExampleChild.new);
}

class ExampleChild extends BaseChildNode<ExampleChild, AppDependencies> {
  ExampleChild(super.parent);
}
```

This structure consists of two nodes: `AppDependencies` and `ExampleChild`. `AppDependencies` is a root node, and `ExampleChild` is a child node of `AppDependencies`.

### Root node

To provide a root `Tree` instance, a default unnamed constructor of `NodeScope` should be used:

```dart
NodeScope<AppDependencies>(
  create: (context) => AppDependencies(),
  child: child,
);
```

Placing this widget in the `Widget`s structure will effectively propagate `AppDependencies` to all the `Element`s below it, which can be accessed through `NodeScope.of<N>(context, listen: listen)`.

### Child node

To provide a `Tree` instance for a stateful subtree, a named constructor `child` of `NodeScope` should be used:

```dart
NodeScope.child(
  create: (context, find) => find<AppDependencies>().exampleChild,
  child: child,
);
```

The named constructor offers a shortcut to finding a parent node and creating a child node from it and lifts the return type of `create` to a thunk - `ObjectFactory<N>`/`N Function()`.
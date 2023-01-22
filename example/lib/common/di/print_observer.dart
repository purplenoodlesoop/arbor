// ignore_for_file: avoid_print

import 'package:arbor/arbor.dart';

class PrintObserver implements ArborObserver {
  @override
  void onCreatedChild<A extends Node<A>>(ChildNode node) {
    print('$A created child: ${node.runtimeType}');
  }

  @override
  void onCreatedInstance<A extends Node<A>>(Object? object) {
    print('$A created instance: ${object.runtimeType}');
  }

  @override
  void onCreatedModule<A extends Node<A>>(ModuleNode module) {
    print('$A created module: ${module.runtimeType}');
  }

  @override
  void onCreatedShared<A extends Node<A>>(Object? object) {
    print('$A created shared: ${object.runtimeType}');
  }

  @override
  void onDisposed<A extends Disposable>() {
    print('$A disposed');
  }

  @override
  void onInit<A extends Lifecycle>() {
    print('$A initialized');
  }
}

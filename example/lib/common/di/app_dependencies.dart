import 'dart:async';

import 'package:arbor/arbor.dart';
import 'package:example/common/di/shared_parent.dart';
import 'package:example/common/repository/user_repository.dart';
import 'package:example/common/service/logger_service.dart';
import 'package:example/feature/user/shared/di/user_feature.dart';

abstract class SharedServices implements LoggerDependency {}

abstract class SharedDependencies {
  SharedServices get services;
}

abstract class FeatureDependencies {
  ObjectFactory<UserFeature> get user;
}

abstract class AppDependencies implements Lifecycle {
  SharedDependencies get sharedDependencies;
  FeatureDependencies get feature;
}

class SharedRepositoryModule<P extends SharedParent<P>>
    extends SharedBaseModule<SharedRepositoryModule<P>, P>
    implements UserRepositoryDependencies {
  SharedRepositoryModule(super.parent);

  @override
  IUserRepository get userRepository => shared(() => UserRepository(this));

  @override
  StreamController<User> get userStreamController => shared(
        () => StreamController.broadcast(),
        dispose: (controller) => controller.close(),
      );
}

import 'dart:async';

import 'package:example/common/service/logger_service.dart';
import 'package:example/common/service/mock_user_data_service.dart';

class User {
  final String name;

  User(this.name);
}

abstract class IUserRepository {
  Future<User> fetchUser();

  Stream<User> userUpdates();
}

mixin UserRepositoryDependency {
  IUserRepository get userRepository;
}

mixin CustomUserRepositoryDependencies {
  StreamController<User> get userStreamController;
}

abstract class UserRepositoryDependencies = Object
    with
        CustomUserRepositoryDependencies,
        LoggerDependency,
        MockUserDataServiceDependency;

class UserRepository implements IUserRepository {
  final UserRepositoryDependencies _dependencies;

  UserRepository(this._dependencies);

  User? _lastUser;

  @override
  Future<User> fetchUser() async {
    _dependencies.loggerService.log('Fetching user');
    await Future<void>.delayed(const Duration(seconds: 1));
    final user = User(_dependencies.mockUserDataService.name);
    _lastUser = user;
    _dependencies.userStreamController.add(user);
    return user;
  }

  @override
  Stream<User> userUpdates() async* {
    _dependencies.loggerService.log('Returning current user updates');
    yield (_lastUser ?? await fetchUser());
    yield* _dependencies.userStreamController.stream;
  }
}

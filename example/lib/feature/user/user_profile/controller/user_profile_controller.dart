import 'dart:async';

import 'package:example/common/repository/user_repository.dart';
import 'package:example/common/service/logger_service.dart';
import 'package:example/feature/user/user_profile/repository/user_profile_repository.dart';
import 'package:flutter/foundation.dart';

abstract class IUserProfileController implements Listenable {
  String? get name;
  bool get isLoading;
  Future<void> setName(String name);
  Future<void> dispose();
}

abstract class UserProfileControllerDependencies = Object
    with
        LoggerDependency,
        UserRepositoryDependency,
        UserProfileRepositoryDependency;

class UserProfileController extends ChangeNotifier
    implements IUserProfileController {
  final UserProfileControllerDependencies _dependencies;
  late final StreamSubscription<void> _userSubscription;

  UserProfileController(this._dependencies) {
    _userSubscription = _dependencies.userRepository
        .userUpdates()
        .map((user) => user.name)
        .distinct()
        .listen(_consumeName);
  }

  bool _isLoading = false;
  String? _name;

  void _consumeName(String name) {
    _name = name;
  }

  void _setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  @override
  Future<void> setName(String name) async {
    _dependencies.loggerService.log('Setting name to $name');
    _setIsLoading(true);
    await _dependencies.userProfileRepository.setName(name);
    await _dependencies.userRepository.fetchUser();
    _setIsLoading(false);
  }

  @override
  Future<void> dispose() async {
    await _userSubscription.cancel();
    _dependencies.loggerService.log('Disposed');
    super.dispose();
  }

  @override
  String? get name => _name;

  @override
  bool get isLoading => _isLoading;
}

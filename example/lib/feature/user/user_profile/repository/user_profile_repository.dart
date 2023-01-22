import 'package:example/common/service/mock_user_data_service.dart';

abstract class IUserProfileRepository {
  Future<void> setName(String name);
}

abstract class UserProfileRepositoryDependency {
  IUserProfileRepository get userProfileRepository;
}

abstract class UserProfileRepositoryDependencies = Object
    with MockUserDataServiceDependency;

class UserProfileRepository implements IUserProfileRepository {
  final UserProfileRepositoryDependencies _dependencies;

  UserProfileRepository(this._dependencies);

  @override
  Future<void> setName(String name) async {
    _dependencies.mockUserDataService.name = name;
  }
}

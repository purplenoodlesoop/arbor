import 'package:example/common/di/shared_parent.dart';
import 'package:example/feature/user/user_profile/controller/user_profile_controller.dart';
import 'package:example/feature/user/user_profile/repository/user_profile_repository.dart';

abstract class UserProfileFeature implements UserProfileControllerDependencies {
}

class UserProfileFeatureModule<P extends SharedParent<P>>
    extends SharedBaseModule<UserProfileFeatureModule<P>, P>
    implements UserProfileFeature, UserProfileRepositoryDependencies {
  UserProfileFeatureModule(super.parent);

  @override
  IUserProfileRepository get userProfileRepository =>
      shared(() => UserProfileRepository(this));
}

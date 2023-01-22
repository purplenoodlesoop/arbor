import 'package:example/common/di/shared_parent.dart';
import 'package:example/feature/user/user_profile/di/user_profile_feature.dart';

abstract class UserFeature {
  UserProfileFeature get profile;
}

class UserFeatureNode<P extends SharedParent<P>>
    extends SharedBaseChildNode<UserFeatureNode<P>, P> implements UserFeature {
  UserFeatureNode(super.parent);

  @override
  UserProfileFeature get profile =>
      module<UserProfileFeatureModule<UserFeatureNode<P>>>(
        UserProfileFeatureModule.new,
      );
}

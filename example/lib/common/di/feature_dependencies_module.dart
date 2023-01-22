import 'package:arbor/arbor.dart';
import 'package:example/common/di/app_dependencies.dart';
import 'package:example/common/di/shared_parent.dart';
import 'package:example/feature/user/shared/di/user_feature.dart';

class FeatureDependenciesModule<P extends SharedParent<P>>
    extends SharedBaseModule<FeatureDependenciesModule<P>, P>
    implements FeatureDependencies {
  FeatureDependenciesModule(super.parent);

  @override
  ObjectFactory<UserFeature> get user =>
      child<UserFeatureNode<FeatureDependenciesModule<P>>>(UserFeatureNode.new);
}

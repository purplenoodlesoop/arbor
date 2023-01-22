import 'package:arbor/arbor.dart';
import 'package:example/common/di/app_dependencies.dart';
import 'package:example/common/di/feature_dependencies_module.dart';
import 'package:example/common/di/shared_dependencies_module.dart';
import 'package:example/common/di/shared_parent.dart';
import 'package:example/common/repository/user_repository.dart';
import 'package:example/common/service/logger_service.dart';
import 'package:example/common/service/mock_user_data_service.dart';

class AppDependenciesTree extends BaseTree<AppDependenciesTree>
    implements AppDependencies, SharedParent<AppDependenciesTree> {
  AppDependenciesTree({super.observer});

  @override
  FeatureDependencies get feature =>
      module<FeatureDependenciesModule<AppDependenciesTree>>(
          FeatureDependenciesModule.new);

  @override
  SharedDependenciesModule<AppDependenciesTree> get sharedDependencies =>
      module(SharedDependenciesModule.new);

  @override
  ILoggerService get loggerService => sharedDependencies.loggerService;

  @override
  IMockUserDataService get mockUserDataService =>
      sharedDependencies.mockUserDataService;

  @override
  IUserRepository get userRepository => sharedDependencies.userRepository;
}

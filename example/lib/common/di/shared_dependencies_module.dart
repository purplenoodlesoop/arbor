import 'package:arbor/arbor.dart';
import 'package:example/common/di/app_dependencies.dart';
import 'package:example/common/di/shared_parent.dart';
import 'package:example/common/di/shared_services_module.dart';
import 'package:example/common/repository/user_repository.dart';
import 'package:example/common/service/logger_service.dart';
import 'package:example/common/service/mock_user_data_service.dart';

class SharedDependenciesModule<P extends Node<P>>
    extends BaseModule<SharedDependenciesModule<P>, P>
    implements SharedDependencies, SharedParent<SharedDependenciesModule<P>> {
  SharedDependenciesModule(super.parent);

  @override
  SharedServicesModule<SharedDependenciesModule<P>> get services =>
      module(SharedServicesModule.new);

  SharedRepositoryModule<SharedDependenciesModule<P>> get repository =>
      module(SharedRepositoryModule.new);

  @override
  ILoggerService get loggerService => services.loggerService;

  @override
  IMockUserDataService get mockUserDataService => services.mockUserDataService;

  @override
  IUserRepository get userRepository => repository.userRepository;
}

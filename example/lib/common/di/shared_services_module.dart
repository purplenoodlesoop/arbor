import 'package:arbor/arbor.dart';
import 'package:example/common/di/app_dependencies.dart';
import 'package:example/common/service/logger_service.dart';
import 'package:example/common/service/mock_user_data_service.dart';

class SharedServicesModule<P extends Node<P>>
    extends BaseModule<SharedServicesModule<P>, P>
    implements SharedServices, MockUserDataServiceDependencies {
  SharedServicesModule(super.parent);

  @override
  ILoggerService get loggerService => shared(PrintLoggerService.new);

  IMockUserDataService get mockUserDataService =>
      shared(() => MockUserDataService(this));
}

import 'package:example/common/service/logger_service.dart';

abstract class IMockUserDataService {
  abstract String name;
}

mixin MockUserDataServiceDependency {
  IMockUserDataService get mockUserDataService;
}

abstract class MockUserDataServiceDependencies = Object with LoggerDependency;

class MockUserDataService implements IMockUserDataService {
  final MockUserDataServiceDependencies _dependencies;

  MockUserDataService(this._dependencies);

  String _name = '';

  @override
  String get name {
    _dependencies.loggerService.log('Reading name – $_name');

    return _name;
  }

  @override
  set name(String name) {
    _dependencies.loggerService.log('Setting name to $name');
    _name = name;
  }
}

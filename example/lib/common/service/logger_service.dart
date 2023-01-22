abstract class ILoggerService {
  void log(Object? data);
}

mixin LoggerDependency {
  ILoggerService get loggerService;
}

class PrintLoggerService implements ILoggerService {
  @override
  void log(Object? data) {
    // ignore: avoid_print
    print(data);
  }
}

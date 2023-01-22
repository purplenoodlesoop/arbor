import 'package:arbor/arbor.dart';
import 'package:example/common/repository/user_repository.dart';
import 'package:example/common/service/logger_service.dart';
import 'package:example/common/service/mock_user_data_service.dart';

abstract class SharedParent<P extends SharedParent<P>>
    implements
        Node<P>,
        MockUserDataServiceDependency,
        LoggerDependency,
        UserRepositoryDependency {}

mixin BaseParentedNodeMixin<C extends BaseParentedNodeMixin<C, P>,
    P extends SharedParent<P>> on HasParent<P> implements SharedParent<C> {
  @override
  IMockUserDataService get mockUserDataService => parent.mockUserDataService;

  @override
  ILoggerService get loggerService => parent.loggerService;

  @override
  IUserRepository get userRepository => parent.userRepository;
}

abstract class SharedBaseChildNode<C extends SharedBaseChildNode<C, P>,
        P extends SharedParent<P>> = BaseChildNode<C, P>
    with BaseParentedNodeMixin<C, P>;

abstract class SharedBaseModule<C extends SharedBaseModule<C, P>,
        P extends SharedParent<P>> = BaseModule<C, P>
    with BaseParentedNodeMixin<C, P>;

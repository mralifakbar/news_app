import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationSubscriptionRequested>(_onSubcriptionRequested);
    on<AuthenticationLogoutPressed>(_onLogoutPressed);
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  Future<void> _onSubcriptionRequested(
    AuthenticationSubscriptionRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    return emit.onEach(_authenticationRepository.status,
        onData: (status) async {
      switch (status) {
        case AuthenticationStatus.authenticated:
          final user = await _tryGetUser();
          return emit(user != null
              ? AuthenticationState.authenticated(user)
              : const AuthenticationState.unauthenticated());
        case AuthenticationStatus.unauthenticated:
          emit(const AuthenticationState.unauthenticated());
        case AuthenticationStatus.unknown:
          return emit(const AuthenticationState.unknown());
      }
    }, onError: addError);
  }

  void _onLogoutPressed(
    AuthenticationLogoutPressed event,
    Emitter<AuthenticationState> emit,
  ) {
    _authenticationRepository.logOut();
  }

  Future<User?> _tryGetUser() async {
    try {
      return await _userRepository.getUser();
    } catch (_) {
      return null;
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bhoomi_sakti/features/auth/domain/usecases/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUsecase _loginUsecase;

  LoginBloc({
    required LoginUsecase loginUsecase,
  })  : _loginUsecase = loginUsecase,
        super(const LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<ResendLoginOtp>(_onResendLoginOtp);
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());
    final result = await _loginUsecase(
      LoginParams(mobileNumber: event.mobileNumber),
    );
    result.fold(
      (failure) => emit(LoginFailure(failure: failure)),
      (_) => emit(const LoginOtpSentSuccess()),
    );
  }

  Future<void> _onResendLoginOtp(
    ResendLoginOtp event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());
    final result = await _loginUsecase(
      LoginParams(mobileNumber: event.mobileNumber),
    );
    result.fold(
      (failure) => emit(LoginFailure(failure: failure)),
      (_) => emit(const LoginOtpSentSuccess()),
    );
  }
}

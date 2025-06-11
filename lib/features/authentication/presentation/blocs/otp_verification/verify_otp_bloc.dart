import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bhoomi_sakti/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:bhoomi_sakti/features/auth/presentation/blocs/auth_notifier/auth_notifier.dart';
import 'verify_otp_event.dart';
import 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final VerifyOtpUsecase _verifyOtpUsecase;
  final AuthNotifier _authNotifier; // To update global auth state

  VerifyOtpBloc({
    required VerifyOtpUsecase verifyOtpUsecase,
    required AuthNotifier authNotifier,
  })  : _verifyOtpUsecase = verifyOtpUsecase,
        _authNotifier = authNotifier,
        super(const VerifyOtpInitial()) {
    on<VerifyOtpButtonPressed>(_onVerifyOtpButtonPressed);
  }

  Future<void> _onVerifyOtpButtonPressed(
    VerifyOtpButtonPressed event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(const VerifyOtpLoading());
    final result = await _verifyOtpUsecase.call(
      VerifyOtpParams(mobileNumber: event.mobileNumber, otp: event.otp),
    );
    result.fold(
      (failure) => emit(VerifyOtpFailure(failure: failure)),
      (authSuccess) {
        // Notify AuthNotifier about successful login and token/user data
        // Assuming AuthNotifier has a method like loggedIn(user, tokens)
        // This part depends on AuthNotifier's specific API
        _authNotifier.processAuthSuccess(authSuccess.user, authSuccess.tokens);
        emit(VerifyOtpSuccess(authSuccessEntity: authSuccess));
      },
    );
  }
}

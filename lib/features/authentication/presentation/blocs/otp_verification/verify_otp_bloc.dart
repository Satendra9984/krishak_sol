import 'package:bhoomi_sakti/features/authentication/domain/usecases/resend_otp_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bhoomi_sakti/features/authentication/domain/usecases/verify_otp_usecase.dart';
// import 'package:bhoomi_sakti/common/providers/auth_notifier/auth_notifier.dart';
import 'verify_otp_event.dart';
import 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final VerifyOtpUsecase _verifyOtpUsecase;
  final ResendOtpUsecase _resendOtpUsecase;
  // final AuthNotifier _authNotifier; // To update global auth state

  VerifyOtpBloc({
    required VerifyOtpUsecase verifyOtpUsecase,
    required ResendOtpUsecase resendOtpUsecase,
    // required AuthNotifier authNotifier,
  }) : _verifyOtpUsecase = verifyOtpUsecase,
       _resendOtpUsecase = resendOtpUsecase,
       //  _authNotifier = authNotifier,
       super(const VerifyOtpInitial()) {
    on<VerifyOtpButtonPressed>(_onVerifyOtpButtonPressed);
    on<ResendOtpButtonPressed>(_onResendOtpButtonPressed);
  }

  Future<void> _onVerifyOtpButtonPressed(
    VerifyOtpButtonPressed event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(const VerifyOtpLoading());
    final result = await _verifyOtpUsecase.call(
      VerifyOtpParams(mobileNumber: event.mobileNumber, otp: event.otp),
    );
    result.fold((failure) => emit(VerifyOtpFailure(failure: failure)), (
      authSuccessEntity,
    ) {
      emit(VerifyOtpSuccess(authSuccessEntity: authSuccessEntity));
    });
  }

  Future<void> _onResendOtpButtonPressed(
    ResendOtpButtonPressed event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(const VerifyOtpResendLoading());
    final result = await _resendOtpUsecase.call(event.mobileNumber);
    result.fold((failure) => emit(VerifyOtpResendFailure(failure: failure)), (
      _,
    ) {
      emit(VerifyOtpResendSuccess());
    });
  }
}

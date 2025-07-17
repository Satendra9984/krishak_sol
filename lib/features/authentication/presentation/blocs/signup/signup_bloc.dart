import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bhoomi_sakti/features/authentication/domain/usecases/signup_usecase.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUsecase _signupUsecase;

  SignupBloc({required SignupUsecase signupUsecase})
    : _signupUsecase = signupUsecase,
      super(const SignupInitial()) {
    on<SignupButtonPressed>(_onSignupButtonPressed);
    on<ResendSignupOtp>(_onResendSignupOtp);
  }

  Future<void> _onSignupButtonPressed(
    SignupButtonPressed event,
    Emitter<SignupState> emit,
  ) async {
    emit(const SignupLoading());
    final result = await _signupUsecase.call(
      SignupParams(name: event.name, mobileNumber: event.mobileNumber),
    );
    result.fold((failure) => emit(SignupFailure(failure: failure)), (_) {
      emit(const SignupOtpSentSuccess());
    });
  }

  Future<void> _onResendSignupOtp(
    ResendSignupOtp event,
    Emitter<SignupState> emit,
  ) async {
    emit(const SignupLoading());
    final result = await _signupUsecase(
      // Passing empty string for name as ResendSignupOtp doesn't carry it.
      // This might need adjustment based on backend requirements for resend.
      SignupParams(name: "", mobileNumber: event.mobileNumber),
    );
    result.fold(
      (failure) => emit(SignupFailure(failure: failure)),
      (_) => emit(const SignupOtpSentSuccess()),
    );
  }
}

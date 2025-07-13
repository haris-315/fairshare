import 'package:fairshare/features/auth/domain/entities/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_up.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn signIn;
  final SignUp signUp;

  AuthBloc({required this.signIn, required this.signUp})
    : super(AuthInitial()) {
    on<SignInEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await signIn(
          SignInParams(email: event.email, password: event.password),
        );
        user.fold(
          (e) => emit(AuthError(e.message)),
          (usr) => emit(AuthAuthenticated(usr)),
        );
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await signUp(
          SignUpParams(email: event.email, password: event.password),
        );
        user.fold(
          (e) => emit(AuthError(e.message)),
          (usr) => emit(AuthAwaitingOTP(usr)),
        );
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<VerifyOTPEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final session = await sb.Supabase.instance.client.auth.verifyOTP(
          token: event.otp,
          type: sb.OtpType.signup,
          email: event.email,
        );
        emit(
          AuthAuthenticated(
            User(
              email: session.user?.email ?? "",
              id: session.user?.id ?? "",
              profile: session.user?.userMetadata?['profile_pic'],
            ),
          ),
        );
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}

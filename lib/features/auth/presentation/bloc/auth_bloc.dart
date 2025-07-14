import 'package:fairshare/features/auth/domain/entities/user.dart';
import 'package:fairshare/features/auth/domain/usecases/check_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_up.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn signIn;
  final SignUp signUp;
  final CheckUser checkUser;
  bool alreadyRegistred = false;
  AuthBloc({
    required this.signIn,
    required this.signUp,
    required this.checkUser,
  }) : super(AuthInitial()) {
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

    on<CheckUserEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final res = await checkUser(event.email);
        res.fold((fail) => emit(AuthError("There was an error: $fail")), (dex) {
          alreadyRegistred = dex;
        });
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await signUp(
          SignUpParams(
            email: event.email,
            name: event.name,
            profilePic: event.profilePic,
          ),
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
              name: session.user?.userMetadata?['name'],
            ),
          ),
        );
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}

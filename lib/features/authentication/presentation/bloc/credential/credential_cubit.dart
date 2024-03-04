import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/authentication/domain/entities/user_entity.dart';
import 'package:news_app/features/authentication/domain/usecases/forgot_password_usecase.dart';
import 'package:news_app/features/authentication/domain/usecases/get_create_current_user_usecase.dart';
import 'package:news_app/features/authentication/domain/usecases/google_sign_in_useCase.dart';
import 'package:news_app/features/authentication/domain/usecases/sign_in_usecase.dart';
import 'package:news_app/features/authentication/domain/usecases/sign_up_usecase.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final SignUpUseCase signUpUseCase;
  final SignInUseCase signInUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final GetCreateCurrentUserUseCase getCreateCurrentUserUseCase;
  final GoogleSignInUseCase googleSignInUseCase;

  CredentialCubit(
      {required this.googleSignInUseCase,
        required this.signUpUseCase,
        required this.signInUseCase,
        required this.forgotPasswordUseCase,
        required this.getCreateCurrentUserUseCase})
      : super(CredentialInitial());

  Future<void> forgotPassword({required String email}) async {
    try {
      await forgotPasswordUseCase.call(email);
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  Future<void> signInSubmit({
    required String email,
    required String password,
  }) async {
    emit(CredentialLoading());
    try {
      await signInUseCase.call(UserEntity(email: email, password: password));
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  Future<void> googleAuthSubmit() async {
    emit(CredentialLoading());
    try {
      await googleSignInUseCase.call();
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  Future<void> signUpSubmit({required UserEntity user}) async {
    emit(CredentialLoading());
    try {
      await signUpUseCase
          .call(UserEntity(email: user.email, password: user.password));
      await getCreateCurrentUserUseCase.call(user);
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

}


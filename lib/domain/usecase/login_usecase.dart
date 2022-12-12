import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch/data/network/failure.dart';
import 'package:flutter_clean_arch/data/network/requests.dart';
import 'package:flutter_clean_arch/data/response/responses.dart';
import 'package:flutter_clean_arch/domain/model/models.dart';
import 'package:flutter_clean_arch/domain/repository/repository.dart';
import 'package:flutter_clean_arch/domain/usecase/base_usecase.dart';

class LoginUseCase implements BaseUseCase<LoginUseCaseInput, Authentication> {
  final Repository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(input) async {
    return await _repository.login(LoginRequest(input.email, input.password));
  }
}

class LoginUseCaseInput {
  String email;
  String password;

  LoginUseCaseInput(this.email, this.password);
}

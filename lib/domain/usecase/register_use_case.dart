import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch/data/network/failure.dart';
import 'package:flutter_clean_arch/data/network/requests.dart';
import 'package:flutter_clean_arch/data/response/responses.dart';
import 'package:flutter_clean_arch/domain/model/models.dart';
import 'package:flutter_clean_arch/domain/repository/repository.dart';
import 'package:flutter_clean_arch/domain/usecase/base_usecase.dart';

class RegisterUseCase
    implements BaseUseCase<RegisterUseCaseInput, Authentication> {
  final Repository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(input) async {
    return await _repository.register(RegisterRequest(
        input.userName,
        input.countryMobileCode,
        input.mobileNumber,
        input.email,
        input.password,
        input.profilePicture));
  }
}

class RegisterUseCaseInput {
  String userName;
  String countryMobileCode;
  String mobileNumber;
  String email;
  String password;
  String profilePicture;

  RegisterUseCaseInput(this.userName, this.countryMobileCode, this.mobileNumber,
      this.email, this.password, this.profilePicture);
}

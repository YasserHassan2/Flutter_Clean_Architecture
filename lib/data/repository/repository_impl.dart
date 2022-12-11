import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch/data/network/failure.dart';
import 'package:flutter_clean_arch/data/network/requests.dart';
import 'package:flutter_clean_arch/domain/model/models.dart';
import 'package:flutter_clean_arch/domain/repository/repository.dart';

class RepositoryImpl implements Repository {
  @override
  Future<Either<Failure, Authentication>> login(LoginRequest loginRequest) {
    // TODO: implement login
    throw UnimplementedError();
  }
}

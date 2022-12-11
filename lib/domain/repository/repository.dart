import 'package:flutter_clean_arch/data/data_source/remote_data_source.dart';
import 'package:flutter_clean_arch/data/mapper/mapper.dart';
import 'package:flutter_clean_arch/data/network/network_info.dart';
import 'package:flutter_clean_arch/data/network/requests.dart';
import 'package:flutter_clean_arch/domain/model/models.dart';
import 'package:dartz/dartz.dart';

import '../../data/network/failure.dart';

abstract class Repository {
  final RemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  Repository(this._remoteDataSource, this._networkInfo);

  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      final response = await _remoteDataSource.login(loginRequest);
      if (response.status == 0) {
        //success
        //return data
        return Right(response.toDomain());
      } else {
        //business error -- return failure
        return Left(Failure(409, response.message ?? "business error message"));
      }
    } else {
      return Left(Failure(501, "Please check your internet connection"));
    }
  }
}

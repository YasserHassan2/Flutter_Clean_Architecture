import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch/data/mapper/mapper.dart';
import 'package:flutter_clean_arch/data/network/failure.dart';
import 'package:flutter_clean_arch/data/network/requests.dart';
import 'package:flutter_clean_arch/domain/model/models.dart';
import 'package:flutter_clean_arch/domain/repository/repository.dart';

import '../data_source/local_data_source.dart';
import '../data_source/remote_data_source.dart';
import '../network/error_handler.dart';
import '../network/network_info.dart';
import '../response/responses.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;

  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  RepositoryImpl(this._remoteDataSource, this._networkInfo,
      this._localDataSource);

  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
    // its connected to internet, its safe to call API
    try {
    final response = await _remoteDataSource.login(loginRequest);

    if (response.status == ApiInternalStatus.SUCCESS) {
    // success
    // return either right
    // return data
    return Right(response.toDomain());
    } else {
    // failure --return business error
    // return either left
    return Left(Failure(ApiInternalStatus.FAILURE,
    response.message ?? ResponseMessage.DEFAULT));
    }
    } catch (error) {
    return Left(ErrorHandler.handle(error).failure);
    }
    } else {
    // return internet connection error
    // return either left
    return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.forgotPassword(email);

        if (response.status == ApiInternalStatus.SUCCESS) {
          // success
          // return either right
          // return data
          return Right(response.toDomain());
        } else {
          // failure --return business error
          // return either left
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler
            .handle(error)
            .failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, Authentication>> register(
      RegisterRequest registerRequest) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.register(registerRequest);

        if (response.status == ApiInternalStatus.SUCCESS) {
          // success
          // return either right
          // return data
          return Right(response.toDomain());
        } else {
          // failure --return business error
          // return either left
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler
            .handle(error)
            .failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, HomeObject>> getHomeData() async {
    try {
      //getResponse from cache

      final response = await _localDataSource.getHomeData();

      return Right(response.toDomain());
    } catch (cacheError) {
      //cache is not exiting or cache not valid
      // its the time to get from API side
      if (await _networkInfo.isConnected) {
        // its connected to internet, its safe to call API
        try {
          final response = await _remoteDataSource.getHomeData();

          if (response.status == ApiInternalStatus.SUCCESS) {
            // success
            // return either right
            // return data
            // save home response to cache

            // save response in cache (local data source)
            _localDataSource.saveHomeToCache(response);

            return Right(response.toDomain());
          } else {
            // failure --return business error
            // return either left
            return Left(Failure(ApiInternalStatus.FAILURE,
                response.message ?? ResponseMessage.DEFAULT));
          }
        } catch (error) {
          return Left(ErrorHandler
              .handle(error)
              .failure);
        }
      } else {
        // return internet connection error
        // return either left
        return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
      }
    }
  }

@override
Future<Either<Failure, StoreDetails>> getStoreDetails() async {
  try {
    // get data from cache

    final response = await _localDataSource.getStoreDetails();
    return Right(response.toDomain());
  } catch (cacheError) {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.getStoreDetails();
        if (response.status == ApiInternalStatus.SUCCESS) {
          _localDataSource.saveStoreDetailsToCache(response);
          return Right(response.toDomain());
        } else {
          return Left(Failure(response.status ?? ResponseCode.DEFAULT,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
}

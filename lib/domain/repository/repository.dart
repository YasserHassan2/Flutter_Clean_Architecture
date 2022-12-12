
import 'package:flutter_clean_arch/data/network/requests.dart';
import 'package:flutter_clean_arch/domain/model/models.dart';
import 'package:dartz/dartz.dart';

import '../../data/network/failure.dart';

abstract class Repository {
  Future<Either<Failure, Authentication>> login(LoginRequest loginRequest);
}

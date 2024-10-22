import 'package:dartz/dartz.dart';
import 'failure.dart';

abstract class UseCase<Type, P> {
  Future<Either<Failure, Type>> call(P params);
}

class NoParams {
  NoParams();
}

class Params<T1, T2, T3> {
  final T1 data;
  final T2? data2;
  final T3? data3;

  Params(this.data, {this.data2, this.data3});
}

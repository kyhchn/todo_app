import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class DataState<T> {
  final T? data;
  final DioException? exception;
  final FirebaseAuthException? authException;
  final String? message;

  const DataState(
      {this.data, this.exception, this.authException, this.message});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataErrorAPI<T> extends DataState<T> {
  const DataErrorAPI(DioException exception, String? message)
      : super(exception: exception, message: message);
}

class DataErrorAuth<T> extends DataState<T> {
  const DataErrorAuth(FirebaseAuthException? exception, String? message)
      : super(authException: exception, message: message);
}

class DataNetworkError<T> extends DataState<T> {
  const DataNetworkError() : super(message: 'No Internet Connection');
}

class DataInternalError<T> extends DataState<T> {
  const DataInternalError(String message) : super(message: message);
}

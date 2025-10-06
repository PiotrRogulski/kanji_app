import 'dart:async';
import 'dart:io';

import 'package:cached_query_flutter/cached_query_flutter.dart' as cq;
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

(QueryResult<T>, Future<void> Function()) useQuery<T extends Object>(
  cq.Query<T> query,
) {
  final stream = useMemoized(() => query.stream, [query.key]);
  final snapshot = useStream(stream, preserveState: false);

  useEffect(() {
    final timer = Timer.periodic(
      query.config.staleDuration,
      (_) => query.refetch(),
    );
    return timer.cancel;
  }, [query.key]);

  return (
    switch (snapshot.data) {
      cq.QuerySuccess(:final data) => QuerySuccess(data),
      cq.QueryError(:final error, :final stackTrace) => QueryFailure(
        error,
        stackTrace,
      ),
      cq.QueryInitial() || cq.QueryLoading() || null => const QueryLoading(),
    },
    query.refetch,
  );
}

sealed class QueryResult<T extends Object> with EquatableMixin {
  const QueryResult();
}

final class QueryLoading extends QueryResult<Never> {
  const QueryLoading();

  @override
  List<Object?> get props => [];
}

sealed class FinalQueryResult<T extends Object> extends QueryResult<T> {
  const FinalQueryResult();
}

final class QuerySuccess<T extends Object> extends FinalQueryResult<T> {
  const QuerySuccess(this.value);

  final T value;

  @override
  List<Object?> get props => [value];
}

final class QueryFailure extends FinalQueryResult<Never> {
  const QueryFailure(this.error, this.stackTrace);

  final dynamic error;
  final StackTrace stackTrace;

  bool get isNetworkError => error is SocketException || error is DioException;

  @override
  List<Object?> get props => [error, stackTrace];
}

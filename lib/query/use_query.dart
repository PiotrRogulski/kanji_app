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

sealed class const QueryResult<T extends Object>() with Equatable;

final class const QueryLoading() extends QueryResult<Never> {
  @override
  List<Object?> get props => [];
}

sealed class const FinalQueryResult<T extends Object>() extends QueryResult<T>;

final class const QuerySuccess<T extends Object>(final T value)
    extends FinalQueryResult<T> {
  @override
  List<Object?> get props => [value];
}

final class const QueryFailure(final dynamic error, final StackTrace stackTrace)
    extends FinalQueryResult<Never> {
  bool get isNetworkError => error is SocketException || error is DioException;

  @override
  List<Object?> get props => [error, stackTrace];
}

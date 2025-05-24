import 'dart:async';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

QueryResult<T> useQuery<T extends Object>(Query<T> query) {
  final stream = useMemoized(() => query.stream, [query.key]);
  final snapshot = useStream(stream, preserveState: false);

  useEffect(() {
    final timer = Timer.periodic(
      query.config.refetchDuration,
      (_) => query.refetch(),
    );
    return timer.cancel;
  }, [query.key]);

  return switch (snapshot.data) {
    QueryState(:final data?) => QuerySuccess(data),
    QueryState(status: QueryStatus.error, :final error) => QueryFailure(error),
    _ => const QueryLoading(),
  };
}

sealed class QueryResult<T extends Object> {
  const QueryResult();
}

final class QueryLoading extends QueryResult<Never> {
  const QueryLoading();
}

sealed class FinalQueryResult<T extends Object> extends QueryResult<T> {
  const FinalQueryResult();
}

final class QuerySuccess<T extends Object> extends FinalQueryResult<T> {
  const QuerySuccess(this.value);

  final T value;
}

final class QueryFailure extends FinalQueryResult<Never> {
  const QueryFailure(this.error);

  final dynamic error;
}

extension QueryFetchX<T extends Object> on Query<T> {
  Future<FinalQueryResult<T>> fetch() async {
    final state = await result;
    return switch (state) {
      QueryState(:final data?) => QuerySuccess(data),
      QueryState(status: QueryStatus.error, :final error) => QueryFailure(
        error,
      ),
      _ => const QueryFailure(null),
    };
  }
}
